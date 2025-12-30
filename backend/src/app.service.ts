import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  private readonly startTime = Date.now();

  getHealth() {
    return {
      status: 'ok',
      version: '2.0.0',
      timestamp: new Date().toISOString(),
      uptime: (Date.now() - this.startTime) / 1000,
    };
  }

  getInfo() {
    return {
      name: 'Service Platform API',
      version: '2.0.0',
      description: 'Social platform for service professionals',
      documentation: '/api/v2/docs',
      endpoints: {
        health: '/api/v2/health',
        swagger: '/api/v2/docs',
      },
    };
  }
}
