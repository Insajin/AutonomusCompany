// Example Backend Application
// This is a template - customize for your needs

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'AI-Powered Monorepo Template API',
    version: '1.0.0',
    features: [
      'Automated code review',
      'AI-assisted fixes',
      'Intelligent CI/CD',
      'Documentation sync',
    ],
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Example API endpoint
app.get('/api/example', (req, res) => {
  res.json({
    message: 'Replace this with your actual API endpoints',
  });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Visit http://localhost:${PORT}`);
});

module.exports = app;
