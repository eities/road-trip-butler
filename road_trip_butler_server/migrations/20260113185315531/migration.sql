BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "stop" DROP CONSTRAINT "stop_fk_0";
ALTER TABLE "stop" DROP COLUMN "_tripStopsTripId";
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "stop"
    ADD CONSTRAINT "stop_fk_0"
    FOREIGN KEY("tripId")
    REFERENCES "trip"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR road_trip_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('road_trip_butler', '20260113185315531', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260113185315531', "timestamp" = now();

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
