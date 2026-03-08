export type RequirementStatus = 'backlog' | 'ready' | 'running' | 'done' | 'failed';

export interface Requirement {
  id: string;
  title: string;
  description: string;
  status: RequirementStatus;
  workflowId?: string;
  createdAt: string;
  updatedAt: string;
}
