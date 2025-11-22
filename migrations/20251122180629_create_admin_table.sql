-- Create "admins" table
CREATE TABLE "public"."admins" (
 "id" bigserial NOT NULL,
 "email" text NOT NULL,
 "password" text NOT NULL,
 "created_at" timestamptz NULL,
 "updated_at" timestamptz NULL,
 PRIMARY KEY ("id"),
 CONSTRAINT "uni_admins_email" UNIQUE ("email")
);
