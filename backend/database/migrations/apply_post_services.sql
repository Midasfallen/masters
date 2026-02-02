-- Применение миграции для post_services вручную

CREATE EXTENSION IF NOT EXISTS postgis;

ALTER TABLE "posts" 
ADD COLUMN IF NOT EXISTS "custom_service_name" TEXT;

ALTER TABLE "posts" 
ADD COLUMN IF NOT EXISTS "location_geography" geography(POINT, 4326);

CREATE TABLE IF NOT EXISTS "post_services" (
  "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  "post_id" UUID NOT NULL,
  "service_id" UUID NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT now(),
  CONSTRAINT "FK_post_services_post" FOREIGN KEY ("post_id") REFERENCES "posts"("id") ON DELETE CASCADE,
  CONSTRAINT "FK_post_services_service" FOREIGN KEY ("service_id") REFERENCES "services"("id") ON DELETE CASCADE,
  CONSTRAINT "UQ_post_services" UNIQUE ("post_id", "service_id")
);

CREATE INDEX IF NOT EXISTS "IDX_post_services_post" ON "post_services" ("post_id");
CREATE INDEX IF NOT EXISTS "IDX_post_services_service" ON "post_services" ("service_id");
CREATE INDEX IF NOT EXISTS "IDX_posts_custom_service_gin" ON "posts" USING gin(to_tsvector('russian', COALESCE("custom_service_name", '')));
CREATE INDEX IF NOT EXISTS "IDX_posts_location_geography" ON "posts" USING gist("location_geography");

UPDATE "posts" 
SET "location_geography" = ST_SetSRID(ST_MakePoint("location_lng", "location_lat"), 4326)::geography
WHERE "location_lat" IS NOT NULL 
  AND "location_lng" IS NOT NULL 
  AND "location_geography" IS NULL;
