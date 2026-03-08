# PRD 增量更新 — 根据代码变更更新 PRD

当项目代码发生变更后，自动识别受影响的 PRD 模块并增量更新。

## 前置条件

- `prd/plan.md` 已存在（需要模块与代码路径的映射关系）
- 对应模块的 PRD 已生成（状态为 `[x]`）

## 输入

用户可以指定变更范围：
- 默认：最近一次 git 提交的变更（`HEAD~1`）
- 指定分支："与 main 分支比较"
- 指定时间："最近 7 天的变更"
- 指定模块："只更新 预算管理 模块"
- 指定文件："更新涉及 pomp-budget-server 的 PRD"

## 执行

使用 `prd-updater` agent（`.claude/agents/prd/prd-updater.md`）执行增量更新。

遵循 `.claude/skills/prd/reverse-engineer.md` 中的全部标准。

流程：
1. 通过 git diff 识别变更文件
2. 映射变更文件到 plan.md 中的 PRD 模块
3. 分析变更的业务含义（新增/修改/删除/无影响）
4. 精确更新受影响的 PRD 章节
5. 更新 PRD 的修订记录
6. 生成更新报告

## 输出

- 受影响的 `prd/模块名.md` 被增量更新
- `prd/update-report.md` — 本次更新的详细报告

## 后续步骤

- `/prd-review` 审查更新后的 PRD 质量
- `/prd-consolidate` 如有新增模块，更新项目总览
