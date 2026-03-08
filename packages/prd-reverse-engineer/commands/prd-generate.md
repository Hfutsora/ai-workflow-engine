# PRD 生成 — 逐模块或并行生成

根据 `prd/plan.md` 中的计划，生成单个或多个模块的 PRD 文档。

## 输入

用户可以指定：
- 具体模块："生成 PRD-03"
- 下一个待生成模块："继续下一个"
- 并行批量："并行生成 PRD-03、PRD-04、PRD-05" 或 "启动所有模块"

如果用户未指定模块，从 `prd/plan.md` 中找到第一个状态为 `[ ]` 的模块。

## 执行

### 逐个生成（默认）

使用 `prd-generator` agent（`.claude/agents/prd/prd-generator.md`）生成单个模块 PRD。

### 并行生成

为每个待生成模块启动一个后台 Agent，每个 Agent 接收：
1. 规范引用：`.claude/skills/prd/reverse-engineer.md`
2. 该模块的全部数据源（从 plan.md 读取）
3. 输出文件路径
4. 核心约束：产品经理视角、纯业务语言、禁止技术术语、不编造、内容越详细越好不限制行数

所有 Agent 使用 `run_in_background: true` 并行执行。

## 输出

`prd/XX-模块名.md` — 完成后自动更新 plan.md 中该模块状态为 `[x]`。

## 后续步骤

- `/prd-review` 审查已生成的 PRD
- `/prd-generate` 继续生成下一个模块
