BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "stop" DROP COLUMN "estimatedArrivalTime";
ALTER TABLE "stop" ADD COLUMN "detourTimeMinutes" bigint;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "trip" DROP COLUMN "totalDurationSeconds";
ALTER TABLE "trip" ADD COLUMN "totalDurationMinutes" bigint;

--
-- MIGRATION VERSION FOR road_trip_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('road_trip_butler', '20260116042506390', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260116042506390', "timestamp" = now();

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
