export type AgentRole = 'pm' | 'dev' | 'qa' | 'review';

export interface AgentConfig {
  role: AgentRole;
  name: string;
  description: string;
  systemPrompt: string;
  model: string;
}

export interface AgentMessage {
  executionId: string;
  nodeId: string;
  type: 'start' | 'chunk' | 'complete' | 'error';
  content: string;
  timestamp: string;
}
