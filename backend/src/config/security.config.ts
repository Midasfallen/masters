import { INestApplication } from '@nestjs/common';
import helmet from 'helmet';

/**
 * Configure security middleware for the application
 * Implements OWASP security best practices
 */
export function configureSecurity(app: INestApplication): void {
  // Helmet - Sets various HTTP headers for security
  app.use(
    helmet({
      // Content Security Policy
      contentSecurityPolicy: {
        directives: {
          defaultSrc: ["'self'"],
          styleSrc: ["'self'", "'unsafe-inline'"],
          scriptSrc: ["'self'"],
          imgSrc: ["'self'", 'data:', 'https:'],
          connectSrc: ["'self'"],
          fontSrc: ["'self'"],
          objectSrc: ["'none'"],
          mediaSrc: ["'self'"],
          frameSrc: ["'none'"],
        },
      },

      // Cross-Origin-Embedder-Policy
      crossOriginEmbedderPolicy: false, // Disabled for compatibility

      // Cross-Origin-Opener-Policy
      crossOriginOpenerPolicy: { policy: 'same-origin-allow-popups' },

      // Cross-Origin-Resource-Policy
      crossOriginResourcePolicy: { policy: 'cross-origin' },

      // DNS Prefetch Control
      dnsPrefetchControl: { allow: false },

      // Frameguard (X-Frame-Options)
      frameguard: { action: 'deny' },

      // Hide Powered-By
      hidePoweredBy: true,

      // HTTP Strict Transport Security (HSTS)
      hsts: {
        maxAge: 31536000, // 1 year
        includeSubDomains: true,
        preload: true,
      },

      // IE No Open
      ieNoOpen: true,

      // Don't Sniff Mimetype
      noSniff: true,

      // Origin Agent Cluster
      originAgentCluster: true,

      // Permitted Cross-Domain Policies
      permittedCrossDomainPolicies: { permittedPolicies: 'none' },

      // Referrer Policy
      referrerPolicy: { policy: 'no-referrer' },

      // X-XSS-Protection
      xssFilter: true,
    }),
  );

  // CORS Configuration
  app.enableCors({
    origin: (origin, callback) => {
      // Allow requests with no origin (mobile apps, Postman, etc.)
      if (!origin) {
        return callback(null, true);
      }

      // Whitelist of allowed origins
      const allowedOrigins = [
        'http://localhost:3000', // Development frontend
        'http://localhost:8080', // Development frontend alt
        'https://yourdomain.com', // Production
        'https://www.yourdomain.com', // Production www
        'https://app.yourdomain.com', // Production app
      ];

      if (process.env.NODE_ENV === 'development') {
        // Allow all origins in development
        return callback(null, true);
      }

      if (allowedOrigins.indexOf(origin) !== -1) {
        callback(null, true);
      } else {
        callback(new Error('Not allowed by CORS'));
      }
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: [
      'Content-Type',
      'Authorization',
      'X-Requested-With',
      'X-Device-Id',
      'X-App-Version',
    ],
    exposedHeaders: [
      'X-RateLimit-Limit',
      'X-RateLimit-Remaining',
      'X-RateLimit-Reset',
    ],
    maxAge: 86400, // 24 hours
  });
}

/**
 * Security headers middleware
 * Add custom security headers
 */
export function securityHeadersMiddleware(req: any, res: any, next: () => void) {
  // Remove sensitive headers
  res.removeHeader('X-Powered-By');

  // Add custom security headers
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Referrer-Policy', 'no-referrer');
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');

  next();
}

/**
 * Request validation middleware
 * Validate and sanitize request data
 */
export function requestValidationMiddleware(req: any, res: any, next: () => void) {
  // Block requests with suspicious patterns
  const suspiciousPatterns = [
    /<script[^>]*>.*?<\/script>/gi, // XSS
    /javascript:/gi, // XSS
    /on\w+\s*=/gi, // Event handlers
    /eval\(/gi, // Code execution
    /expression\(/gi, // CSS expressions
    /(union|select|insert|update|delete|drop|create|alter|exec|execute)\s/gi, // SQL injection
  ];

  const checkData = (data: any): boolean => {
    if (typeof data === 'string') {
      return suspiciousPatterns.some((pattern) => pattern.test(data));
    }
    if (typeof data === 'object' && data !== null) {
      return Object.values(data).some((value) => checkData(value));
    }
    return false;
  };

  // Check request body
  if (req.body && checkData(req.body)) {
    return res.status(400).json({
      statusCode: 400,
      message: 'Invalid request data detected',
      error: 'Bad Request',
    });
  }

  // Check query parameters
  if (req.query && checkData(req.query)) {
    return res.status(400).json({
      statusCode: 400,
      message: 'Invalid query parameters detected',
      error: 'Bad Request',
    });
  }

  next();
}
