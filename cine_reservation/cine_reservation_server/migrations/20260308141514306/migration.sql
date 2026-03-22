BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "avis" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "filmId" bigint NOT NULL,
    "note" bigint NOT NULL,
    "dateAvis" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "avis_film_idx" ON "avis" USING btree ("filmId");
CREATE UNIQUE INDEX "avis_utilisateur_film_idx" ON "avis" USING btree ("utilisateurId", "filmId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "billets" ADD COLUMN "typeReservation" text DEFAULT 'cinema'::text;
ALTER TABLE "billets" ADD COLUMN "dateValidation" timestamp without time zone;
ALTER TABLE "billets" ALTER COLUMN "siegeId" DROP NOT NULL;
--
-- ACTION ALTER TABLE
--
DROP INDEX "cinema_nom_idx";
ALTER TABLE "cinemas" ADD COLUMN "telephone" text;
ALTER TABLE "cinemas" ADD COLUMN "email" text;
ALTER TABLE "cinemas" ADD COLUMN "description" text;
ALTER TABLE "cinemas" ADD COLUMN "photo" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "codes_promo" ADD COLUMN "description" text;
ALTER TABLE "codes_promo" ADD COLUMN "montantMinimum" double precision DEFAULT 0.0;
--
-- ACTION ALTER TABLE
--
DROP INDEX "demande_support_utilisateur_idx";
CREATE INDEX "support_utilisateur_idx" ON "demandes_support" USING btree ("utilisateurId");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "evenements" (
    "id" bigserial PRIMARY KEY,
    "titre" text NOT NULL,
    "description" text,
    "type" text DEFAULT 'concert'::text,
    "cinemaId" bigint,
    "lieu" text,
    "ville" text,
    "dateDebut" timestamp without time zone NOT NULL,
    "dateFin" timestamp without time zone,
    "affiche" text,
    "bandeAnnonce" text,
    "prix" double precision DEFAULT 0.0,
    "placesDisponibles" bigint DEFAULT 0,
    "placesTotales" bigint DEFAULT 0,
    "organisateur" text,
    "noteMoyenne" double precision DEFAULT 0.0,
    "nombreAvis" bigint DEFAULT 0,
    "statut" text DEFAULT 'actif'::text,
    "annulationGratuite" boolean DEFAULT true,
    "delaiAnnulation" bigint DEFAULT 48,
    "fraisAnnulation" double precision DEFAULT 0.0
);

-- Indexes
CREATE INDEX "evenement_cinema_idx" ON "evenements" USING btree ("cinemaId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "faqs" ADD COLUMN "actif" boolean DEFAULT true;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "fidelite" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "points" bigint DEFAULT 0,
    "niveau" text DEFAULT 'bronze'::text,
    "totalDepense" double precision DEFAULT 0.0,
    "dateAdhesion" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "fidelite_utilisateur_idx" ON "fidelite" USING btree ("utilisateurId");

--
-- ACTION ALTER TABLE
--
DROP INDEX "film_titre_idx";
ALTER TABLE "films" ADD COLUMN "nombreAvis" bigint DEFAULT 0;
ALTER TABLE "films" ADD COLUMN "langue" text DEFAULT 'VF'::text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "options_supplementaires" (
    "id" bigserial PRIMARY KEY,
    "nom" text NOT NULL,
    "description" text,
    "prix" double precision NOT NULL,
    "categorie" text DEFAULT 'snack'::text,
    "disponible" boolean DEFAULT true,
    "image" text
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "paiements" ADD COLUMN "paypalOrderId" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "remboursements" (
    "id" bigserial PRIMARY KEY,
    "paiementId" bigint NOT NULL,
    "reservationId" bigint NOT NULL,
    "utilisateurId" bigint NOT NULL,
    "montant" double precision NOT NULL,
    "raison" text,
    "statut" text DEFAULT 'en_attente'::text,
    "stripeRefundId" text,
    "dateDemandeRemboursement" timestamp without time zone NOT NULL,
    "dateRemboursement" timestamp without time zone,
    "traitePar" bigint
);

-- Indexes
CREATE INDEX "remboursement_paiement_idx" ON "remboursements" USING btree ("paiementId");
CREATE INDEX "remboursement_reservation_idx" ON "remboursements" USING btree ("reservationId");
CREATE INDEX "remboursement_utilisateur_idx" ON "remboursements" USING btree ("utilisateurId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reservation_options" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "optionId" bigint NOT NULL,
    "quantite" bigint DEFAULT 1,
    "prixUnitaire" double precision
);

-- Indexes
CREATE INDEX "reservation_option_idx" ON "reservation_options" USING btree ("reservationId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "reservation_sieges" ADD COLUMN "typeTarif" text DEFAULT 'normal'::text;
ALTER TABLE "reservation_sieges" ADD COLUMN "prix" double precision;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "reservations" ADD COLUMN "evenementId" bigint;
ALTER TABLE "reservations" ADD COLUMN "typeReservation" text DEFAULT 'cinema'::text;
ALTER TABLE "reservations" ADD COLUMN "montantApresReduction" double precision;
ALTER TABLE "reservations" ADD COLUMN "codePromoId" bigint;
ALTER TABLE "reservations" ALTER COLUMN "seanceId" DROP NOT NULL;
CREATE INDEX "reservation_evenement_idx" ON "reservations" USING btree ("evenementId");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "salles" ADD COLUMN "typeProjection" text DEFAULT '2D'::text;
--
-- ACTION DROP TABLE
--
DROP TABLE "seances" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "seances" (
    "id" bigserial PRIMARY KEY,
    "filmId" bigint NOT NULL,
    "salleId" bigint NOT NULL,
    "dateHeure" timestamp without time zone NOT NULL,
    "langue" text DEFAULT 'VF'::text,
    "typeProjection" text DEFAULT '2D'::text,
    "typeSeance" text DEFAULT 'standard'::text,
    "placesDisponibles" bigint NOT NULL,
    "prixNormal" double precision NOT NULL,
    "prixReduit" double precision,
    "prixSenior" double precision,
    "prixEnfant" double precision,
    "prixVip" double precision
);

-- Indexes
CREATE INDEX "seance_film_idx" ON "seances" USING btree ("filmId");
CREATE INDEX "seance_salle_idx" ON "seances" USING btree ("salleId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "sieges" ADD COLUMN "rangee" text;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "utilisateurs" ADD COLUMN "pointsFidelite" bigint DEFAULT 0;
ALTER TABLE "utilisateurs" ADD COLUMN "photoProfil" text;

--
-- MIGRATION VERSION FOR cine_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cine_reservation', '20260308141514306', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260308141514306', "timestamp" = now();

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
