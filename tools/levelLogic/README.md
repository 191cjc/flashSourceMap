# levelLogic 关卡配置与奖励分析

这个目录用于沉淀关卡数据、关卡难度、关卡成就点和通关奖励相关逻辑的阅读结论。当前已经接入本地 saveData 运行时覆盖能力：实现代码在 `runtime/save-data/`，这里记录分析依据和功能边界。

## 分析目标

1. 找出关卡配置从 XML 加载到运行时对象的路径。
2. 找出关卡成就点、通关需求和关卡解锁逻辑。
3. 找出关卡难度如何传入战斗运行时。
4. 找出通关后的经验、金币、成就和开牌奖励结算流程。

## 当前结论

关卡逻辑主要分为三层：

- 静态配置层：`LevelDataManager.createClel()` 从 XML 读取关卡配置，构造运行时关卡数据和 `LevelBD` 基础数据。
- 存档进度层：`LevelSaveD` 和 `LevelSaveDList` 保存每个关卡的成就点、通关状态和已达成难度。
- 运行结算层：`CLevel` 负责当前关卡的经验、金币、成就和开牌奖励计算，`PinFengC/KaiPaiC/GamePassC` 负责通关后的 UI 流程。

## 配置加载链路

游戏初始化时，`GameDataInit` 会加载 XML 并调用关卡数据构造方法：

- `LevelDataManager.createCbo`
- `LevelDataManager.createCdoor`
- `LevelDataManager.createCroom`
- `LevelDataManager.createCsce`
- `LevelDataManager.createClel`
- `LevelDataManager.initnewlevelshowbd`

其中 `createClel()` 是关卡主体配置入口，会解析 XML 中的 `<关卡>` 节点。

## 关卡配置字段

`LevelDataManager.createClel()` 读取的主要字段包括：

- `关卡ID`
- `关卡名`
- `难度`
- `进入条件ID`
- `物品ID`
- `过关需求关卡成就`
- `成就最大值`
- `成就奖励经验`
- `成就奖励金币`
- `过关奖励经验`
- `过关奖励金币`
- `过关奖励成就`
- `剩余生命额外奖励`
- `中立怪个数`
- `被击数`
- `经验等级惩罚`
- `晶币等级惩罚`
- `开牌奖励`
- `关卡元件`
- `场景列表`

这些字段会被拆进两个方向：

- 运行时关卡对象，用于进入战斗后计算奖励和场景。
- `LevelBD` 基础数据，用于关卡列表、解锁判断和成就上限展示。

## 关卡成就点

`LevelBD` 中和成就有关的关键字段：

- `passach`：过关或解锁需求的关卡成就点。
- `maxach`：当前关卡可获得的最大成就点。

`LevelSaveD` 中和进度有关的关键字段：

- `id`：关卡 ID。
- `lAchieve`：该关卡已获得成就点。
- `lOver`：该关卡已达成的最高通关难度或星级进度。

核心逻辑：

- `LevelSaveD.hasOver()` 使用 `lAchieve >= tempbd.passach` 判断是否满足通关/前置条件。
- `LevelSaveD.addAchieve()` 增加成就点，并把成就点封顶到 `tempbd.maxach`。
- `LevelSaveD.addLstar()` 保存更高的通关难度进度。

`LevelSaveDList.getOverProcess(id)` 负责关卡解锁判断：

- 如果存档里已经有该关卡记录，返回 `lOver`。
- 如果该关卡没有前置关卡，即 `enterlid == 0`，会创建初始记录。
- 如果前置关卡存在且 `hasOver()` 为真，会创建当前关卡记录。
- 否则返回 `-1`，表示未解锁或不可进入。

## 关卡难度

关卡难度主要通过 `lstar` 或 `ll` 传递：

- XML 中的 `难度` 会进入运行时关卡数据的 `_diff`。
- `CLevel` 构造时读取 `param1._diff` 并设置 `this.lstar`。
- UI 选择关卡时调用 `LevelManager.changeLevelDataByIdAndLs(id, ls)`。
- `changeLevelDataByIdAndLs()` 根据 `LevelBD` 的进入场景信息组装 `{gqm,cjm,fjm,x,y,ll}`，其中 `ll` 就是传入的难度。
- `CScene`、`CRoom` 等运行时对象会继续使用 `lstar` 加载对应难度的房间、怪物或场景数据。

常见入口包括老关卡选择、新关卡选择、活动关卡、生肖关卡、挑战塔等。

## 通关奖励结算

通关后主要由 `PinFengC` 分阶段播放和结算：

1. `getHpRat()`：计算剩余生命或生命比例相关显示。
2. `getKillBaoWu()`：统计击杀和掉落相关内容。
3. `getByHitNum()`：统计被击次数相关表现。
4. `getAgod()`：结算金币。
5. `getAexp()`：结算经验。
6. `getAach()`：结算成就点。

`CLevel.getAgod()`：

- 以 `awardfixgod` 作为基础通关金币。
- 额外金币来自剩余生命、中立怪数量、被击数等规则。
- 会考虑等级惩罚或倍率配置。
- 最终通过 `GM.cp.addGodByRole(...)` 发放。

`CLevel.getAexp()`：

- 以 `awardfixexp` 作为基础通关经验。
- 额外经验同样会参考剩余生命、中立怪数量、被击数等规则。
- 会考虑等级惩罚或倍率配置。
- 最终加到角色经验。

`CLevel.getAach()`：

- 以 `awardfixach` 作为基础通关成就点。
- 额外成就来自剩余生命、中立怪数量、被击数等规则。
- 调用 `GM.levelSD.addAch(this.id, achieve, this.lstar)` 写入关卡进度。
- 当成就跨过 `achexpkey/achgodkey` 阈值时，还会发放额外经验或金币奖励。

## 开牌奖励

评分阶段结束后，流程进入 `KaiPaiC`：

1. 玩家选择一张牌。
2. 调用 `GM.levelm.curLevel.getKaiPaiAward()`。
3. `CLevel.getKaiPaiAward()` 使用 `Math.random() * 10000` 生成随机值。
4. 遍历 `kaipaiaward` 权重数组。
5. 根据命中的配置调用 `FlowInterface.createGoodsByCreateLevel(...)` 生成物品。
6. 检查背包容量。
7. 金币类物品直接加金币，普通物品进入背包。

开牌完成后会进入 `GamePassC`。部分流程中会设置 `GM.testapi.isShowSaveS = true` 并调用 `GM.testapi.saveDataBefore()` 保存通关结果。

## 关键文件索引

- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/GameDataInit.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/LevelDataManager.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/LevelManager.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/CLevel.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/CScene.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/CRoom.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/leveldata/LevelBD.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/leveldata/LevelBDList.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/leveldata/LevelSaveD.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/leveldata/LevelSaveDList.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gview/PinFengC.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gview/KaiPaiC.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gview/GamePassC.as`

## 后续开发方向

### 已接入的本地覆盖能力

`runtime/save-data` 左侧操作面板现在提供“通关奖励”编辑区，可修改单个关卡难度的基础通关奖励：

- `过关奖励经验`
- `过关奖励金币`
- `过关奖励成就`

实现边界：

- 覆盖配置保存到 `workspace/saveData/level-rewards.json`。
- 原始资源仍来自 `workspace/saveData/remote-assets/.../dataxmlvav447.swf`。
- 服务端读取 DefineBinaryData `52` 中的关卡 XML，按覆盖配置替换上述三个字段，再生成 `workspace/saveData/generated-assets/level-rewards/dataxmlvav447.swf`。
- 游戏初始化加载 `dataxmlvav447.swf` 时才会读取奖励配置，所以修改后需要重载游戏才能生效；已进入的关卡不会即时刷新。
- 当前不修改 `开牌奖励`、解锁条件、成就上限、怪物或场景配置。

后续如果要做更完整的关卡数据工具，建议继续扩展：

1. 解析反编译导出的 XML 或 AS3 初始化数据。
2. 导出关卡 ID、关卡名、难度、前置关卡、需求成就、最大成就、基础奖励。
3. 导出每个关卡的开牌奖励权重表。
4. 建立关卡解锁图，标出每个关卡依赖的前置关卡。
5. 将结果输出为 JSON 和 Markdown，方便后续做可视化或桌面端配置编辑器。

## 尚未确认

- XML 原始资源在反编译目录中的准确位置还需要继续整理。
- `剩余生命额外奖励`、`中立怪个数`、`被击数` 的数组格式需要结合实际 XML 样本进一步解释。
- 特殊活动关卡、挑战塔、PK 关卡是否完全复用普通关卡结算链路，需要逐个确认。
