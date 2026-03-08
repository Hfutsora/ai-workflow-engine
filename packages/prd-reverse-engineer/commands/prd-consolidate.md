# PRD 整合 — 生成项目总览

在所有模块（或 Phase 1 全部模块）PRD 生成完成后，生成项目级别的整合入口文档。

## 前置条件

`prd/plan.md` 中至少 Phase 1 所有模块状态为 `[x]`。

## 执行

使用 `prd-consolidator` agent（`.claude/agents/prd/prd-consolidator.md`）执行整合。

遵循 `.claude/skills/prd/reverse-engineer.md` 中的全部标准。

## 输出

`prd/00-项目总览.md` — 项目级整合入口文档，包含：
- 平台概述与业务全景
- 用户与角色全景矩阵
- 核心业务流程（端到端）
- 功能索引（按业务域和角色分组）
- 模块依赖关系图
- 文档导航索引
