# saveData Runtime

这个目录是本地 mock 4399 Flash 平台能力的运行时。存档、钱包、充值、商城、资源代理和运行日志都应复用这里的 server/services/persistence，不要在 native 启动器或工具脚本里复制业务逻辑。

## 结构

```text
runtime/save-data/
  persistence/          # SQLite 连接、schema 初始化、存档/钱包/购买记录读写
  services/             # 存档解析、商城价值估算、反作弊金额规则、关卡奖励覆盖
  platform4399/         # 4399 save/pay/mall 接口和 FlashStoreApi 适配
  server/               # HTTP server、静态资源、日志、路径配置
  public/               # Ruffle 备用页和 native Flash 承载页
  schema/               # SQLite schema
  tests/                # saveData 流程测试
  types.ts              # 共享类型
```

## 启动

普通浏览器/Ruffle 备用入口：

```bash
npm run saveData:serve
```

Windows native Flash 入口：

```bash
npm run native-flash:prepare
npm run start:native-flash:mock
```

无日志模式可减少运行期 I/O：

```bash
SAVE_DATA_LOGS=0 npm run saveData:serve
```

## 数据位置

默认运行数据在：

```text
workspace/saveData/local-save.db
workspace/saveData/remote-assets/
workspace/saveData/platform-assets/
workspace/saveData/public/
workspace/saveData/logs/
```

后续如果做 native 打包，应通过环境变量或启动器配置把数据库和缓存目录指向用户数据目录，例如 `%APPDATA%/flashSourceMap/saveData/`。

## 渲染路径

`index.html + runner.js` 是 Ruffle 备用路径，仍可用于浏览器对照调试。

`native.html + native-player.js` 是 CEF/Pepper Flash 路径，目标是接近原版 Flash 的运行性能和音频表现。

## 验证

```bash
npm run saveData:test:db
npm run typecheck
git diff --check
```
