# noCheat 反作弊机制分析

这个目录用于沉淀反作弊相关逻辑的阅读结论，并为后续开发 `noCheat` 相关分析工具做准备。这里只记录机制和流程，不包含修改发布包、绕过校验或注入逻辑的实现。

## 当前结论

当前反编译结果显示，项目里的反作弊逻辑更像是“客户端自检 + 存档异常标记”，而不是完整的服务端强校验系统。

主要分为三层：

1. 数值混淆包装
   - 相关文件：
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/common/VT.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/common/SVT.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/common/GSSVT.as`
   - 作用：把数值以随机偏移的形式存储，读取时再还原，降低直接搜索裸数值的可行性。

2. 存档异常标记
   - 相关文件：
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/savedatal/CheckFlag.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/savedatal/CheckFlagM.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/savedatal/NewSDList.as`
   - `CheckFlagM` 会把异常记录保存进存档字段 `asaved.cm`。
   - 已识别的异常类型包括：
     - `id不同`
     - `存档位不同`
     - `物品价格超过`
     - `物品数量超过`
     - `直接改了存档`
     - `掉落了不可能掉的`
     - `职业标识有问题`
     - `基础数据修改`
     - `不存在些物品id`

3. 读档、保存和业务行为触发点
   - 相关文件：
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/ApiInterface.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/Api4399.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/repository/goods/GoodsFactory.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/DiaoLouGoodsM.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/glevel/CLevel.as`
     - `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/Control/FlowInterface.as`
   - `ApiInterface.dataCheckTest()` 会检查用户 ID、存档位、`idandindex` 和直接改档标记。
   - `Api4399.saveDataStart()` 保存前会检查背包结构、物品总商城价和物品数量上限。
   - `GoodsFactory` 会在物品 ID 不存在或 ID 对不上时写入异常标记。
   - `DiaoLouGoodsM` 会在拾取特定“不可能掉落”的物品时写入异常标记。
   - `CLevel` 和 `FlowInterface` 会检查职业标识是否异常。

## 处置入口观察

项目里有大量调用 `GM.findCheatMax()`、`GM.findTrueCheatMax()` 和 `GM.findCheatMaxLeave()` 的位置，但当前 AS3 和 p-code 反编译结果中，这几个函数本身是空实现。

因此，当前发布包里更确定的反作弊痕迹是“写入存档的异常标记”，而不是已经还原出的强制封禁、弹窗或退出逻辑。

## 后续 noCheat 开发方向

后续如果开发 `noCheat`，建议先把目标限定为“分析和可视化”，而不是直接修改发布包：

1. 解析反编译目录中的相关 AS3 文件。
2. 汇总所有 `addFlag`、`addFlagB`、`addDanagerFlag` 调用点。
3. 输出异常类型、触发文件、触发行号、触发条件的索引表。
4. 标记哪些逻辑只是运行时空入口，哪些逻辑会写入存档。
5. 为存档结构、账号系统和未来桌面端打包保留独立适配层。

如果以后需要修改发布包，应把 `downloads/` 下的原始文件视为只读来源，把修改后的产物输出到 `builds/` 或专门的补丁目录中，避免污染原始发布包。

## 约定的数据分析流程

之后进行类似数据分析时，先按以下流程整理资料：

1. 在 `tools/` 下创建一个专题目录，目录名使用简短英文驼峰或小驼峰命名。
2. 在专题目录中先创建中文 `README.md`。
3. README 先记录：
   - 分析目标
   - 当前阶段结论
   - 涉及的关键路径
   - 尚未确认的问题
   - 后续开发或分析方向
4. 确认 README 结构后，再添加脚本、数据导出或自动化工具。
5. 原始发布包、反编译结果、分析脚本、修改产物分目录管理，不互相覆盖。

## 当前状态

本目录目前只包含结论文档，尚未实现任何 `noCheat` 代码。
