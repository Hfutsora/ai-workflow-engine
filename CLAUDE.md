# AI 工作流引擎 - Claude Code 项目指令

## 项目概述
AI 多 Agent 协作工作流引擎，带看板 UI。用户创建需求，Claude 多个 Agent 协作，按定义好的工作流阶段自动执行。

## 技术栈
- **服务端**: Hono + Node.js + TypeScript
- **数据库**: SQLite + Drizzle ORM
- **前端**: React 19 + Tailwind CSS 4 + Vite
- **AI 引擎**: Anthropic Claude SDK（多 Agent 编排）
- **实时通信**: WebSocket 实时状态推送

## 开发约定
- 使用 pnpm 作为包管理器
- 所有源码在 `src/` 下，分为 `server/`、`web/`、`shared/` 三个模块
- 前后端共享类型定义放在 `src/shared/types/`
- 使用 Zod 做 API 边界的运行时校验
- 使用 nanoid 生成 ID
- Agent 保持无状态，所有状态存数据库
- 所有注释和说明使用中文

## 常用命令
- `pnpm dev` - 启动开发服务（前后端同时启动）
- `pnpm build` - 生产环境构建
- `pnpm db:migrate` - 执行数据库迁移
