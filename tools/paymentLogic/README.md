# paymentLogic 付费链路分析

这个目录用于沉淀付费、余额、充值累计和商城购买相关逻辑的阅读结论。这里只放机制分析；本地钱包、充值和商城购买 mock 的公共运行能力在 `runtime/save-data/`。

## 分析目标

1. 找出当前余额和累计充值额分别从哪里获取。
2. 找出商城购买从 UI 到平台接口的调用链。
3. 找出反作弊中与付费比较相关的真实数据来源。
4. 为以后自建账号系统、存档系统和桌面端支付替换保留接口边界。

## 当前结论

项目中至少存在两类和付费有关的金额：

- 当前余额：通过 `getDGBalance()` 获取，UI 中通常表现为星钻余额。
- 累计充值：通过 `getAllChongeMoney()` 或 `getAllChongeMoneyByVip()` 获取，主要用于活动、VIP、充值累计和反作弊比较。

真正参与“商城物品总价值是否超过已充值额度”比较的是累计充值额 `allChongGod`，不是当前余额 `dgMoney`。

## 当前余额链路

余额查询：

1. 游戏调用 `GM.testapi.getDGBalance()`。
2. `Api4399.getDGBalance()` 调用 `Main.serviceHold.getBalance()`。
3. 平台回包触发 `PayEvent.GET_MONEY`。
4. `ApiInterface.onPayEventHandler()` 分发事件。
5. `GameShangChengC.self.getMoneyOk(param1.data.balance)` 更新商城 UI 余额。

UI 中的余额字段：

- `GameShangChengC._dgMoney` 使用 `VT` 包装。
- `GameShangChengC.dgMoney` 是读写当前余额的 getter/setter。
- `FlowInterface.getDGMoney()` 也会读取 `GameShangChengC.self.dgMoney`。

## 累计充值链路

累计充值查询：

1. 游戏调用 `GM.testapi.getAllChongeMoney()`。
2. `Api4399.getAllChongeMoney()` 调用平台累计充值接口。
3. 平台回包触发 `PayEvent.RECHARGED_MONEY`。
4. 回包数据写入 `allChongGod`、`dateInChongGod`、`vipChongGod`、`summerVchongGod`、`congGuoNian` 等字段。

`allChongGod` 是反作弊比较中最关键的累计值。

## 充值入口

普通充值入口：

1. UI 或业务逻辑调用 `GM.testapi.gameChongMoney(value)`。
2. `Api4399.gameChongMoney(param1)` 创建或更新 `payMoneyVar.money`。
3. 调用 `Main.serviceHold.payMoney_As3(payMoneyVar)`。

代码里还有 `gameChongMoneyByTrue()` 等接口形态，需要后续结合页面层或平台层继续确认用途。

## 商城购买链路

通用购买入口：

1. UI 先检查当前余额是否足够。
2. 调用 `FlowInterface.djGouMai(...)` 或直接调用 `GM.testapi.getStateAndBuyShopProp(...)`。
3. `Api4399.getStateAndBuyShopProp(param1, param2, param3, param4, param5)` 保存本次购买上下文：
   - `sid`：平台商品或道具 ID。
   - `num`：购买数量。
   - `pprice`：单价或请求价格。
   - `pid`：游戏内发放物品 ID。
   - `tax`：请求标记。
4. 购买前先调用 `getSaveStateByFun(getStateAndBuyShopPropCallBack)`。
5. `getStateAndBuyShopPropCallBack()` 组装 `{propId,count,price,idx,tag}`。
6. 调用 `Main.serviceHold.buyPropNd(...)`。

购买回包：

1. 平台回包进入 `ApiInterface.onShopEventHandler()`。
2. 成功时调用 `buySuccFun(param1)`。
3. 失败时调用 `errorFun(param1)`。

成功回包会校验：

- 回包 `propId` 必须等于本次请求的 `shopdata.sid`。
- 回包 `count` 必须等于本次请求的 `shopdata.num`。
- 回包 `tag` 必须等于本次请求的 `shopdata.tax`。

校验通过后：

- 如果 `pid != 0`，调用 `FlowInterface.addInBagDL(FlowInterface.getGoodsById(pid), num)` 发放游戏内物品。
- 使用回包的 `balance` 更新 `GameShangChengC.self.dgMoney`。
- 清空 `shopdata/shopFun`。
- 调用购买回调。

失败回包中，`eId` 为 `20002/20003` 时会按购买失败处理，其他错误可能进入作弊异常处理。

## UI 购买检查

`GameShangChengC` 中的商城 UI 会先做余额判断：

- 多个购买入口都会比较 `buyPrice * buynumCur > dgMoney`。
- 余额不足时会弹出充值界面。
- 余额足够时调用 `buyShopByApi()` 或 `buyShopByApiOne()`。

其他功能也会直接调用购买接口，例如复活、活动关卡、开牌、强化、礼包、生肖系统等。

## 反作弊中的付费比较

保存前检查中有一条关键逻辑：

`BagFactory.getShopG() * (GS.a07 + GS.a05 * GS.a01) > allChongGod`

含义是：背包中商城物品估算总价值乘以某个倍率后，如果超过累计充值额，就向 `CheckFlagM` 写入异常标记。

这条逻辑也说明：

- 客户端不是只看当前余额。
- 用于比较的是累计充值 `allChongGod`。
- 背包物品价值来自 `BagFactory.getShopG()`。
- 当前判断属于客户端保存前异常标记，具体处置还要结合 `CheckFlagM` 和后续服务端/平台行为继续确认。

## 关键文件索引

- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/Api4399.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/ApiInterface.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gameobj/ApiShopTax.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/gview/GameShangChengC.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/Control/FlowInterface.as`
- `decompiled/ffdec/L4399Main_gamefile/as3/scripts/hotpointgame/views/shopPanel/ShopData.as`

## 后续开发方向

如果以后替换 4399 页面层或做桌面端，需要把付费相关能力拆成几类接口：

1. `getBalance()`：查询当前余额。
2. `getTotalRecharged()`：查询累计充值。
3. `payMoney()`：打开或执行充值。
4. `buyProp()`：购买平台商品并返回商品、数量、余额和请求标记。
5. `grantItem()`：把购买结果映射为游戏内物品发放。

如果早期版本暂时不做真实支付，可以保留接口形状，用本地开发桩返回固定数据，但应在文档和代码中明确区分“开发环境模拟”和“真实付费”。

## 尚未确认

- `Main.serviceHold` 到 4399 平台支付接口的具体页面层代码还需要继续追踪。
- `ApiShopTax.tax` 的完整语义需要结合请求和回包继续确认。
- 各活动系统对累计充值字段的使用尚未全部展开。
