-- Performance Optimization: Database Indexes
-- Migration for faster queries on critical tables

-- ============================================
-- USERS TABLE - Critical for authentication and lookups
-- ============================================

-- Email lookup (login, registration check)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Phone lookup (alternative login)
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);

-- Master profile queries
CREATE INDEX IF NOT EXISTS idx_users_is_master ON users(is_master) WHERE is_master = TRUE;

-- Admin queries
CREATE INDEX IF NOT EXISTS idx_users_is_admin ON users(is_admin) WHERE is_admin = TRUE;

-- Active users filter
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);

-- Recent users (analytics)
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at DESC);

-- Last login tracking
CREATE INDEX IF NOT EXISTS idx_users_last_login_at ON users(last_login_at DESC);

-- ============================================
-- BOOKINGS TABLE - High-traffic operations
-- ============================================

-- Client's bookings lookup
CREATE INDEX IF NOT EXISTS idx_bookings_client_id ON bookings(client_id);

-- Master's bookings lookup
CREATE INDEX IF NOT EXISTS idx_bookings_master_id ON bookings(master_id);

-- Service bookings
CREATE INDEX IF NOT EXISTS idx_bookings_service_id ON bookings(service_id);

-- Status filtering (pending, confirmed, completed, cancelled)
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(status);

-- Scheduled time range queries
CREATE INDEX IF NOT EXISTS idx_bookings_start_time ON bookings(start_time);

-- Composite index for master's upcoming bookings
CREATE INDEX IF NOT EXISTS idx_bookings_master_start ON bookings(master_id, start_time DESC);

-- Composite index for client's bookings history
CREATE INDEX IF NOT EXISTS idx_bookings_client_start ON bookings(client_id, start_time DESC);

-- Review tracking
CREATE INDEX IF NOT EXISTS idx_bookings_client_review_left ON bookings(client_id, client_review_left)
  WHERE client_review_left = FALSE;

-- Recent bookings (admin analytics)
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings(created_at DESC);

-- ============================================
-- POSTS TABLE - Social feed performance
-- ============================================

-- Author's posts
CREATE INDEX IF NOT EXISTS idx_posts_author_id ON posts(author_id);

-- Category filtering
CREATE INDEX IF NOT EXISTS idx_posts_category_id ON posts(category_id);

-- Repost tracking
CREATE INDEX IF NOT EXISTS idx_posts_reposted_from_id ON posts(reposted_from_id)
  WHERE reposted_from_id IS NOT NULL;

-- Feed sorting by creation time
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC);

-- Popular posts (by likes)
CREATE INDEX IF NOT EXISTS idx_posts_likes_count ON posts(likes_count DESC);

-- Composite: author's posts by date
CREATE INDEX IF NOT EXISTS idx_posts_author_created ON posts(author_id, created_at DESC);

-- ============================================
-- LIKES TABLE - Social interactions
-- ============================================

-- User's liked posts
CREATE INDEX IF NOT EXISTS idx_likes_user_id ON likes(user_id);

-- Post's likes count
CREATE INDEX IF NOT EXISTS idx_likes_post_id ON likes(post_id);

-- Composite: check if user liked post (prevent duplicates)
CREATE UNIQUE INDEX IF NOT EXISTS idx_likes_user_post ON likes(user_id, post_id);

-- ============================================
-- COMMENTS TABLE - Social interactions
-- ============================================

-- Post's comments
CREATE INDEX IF NOT EXISTS idx_comments_post_id ON comments(post_id);

-- Author's comments
CREATE INDEX IF NOT EXISTS idx_comments_author_id ON comments(author_id);

-- Parent comment (replies)
CREATE INDEX IF NOT EXISTS idx_comments_parent_id ON comments(parent_comment_id)
  WHERE parent_comment_id IS NOT NULL;

-- Recent comments
CREATE INDEX IF NOT EXISTS idx_comments_created_at ON comments(created_at DESC);

-- Composite: post's comments by date
CREATE INDEX IF NOT EXISTS idx_comments_post_created ON comments(post_id, created_at ASC);

-- ============================================
-- REVIEWS TABLE - Rating system
-- ============================================

-- Booking review
CREATE INDEX IF NOT EXISTS idx_reviews_booking_id ON reviews(booking_id);

-- Reviewer lookup
CREATE INDEX IF NOT EXISTS idx_reviews_reviewer_id ON reviews(reviewer_id);

-- Reviewed user (master/client)
CREATE INDEX IF NOT EXISTS idx_reviews_reviewed_user_id ON reviews(reviewed_user_id);

-- Rating filter
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);

-- Recent reviews
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

-- Composite: user's received reviews
CREATE INDEX IF NOT EXISTS idx_reviews_user_created ON reviews(reviewed_user_id, created_at DESC);

-- ============================================
-- SERVICES TABLE - Service catalog
-- ============================================

-- Master's services
CREATE INDEX IF NOT EXISTS idx_services_master_id ON services(master_id);

-- Category services
CREATE INDEX IF NOT EXISTS idx_services_category_id ON services(category_id);

-- Active services
CREATE INDEX IF NOT EXISTS idx_services_is_active ON services(is_active) WHERE is_active = TRUE;

-- Price range queries
CREATE INDEX IF NOT EXISTS idx_services_price ON services(price);

-- Composite: master's active services
CREATE INDEX IF NOT EXISTS idx_services_master_active ON services(master_id, is_active)
  WHERE is_active = TRUE;

-- ============================================
-- FRIENDS TABLE - Social connections
-- ============================================

-- User's friendships
CREATE INDEX IF NOT EXISTS idx_friends_user_id ON friends(user_id);

-- Friend lookup
CREATE INDEX IF NOT EXISTS idx_friends_friend_id ON friends(friend_id);

-- Status filtering
CREATE INDEX IF NOT EXISTS idx_friends_status ON friends(status);

-- Composite: user's pending requests
CREATE INDEX IF NOT EXISTS idx_friends_user_status ON friends(user_id, status);

-- Composite: prevent duplicate friendship
CREATE UNIQUE INDEX IF NOT EXISTS idx_friends_user_friend ON friends(user_id, friend_id);

-- ============================================
-- SUBSCRIPTIONS TABLE - Follow system
-- ============================================

-- Follower's subscriptions
CREATE INDEX IF NOT EXISTS idx_subscriptions_follower_id ON subscriptions(follower_id);

-- Following count
CREATE INDEX IF NOT EXISTS idx_subscriptions_following_id ON subscriptions(following_id);

-- Recent subscriptions
CREATE INDEX IF NOT EXISTS idx_subscriptions_created_at ON subscriptions(created_at DESC);

-- Composite: prevent duplicate subscription
CREATE UNIQUE INDEX IF NOT EXISTS idx_subscriptions_follower_following
  ON subscriptions(follower_id, following_id);

-- ============================================
-- CHATS TABLE - Messaging
-- ============================================

-- User's chats
CREATE INDEX IF NOT EXISTS idx_chats_user1_id ON chats(user1_id);
CREATE INDEX IF NOT EXISTS idx_chats_user2_id ON chats(user2_id);

-- Last message time (sorting)
CREATE INDEX IF NOT EXISTS idx_chats_last_message_at ON chats(last_message_at DESC);

-- ============================================
-- MESSAGES TABLE - Chat messages
-- ============================================

-- Chat's messages
CREATE INDEX IF NOT EXISTS idx_messages_chat_id ON messages(chat_id);

-- Sender lookup
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);

-- Unread messages
CREATE INDEX IF NOT EXISTS idx_messages_is_read ON messages(is_read) WHERE is_read = FALSE;

-- Message ordering
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at ASC);

-- Composite: chat's messages by date
CREATE INDEX IF NOT EXISTS idx_messages_chat_created ON messages(chat_id, created_at ASC);

-- ============================================
-- NOTIFICATIONS TABLE - Real-time updates
-- ============================================

-- User's notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);

-- Unread notifications
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read) WHERE is_read = FALSE;

-- Recent notifications
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- Composite: user's unread notifications
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread
  ON notifications(user_id, is_read, created_at DESC) WHERE is_read = FALSE;

-- ============================================
-- MASTER_PROFILES TABLE - Master data
-- ============================================

-- User's master profile
CREATE UNIQUE INDEX IF NOT EXISTS idx_master_profiles_user_id ON master_profiles(user_id);

-- Active profiles
CREATE INDEX IF NOT EXISTS idx_master_profiles_is_active ON master_profiles(is_active)
  WHERE is_active = TRUE;

-- Verified masters
CREATE INDEX IF NOT EXISTS idx_master_profiles_is_verified ON master_profiles(is_verified)
  WHERE is_verified = TRUE;

-- ============================================
-- STATISTICS
-- ============================================

-- Analyze tables for query planner
ANALYZE users;
ANALYZE bookings;
ANALYZE posts;
ANALYZE likes;
ANALYZE comments;
ANALYZE reviews;
ANALYZE services;
ANALYZE friends;
ANALYZE subscriptions;
ANALYZE chats;
ANALYZE messages;
ANALYZE notifications;
ANALYZE master_profiles;

-- Show index usage statistics (for monitoring)
-- Run this query periodically to check index effectiveness:
-- SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
-- FROM pg_stat_user_indexes
-- ORDER BY idx_scan ASC;

-- Show table sizes
-- SELECT
--   schemaname,
--   tablename,
--   pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
-- FROM pg_tables
-- WHERE schemaname = 'public'
-- ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
