# PRD 进度 — 查看当前状态

快速查看 PRD 逆向生成的整体进度。

## 执行

1. 读取 `prd/plan.md`，统计各模块状态
2. 检查 `prd/` 目录下已生成的文件
3. 检查 `prd/review-report.md` 是否存在及未修复问题数

## 输出

展示进度摘要：

```
PRD 逆向生成进度
================
已完成: X/N 模块
待生成: X 模块
需补充 wiki: X 模块

已生成文件:
  [x] prd/01-xxx.md
  [x] prd/02-xxx.md
  [ ] prd/03-xxx.md
  ...

审查状态: 已审查 / 未审查 / X 个未修复问题
项目总览: 已生成 / 未生成

下一步建议:
  - 继续生成 PRD-XX: /prd-generate
  - 运行审查: /prd-review
  - 修复问题: /prd-fix
```
