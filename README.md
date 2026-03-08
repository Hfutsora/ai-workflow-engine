# AI 工作流引擎

AI 多 Agent 协作工作流引擎 — 看板驱动需求，Claude 多 Agent 自动执行。

## 愿景

一个可视化的 AI 工作流平台：把需求贴到看板上，点击「开始执行」，多个 Claude Agent 自动协作完成任务，全程可观测。

## 核心架构

```
┌─────────────────────────────────────────────────┐
│               前端界面 (React)                   │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │  看板视图  │  │ 工作流编辑 │  │  实时执行监控  │  │
│  └──────────┘  └──────────┘  └───────────────┘  │
└──────────────────┬──────────────────────────────┘
                   │ REST API + WebSocket
┌──────────────────▼──────────────────────────────┐
│             服务端 (Hono + Node.js)              │
│  ┌──────────┐  ┌──────────┐  ┌───────────────┐  │
│  │ 需求管理   │  │ 工作流引擎 │  │  Agent 调度器  │  │
│  └──────────┘  └──────────┘  └───────────────┘  │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│           Claude 多 Agent 协作层                 │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌──────────┐  │
│  │产品经理  │ │开发工程师│ │测试工程师│ │代码评审   │  │
│  └────────┘ └────────┘ └────────┘ └──────────┘  │
└──────────────────┬──────────────────────────────┘
                   │
          ┌────────▼────────┐
          │  SQLite (Drizzle)│
          └─────────────────┘
```

## 功能规划

### 第一阶段：基础框架 (MVP)

- [ ] **项目脚手架** — Hono 服务端 + React 前端 + SQLite
- [ ] **需求看板** — 创建、编辑、拖拽需求卡片（待规划 / 进行中 / 已完成）
- [ ] **单 Agent 执行** — 点击需求卡片，调用 Claude API 生成执行结果
- [ ] **实时状态** — WebSocket 推送 Agent 执行进度到前端

### 第二阶段：多 Agent 协作

- [ ] **工作流定义** — 可视化定义工作流节点（需求分析 → 方案设计 → 编码 → 测试 → 评审）
- [ ] **Agent 角色系统** — 定义不同角色的 Agent（PM、开发、测试、评审）
  - **产品经理 Agent**: 分析需求，拆解子任务，生成 PRD
  - **开发 Agent**: 根据 PRD 编写代码，生成实现方案
  - **测试 Agent**: 编写测试用例，验证代码质量
  - **评审 Agent**: 代码评审，提出改进建议
- [ ] **Agent 间通信** — 上游 Agent 的输出作为下游 Agent 的输入
- [ ] **并行执行** — 无依赖的 Agent 节点可并行运行

### 第三阶段：增强能力

- [ ] **上下文管理** — Agent 可读取项目代码库作为上下文
- [ ] **工具集成** — Agent 可调用外部工具（Git、文件系统、API）
- [ ] **人工干预节点** — 工作流中插入人工审批/修改节点
- [ ] **历史回溯** — 查看每次执行的完整 Agent 对话记录
- [ ] **模板市场** — 预置常用工作流模板（Bug 修复流、新功能流、重构流）

### 第四阶段：生产化

- [ ] **飞书集成** — 需求从飞书消息/文档同步到看板
- [ ] **Git 集成** — Agent 执行结果自动提交 PR
- [ ] **权限控制** — 多用户、团队协作
- [ ] **执行报告** — 每次工作流执行生成可分享的报告

## 技术栈

| 层级 | 技术选型 | 说明 |
|------|---------|------|
| 前端 | React 19 + Tailwind CSS 4 | 看板 UI、工作流编辑器、实时监控 |
| 构建 | Vite 6 | 快速开发体验 |
| 服务端 | Hono + Node.js | 轻量高性能，REST API + WebSocket |
| 数据库 | SQLite + Drizzle ORM | 零配置，本地优先，类型安全 |
| AI 引擎 | Anthropic Claude SDK | 多 Agent 编排，流式输出 |
| 实时通信 | WebSocket (ws) | Agent 执行状态实时推送 |
| 校验 | Zod | 运行时类型校验 |

## 项目结构

```
ai-workflow-engine/
├── src/
│   ├── server/                 # 后端服务
│   │   ├── index.ts            # Hono 服务入口
│   │   ├── routes/             # API 路由
│   │   │   ├── requirements.ts # 需求 CRUD
│   │   │   ├── workflows.ts    # 工作流管理
│   │   │   └── executions.ts   # 执行记录
│   │   ├── services/           # 业务逻辑
│   │   │   ├── workflow-engine.ts  # 工作流引擎核心
│   │   │   └── agent-scheduler.ts  # Agent 调度器
│   │   ├── agents/             # Agent 定义
│   │   │   ├── base-agent.ts   # Agent 基类
│   │   │   ├── pm-agent.ts     # PM Agent
│   │   │   ├── dev-agent.ts    # 开发 Agent
│   │   │   ├── qa-agent.ts     # 测试 Agent
│   │   │   └── review-agent.ts # 评审 Agent
│   │   └── db/                 # 数据库
│   │       ├── schema.ts       # Drizzle schema
│   │       └── index.ts        # 数据库连接
│   ├── web/                    # 前端应用
│   │   ├── App.tsx             # 根组件
│   │   ├── main.tsx            # 入口
│   │   ├── pages/              # 页面
│   │   │   ├── KanbanPage.tsx  # 看板页面
│   │   │   ├── WorkflowPage.tsx # 工作流编辑
│   │   │   └── ExecutionPage.tsx # 执行监控
│   │   ├── components/         # 组件
│   │   │   ├── RequirementCard.tsx
│   │   │   ├── WorkflowNode.tsx
│   │   │   └── AgentStatusPanel.tsx
│   │   ├── hooks/              # 自定义 hooks
│   │   │   └── useWebSocket.ts
│   │   └── stores/             # 状态管理
│   │       └── workflow-store.ts
│   └── shared/                 # 前后端共享
│       ├── types/              # 类型定义
│       │   ├── requirement.ts
│       │   ├── workflow.ts
│       │   └── agent.ts
│       └── constants/          # 常量
│           └── agent-roles.ts
├── CLAUDE.md                   # Claude Code 项目指令
├── package.json
├── tsconfig.json
├── vite.config.ts
└── .env.example
```

## 核心数据模型

```typescript
// 需求
interface Requirement {
  id: string;
  title: string;
  description: string;
  status: 'backlog' | 'ready' | 'running' | 'done' | 'failed';
  workflowId?: string;
  createdAt: Date;
}

// 工作流模板
interface Workflow {
  id: string;
  name: string;
  nodes: WorkflowNode[];     // 有序节点列表
  edges: WorkflowEdge[];     // 节点间连接关系
}

// 工作流节点
interface WorkflowNode {
  id: string;
  agentRole: 'pm' | 'dev' | 'qa' | 'review';
  prompt: string;            // Agent 的系统提示词
  dependsOn: string[];       // 依赖的上游节点
}

// 执行记录
interface Execution {
  id: string;
  requirementId: string;
  workflowId: string;
  status: 'pending' | 'running' | 'completed' | 'failed';
  nodeResults: NodeResult[];  // 每个节点的执行结果
  startedAt: Date;
  completedAt?: Date;
}
```

## 工作流执行流程

```
用户点击「开始执行」
  → 创建 Execution 记录
  → 工作流引擎按拓扑排序节点
  → 依次/并行调度 Agent：
      → Agent 收到: 系统提示词 + 需求描述 + 上游输出
      → Agent 流式输出结果 → WebSocket 推送到前端
      → 结果存入 NodeResult
  → 所有节点完成 → 标记需求为 done
  → 前端看板自动更新状态
```

## 快速开始

```bash
# 1. 安装依赖
pnpm install

# 2. 配置环境变量
cp .env.example .env
# 编辑 .env 填入 ANTHROPIC_API_KEY

# 3. 启动开发服务
pnpm dev
```

## 许可证

MIT
