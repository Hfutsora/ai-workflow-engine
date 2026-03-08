# PRD 全流程 — 一键分析、生成、审查、修复、整合

自动依次执行 PRD 逆向生成的完整流程，用户只需观察进度。

## 流程

```
Step 1: 分析 → prd/plan.md
Step 2: 并行生成所有模块 → prd/*.md
Step 3: 审查 → prd/review-report.md
Step 4: 修复 → 根据审查报告自动修复
Step 5: 整合 → prd/00-项目总览.md
Step 6: 同步到文档站 → docs/prd/*.md + 更新 VitePress 配置
```

## 执行规则

**全程自动执行，不中断等待用户确认。** 每个步骤完成后直接进入下一步。

### Step 1: 分析

检查 `prd/plan.md` 是否存在：
- **不存在**：启动 `prd-analyzer` agent 生成计划
- **已存在且有待生成模块**：直接进入 Step 2
- **已存在且全部完成**：将所有模块重置为 `[ ]`，重新生成

### Step 2: 并行生成

读取 `prd/plan.md`，为所有状态为 `[ ]` 的模块启动后台 Agent 并行生成。

每个 Agent 接收：
1. 规范引用：`.claude/skills/prd/reverse-engineer.md`
2. 该模块的全部数据源（从 plan.md 读取）
3. 输出文件路径
4. 核心约束：产品经理视角、纯业务语言、禁止技术术语、不编造、业务规则展开为可执行描述、内容越详细越好不限制行数

等待所有 Agent 完成，汇报生成结果。

### Step 3: 审查

启动 `prd-reviewer` agent，对所有已生成的 PRD 执行质量检查：
- 模板完整性
- 业务规则可执行性
- 跨文档一致性
- 代码抽样验证

输出 `prd/review-report.md`。

### Step 4: 修复

读取 `prd/review-report.md`，如存在严重或高优先级问题：
- 为每个需修复的 PRD 启动后台 Agent 并行修复
- 修复完成后更新审查报告中的修复记录

如无严重/高优先级问题，跳过此步。

### Step 5: 整合

启动 `prd-consolidator` agent，生成 `prd/00-项目总览.md`。

### Step 6: 同步到文档站

将 `prd/*.md` 复制到 `docs/prd/`，确保 VitePress 文档站可访问最新 PRD。

## 进度汇报

每个步骤开始和结束时输出简短状态：

```
[Step 1/6] 分析模块计划... 完成（12 个模块）
[Step 2/6] 并行生成 12 个模块... 3/12 完成... 8/12 完成... 全部完成
[Step 3/6] 审查质量... 完成（3 严重 / 5 高 / 8 中）
[Step 4/6] 修复问题... 完成（8 个已修复）
[Step 5/6] 生成项目总览... 完成
[Step 6/6] 同步到文档站... 完成
```

## 输出

| 产物 | 路径 |
|------|------|
| 模块计划 | `prd/plan.md` |
| 模块 PRD | `prd/01-*.md` ~ `prd/12-*.md` |
| 审查报告 | `prd/review-report.md` |
| 项目总览 | `prd/00-项目总览.md` |
| 文档站副本 | `docs/prd/*.md` |
