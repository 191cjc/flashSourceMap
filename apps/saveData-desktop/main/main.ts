import { app, BrowserWindow, Menu, dialog, shell } from "electron";
import { mkdirSync, existsSync } from "node:fs";
import path from "node:path";

type SaveDataServerHandle = {
  host: string;
  port: number;
  url: string;
  close: () => Promise<void>;
};

let mainWindow: BrowserWindow | null = null;
let saveDataServer: SaveDataServerHandle | null = null;

function configureSaveDataEnvironment(): { workspaceRoot: string; dbFile: string } {
  const workspaceRoot = path.join(app.getPath("userData"), "saveData");
  const dbFile = path.join(workspaceRoot, "local-save.db");

  mkdirSync(workspaceRoot, { recursive: true });

  process.env.SAVE_DATA_PROJECT_ROOT = app.getAppPath();
  process.env.SAVE_DATA_WORKSPACE_ROOT = workspaceRoot;
  process.env.SAVE_DATA_DB = dbFile;
  process.env.SAVE_DATA_HOST = "127.0.0.1";
  process.env.SAVE_DATA_PORT = "0";
  process.env.SAVE_DATA_LOGS ??= "0";

  if (app.isPackaged) {
    const ruffleRoot = path.join(process.resourcesPath, "ruffle");
    if (existsSync(ruffleRoot)) {
      process.env.SAVE_DATA_RUFFLE_ROOT = ruffleRoot;
    }
  }

  return { workspaceRoot, dbFile };
}

async function startRuntimeServer(): Promise<SaveDataServerHandle> {
  const { dbFile } = configureSaveDataEnvironment();
  const runtime = (await import("../../../runtime/save-data/server/server.js")) as {
    startSaveDataServer: (options?: { host?: string; port?: number; dbFile?: string }) => Promise<SaveDataServerHandle>;
  };

  return runtime.startSaveDataServer({
    host: "127.0.0.1",
    port: 0,
    dbFile,
  });
}

function createAppMenu(workspaceRoot: string): void {
  const template: Electron.MenuItemConstructorOptions[] = [
    {
      label: "文件",
      submenu: [
        {
          label: "打开数据目录",
          click: () => {
            void shell.openPath(workspaceRoot);
          },
        },
        { type: "separator" },
        { role: "quit", label: "退出" },
      ],
    },
    {
      label: "视图",
      submenu: [
        { role: "reload", label: "重载窗口" },
        { role: "forceReload", label: "强制重载" },
        { role: "toggleDevTools", label: "开发者工具" },
        { type: "separator" },
        { role: "resetZoom", label: "重置缩放" },
        { role: "zoomIn", label: "放大" },
        { role: "zoomOut", label: "缩小" },
      ],
    },
  ];

  Menu.setApplicationMenu(Menu.buildFromTemplate(template));
}

async function createWindow(): Promise<void> {
  const { workspaceRoot } = configureSaveDataEnvironment();
  saveDataServer = await startRuntimeServer();
  createAppMenu(workspaceRoot);

  mainWindow = new BrowserWindow({
    width: 1280,
    height: 760,
    minWidth: 1024,
    minHeight: 640,
    title: "FlashSourceMap SaveData",
    backgroundColor: "#1b1d20",
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true,
    },
  });

  mainWindow.on("closed", () => {
    mainWindow = null;
  });

  await mainWindow.loadURL(saveDataServer.url);
}

async function stopRuntimeServer(): Promise<void> {
  if (!saveDataServer) {
    return;
  }

  const handle = saveDataServer;
  saveDataServer = null;
  await handle.close();
}

const lock = app.requestSingleInstanceLock();
if (!lock) {
  app.quit();
} else {
  app.on("second-instance", () => {
    if (!mainWindow) {
      return;
    }
    if (mainWindow.isMinimized()) {
      mainWindow.restore();
    }
    mainWindow.focus();
  });

  app.whenReady().then(() => {
    createWindow().catch((error) => {
      const message = error instanceof Error ? error.stack ?? error.message : String(error);
      dialog.showErrorBox("启动失败", message);
      app.quit();
    });
  });

  app.on("before-quit", (event) => {
    if (!saveDataServer) {
      return;
    }

    event.preventDefault();
    stopRuntimeServer()
      .catch((error) => {
        console.error(error);
      })
      .finally(() => {
        app.exit(0);
      });
  });

  app.on("window-all-closed", () => {
    app.quit();
  });
}
