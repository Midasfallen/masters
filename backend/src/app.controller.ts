import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AppService } from './app.service';

@ApiTags('health')
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('health')
  @ApiOperation({ summary: 'Health check endpoint' })
  @ApiResponse({
    status: 200,
    description: 'Service is healthy',
    schema: {
      example: {
        status: 'ok',
        version: '2.0.0',
        timestamp: '2025-12-29T12:00:00.000Z',
        uptime: 1234.56,
      },
    },
  })
  healthCheck() {
    return this.appService.getHealth();
  }

  @Get()
  @ApiOperation({ summary: 'API info' })
  @ApiResponse({
    status: 200,
    description: 'API information',
  })
  getInfo() {
    return this.appService.getInfo();
  }
}
