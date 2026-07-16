# Global Data Runtime

Linux 专用全局数据服务，独立于 Windows 本地 `runtime/save-data/`。

当前提供：

- `GET /health`
- 全局 UID 注册和实例绑定
- 用户名查询与修改
- 完整远程存档副本的 revision/checksum 幂等写入
- 全局军团 SQLite 数据
- 排行榜提交、分页、本人附近和用户名查询
- 竞技场对手远程存档读取

启动：

```bash
npm run globalData:serve
```

默认监听 `0.0.0.0:7778`。指定监听地址和数据库：

```bash
GLOBAL_DATA_HOST=0.0.0.0 \
GLOBAL_DATA_PORT=7778 \
GLOBAL_DATA_DB=/var/lib/flash-global-data/global-game.db \
npm run globalData:serve
```

默认数据库：

```text
workspace/globalData/global-game.db
```

检查服务：

```bash
curl http://127.0.0.1:7778/health
```

## Linux systemd

参考 `runtime/global-data/deploy/flash-global-data.service.example`，根据实际仓库路径和运行用户修改后安装：

```bash
sudo cp runtime/global-data/deploy/flash-global-data.service.example /etc/systemd/system/flash-global-data.service
sudo systemctl daemon-reload
sudo systemctl enable --now flash-global-data
sudo systemctl status flash-global-data
```

## Windows 客户端

Windows 本地服务默认访问 `http://118.89.150.116:7778`，无需额外配置。需要切换其他 Linux 服务时，可以通过 `GLOBAL_DATA_URL` 覆盖：

```powershell
$env:GLOBAL_DATA_URL = "http://其他Linux公网IP:7778"
npm run start:native-flash:mock
```

持久设置可使用：

```powershell
setx GLOBAL_DATA_URL "http://其他Linux公网IP:7778"
```

修改 `setx` 后需要重新启动终端或游戏启动器。钱包、充值和商城数据库仍只保存在 Windows 本地。

## 验证

```bash
npm run globalData:test
npm run saveData:test:db
npm run typecheck
```
