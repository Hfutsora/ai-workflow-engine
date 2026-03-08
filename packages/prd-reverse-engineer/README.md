# PRD Reverse Engineer

从已有代码逆向生成标准化《需求规格说明书》的 Claude Code 扩展包。

**不是生成技术文档，而是生成产品经理视角的需求文档。**

## 解决什么问题

系统跑了很久，但需求文档缺失或严重过时。代码里包含了所有业务规则，但没有高效方式把它提炼成业务人员能读懂的需求文档。

本方案从代码出发，以产品经理视角逆向输出标准化的需求规格说明书——纯业务语言，禁止技术术语。

## 架构

```
知识层（Skill）                    执行层（Agents）
┌─────────────────────┐    ┌──────────────────────────────────┐
│ reverse-engineer.md  │    │ prd-analyzer     → 分析并生成计划   │
│                     │───→│ prd-generator    → 逐模块生成 PRD   │
│ 模板 + 质量标准      │    │ prd-reviewer     → 质量审查         │
│ + 写作规范          │    │ prd-consolidator → 项目级整合       │
│                     │    │ prd-updater      → 增量更新         │
└─────────────────────┘    └──────────────────────────────────┘
```

## 包含内容

```
prd-reverse-engineer/
├── skill/
│   └── reverse-engineer.md       # 核心规范：模板、质量标准、方法论
├── agents/
│   ├── prd-analyzer.md           # 分析项目结构，生成模块计划
│   ├── prd-generator.md          # 逐模块生成 PRD
│   ├── prd-reviewer.md           # 审查 PRD 质量
│   ├── prd-consolidator.md       # 生成项目级整合文档
│   ├── prd-updater.md            # 代码变更后增量更新 PRD
│   └── README.md                 # Agent 说明文档
├── commands/
│   ├── prd-analyze.md            # /prd-analyze 命令
│   ├── prd-generate.md           # /prd-generate 命令
│   ├── prd-review.md             # /prd-review 命令
│   ├── prd-fix.md                # /prd-fix 命令
│   ├── prd-consolidate.md        # /prd-consolidate 命令
│   ├── prd-update.md             # /prd-update 命令
│   └── prd-status.md             # /prd-status 命令
├── install.sh                    # 安装脚本
└── README.md                     # 本文件
```

## 安装

### 方式一：安装脚本（推荐）

```bash
# 安装到当前项目
cd /path/to/your/project
/path/to/prd-reverse-engineer/install.sh

# 或指定目标项目
./install.sh /path/to/your/project
```

脚本会将文件复制到项目的 `.claude/` 目录：

| 源文件 | 安装位置 |
|--------|----------|
| `skill/reverse-engineer.md` | `.claude/skills/prd/reverse-engineer.md` |
| `agents/*.md` | `.claude/agents/prd/*.md` |
| `commands/prd-*.md` | `.claude/commands/prd-*.md` |

### 方式二：手动安装

```bash
cp skill/reverse-engineer.md   .claude/skills/prd/
cp agents/*.md                 .claude/agents/prd/
cp commands/prd-*.md           .claude/commands/
```

## 前置条件

1. **mini-wiki**：必须先生成 `.mini-wiki/wiki/` 目录。本包以 mini-wiki 的静态分析结果作为导航索引，再深入源代码确认细节。
2. **git**：`/prd-update` 依赖 git diff 识别代码变更（非必需，其他功能不依赖 git）。

## 使用流程

```
第 0 步：确认 .mini-wiki/wiki/ 已生成
         ↓
第 1 步：/prd-analyze — 分析项目，生成 prd/plan.md
         ↓
第 2 步：确认/调整计划
         ↓
第 3 步：/prd-generate — 逐模块或并行生成 PRD
         ↓
第 4 步：/prd-review — 审查质量
         ↓
第 5 步：/prd-fix — 自动修复问题
         ↓
第 6 步：/prd-consolidate — 生成项目总览

--- 后续维护 ---

代码变更后：/prd-update — 增量更新受影响的 PRD
随时查看：/prd-status — 查看进度
```

## 命令速查

| 命令 | 说明 |
|------|------|
| `/prd-analyze` | 分析项目结构，生成 `prd/plan.md` |
| `/prd-generate` | 逐模块或并行生成 PRD |
| `/prd-review` | 审查已生成 PRD 的质量 |
| `/prd-fix` | 根据审查报告自动修复问题 |
| `/prd-consolidate` | 生成项目级整合入口文档 |
| `/prd-update` | 代码变更后，增量更新受影响的 PRD |
| `/prd-status` | 查看当前 PRD 生成进度 |

## 输出目录

```
prd/
├── plan.md               # 生成计划（进度追踪）
├── 00-项目总览.md        # 项目级整合入口
├── 模块名.md             # 各模块 PRD
├── review-report.md      # 审查报告
└── update-report.md      # 增量更新报告
```

## 核心原则

- **代码即真相**：源代码是唯一事实来源，mini-wiki 是索引
- **产品经理视角**：纯业务语言输出，禁止技术术语
- **不编造**：只写已实现的功能，不写愿景和规划
- **可追溯**：所有需求可追溯到源代码
- **计划驱动**：可追踪、可中断、可恢复

## 适用场景

- 从已有系统逆向补全需求文档
- 为重构项目建立需求基线
- 交接、验收、审计前统一沉淀文档
- 将散落的需求信息整理为标准格式
- 代码持续演进后保持文档同步
