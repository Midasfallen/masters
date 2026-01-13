-- Add admin and activity tracking fields to users table
-- Migration for Admin Module support

ALTER TABLE users
ADD COLUMN IF NOT EXISTS is_admin BOOLEAN DEFAULT FALSE;

ALTER TABLE users
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

ALTER TABLE users
ADD COLUMN IF NOT EXISTS last_login_at TIMESTAMP NULL;

-- Create index for faster admin queries
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_last_login_at ON users(last_login_at);

-- Set default values for existing users
UPDATE users
SET is_admin = FALSE
WHERE is_admin IS NULL;

UPDATE users
SET is_active = TRUE
WHERE is_active IS NULL;

-- Add comment to columns
COMMENT ON COLUMN users.is_admin IS 'Флаг админа платформы';
COMMENT ON COLUMN users.is_active IS 'Флаг активного пользователя (false = заблокирован)';
COMMENT ON COLUMN users.last_login_at IS 'Время последнего входа для аналитики';
