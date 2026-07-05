# 宠物孵化逻辑分析

本文记录游戏宠物蛋使用、孵化倒计时、概率和存档结构的当前分析结论。

## 结论

宠物孵化逻辑主要在客户端 AS3 内完成，不是独立服务端接口。

整体流程：

1. 玩家在背包中使用宠物蛋物品。
2. 背包逻辑判断物品小类型是否为 `GS.a18`。
3. 根据物品配置中的 `需求id` 和 `奖励概率` 抽取一个宠物 ID。
4. 调用 `PetManager.useEgg(pid, datelimit, pcolor)` 写入 `eggArr`。
5. `EggR.datelimit` 设置本次运行时的到期时间。
6. `PetManager.autoUpdate()` 在倒计时结束后把蛋转换为 `PetR`。
7. 立即孵化按钮调用 `PetManager.eggChangPet(slot)`，直接把指定槽位的蛋转换为宠物。

## 关键代码

反编译代码位置：

```text
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/pet/PetManager.as
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/pet/EggR.as
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/pet/PetR.as
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/views/playerPanel/BagDisplay.as
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/views/chongwu/ChongWuPanel.as
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/repository/goods/GoodsFactory.as
decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/repository/goods/GoodsData.as
```

`PetManager.useEgg(pid, datelimit, pcolor)` 会找第一个空槽，创建 `EggR`，写入：

```as3
egg.pid = pid;
egg.pcolor = pcolor;
egg.datelimit = datelimit;
eggArr[slot] = egg;
```

`PetManager.autoUpdate()` 会检查：

```as3
if (egg.countTime() <= 0) {
  eggArr[slot] = null;
  pet = new PetR();
  pet.initBid(egg.pid);
  petArr[slot] = pet;
}
```

`EggR.countTime()` 返回：

```as3
usedate - FlowInterface.getCurrTimer()
```

`EggR.datelimit` setter 会设置：

```as3
usedate = FlowInterface.getCurrTimer() + datelimit;
```

## 物品配置

宠物蛋物品数据来自：

```text
assets/exported/dataxmlvav447/binary/15_DefineBinaryData.bin
```

宠物蛋一般满足：

```xml
<类型>2</类型>
<小类型>18</小类型>
```

关键字段：

- `<其他><值>`：孵化等待时间，单位毫秒。
- `<其他><需求id>`：候选宠物 ID 列表，使用 `*` 分隔。
- `<其他><奖励概率>`：候选宠物概率权重，使用 `*` 分隔。

例子：

- `331093 普通的宠物蛋`：`值=1800000`，即 30 分钟。
- `331196 高级宠物蛋`：`值=1000`，基本等同快速孵化。
- `331253 烈焰凤凰宠物蛋`：`需求id=15`，`奖励概率=1000000`，因此必定孵出宠物 ID `15`。

## 存档结构

宠物数据位于 `petm`：

- `petm.parr`：已经孵化完成的宠物数组。
- `petm.earr`：尚未孵化完成的蛋数组。

蛋对象保存字段：

```json
{
  "id": 15,
  "dl": 1800000,
  "pc": 4
}
```

含义：

- `id`：目标宠物 ID。
- `dl`：孵化等待时间。
- `pc`：蛋颜色。

注意：蛋存档保存的是 `dl`，不是绝对到期时间。读档时会重新计算 `usedate = 当前时间 + dl`，因此未孵化蛋可能在重载后重新开始等待。

## 可改造点

让蛋立即孵化：

- 修改物品数据中的 `<其他><值>` 为 `0` 或 `1000`。
- Patch `PetManager.useEgg()`，固定 `datelimit = 0`。
- Patch `EggR.countTime()`，让它始终返回 `0`。
- 批量处理已有蛋时，优先调用游戏自身的 `eggChangPet(slot)`，避免手工拼接复杂的 `PetR` 存档对象。

控制孵化结果：

- 修改物品配置中的 `需求id` 和 `奖励概率`。
- 或在 `BagDisplay.as` 的抽奖逻辑之后强制指定选中的宠物 ID。

如果只想让某个蛋必出固定宠物，最简单的数据形态是：

```xml
<需求id>15</需求id>
<奖励概率>1000000</奖励概率>
```
