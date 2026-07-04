# saveData 访问方式与 native Flash 边界

这个项目的 mock 逻辑统一放在 `runtime/save-data`。无论是浏览器调试、native Flash 运行，还是后续打包，都不要复制存档、钱包、商城或资源服务逻辑。

## 入口

公网或普通浏览器调试：

```bash
SAVE_DATA_LOGS=0 SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

Windows native Flash 运行：

```bash
npm run native-flash:prepare
npm run start:native-flash:mock
```

`start:native-flash:mock` 会启动同一套 saveData mock server，并用 CEF/Pepper Flash 打开 `runtime/save-data/public/native.html`。

## 当前边界

- `runtime/save-data/server` 是唯一 mock server 实现。
- `runtime/save-data/public/index.html` 和 `runner.js` 保留为 Ruffle 浏览器备用入口。
- `runtime/save-data/public/native.html` 和 `native-player.js` 是 native Flash 承载入口。
- `tools/launch-native-flash-mock.cjs` 负责准备/启动本地 CEF 和 Pepper Flash。
- 旧桌面壳已移除，不再维护 `desktop:*` 脚本或桌面打包器配置。
- `.github/workflows/release.yml` 只负责在 `v*` tag 推送后跑校验并创建 GitHub Release 页面，不上传旧桌面包。

## 运行数据

保留这些数据目录，不要随手清理：

```text
workspace/saveData/local-save.db
workspace/saveData/remote-assets/
workspace/saveData/platform-assets/
workspace/onlineSave/raw/
workspace/onlineSave/decoded/
```

可清理的通常只有日志、截图和可再生成的临时产物：

```text
workspace/saveData/*.png
workspace/saveData/logs/*.ndjson
workspace/saveData/logs/*.out
logs/
```
