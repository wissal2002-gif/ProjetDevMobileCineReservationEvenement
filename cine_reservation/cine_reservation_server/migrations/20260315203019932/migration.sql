BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "utilisateurs" ADD COLUMN "cinemaId" bigint;
CREATE INDEX "utilisateur_cinema_idx" ON "utilisateurs" USING btree ("cinemaId");

--
-- MIGRATION VERSION FOR cine_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cine_reservation', '20260315203019932', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260315203019932', "timestamp" = now();

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
