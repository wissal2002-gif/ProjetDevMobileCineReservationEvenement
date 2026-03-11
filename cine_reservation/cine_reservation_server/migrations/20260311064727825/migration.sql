BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "options_supplementaires" ADD COLUMN "cinemaId" bigint;
CREATE INDEX "option_cinema_idx" ON "options_supplementaires" USING btree ("cinemaId");

--
-- MIGRATION VERSION FOR cine_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cine_reservation', '20260311064727825', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260311064727825', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260129181124635', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181124635', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
