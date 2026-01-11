BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "stop" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stop" (
    "id" bigserial PRIMARY KEY,
    "stopId" bigint NOT NULL,
    "tripId" bigint NOT NULL,
    "name" text NOT NULL,
    "slotTitle" text NOT NULL,
    "address" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "category" text NOT NULL,
    "butlerNote" text NOT NULL,
    "rating" double precision,
    "priceLevel" text NOT NULL,
    "status" text NOT NULL,
    "estimatedArrivalTime" timestamp without time zone NOT NULL
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "trip" ADD COLUMN "stops" json;

--
-- MIGRATION VERSION FOR road_trip_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('road_trip_butler', '20260111181650881', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260111181650881', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
