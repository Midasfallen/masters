import { Injectable, NestMiddleware, ForbiddenException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import * as crypto from 'crypto';

/**
 * CSRF Protection Middleware
 *
 * Implements Double Submit Cookie pattern for CSRF protection
 * https://owasp.org/www-community/SameSite
 *
 * How it works:
 * 1. Server generates CSRF token and sends it in cookie + response
 * 2. Client includes token in X-CSRF-Token header for state-changing requests
 * 3. Server validates that cookie token matches header token
 */
@Injectable()
export class CsrfMiddleware implements NestMiddleware {
  private readonly CSRF_COOKIE_NAME = 'XSRF-TOKEN';
  private readonly CSRF_HEADER_NAME = 'X-CSRF-Token';
  private readonly SAFE_METHODS = ['GET', 'HEAD', 'OPTIONS'];

  use(req: Request, res: Response, next: NextFunction) {
    // Skip CSRF check for safe methods
    if (this.SAFE_METHODS.includes(req.method)) {
      this.ensureCsrfToken(req, res);
      return next();
    }

    // Skip CSRF check for API endpoints with JWT (Bearer token)
    // JWT provides CSRF protection when stored in httpOnly cookie
    if (req.headers.authorization?.startsWith('Bearer ')) {
      return next();
    }

    // Get CSRF token from cookie and header
    const cookieToken = req.cookies?.[this.CSRF_COOKIE_NAME];
    const headerToken = req.headers[this.CSRF_HEADER_NAME.toLowerCase()] as string;

    // Validate tokens
    if (!cookieToken || !headerToken) {
      throw new ForbiddenException('CSRF token missing');
    }

    if (!this.compareTokens(cookieToken, headerToken)) {
      throw new ForbiddenException('CSRF token mismatch');
    }

    next();
  }

  /**
   * Ensure CSRF token exists in cookie
   */
  private ensureCsrfToken(req: Request, res: Response): void {
    let token = req.cookies?.[this.CSRF_COOKIE_NAME];

    if (!token) {
      token = this.generateToken();
      res.cookie(this.CSRF_COOKIE_NAME, token, {
        httpOnly: false, // Must be accessible to JavaScript
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 24 * 60 * 60 * 1000, // 24 hours
      });
    }

    // Also send token in response header for convenience
    res.setHeader(this.CSRF_HEADER_NAME, token);
  }

  /**
   * Generate random CSRF token
   */
  private generateToken(): string {
    return crypto.randomBytes(32).toString('hex');
  }

  /**
   * Compare tokens in constant time to prevent timing attacks
   */
  private compareTokens(a: string, b: string): boolean {
    if (a.length !== b.length) {
      return false;
    }

    try {
      return crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b));
    } catch {
      return false;
    }
  }
}
