import { serve } from '@hono/node-server';
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import 'dotenv/config';

const app = new Hono();

app.use('/*', cors());

app.get('/api/health', (c) => c.json({ status: 'ok' }));

// TODO: 挂载路由模块
// app.route('/api/requirements', requirementsRoutes);
// app.route('/api/workflows', workflowsRoutes);
// app.route('/api/executions', executionsRoutes);

const port = Number(process.env.PORT) || 3000;

console.log(`服务启动于 http://localhost:${port}`);
serve({ fetch: app.fetch, port });
