# 军团功能接口文档

> 实现来源 commit：`44a40c7 实现本地可玩军团 mock`（cherry-pick 自 main 分支到 master-bak）
>
> 协议依据：本地缓存的官方 `ctrl_mo_v5.swf` 中 `ctrl4399.proxy.unionApi` Thrift 生成代码，以及主游戏 SWF 的实际调用代码。

## 概述

军团功能通过 **Thrift Binary Protocol** 进行通信。客户端（Flash SWF）发送 Thrift 二进制请求，本地 mock 服务器解析后路由到对应处理逻辑，返回 Thrift 二进制响应。

官方网络方法使用 `unionCreate`、`unionList`、`unionApply` 等名称。文档中 `/` 后的名称是控制器包装方法或本地兼容别名，不代表官方客户端一定会发送该 Thrift 方法名。

官方控制 SWF 将军团接口分为 visitor、member、grow、master、variable、role 多个 URL；本地服务统一通过 `/api/4399/union/*` 路由处理。

### 请求结构

每个请求包含：

| 位置 | Thrift 字段 ID | 类型 | 说明 |
|------|--------------|------|------|
| Header | field 1 (STRUCT) | UnionApiHeader | 公共头部 |
| Body | field 2+ | 各方法自定义 | 方法参数 |

**UnionApiHeader 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | tag | 请求标识，原样回传 |
| 2 | STRING | gameId | 游戏 ID，默认 `100025235` |
| 3 | STRING | index | 存档槽位索引字符串，通常为 `"0"` |

---

## 接口列表

### 1. 创建军团 `unionCreate` / `createUnion`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | STRING | title | 是 | 军团名称 |
| 3 | STRING | extra | 否 | 军团公告，默认 `欢迎加入军团，大家可以加入QQ群:XX!*0` |

**响应：** `BoolResponse` — `true` 成功，`false` 已在军团或名称为空

---

### 2. 获取军团列表 `unionList` / `getUnionList`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId） |
| 2 | I32 | pageId | 否 | 页码，默认 `1` |
| 3 | I32 | pageShow | 否 | 每页数量，默认 `10` |

**响应：** `UnionListResponse`

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | tag | 请求标识 |
| 2 | LIST\<UnionListItem\> | unionList | 军团列表（按等级/经验降序） |
| 3 | STRING | count | 总数量 |

**UnionListItem 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | I32 | unionId | 军团 ID |
| 2 | STRING | title | 军团名称 |
| 3 | STRING | username | 团长用户名 |
| 4 | I32 | level | 军团等级 |
| 5 | STRING | count | 成员数量 |
| 6 | STRING | extra | 军团公告 |
| 7 | I32 | experience | 军团经验 |

---

### 3. 申请加入军团 `unionApply` / `applyUnion`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | I32 | unionId | 是 | 目标军团 ID |
| 3 | STRING | extra | 否 | 申请附言，默认 `1*0*本地机甲*0` |

**响应：** `BoolResponse`

---

### 4. 查询我的军团 `unionOfMe` / `getOwnUnion`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |

**响应：** `UnionOfMeResponse`

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | tag | 请求标识 |
| 2 | STRUCT | me | `Me`（含 unionInfo + member） |

没有加入军团时，`Me` 中不写入 `unionInfo` 和 `member` 字段，使官方客户端将二者保持为 `null`。

**UnionInfo 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | I32 | id | 军团 ID |
| 2 | I32 | gameId | 游戏 ID |
| 3 | STRING | uId | 团长 UID |
| 4 | STRING | userName | 团长用户名 |
| 5 | STRING | index | 团长创建军团时使用的存档槽位 |
| 6 | STRING | nickName | 团长昵称 |
| 7 | STRING | title | 军团名称 |
| 8 | I32 | level | 军团等级（经验/1000+1） |
| 9 | I32 | experience | 军团经验 |
| 10 | I32 | contribution | 军团贡献值 |
| 11 | STRING | extra | 军团公告 |
| 12 | STRING | extra2 | 扩展字段2 |
| 13 | STRING | dissolveDate | 解散日期（空=未解散） |
| 14 | STRING | count | 成员数量 |
| 15 | STRING | transfer | 转让信息 |

**UnionMember 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | I32 | gameId | 游戏 ID |
| 2 | I32 | unionId | 军团 ID |
| 3 | STRING | uId | 成员 UID |
| 4 | STRING | userName | 成员用户名 |
| 5 | STRING | index | 槽位索引 |
| 6 | STRING | nickName | 成员昵称 |
| 7 | I32 | contribution | 个人贡献值 |
| 8 | STRING | extra | 扩展字段（格式：`1*0*机甲名*0`） |
| 9 | STRING | extra2 | 扩展字段2 |
| 10 | STRING | active_time | 最后活跃时间（毫秒时间戳字符串） |
| 11 | STRING | roleId | 角色 ID（"1"=团长，"0"=成员） |
| 12 | STRING | roleName | 角色名称 |

---

### 5. 查询军团详情 `unionInfo` / `getUnionDetail`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部 |
| 2 | I32 | unionId | 是 | 军团 ID |

**响应：** `UnionInfoResponse`（含 UnionInfo 结构，见上）

---

### 6. 查询军团成员列表 `unionMembers` / `getUnionMembers`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部 |
| 2 | I32 | unionId | 是 | 军团 ID |

**响应：** `UnionMembersResponse`（LIST\<UnionMember\>，按角色/贡献降序）

---

### 7. 设置成员扩展信息 `setMemberExtra` / `setMemberExtraRevised`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| 1 | STRUCT | header | 是 | 公共头部 |
| 2 | I32 | type | 是 | 官方接口的更新类型；主游戏更新自身资料时传 `1` |
| 3 | STRING | extra | 是 | 新的 extra 值 |
| 4 | I32 | unionId | 是 | 军团 ID |
| 5 | I32 | uId | 是 | 目标成员 UID |
| 6 | I32 | index | 是 | 目标成员槽位 |

**响应：** `BoolResponse`

---

### 8. 设置军团公告 `setUnionExtra`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| 1 | STRUCT | header | 是 | 公共头部（当前用户需为团长） |
| 2 | I32 | type | 是 | 官方接口的更新类型；主游戏传 `1` |
| 3 | STRING | extra | 是 | 新的公告内容 |
| 4 | I32 | unionId | 是 | 军团 ID |

**响应：** `BoolResponse`

---

### 9. 查询军团日志 `unionLog` / `getUnionLog`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | I32 | pageId | 否 | 页码，默认 `1` |
| 3 | I32 | pageShow | 否 | 每页数量，默认 `10` |

**响应：** `UnionLogListResponse`

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | tag | 请求标识 |
| 2 | LIST\<STRING\> | logList | 日志列表（JSON 字符串，含 time/msg/userName） |
| 3 | STRING | count | 总数量 |

---

### 10. 退出军团 `unionQuit` / `quitUnion` / `quitUion`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |

**响应：** `BoolResponse` — 团长不可退出

---

### 11. 完成军团任务 `doTask`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | STRING | taskId | 是 | 任务标识。部分值是官方任务编号，部分调用直接传贡献配置值 |

**响应：** `BoolResponse` — 成功时同时增加个人贡献、军团经验和军团可用贡献

本地已确认的任务映射：`7 → 20`、`9 → 50`、`10 → 100`、`20 → 20`、`21 → 13`。其他正数字符串作为贡献配置值处理，上限 10000；非数字值按 20 处理。

---

### 12. 查询任务贡献值 `getTaskValue`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |

**响应：** `UnionTaskValueResponse`

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | tag | 请求标识 |
| 2 | LIST\<UnionTask\> | value | 任务列表 |
| 3 | STRING | exchange | 兑换贡献（固定 "0"） |
| 4 | STRING | total | 总贡献值 |

**UnionTask 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | taskName | 任务 ID |
| 2 | STRING | value | 贡献值 |

---

### 13. 兑换贡献 `exchange` / `doExchange`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | I32 | money | 是 | 兑换金额（最小 1000） |

**响应：** `BoolResponse`

---

### 14. 查询申请列表 `applyList` / `getApplyList`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | I32 | pageId | 否 | 页码，默认 `1` |
| 3 | I32 | pageShow | 否 | 每页数量，默认 `6` |

**响应：** `UnionApplyListResponse`

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | tag | 请求标识 |
| 2 | LIST\<UnionApply\> | applyList | 申请列表 |
| 3 | STRING | count | 总数量 |

**UnionApply 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | I32 | gameId | 游戏 ID |
| 2 | I32 | unionId | 军团 ID |
| 3 | STRING | uId | 申请者 UID |
| 4 | STRING | userName | 申请者用户名 |
| 5 | STRING | index | 申请者槽位 |
| 6 | STRING | nickName | 申请者昵称 |
| 7 | STRING | extra | 申请附言 |

---

### 15. 审核申请 `applyAudit` / `auditMember` / `auditMemberRevised`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index，需为团长） |
| 2 | I32 | uId | 是 | 申请者 UID |
| 3 | STRING | index | 是 | 申请者槽位字符串 |
| 4 | I32 | auditResult | 是 | `1`=通过，其他=拒绝 |

**响应：** `BoolResponse`

---

### 16. 批量审核申请 `applyAuditMuch` / `applyMultiAudit`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（需为团长） |
| 2 | LIST\<UserRef\> | users | 是 | 申请者列表（每项含 field1=uId, field2=index） |
| 3 | I32 | auditResult | 是 | `1`=通过，其他=拒绝 |

**响应：** `BoolResponse`

---

### 17. 踢出成员 `memberRemove` / `removeMember` / `removeMemberRevised`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（需为团长） |
| 2 | I32 | uId | 是 | 目标成员 UID |
| 3 | STRING | index | 是 | 目标成员槽位字符串 |

**响应：** `BoolResponse` — 不可踢出自己

---

### 18. 解散/取消解散军团 `dissolve` / `dissolveUnion`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（需为团长） |
| 2 | I32 | actionType | 是 | `1`=发起解散（3天后），其他=取消解散 |

**响应：** `StringResultResponse` — 解散时返回解散日期字符串，取消时返回 `"0"`

---

### 19. 消耗个人贡献 `deleteContributionPersonal` / `usePersonalContribution`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | I32 | contribution | 是 | 消耗数量 |

**响应：** `IntResponse` — 实际消耗量（不超过当前持有量）

---

### 20. 消耗军团贡献 `deleteContributionUnion` / `useUnionContribution`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（需为团长） |
| 2 | I32 | contribution | 是 | 消耗数量 |

**响应：** `IntResponse` — 实际消耗量

---

### 21. 查询军团变量 `getVariables`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | LIST\<I32\> | ids | 是 | 变量 ID 列表 |

**响应：** `UnionVariablesResponse`（LIST\<UnionVariable\>）

**UnionVariable 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | STRING | id | 变量 ID |
| 2 | STRING | value | 变量值 |

**默认初始化变量 ID：** `6-13, 61-72, 76-88, 90-99`

---

### 22. 递增军团变量 `doVariable`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（含 gameId、index） |
| 2 | I32 | id | 是 | 变量 ID（需 > 0） |

**响应：** `BoolResponse` — 将指定变量值 +1

---

### 23. 查询角色列表 `getRoleList`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| 1 | STRUCT | header | 是 | 公共头部；官方角色代理通常使用 index `-1` |
| 2 | I32 | pageId | 是 | 页码，从 `1` 开始 |
| 3 | I32 | pageShow | 是 | 每页数量 |

**响应：** `UnionRoleListResponse`

**UnionRole 结构：**

| 字段 ID | 类型 | 字段名 | 说明 |
|--------|------|--------|------|
| 1 | I32 | id | 角色 ID（1=团长，0=成员） |
| 2 | STRING | name | 角色名称 |
| 3 | STRING | privilegeList | 权限列表（团长为 `*`） |
| 4 | I32 | create_time | 创建时间 |
| 5 | STRING | memo | 备注 |

---

### 24. 设置成员角色 `setRole` / `setRoleRevised`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（需为团长） |
| 2 | I32 | uId | 是 | 目标成员 UID |
| 3 | STRING | index | 是 | 目标成员槽位字符串 |
| 4 | I32 | roleId | 是 | 角色 ID（1=团长，0=成员） |

**响应：** `BoolResponse`

---

### 25. 转让团长 `transfer` / `transferUnion` / `transferUnionRevised`

**请求参数：**

| 字段 ID | 类型 | 字段名 | 必填 | 说明 |
|--------|------|--------|------|------|
| Header | STRUCT | header | 是 | 公共头部（需为团长） |
| 2 | I32 | uId | 是 | 目标成员 UID |
| 3 | STRING | index | 是 | 目标成员槽位字符串 |
| 4 | I32 | transferResult | 是 | 必须为 `1` 才执行转让 |

**响应：** `BoolResponse`

---

## 数据库表结构

| 表名 | 说明 |
|------|------|
| `union_mock` | 军团基本信息 |
| `union_member_mock` | 军团成员（主键：union_id + uid + slot_index） |
| `union_apply_mock` | 入团申请（主键：union_id + uid + slot_index） |
| `union_variable_mock` | 军团变量（主键：union_id + variable_id） |
| `union_task_mock` | 成员任务记录（主键：union_id + uid + slot_index + task_id） |
| `union_log_mock` | 军团操作日志 |

`union_log_mock` 同时保存 `actor_username`，用于正确返回每条日志的实际操作账号。

## 业务规则

以下是**当前本地 mock 行为**，不是对线上服务全部规则的还原：

- 军团等级 = `floor(experience / 1000) + 1`，最低 1 级。
- 已确认任务编号使用上文映射；其他正数字符串按贡献配置值处理。
- 兑换贡献时，实际贡献值 = `max(1000, money)`。
- 同一游戏中军团名称不允许重复，比较时忽略 ASCII 大小写。
- 同一账号的同一存档槽位只能属于一个军团；审核成功后会清除该槽位的其他待审核申请。
- 成员只能修改自己的 extra；团长可以修改本军团成员资料和军团公告。
- 只有团长（`owner_uid` 匹配）可执行：踢人、审核、解散、转让、消耗军团贡献、设置角色。
- `setRole` 不能把普通成员直接设为团长；团长变更必须使用 `transfer`。
- 团长不可退出军团，需先完成转让。
- 解散操作记录 3 天后的日期；当前本地实现不会后台定时删除用户数据库中的军团数据。
- `extra` 最大长度为 1500 个 JavaScript 字符。

## 已知差异

- 本地 native 运行时默认只有一个固定本地账号；申请审核、踢人和转让等多人流程主要通过数据库测试账号验证。
- 原服务支持 `Err` 业务异常及具体错误码；本地 mock 当前主要返回布尔值、空结果或实际消耗量，没有完整复刻全部错误码。
- 原服务的成员容量、每日任务限制、退出后冷却时间和最大贡献值等规则尚未完整还原。
