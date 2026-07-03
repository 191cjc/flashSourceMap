# saveData Desktop

这个目录是未来 Windows 桌面应用的薄壳。桌面端不实现存档、钱包、商城或资源服务逻辑，只启动并复用 `runtime/save-data/server`，再用 Electron `BrowserWindow` 打开本机 URL。

## 开发

```bash
npm run desktop:dev
```

`desktop:dev` 会先编译 TypeScript，再启动 Electron。运行数据默认写入 Electron userData 目录下的 `saveData/`，不会写入安装目录。

## 打包

本机目录包检查：

```bash
npm run desktop:pack
```

Windows 安装包：

```bash
npm run desktop:build:win
```

正式 Windows 包建议通过 GitHub Actions 的 `windows-latest` runner 构建，而不是在 Linux 上交叉构建后直接发布。

## 数据目录

桌面壳启动时会设置：

```text
SAVE_DATA_PROJECT_ROOT     # 包内资源根目录
SAVE_DATA_WORKSPACE_ROOT   # userData/saveData
SAVE_DATA_DB               # userData/saveData/local-save.db
SAVE_DATA_RUFFLE_ROOT      # 打包后 resources/ruffle
```

因此 SQLite 数据库、WAL/SHM、资源缓存、生成页面和日志都位于用户数据目录，避免 Windows 安装目录或 asar 只读问题。

## Release

推送 `v*` tag 会触发 `.github/workflows/release-desktop.yml`：

```bash
git tag v0.1.0
git push origin v0.1.0
```

workflow 会在 Windows runner 上运行测试、构建 NSIS 安装包、生成 `checksums.txt`，并上传到 GitHub Release。
