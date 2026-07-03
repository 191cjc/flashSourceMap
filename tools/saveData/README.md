# saveData 机制分析与调试记录

这个目录用于沉淀保存、读档、本地 mock 行为、商城购买和充值相关的分析结论。`tools/saveData/` 不再承载运行时代码；公共运行能力已经迁移到 `runtime/save-data/`，公网访问和未来 Windows 桌面应用都复用那里。

运行方式、公网访问和桌面打包边界见：

- `runtime/save-data/README.md`
- `tools/saveData/packaging/README.md`

本目录保留为存档链路、商城/充值 mock 行为、日志策略和反作弊相关交叉说明。

## 分析目标

1. 找出主存档从客户端写出到平台接口的调用链。
2. 找出读档时各个业务模块如何恢复数据。
3. 明确主存档字段和主要子存档字段，为之后替换 4399 页面层、接入自建存档系统做结构准备。

## 当前结论

项目的主存档逻辑集中在 `ApiInterface` 和 `Api4399`：

- `ApiInterface.writeData()` 负责把角色、关卡、技能、背包、活动和反作弊标记等内容组装成一个普通对象。
- `ApiInterface.readData()` 负责按相同结构恢复游戏运行状态。
- `Api4399.saveDataBefore()` 会先查询平台存档状态，再进入真正保存。
- `Api4399.saveDataBeforeNoState()` 会跳过存档状态查询，直接保存。
- `Api4399.saveDataStart()` 是最终保存入口，保存前还会做若干客户端异常检查。
- `Api4399.getData()` 和 `Api4399.getDataList()` 分别读取当前存档位和存档列表。

这意味着后续如果抛弃 4399 页面层，比较理想的做法不是直接让业务模块感知新后端，而是在 `serviceHold` 或 `ApiInterface/Api4399` 等接口层做适配，把原本的平台存档接口替换为自建存档接口。

## 主调用链

保存链路：

1. 游戏内触发保存。
2. 调用 `GM.testapi.saveDataBefore()` 或 `saveDataBeforeNoState()`。
3. `Api4399.saveDataBefore()` 调用 `getSaveStateByFun(saveDataStart)`。
4. `Api4399.saveDataStart()` 执行保存前检查。
5. `ApiInterface.writeData()` 组装存档对象。
6. `Main.serviceHold.saveData(title, data, false, dataIndex)` 把数据交给平台层。

读取链路：

1. 选择存档位或进入游戏时调用 `Api4399.getData()`。
2. `Main.serviceHold.getData(false, dataIndex)` 向平台层请求数据。
3. `Api4399.saveProcess()` 收到 `SaveEvent.SAVE_GET`。
4. `ApiInterface.readData(param1.ret.data)` 恢复存档对象。
5. `GM.enterGame()` 进入游戏。

存档列表链路：

1. `Api4399.getDataList()` 优先使用已有 `dataList`。
2. 如果没有列表缓存，则调用 `Main.serviceHold.getList()`。
3. `Api4399.saveProcess()` 收到 `SaveEvent.SAVE_LIST` 后更新列表并刷新界面。

## 主存档结构

`ApiInterface.writeData()` 组装的主对象包含：

- `jxv`：职业标识 `jobFlag`。
- `jxid`：用户 ID。
- `sidx`：存档位索引。
- `newnn`：编码后的用户名。
- `idn`：账号和存档位组合标识。
- `jxsflag`：游戏标记对象 `GM.flagobj`。
- `jxrole`：角色数据，来自 `GM.cp.save()`。
- `jxguanka`：关卡进度，来自 `GM.levelSD.save()`。
- `jxjinenglv`：技能等级，来自 `GM.skillLvM.save()`。
- `jxkaizhong`：背包、商城、任务、活动等综合数据，来自 `FlowInterface.save()`。
- `kpji`：开牌计时数据，来自 `GM.kaipaijssavedata.save()`。
- `asaved`：新增活动和扩展数据，来自 `GM.aSaveData.save()`。
- `lactd`：旧线上档中出现过的遗留活动字段，只在部分早期存档存在，读取时应按可选字段处理。

对应读取时，`ApiInterface.readData()` 会读取 `jxid/sidx/jxv/jxrole/jxguanka/jxjinenglv/kpji/asaved/jxkaizhong` 等字段。若传入数据为空，则初始化新档。

当前已根据 6 个线上存档补充了 TypeScript 类型定义，位置为 `runtime/save-data/types.ts`。核心类型为：

- `GameSaveData`：解码后的完整游戏存档对象。
- `GameSaveRole`：`jxrole`，字段为 `job/lv/sn/ec/g/d`。
- `GameSaveLevelProgress`：`jxguanka` 中单个关卡进度，字段为 `id/ach/ov`。
- `GameSaveSkillLevels`：`jxjinenglv`，字段为 `bs/wid/wlv`。
- `GameSaveFlowData`：`jxkaizhong`，对应 `GoodsManger.save()` 的第一层结构。
- `GameSaveExtendedData`：`asaved`，对应 `NewSDList.save()` 的第一层结构。

线上存档外层接口返回的 `data` 是字符串，解码流程为 `Base64 -> zlib inflate -> AMF3 String -> saveXml`。因此接口层可以使用 `OnlineSaveSlot`，解码后再使用 `DecodedSaveSlot/GameSaveData`。

## 关键子结构

`FlowInterface.save()` 实际代理到 `GoodsManger.save()`。其中保存的内容包括：

- `addEq`：装备槽。
- `jxbag`：背包。
- `jxtask`：任务。
- `jxshop`：商城数据。
- `jxfengj`：背包显示或分解相关数据。
- `jxware`：仓库。
- `gene`：基因数据。
- `gift`：礼包数据。
- `vp`：VIP 数据。
- `fb/fmv`：副本相关数据。
- `zp`：转盘数据。
- `tim`：时间计数。
- `ship`：飞船或航运相关数据。
- `pgj`：宠物攻击相关数据。
- `dl`：`DataList` 的综合数据。

`NewSDList.save()` 保存扩展存档 `asaved`，主要字段包括：

- `ndf`：每日刷新记录。
- `sxd/sxlv`：十二生肖相关数据。
- `pm`：宠物管理器。
- `gv`：游戏版本或数据版本。
- `pkl/pks`：PK 敌人与 PK 数据。
- `tr`：挑战塔数据。
- `cm`：反作弊标记 `CheckFlagM`。
- `nlel`：新关卡数据。
- `jsha`：劫杀数据。
- `sum/summr`：活动记录。

线上对比发现，`asaved.jsha/sum/summr` 在个别旧档中可能不存在，因此类型中定义为可选。`jxkaizhong.dl.dl` 也可能缺失，属于旧版本结构漂移，读取代码应保持兼容。

## 保存前检查

`Api4399.saveDataStart()` 保存前会执行几类检查：

- `FlowInterface.isXg()`：判断基础数据或职业标识是否异常。
- `BagFactory.getShopG()` 与累计充值额 `allChongGod` 比较，判断背包中商城物品总价值是否异常。
- `BagFactory.getGoodsMaxNum()` 检查物品数量是否超过上限。

这些检查与反作弊标记有关，但此目录只记录存档读写流程。相关异常标记细节见 `tools/noCheat/README.md`。

## 关键文件索引

- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/ApiInterface.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/Api4399.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/Control/FlowInterface.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/Control/GoodsManger.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/Control/DataList.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/grole/MPlayer.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/savedatal/NewSDList.as`

## 后续开发方向

后续如果要做自建存档系统，建议按以下顺序推进：

1. 先写只读导出工具，把 `writeData()` 的结构整理成 JSON schema 风格文档。
2. 再设计一个平台无关的存档适配层，接口保持接近 `getData/getList/saveData`。
3. 桌面端可以优先落地为本地文件存档，再抽象出远程账号存档。
4. 原始 `downloads/` 发布包保持只读，修改产物输出到独立目录。
5. 任何二进制补丁都应基于明确的调用点和可回滚产物，不直接覆盖原包。

## 当前 mock 日志策略

当前阶段先只在外层接口和本地 mock 层加日志，不修改 SWF 发布包。日志用于观察平台接口调用链，包括保存、读取、存档列表、session、服务器时间和部分付费 stub。

运行 `npm run saveData:serve` 后，日志会写入：

- `workspace/saveData/logs/mock-api.ndjson`

如果只想尽量减少运行期 I/O 和公网测试抖动，可以无日志启动：

```bash
SAVE_DATA_LOGS=0 npm run saveData:serve
```

也可以使用等价别名：

```bash
SAVE_DATA_NO_LOGS=1 npm run saveData:serve
```

无日志模式下接口仍会正常返回，`/api/saveData/logs` 返回空列表，客户端 `client.fetch_slow/client.frame_jank` telemetry 也会被服务端丢弃。

也可以通过本地接口查看：

- `GET /api/saveData/logs?limit=200`：查看最近日志。
- `GET /api/saveData/logs/clear`：清空日志。
- `GET /api/saveData/slots`：查看当前 mock 数据库中的存档位摘要。
- `GET /api/saveData/wallet`：查看当前本地 mock 钱包。
- `POST /api/saveData/recharge`：本地模拟充值，更新 `wallet_mock.balance` 和 `wallet_mock.total_recharged`，并写入 `recharge_records`。

保存日志不会直接把完整存档 payload 全量写入日志，只记录：

- `uid/gameid/slotIndex/title`
- 接口事件名与结果
- payload 长度
- payload `sha256`
- payload 前缀预览

完整 payload 仍保存在 SQLite 的 `save_slots.raw_data` 中。由于 4399 ctrl 层传入 mock 接口的 `data` 是压缩/Base64 后的字符串，mock 层目前无法直接看到 `jxrole/jxguanka/jxkaizhong/asaved` 这类真实对象字段。

公网调试卡顿时，页面会把两类轻量客户端事件写入同一个日志：

- `client.fetch_slow`：SWF、存档、商城等请求耗时超过阈值，或请求失败。
- `client.frame_jank`：浏览器 `requestAnimationFrame` 在 15 秒窗口内出现 80ms 以上长帧。

URL 上可用以下开关临时调整：

- `telemetry=0`：关闭客户端性能日志。
- `warmup=0`：关闭常用战斗资源预热。

运行页现在固定使用 Ruffle `webgl` 渲染。不要再切回 `canvas`：canvas 会丢失部分 Flash 滤镜效果，表现为黄色文字黑描边、发光或阴影和原版不一致。

服务端默认只记录首次远程拉取和接口调用，不再为每个已缓存 SWF 资源写 `asset.local_hit`，避免资源密集加载时同步日志写入干扰响应。若需要详细资源命中日志，可启动时加：

```bash
SAVE_DATA_LOG_ASSET_HITS=1 npm run saveData:serve
```

`SAVE_DATA_LOG_ASSET_HITS=1` 只在日志开启时生效。

手动保存后已确认 `raw_data` 的外层格式是 `Base64(zlib deflate(saveXml))`。解压后可得到 `saveXml`，其中包含 `jxsflag/jxrole/jxv/jxid/jxjinenglv/sidx/newnn/kpji/jxguanka/jxkaizhong/asaved/idn` 等顶层字段。当前代码仍只保存原始 payload，尚未内置 XML 解码和字段类型化工具。

如果需要查看运行时对象在进入平台序列化前的状态，再做小范围 SWF patch，优先 patch 以下位置输出结构化日志：

- `ApiInterface.writeData()`
- `ApiInterface.readData()`
- `Api4399.saveDataStart()`

patch 产物应输出到独立运行目录，不覆盖 `downloads/` 原始发布包。

## 本地充值 mock

当前本地运行页侧边栏提供 `点击充值` 按钮。它只作用于本地 SQLite mock 数据库，不访问 4399 真实充值接口，也不会修改线上账号余额。

页面会在检测到当前已经进入存档后暂时禁用本地充值入口，避免游戏内存里的累计充值 `allChongGod` 与 SQLite 中的新累计充值不同步。需要充值时，先重载游戏或回到进入存档前的状态，充值完成后再进入存档。

按钮提交金额后：

1. 调用 `POST /api/saveData/recharge`。
2. 本地数据库同时增加当前余额 `balance` 和累计充值 `total_recharged`。
3. 后续游戏调用 `GetMoney` 时返回新的当前余额。
4. 后续游戏调用 `GetTotalRecharge` 时返回新的累计充值。
5. 页面只尝试通过 Ruffle 暴露回调通知游戏刷新当前余额，不主动触发累计充值刷新。

反编译代码里 `ApiInterface.allChongGod` 的普通 setter 只允许从初始负值写入一次，二次写入会进入异常逻辑。因此本地 mock 充值的推荐测试顺序是：

1. 先在本地运行页点击 `点击充值`。
2. 再选择存档进入游戏。
3. 进入游戏时原有 `GM.testapi.getAllChongeMoney()` 链路会首次读取 `GetTotalRecharge`，把本地 mock 的累计充值写入 `allChongGod`。
4. 之后进商城购买、保存、切换存档并读档，购买得到的道具会随 `jxkaizhong.jxbag` 存档结构持久化。

如果以后必须支持游戏中途充值后立即刷新累计充值，需要做一个仅本地运行产物使用的小范围 SWF patch，专门走 `allChongGodbbb` 或等价本地入口更新累计充值；不要复用普通 `rechargedMoney` 二次写入路径。

## 本地商城购买 mock

当前本地 mock 已接管 `POST /api/4399/mall/FlashStoreApi` 的 Thrift 二进制协议：

- `getPropList` 返回空列表，避免平台商城列表请求 404。
- `buyProp` 解析 `Head` 和 `PropInfo`，成功时返回 `RES_BuyData`，字段保持 `propId/count/tag` 与请求一致，让游戏侧 `buySuccFun()` 校验通过。
- 余额不足、价格不匹配或累计充值不足时返回 `Err_Store`，错误码使用游戏会当作普通购买失败处理的 `20002/20003`，不返回通用 Thrift exception。

购买 mock 会读取 `workspace/saveData/remote-assets/.../dataxmlvav447.swf` 中的商城和物品基础数据：

1. 用商城 XML 的 `平台随机ID` 找到平台商品。
2. 用商品的 `商城ID` 找到物品 XML 中的 `商城价格`。
3. 估算本次购买会新增的背包商城价值。
4. 读取当前存档位 `jxkaizhong.jxbag` 中 `b1/b2/b3/b4/b5/b9` 的已有商城价值。
5. 按游戏保存前检查里的倍率 `0.75` 计算所需累计充值：`ceil((已有商城价值 + 新增商城价值) * 0.75)`。

`GetTotalRecharge` 本身没有存档位参数，因此 mock 会按当前账号所有本地存档中的最高商城价值，把返回的累计充值抬高到保存检查需要的安全线以上。`buyProp` 仍按请求中的 `Head.index` 对当前购买存档位做投影校验；如果投影后超过游戏本轮已经能看到的累计充值，会返回 `20003`，需要先本地充值并重新进入游戏。

注意：本地充值和购买记录只更新 SQLite mock 数据库，不会修改线上账号，也不会直接改存档。购买成功后仍由游戏自己的 `buySuccFun()` 把道具加入背包，是否持久化取决于玩家之后是否走原游戏保存流程。

## 尚未确认

- `Main.serviceHold` 在页面层和 4399 平台之间的完整实现还需要继续追踪。
- `DataList` 下各活动数据的业务含义尚未逐个展开。
- 新账号系统需要的用户 ID、存档位、角色名之间的映射策略尚未设计。
