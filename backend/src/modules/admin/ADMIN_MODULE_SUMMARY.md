# Admin Module Summary

## Overview
Admin Module provides comprehensive administrative capabilities for platform management, including user management, statistics, system health monitoring, and analytics.

## Features

### 1. Platform Statistics
- **Total Users** - Count of all registered users
- **Total Masters** - Count of users with master profiles
- **Total Bookings** - All bookings ever created
- **Total Revenue** - Sum of completed bookings
- **Active Users Today** - Users who logged in today
- **New Users** - Weekly and monthly registration stats
- **Booking Stats** - Daily, weekly, monthly booking counts
- **Average Rating** - Platform-wide master rating
- **Total Reviews/Posts/Services** - Content statistics

### 2. User Management
- List all users with pagination
- View user details (email, name, role, status, rating)
- Activate/Deactivate users
- Grant/Revoke admin privileges
- Delete users

### 3. Booking Management
- View recent bookings
- See booking details (client, master, service, amount, status)
- Track booking trends

### 4. System Health
- Database connectivity status
- Redis connectivity status
- Meilisearch connectivity status
- Server uptime
- Memory usage (heap used/total/external)
- CPU usage

### 5. Analytics
- Daily new users chart
- Daily bookings chart
- Daily revenue chart
- Customizable time period (default: 30 days)

## API Endpoints

### GET /admin/stats
Get platform-wide statistics

**Response:**
```json
{
  "totalUsers": 1234,
  "totalMasters": 456,
  "totalBookings": 789,
  "totalRevenue": 123456.78,
  "activeUsersToday": 123,
  "newUsersThisWeek": 45,
  "newUsersThisMonth": 178,
  "bookingsToday": 23,
  "bookingsThisWeek": 156,
  "bookingsThisMonth": 678,
  "averageRating": 4.65,
  "totalReviews": 567,
  "totalPosts": 890,
  "totalServices": 234
}
```

### GET /admin/users?page=1&limit=50
Get paginated list of users

**Query Parameters:**
- `page` - Page number (default: 1)
- `limit` - Items per page (default: 50)

**Response:**
```json
{
  "users": [
    {
      "id": "uuid",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "isMaster": true,
      "isAdmin": false,
      "isActive": true,
      "rating": 4.75,
      "reviewsCount": 42,
      "createdAt": "2025-01-01T00:00:00Z",
      "lastLoginAt": "2025-01-13T10:30:00Z"
    }
  ],
  "total": 1234
}
```

### GET /admin/bookings?limit=50
Get recent bookings

**Query Parameters:**
- `limit` - Number of bookings (default: 50)

**Response:**
```json
[
  {
    "id": "uuid",
    "clientName": "John Doe",
    "masterName": "Jane Smith",
    "serviceName": "Haircut",
    "status": "completed",
    "amount": 1500.00,
    "scheduledFor": "2025-01-15T14:00:00Z",
    "createdAt": "2025-01-10T12:00:00Z"
  }
]
```

### POST /admin/users/:id/status
Update user status

**Body:**
```json
{
  "isActive": false,
  "isAdmin": true,
  "reason": "Violation of terms"
}
```

**Response:**
```json
{
  "id": "uuid",
  "isActive": false,
  "isAdmin": true
}
```

### DELETE /admin/users/:id
Delete user permanently

**Response:**
```
204 No Content
```

### GET /admin/health
Get system health status

**Response:**
```json
{
  "status": "healthy",
  "database": "connected",
  "redis": "connected",
  "meilisearch": "connected",
  "uptime": 86400,
  "memoryUsage": {
    "heapUsed": 256,
    "heapTotal": 512,
    "external": 64
  },
  "cpuUsage": 2.5
}
```

### GET /admin/analytics?days=30
Get platform analytics

**Query Parameters:**
- `days` - Time period in days (default: 30)

**Response:**
```json
{
  "dailyUsers": [
    { "date": "2025-01-01", "count": 45 },
    { "date": "2025-01-02", "count": 52 }
  ],
  "dailyBookings": [
    { "date": "2025-01-01", "count": 23, "revenue": 34500.00 },
    { "date": "2025-01-02", "count": 28, "revenue": 42000.00 }
  ],
  "period": "30 days"
}
```

## Security

### Authentication & Authorization
- All endpoints require JWT authentication (`@UseGuards(JwtAuthGuard)`)
- All endpoints require admin privileges (`@UseGuards(AdminGuard)`)
- Admin status checked via `user.is_admin` field

### Admin Guard
Located at: `src/modules/admin/guards/admin.guard.ts`

Checks:
1. User is authenticated (has valid JWT token)
2. User has `is_admin = true` in database

### Adding is_admin to User Entity
The User entity now includes:
```typescript
@Column({ type: 'boolean', default: false })
is_admin: boolean;

@Column({ type: 'boolean', default: true })
is_active: boolean;

@Column({ type: 'timestamp', nullable: true })
last_login_at: Date;
```

## Database Migration
To add admin fields to existing database, run:

```sql
ALTER TABLE users
ADD COLUMN is_admin BOOLEAN DEFAULT FALSE,
ADD COLUMN is_active BOOLEAN DEFAULT TRUE,
ADD COLUMN last_login_at TIMESTAMP NULL;

CREATE INDEX idx_users_is_admin ON users(is_admin);
```

## Usage Example

### Making a user admin:
```typescript
// In seed or manually via SQL
UPDATE users SET is_admin = true WHERE email = 'admin@example.com';
```

### Frontend Integration:
```typescript
// Check if current user is admin
const user = await authService.getCurrentUser();
if (user.is_admin) {
  // Show admin panel link
}

// Fetch stats
const stats = await fetch('/admin/stats', {
  headers: { Authorization: `Bearer ${token}` }
});
```

## Future Enhancements
- [ ] Real-time dashboard with WebSocket updates
- [ ] Export data to CSV/Excel
- [ ] Advanced filtering and search
- [ ] User activity logs
- [ ] Automated reports generation
- [ ] Email notifications for admin actions
- [ ] Role-based permissions (super admin, moderator, etc.)
- [ ] Audit trail for all admin actions

## Files Created
1. `admin.module.ts` - Module definition
2. `admin.controller.ts` - HTTP endpoints
3. `admin.service.ts` - Business logic
4. `guards/admin.guard.ts` - Authorization guard
5. `dto/admin-stats.dto.ts` - Data transfer objects
6. `ADMIN_MODULE_SUMMARY.md` - This documentation

## Integration
Added to `app.module.ts`:
```typescript
import { AdminModule } from './modules/admin/admin.module';

@Module({
  imports: [
    // ... other modules
    AdminModule,
  ],
})
export class AppModule {}
```
