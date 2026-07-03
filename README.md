# flashSourceMap

这个项目用于归档和分析原 4399 Flash 游戏包，并提供一套本地 mock 平台运行时，让游戏可以脱离线上 4399 saveData 服务运行。当前运行时已经支持本地存档、钱包/充值 mock、商城购买 mock、资源缓存和浏览器承载页；后续 Windows 桌面应用会复用同一套运行时代码。

`downloads/` 视为只读原始材料。修改、测试和生成产物应放在 `workspace/`，最终构建产物放在 `builds/`。

## 环境准备

当前环境使用 Node.js 24 和 npm 11。首次拉取项目后安装依赖：

```bash
npm install
```

常用校验命令：

```bash
npm run saveData:test:db
npx tsc --noEmit
```

## 常用脚本

```bash
npm run download          # 下载原始资源
npm run extract           # 提取内嵌 SWF
npm run decompile         # 反编译参考文件
npm run saveData:serve    # 启动本地 saveData mock server
npm run saveData:test:db  # 跑 saveData 数据库流程测试
npm run desktop:dev       # 编译并启动 Electron 桌面壳
npm run desktop:pack      # 生成本机目录包，用于打包配置检查
npm run desktop:build:win # 生成 Windows 桌面 zip 包
```

## 主要目录

```text
runtime/save-data/        # 本地 mock 平台运行时代码
  persistence/            # SQLite 连接、schema 初始化和数据读写
  services/               # 存档解析、商城价值估算和业务规则
  platform4399/           # 4399 save/pay/mall 接口适配
  server/                 # HTTP 服务、静态资源和启动入口
  public/                 # 浏览器运行页，未来桌面 WebView 也复用
  schema/                 # SQLite schema
  tests/                  # saveData 流程测试

tools/                    # 分析记录、反编译辅助和调试工具
workspace/                # 本地数据库、资源缓存和线上存档基准
builds/                   # 构建产物
downloads/                # 原始资源，只读
apps/saveData-desktop/    # Electron 桌面薄壳
.github/workflows/        # GitHub Release 自动构建
```

当前职责边界：

- `runtime/save-data/persistence/` 负责 SQLite 连接、schema 初始化和数据读写。
- `runtime/save-data/services/` 负责存档解析、身份修正、商城价值估算和反作弊金额规则。
- `runtime/save-data/platform4399/` 负责把 4399 save/pay/mall 接口适配到本地 service。
- `runtime/save-data/server/` 负责 HTTP 服务、静态资源、日志和启动入口。
- `runtime/save-data/public/` 是浏览器运行页，未来桌面 WebView 也应复用它。
- `tools/` 只放分析记录、反编译辅助和临时调试工具，不再承载 saveData 运行时代码。

## 启动本地 mock 平台

默认只监听本机：

```bash
npm run saveData:serve
```

默认地址是：

```text
http://127.0.0.1:8787/
```

如果只是本地或公网体验游戏，推荐关闭运行日志，减少磁盘 I/O 对帧率的影响：

```bash
SAVE_DATA_LOGS=0 npm run saveData:serve
```

## 公网访问

公网访问只在需要远程测试时开启。推荐无日志模式：

```bash
SAVE_DATA_LOGS=0 SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

需要诊断接口调用时再打开日志：

```bash
SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

测试结束后关闭对应进程，并确认端口不再监听：

```bash
ss -ltnp | rg ':(80|8787)\b'
```

## 运行数据

当前本地运行依赖这些目录和文件：

```text
workspace/saveData/local-save.db      # 本地存档、钱包和商城购买记录
workspace/saveData/remote-assets/     # 远程 SWF/资源缓存
workspace/saveData/public/            # 本地运行页面产物
workspace/onlineSave/raw/             # 线上 6 个存档原始抓取
workspace/onlineSave/decoded/         # 线上存档解码结果和摘要
```

不要随手删除这些内容。可清理的通常只有运行日志、临时截图和可再生成的分析日志。

## Windows 桌面应用方向

桌面应用应作为薄壳复用 `runtime/save-data`，不要复制存档、钱包、商城或资源服务逻辑。推荐后续结构：

```text
apps/saveData-desktop/
  main/                   # 启动/停止本机 saveData server，管理窗口生命周期
  preload/                # 可选的桌面桥接 API
  renderer/               # 桌面专属控制页；游戏页仍加载 runtime/save-data/public
  packaging/              # Windows 图标、打包和签名配置
```

桌面壳启动时应选择本机端口，启动同一套 `runtime/save-data/server`，再用 WebView 打开本机 URL。数据库和缓存目录应指向用户数据目录，例如 `%APPDATA%/flashSourceMap/saveData/`，不要写入安装目录或 asar 包。

GitHub Release 对接已经预留在 `.github/workflows/release-desktop.yml`。推送 `v*` tag 时，GitHub Actions 会在 `windows-latest` 上运行检查、构建 Windows 桌面 zip 包、生成校验文件并上传到 Release。

## 重要文档

- `runtime/save-data/README.md`：saveData 运行时代码结构和入口。
- `apps/saveData-desktop/README.md`：Electron 桌面壳、数据目录和 Release 流程。
- `tools/saveData/README.md`：存档、充值 mock、商城购买 mock 和运行日志策略分析。
- `tools/saveData/packaging/README.md`：公网访问方式、未来 Windows 桌面应用打包边界和推荐目录结构。
- `tools/paymentLogic/README.md`：付费、余额、累计充值和商城购买链路分析。
- `tools/noCheat/README.md`：游戏反作弊判断逻辑，尤其是商城物品价值和累计充值比较。
