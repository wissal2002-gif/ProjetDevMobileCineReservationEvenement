BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "billets" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "siegeId" bigint NOT NULL,
    "dateEmission" timestamp without time zone NOT NULL,
    "estValide" boolean DEFAULT true,
    "typeBillet" text DEFAULT 'standard'::text,
    "qrCode" text
);

-- Indexes
CREATE INDEX "billet_reservation_idx" ON "billets" USING btree ("reservationId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cinemas" (
    "id" bigserial PRIMARY KEY,
    "nom" text NOT NULL,
    "adresse" text NOT NULL,
    "ville" text NOT NULL,
    "latitude" double precision,
    "longitude" double precision
);

-- Indexes
CREATE INDEX "cinema_nom_idx" ON "cinemas" USING btree ("nom");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "codes_promo" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "reduction" double precision NOT NULL,
    "typeReduction" text DEFAULT 'pourcentage'::text,
    "dateExpiration" timestamp without time zone,
    "utilisationsMax" bigint DEFAULT 100,
    "utilisationsActuelles" bigint DEFAULT 0,
    "actif" boolean DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "code_promo_unique_idx" ON "codes_promo" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "demandes_support" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "sujet" text NOT NULL,
    "message" text NOT NULL,
    "statut" text DEFAULT 'ouvert'::text,
    "reponse" text,
    "createdAt" timestamp without time zone,
    "updatedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "demande_support_utilisateur_idx" ON "demandes_support" USING btree ("utilisateurId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "faqs" (
    "id" bigserial PRIMARY KEY,
    "question" text NOT NULL,
    "reponse" text NOT NULL,
    "categorie" text DEFAULT 'general'::text,
    "ordre" bigint DEFAULT 0
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "favoris" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "cinemaId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "favori_unique_idx" ON "favoris" USING btree ("utilisateurId", "cinemaId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "films" (
    "id" bigserial PRIMARY KEY,
    "titre" text NOT NULL,
    "synopsis" text,
    "genre" text,
    "duree" bigint,
    "realisateur" text,
    "casting" text,
    "affiche" text,
    "bandeAnnonce" text,
    "classification" text,
    "noteMoyenne" double precision DEFAULT 0.0,
    "dateDebut" timestamp without time zone,
    "dateFin" timestamp without time zone
);

-- Indexes
CREATE INDEX "film_titre_idx" ON "films" USING btree ("titre");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "paiements" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "montant" double precision NOT NULL,
    "methode" text DEFAULT 'carte'::text,
    "statut" text DEFAULT 'en_attente'::text,
    "stripePaymentId" text,
    "createdAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "paiement_reservation_idx" ON "paiements" USING btree ("reservationId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reservation_sieges" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "siegeId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "reservation_siege_unique_idx" ON "reservation_sieges" USING btree ("reservationId", "siegeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "reservations" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "seanceId" bigint NOT NULL,
    "dateReservation" timestamp without time zone NOT NULL,
    "montantTotal" double precision NOT NULL,
    "statut" text DEFAULT 'en_attente'::text
);

-- Indexes
CREATE INDEX "reservation_utilisateur_idx" ON "reservations" USING btree ("utilisateurId");
CREATE INDEX "reservation_seance_idx" ON "reservations" USING btree ("seanceId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "salles" (
    "id" bigserial PRIMARY KEY,
    "cinemaId" bigint NOT NULL,
    "codeSalle" text NOT NULL,
    "capacite" bigint NOT NULL,
    "equipements" text
);

-- Indexes
CREATE INDEX "salle_cinema_idx" ON "salles" USING btree ("cinemaId");

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
    "placesDisponibles" bigint NOT NULL,
    "prix" double precision NOT NULL
);

-- Indexes
CREATE INDEX "seance_film_idx" ON "seances" USING btree ("filmId");
CREATE INDEX "seance_salle_idx" ON "seances" USING btree ("salleId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sieges" (
    "id" bigserial PRIMARY KEY,
    "salleId" bigint NOT NULL,
    "numero" text NOT NULL,
    "type" text DEFAULT 'standard'::text
);

-- Indexes
CREATE INDEX "siege_salle_idx" ON "sieges" USING btree ("salleId");
CREATE UNIQUE INDEX "siege_unique_idx" ON "sieges" USING btree ("salleId", "numero");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "utilisateurs" (
    "id" bigserial PRIMARY KEY,
    "authUserId" text,
    "nom" text NOT NULL,
    "email" text NOT NULL,
    "telephone" text,
    "dateNaissance" timestamp without time zone,
    "preferences" json,
    "statut" text DEFAULT 'actif'::text,
    "role" text DEFAULT 'client'::text
);

-- Indexes
CREATE UNIQUE INDEX "utilisateur_email_idx" ON "utilisateurs" USING btree ("email");
CREATE UNIQUE INDEX "utilisateur_auth_idx" ON "utilisateurs" USING btree ("authUserId");


--
-- MIGRATION VERSION FOR cine_reservation
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('cine_reservation', '20260308113222360', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260308113222360', "timestamp" = now();

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
