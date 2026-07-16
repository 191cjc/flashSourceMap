# Global Data Runtime

Linux 专用全局数据服务，独立于 Windows 本地 `runtime/save-data/`。

当前提供：

- `GET /health`
- 全局 UID 注册和实例绑定
- 用户名查询与修改
- 完整远程存档副本的 revision/checksum 幂等写入

启动：

```bash
npm run globalData:serve
```

公网监听：

```bash
GLOBAL_DATA_HOST=0.0.0.0 GLOBAL_DATA_PORT=8800 npm run globalData:serve
```

默认数据库：

```text
workspace/globalData/global-game.db
```
