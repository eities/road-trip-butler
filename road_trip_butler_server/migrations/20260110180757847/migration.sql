BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stop" (
    "id" bigserial PRIMARY KEY,
    "tripId" bigint NOT NULL,
    "name" text NOT NULL,
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
-- ACTION CREATE TABLE
--
CREATE TABLE "trip" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "startAddress" text NOT NULL,
    "endAddress" text NOT NULL,
    "departureTime" timestamp without time zone NOT NULL,
    "polyline" text NOT NULL,
    "preferences" text,
    "totalDurationSeconds" bigint NOT NULL
);


--
-- MIGRATION VERSION FOR road_trip_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('road_trip_butler', '20260110180757847', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260110180757847', "timestamp" = now();

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
