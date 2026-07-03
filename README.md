# flashSourceMap

这个项目用于归档和分析原 4399 Flash 游戏包，并在本地 mock 平台能力，让游戏可以脱离线上 4399 saveData 服务运行。当前重点是本地存档、充值 mock、商城购买链路和后续 Windows 桌面应用打包边界。

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
```

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

## 重要文档

- `tools/saveData/README.md`：存档、充值 mock、商城购买 mock 和运行日志策略。
- `tools/saveData/packaging/README.md`：公网访问方式、未来 Windows 桌面应用打包边界和推荐目录结构。
- `tools/paymentLogic/README.md`：付费、余额、累计充值和商城购买链路分析。
- `tools/noCheat/README.md`：游戏反作弊判断逻辑，尤其是商城物品价值和累计充值比较。
