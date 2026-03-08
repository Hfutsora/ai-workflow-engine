# PRD 分析 — 生成模块计划

从项目代码和 mini-wiki 分析项目结构，生成 PRD 逆向生成计划。

## 前置条件

确认 `.mini-wiki/wiki/` 目录已生成且为最新。如果不存在，先提示用户运行 mini-wiki skill。

## 执行

使用 `prd-analyzer` agent（`.claude/agents/prd/prd-analyzer.md`）执行分析。

遵循 `.claude/skills/prd/reverse-engineer.md` 中的全部标准。

## 输出

`prd/plan.md` — 包含所有模块的数据源映射、优先级、状态标记和执行建议。

## 后续步骤

计划生成后，用户可以：
- `/prd-generate` 逐模块或并行生成 PRD
- 手动调整 plan.md 中的模块划分和优先级
