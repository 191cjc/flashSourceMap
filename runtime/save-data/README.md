# saveData Runtime

这个目录是本地 mock Flash 平台的运行时代码。公网访问和未来 Windows 桌面应用都应复用这里的 server、services 和 persistence，不再从 `tools/` 目录复制逻辑。

## 目录结构

```text
runtime/save-data/
  persistence/          # SQLite 连接、schema 初始化、存档/钱包/购买记录读写
  services/             # 存档 XML 解析、商城价值估算、反作弊金额规则、关卡奖励覆盖
  platform4399/         # 4399 save/pay/mall 接口适配和 FlashStoreApi 处理
  server/               # HTTP server、静态资源、日志、路径配置
  public/               # 浏览器运行页；未来桌面 WebView 也复用
  schema/               # SQLite schema
  tests/                # saveData 流程测试
  types.ts              # 存档、钱包、购买和日志共享类型
```

## 启动

本地启动：

```bash
npm run saveData:serve
```

无日志启动：

```bash
SAVE_DATA_LOGS=0 npm run saveData:serve
```

公网测试启动：

```bash
SAVE_DATA_LOGS=0 SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

## 数据位置

默认运行数据仍在：

```text
workspace/saveData/local-save.db
workspace/saveData/remote-assets/
workspace/saveData/platform-assets/
workspace/saveData/public/
workspace/saveData/logs/
```

未来 Windows 桌面应用应通过 `SAVE_DATA_DB` 和后续路径配置把数据库与缓存目录指向用户数据目录，例如 `%APPDATA%/flashSourceMap/saveData/`。

## 渲染和字体

运行页优先使用 Ruffle `webgl` renderer 渲染 Flash 滤镜，并启用 `deviceFontRenderer: "canvas"` 让 Windows 浏览器或桌面 WebView 使用本机 `SimSun`、`宋体`、`微软雅黑` 等设备字体。这里的 canvas 是 Ruffle 的设备字体渲染器，不是主渲染器。

如果字体描边或字形异常，先看 `workspace/saveData/logs/mock-api.ndjson` 里的 `ruffle.renderer` 事件和浏览器控制台：WebGL 创建失败会让 Ruffle 回退到主 canvas renderer；缺少设备字体也会导致文字和原版不一致。`?deviceFonts=embedded` 可用于诊断生成的 `/font-aliases/*.swf` 字体别名，但它比系统设备字体路径更重，不作为默认运行方式。

## 验证

```bash
npm run saveData:test:db
npx tsc --noEmit
git diff --check
```
