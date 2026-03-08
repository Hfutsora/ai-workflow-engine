import type { AgentRole } from './agent';

export interface WorkflowNode {
  id: string;
  agentRole: AgentRole;
  name: string;
  prompt: string;
  dependsOn: string[];
}

export interface WorkflowEdge {
  from: string;
  to: string;
}

export interface Workflow {
  id: string;
  name: string;
  description: string;
  nodes: WorkflowNode[];
  edges: WorkflowEdge[];
  createdAt: string;
}

export type ExecutionStatus = 'pending' | 'running' | 'completed' | 'failed';

export interface NodeResult {
  nodeId: string;
  agentRole: AgentRole;
  status: ExecutionStatus;
  output: string;
  startedAt?: string;
  completedAt?: string;
}

export interface Execution {
  id: string;
  requirementId: string;
  workflowId: string;
  status: ExecutionStatus;
  nodeResults: NodeResult[];
  startedAt: string;
  completedAt?: string;
}
