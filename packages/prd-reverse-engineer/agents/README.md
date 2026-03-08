# PRD 逆向生成方案

从已有代码和 mini-wiki 文档逆向生成完整的产品需求文档（PRD）。
采用**计划先行、逐模块生成、可中断恢复**的工作模式。

## 架构

```
Skill (知识层)                    Agents (执行层)
┌─────────────────────┐    ┌──────────────────────────────────┐
│ prd-reverse-engineer│    │ prd-analyzer     → 生成计划       │
│                     │───>│ prd-generator    → 逐模块生成     │
│ 模板 + 质量标准      │    │ prd-reviewer     → 质量审查       │
│                     │    │ prd-consolidator → 项目整合       │
│                     │    │ prd-updater      → 增量更新       │
└─────────────────────┘    └──────────────────────────────────┘
                                       │
                                       ▼
                              prd/plan.md (进度追踪)
```

## 组件说明

| 组件 | 路径 | 职责 |
|------|------|------|
| **Skill** | `.claude/skills/prd/reverse-engineer.md` | PRD 模板、质量标准、逆向方法论、计划驱动工作流 |
| **prd-analyzer** | `.claude/agents/prd/prd-analyzer.md` | 分析项目结构，输出可追踪的生成计划 `prd/plan.md` |
| **prd-generator** | `.claude/agents/prd/prd-generator.md` | 从 plan.md 读取模块信息，逐个生成 PRD |
| **prd-reviewer** | `.claude/agents/prd/prd-reviewer.md` | 审查 PRD 完整性、跨文档一致性、代码追溯准确性 |
| **prd-consolidator** | `.claude/agents/prd/prd-consolidator.md` | 所有模块完成后，生成项目级整合入口文档 `prd/00-项目总览.md` |
| **prd-updater** | `.claude/agents/prd/prd-updater.md` | 代码变更后，增量更新受影响的 PRD 文档 |

## 前置条件

**必须先执行 mini-wiki skill** 生成 `.mini-wiki/wiki/` 目录下的项目文档。PRD 逆向生成以 mini-wiki 的静态分析结果作为主要数据源。

## 执行流程

```
第 0 步: 确认 .mini-wiki/wiki/ 已生成且为最新
         ↓
第 1 步: 运行 prd-analyzer
         分析后端 + 前端 + mini-wiki 覆盖度
         输出 prd/plan.md（含所有模块的数据源、优先级、状态）
         ↓
第 2 步: 用户确认/调整计划
         ↓
第 3 步: 生成模块 PRD（支持并行加速）
         逐个："生成 XX模块" 或 "继续下一个模块"
         并行："启动所有模块" 或 "并行生成 母子项目/外部集成/记账中心"
         每个模块作为独立后台子 agent 运行，互不干扰
         完成后自动更新 plan.md 中的状态为 [x]
         ↓
第 4 步: 阶段性审查
         运行 prd-reviewer 检查已生成的 PRD
         输出 prd/review-report.md
         ↓
第 5 步: 根据审查报告修正
         ↓
第 6 步: 所有模块完成后，运行 prd-consolidator
         生成 prd/00-项目总览.md（项目级整合入口文档）
```

## 核心设计：计划驱动

### plan.md 是唯一进度文件

- 每个模块有状态标记：`[x]` 已完成 / `[ ]` 待生成 / `[~]` 需补充 wiki
- 每个模块列出完整数据源路径，可独立启动生成
- 按 Phase 分组：Phase 1（wiki 充分）→ Phase 2（需补充）→ Phase 3（可选）

### 中断与恢复

- 任何时候查看 `prd/plan.md` 即可了解进度
- 恢复时说"继续 plan.md 下一个模块"即可
- 每个模块独立生成，互不影响

## 数据源

**核心原则：代码即真相，wiki 是索引。**

| 优先级 | 来源 | 说明 |
|--------|------|------|
| 1 | 源代码 | Controller、Entity、Service 等——**唯一事实来源** |
| 2 | `.mini-wiki/wiki/` | 从代码生成的结构化索引，用于快速导航和理解，不是真相本身 |
| 3 | 推断 | 从代码模式推导，需标注 `[待确认]` |

wiki 与代码冲突时以代码为准；代码有但 wiki 未提及的功能应纳入 PRD。

## 质量标准

每个 PRD 必须满足：
- 完整章节结构（按 skill 模板）
- 内容越详细越好，不限制行数
- 至少 3 个用户故事
- 至少 5 个验收标准
- 至少 1 个 Mermaid 图
- 所有功能可追溯到源代码

## 核心原则

- **只写已实现的功能**，不编造、不写愿景
- **代码即真相**，mini-wiki 为补充
- **可追溯**，每条需求标注代码来源

## 输出目录

```
prd/
├── plan.md               # 生成计划（prd-analyzer 生成，持续更新）
├── 00-项目总览.md        # 项目级整合入口（prd-consolidator 生成）
├── 模块名.md             # 各模块 PRD（prd-generator 生成）
├── 模块名.md
├── ...
└── review-report.md      # 审查报告（prd-reviewer 生成）
```

## Commands

| 命令 | 说明 |
|------|------|
| `/prd-analyze` | 分析项目结构，生成 `prd/plan.md` |
| `/prd-generate` | 逐模块或并行生成 PRD |
| `/prd-review` | 审查已生成 PRD 的质量 |
| `/prd-fix` | 根据审查报告自动修复问题 |
| `/prd-consolidate` | 生成项目级整合入口文档 |
| `/prd-update` | 代码变更后，增量更新受影响的 PRD |
| `/prd-status` | 查看当前 PRD 生成进度 |

## 使用方式

```bash
# 第 1 步：生成计划
/prd-analyze

# 第 2 步：逐模块或并行生成
/prd-generate
# 或指定模块："生成 PRD-03"
# 或并行："并行生成 PRD-03、PRD-04、PRD-05"

# 第 3 步：审查
/prd-review

# 第 4 步：修复问题
/prd-fix

# 第 5 步：生成项目总览
/prd-consolidate

# 代码变更后，增量更新 PRD
/prd-update

# 查看进度
/prd-status
```
