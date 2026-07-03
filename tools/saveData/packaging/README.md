# saveData 运行与打包整理

这个目录记录本地 mock Flash 游戏平台的运行边界。当前目标是让同一套
`runtime/save-data` mock server 同时服务两种入口：

- 公网访问：启动 HTTP 服务，让浏览器通过公网地址访问。
- Windows 桌面应用：本机启动同一套 HTTP 服务，再由桌面壳打开内置 WebView。

## 推荐目录结构

```text
runtime/save-data/
  persistence/          # SQLite 连接、schema 初始化和数据读写
  services/             # 存档解析、商城价值估算和业务规则
  platform4399/         # 4399 save/pay/mall 接口适配
  server/               # HTTP 服务、静态资源和启动入口
  public/               # 浏览器页面源码，公网和桌面 WebView 共用
  schema/               # SQLite schema
  tests/                # saveData 单元/流程测试
  README.md             # 运行时代码结构和入口

tools/saveData/
  packaging/            # 访问方式、桌面打包和运行边界说明
  README.md             # 存档/商城/运行调试分析记录

workspace/saveData/
  local-save.db         # 当前本地存档与钱包数据库，不能随手删除
  remote-assets/        # 游戏远程 SWF 缓存，公网和桌面运行都要复用
  platform-assets/      # 4399 控件资源缓存，可重建但不建议频繁清
  public/               # 启动时生成的运行产物，可重建
  logs/                 # 运行日志，可清理；无日志模式不会继续写入

workspace/onlineSave/
  raw/                  # 线上原始 6 个存档抓取结果，保留作基准
  decoded/              # 线上存档解码结果和摘要，保留作排障基准
  analysis/             # 对比分析产物，保留
```

## 公网访问

公网访问只需要启动现有 saveData server。推荐默认无日志启动，减少运行期
I/O 对游戏帧率的影响：

```bash
SAVE_DATA_LOGS=0 SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

需要诊断时再打开日志：

```bash
SAVE_DATA_HOST=0.0.0.0 SAVE_DATA_PORT=80 npm run saveData:serve
```

当前默认 renderer 是 `canvas`，优先保证流畅。需要对比原版滤镜描边时，可在
URL 后加：

```text
?renderer=webgl
```

`webgl` 更接近原版滤镜效果，但在当前 Ruffle 版本和部分环境中会出现 GPU
stall，游戏会明显变卡。

## Windows 桌面应用方向

桌面应用不要复制一套 mock 逻辑。推荐结构是：

```text
apps/
  saveData-desktop/
    main/               # 桌面主进程：启动/停止本机 saveData server
    renderer/           # 可选；也可以直接加载 runtime/save-data/public
    package/            # Windows 安装包配置和图标

runtime/save-data/
  server/               # 继续作为唯一 mock server 实现
  public/               # 继续作为唯一游戏承载页面
```

桌面壳的职责应尽量薄：

1. 选择一个本地端口启动 `startSaveDataServer()`。
2. 用 WebView 打开本机 URL。
3. 把 `workspace/saveData/local-save.db` 和资源缓存目录放到用户数据目录。
4. 提供“打开存档目录”“备份数据库”“清理日志”这类桌面按钮。

不要在桌面壳里重新实现存档、商城或钱包逻辑；否则公网版和桌面版会很快分叉。

## 可清理与不可清理

可以清理：

- `workspace/saveData/*.png`
- `workspace/saveData/logs/*.ndjson`
- `workspace/saveData/logs/*.out`
- 根目录 `logs/` 下临时反编译日志

不要清理：

- `workspace/saveData/local-save.db`
- `workspace/saveData/remote-assets/`
- `workspace/saveData/public/`
- `workspace/onlineSave/raw/`
- `workspace/onlineSave/decoded/`
