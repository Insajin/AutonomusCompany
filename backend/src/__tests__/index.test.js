const request = require('supertest');
const express = require('express');

// Mock the app (you would import your actual app in real scenario)
const createApp = () => {
  const app = express();
  app.use(express.json());

  // Health check endpoint
  app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() });
  });

  // Example API endpoint
  app.get('/api/example', (req, res) => {
    res.json({
      message: 'This is an example API endpoint',
      features: [
        'Automated code review',
        'AI-assisted fixes',
        'Intelligent CI/CD',
      ],
    });
  });

  return app;
};

describe('Backend API Tests', () => {
  let app;

  beforeAll(() => {
    app = createApp();
  });

  describe('GET /health', () => {
    it('should return 200 OK', async () => {
      const response = await request(app).get('/health');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('status', 'ok');
      expect(response.body).toHaveProperty('timestamp');
    });
  });

  describe('GET /api/example', () => {
    it('should return example data', async () => {
      const response = await request(app).get('/api/example');
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('message');
      expect(response.body.features).toBeInstanceOf(Array);
      expect(response.body.features).toHaveLength(3);
    });

    it('should include expected features', async () => {
      const response = await request(app).get('/api/example');
      expect(response.body.features).toContain('Automated code review');
      expect(response.body.features).toContain('AI-assisted fixes');
      expect(response.body.features).toContain('Intelligent CI/CD');
    });
  });

  describe('Error handling', () => {
    it('should return 404 for unknown routes', async () => {
      const response = await request(app).get('/api/unknown');
      expect(response.status).toBe(404);
    });
  });
});
