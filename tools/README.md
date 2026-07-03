# tools 目录说明

`tools/` 现在是项目知识沉淀和少量辅助脚本目录。运行时代码已经迁出到
`runtime/save-data/`，这样公网访问、本地开发和未来 Windows 桌面壳都能复用同一套实现。

## 目录索引

```text
tools/
  decompile.sh                 # FFDec 反编译辅助脚本
  saveData/README.md           # 存档链路、本地 mock 行为、日志、钱包、商城说明
  saveData/packaging/README.md # 公网访问和桌面打包边界
  paymentLogic/README.md       # 余额、累计充值、商城购买和付费链路分析
  noCheat/README.md            # 反作弊标记和保存检查分析
  levelLogic/README.md         # 关卡配置、通关奖励和奖励覆盖分析
```

## 运行时代码边界

可执行的 saveData 行为放在：

```text
runtime/save-data/
```

包括：

- SQLite 持久化和 schema 初始化。
- 4399 存档、付费、商城和平台接口 mock。
- 本地浏览器运行页。
- 资源代理和 SWF patch 生成。
- 关卡通关奖励覆盖能力。

新的分析记录或一次性辅助脚本可以先放在 `tools/`。只要某个能力需要被公网访问或桌面应用复用，就应提升到 `runtime/save-data/`。
