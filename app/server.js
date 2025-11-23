const express = require('express');
const os = require('os');

const app = express();

// Inside the container we'll use 80; for local dev you can override with PORT=8080
const PORT = process.env.PORT || 80;

const APP_ENV = process.env.APP_ENV || 'blue';
const APP_VERSION = process.env.APP_VERSION || 'v1.0.0';
const COMMIT_SHA = process.env.COMMIT_SHA || 'local-dev';

app.get('/healthz', (req, res) => {
  res.status(200).json({
    status: 'ok',
    environment: APP_ENV,
    version: APP_VERSION,
    commit: COMMIT_SHA
  });
});

app.get('/', (req, res) => {
  res.send(`
    <!doctype html>
    <html>
      <head>
        <title>Blue-Green Demo</title>
        <style>
          body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: #0f172a;
            color: #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
          }
          .card {
            padding: 2rem 3rem;
            border-radius: 1rem;
            background: rgba(15, 23, 42, 0.9);
            box-shadow: 0 20px 40px rgba(0,0,0,0.5);
            border: 1px solid rgba(148, 163, 184, 0.4);
          }
          .env {
            font-size: 0.9rem;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            opacity: 0.8;
          }
          .env.blue { color: #38bdf8; }
          .env.green { color: #22c55e; }
          h1 {
            margin-top: 0.5rem;
            margin-bottom: 0.75rem;
            font-size: 1.75rem;
          }
          .meta {
            font-size: 0.9rem;
            color: #9ca3af;
          }
          .meta span {
            display: block;
          }
        </style>
      </head>
      <body>
        <div class="card">
          <div class="env ${APP_ENV.toLowerCase()}">
            Environment: ${APP_ENV.toUpperCase()}
          </div>
          <h1>Blue-Green Deployment Demo</h1>
          <p class="meta">
            <span>Version: ${APP_VERSION}</span>
            <span>Commit: ${COMMIT_SHA}</span>
            <span>Host: ${os.hostname()}</span>
            <span>Time: ${new Date().toISOString()}</span>
          </p>
        </div>
      </body>
    </html>
  `);
});

app.listen(PORT, () => {
  console.log(`Blue-Green demo app listening on port ${PORT}`);
});
