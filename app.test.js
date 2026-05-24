process.env.NODE_ENV = 'test';

const request = require('supertest');

jest.mock('yargs/yargs', () => {
  const yargsMock = {
    option: function() { return this; }, 
    argv: { port: 8000, db_url: 'mysql://fake:fake@localhost/fake_db' }
  };
  return () => yargsMock;
});

jest.mock('yargs/helpers', () => ({
  hideBin: jest.fn()
}));

jest.mock('@prisma/client', () => {
  return {
    PrismaClient: jest.fn().mockImplementation(() => {
      return {
        $queryRaw: jest.fn().mockResolvedValue([{ 1: 1 }]),
        item: {
          findMany: jest.fn().mockResolvedValue([{ id: 1, name: 'Test Item', quantity: 10 }]),
          create: jest.fn().mockResolvedValue({ id: 2, name: 'New Item', quantity: 5 }),
          findUnique: jest.fn().mockResolvedValue({ id: 1, name: 'Test Item', quantity: 10, createdAt: new Date() })
        }
      };
    })
  };
});

const app = require('./index');

describe('Express API Tests', () => {
  
  test('GET /health/alive should return 200 OK', async () => {
    const res = await request(app).get('/health/alive');
    expect(res.statusCode).toBe(200);
    expect(res.text).toBe('OK');
  });

  test('GET /health/ready should return 200 OK', async () => {
    const res = await request(app).get('/health/ready');
    expect(res.statusCode).toBe(200);
  });

  test('GET / should return HTML with title', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('Simple Inventory API');
  });

  test('GET /items should return list of items', async () => {
    const res = await request(app).get('/items').set('Accept', 'application/json');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBeTruthy();
  });
});

test('POST /items should create a new item', async () => {
    const res = await request(app)
      .post('/items')
      .send({ name: 'New Item', quantity: 5 });
    
    expect(res.statusCode).toBe(201);
    expect(res.body.name).toBe('New Item');
  });

  test('GET /items/:id should return a single item', async () => {
    const res = await request(app)
      .get('/items/1')
      .set('Accept', 'application/json');
    
    expect(res.statusCode).toBe(200);
    expect(res.body.name).toBe('Test Item');
  });