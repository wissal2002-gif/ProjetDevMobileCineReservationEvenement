BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class Avis as table avis
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
-- Class Billet as table billets
--
CREATE TABLE "billets" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "siegeId" bigint,
    "typeReservation" text DEFAULT 'cinema'::text,
    "dateEmission" timestamp without time zone NOT NULL,
    "estValide" boolean DEFAULT true,
    "typeBillet" text DEFAULT 'standard'::text,
    "qrCode" text,
    "dateValidation" timestamp without time zone
);

-- Indexes
CREATE INDEX "billet_reservation_idx" ON "billets" USING btree ("reservationId");

--
-- Class Cinema as table cinemas
--
CREATE TABLE "cinemas" (
    "id" bigserial PRIMARY KEY,
    "nom" text NOT NULL,
    "adresse" text NOT NULL,
    "ville" text NOT NULL,
    "telephone" text,
    "email" text,
    "latitude" double precision,
    "longitude" double precision,
    "description" text,
    "photo" text
);

--
-- Class CodePromo as table codes_promo
--
CREATE TABLE "codes_promo" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "description" text,
    "reduction" double precision NOT NULL,
    "typeReduction" text DEFAULT 'pourcentage'::text,
    "montantMinimum" double precision DEFAULT 0.0,
    "dateExpiration" timestamp without time zone,
    "utilisationsMax" bigint DEFAULT 100,
    "utilisationsActuelles" bigint DEFAULT 0,
    "actif" boolean DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "code_promo_unique_idx" ON "codes_promo" USING btree ("code");

--
-- Class DemandeSupport as table demandes_support
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
CREATE INDEX "support_utilisateur_idx" ON "demandes_support" USING btree ("utilisateurId");

--
-- Class Evenement as table evenements
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
-- Class Faq as table faqs
--
CREATE TABLE "faqs" (
    "id" bigserial PRIMARY KEY,
    "question" text NOT NULL,
    "reponse" text NOT NULL,
    "categorie" text DEFAULT 'general'::text,
    "ordre" bigint DEFAULT 0,
    "actif" boolean DEFAULT true
);

--
-- Class Favori as table favoris
--
CREATE TABLE "favoris" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "cinemaId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "favori_unique_idx" ON "favoris" USING btree ("utilisateurId", "cinemaId");

--
-- Class Fidelite as table fidelite
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
-- Class Film as table films
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
    "nombreAvis" bigint DEFAULT 0,
    "dateDebut" timestamp without time zone,
    "dateFin" timestamp without time zone,
    "langue" text DEFAULT 'VF'::text
);

--
-- Class OptionSupplementaire as table options_supplementaires
--
CREATE TABLE "options_supplementaires" (
    "id" bigserial PRIMARY KEY,
    "nom" text NOT NULL,
    "description" text,
    "prix" double precision NOT NULL,
    "categorie" text DEFAULT 'snack'::text,
    "disponible" boolean DEFAULT true,
    "image" text,
    "cinemaId" bigint
);

-- Indexes
CREATE INDEX "option_cinema_idx" ON "options_supplementaires" USING btree ("cinemaId");

--
-- Class Paiement as table paiements
--
CREATE TABLE "paiements" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "montant" double precision NOT NULL,
    "methode" text DEFAULT 'carte'::text,
    "statut" text DEFAULT 'en_attente'::text,
    "stripePaymentId" text,
    "paypalOrderId" text,
    "createdAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "paiement_reservation_idx" ON "paiements" USING btree ("reservationId");

--
-- Class Remboursement as table remboursements
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
-- Class ReservationOption as table reservation_options
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
-- Class ReservationSiege as table reservation_sieges
--
CREATE TABLE "reservation_sieges" (
    "id" bigserial PRIMARY KEY,
    "reservationId" bigint NOT NULL,
    "siegeId" bigint NOT NULL,
    "typeTarif" text DEFAULT 'normal'::text,
    "prix" double precision
);

-- Indexes
CREATE UNIQUE INDEX "reservation_siege_unique_idx" ON "reservation_sieges" USING btree ("reservationId", "siegeId");

--
-- Class Reservation as table reservations
--
CREATE TABLE "reservations" (
    "id" bigserial PRIMARY KEY,
    "utilisateurId" bigint NOT NULL,
    "seanceId" bigint,
    "evenementId" bigint,
    "typeReservation" text DEFAULT 'cinema'::text,
    "dateReservation" timestamp without time zone NOT NULL,
    "montantTotal" double precision NOT NULL,
    "montantApresReduction" double precision,
    "statut" text DEFAULT 'en_attente'::text,
    "codePromoId" bigint
);

-- Indexes
CREATE INDEX "reservation_utilisateur_idx" ON "reservations" USING btree ("utilisateurId");
CREATE INDEX "reservation_seance_idx" ON "reservations" USING btree ("seanceId");
CREATE INDEX "reservation_evenement_idx" ON "reservations" USING btree ("evenementId");

--
-- Class Salle as table salles
--
CREATE TABLE "salles" (
    "id" bigserial PRIMARY KEY,
    "cinemaId" bigint NOT NULL,
    "codeSalle" text NOT NULL,
    "capacite" bigint NOT NULL,
    "equipements" text,
    "typeProjection" text DEFAULT '2D'::text
);

-- Indexes
CREATE INDEX "salle_cinema_idx" ON "salles" USING btree ("cinemaId");

--
-- Class Seance as table seances
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
-- Class Siege as table sieges
--
CREATE TABLE "sieges" (
    "id" bigserial PRIMARY KEY,
    "salleId" bigint NOT NULL,
    "numero" text NOT NULL,
    "rangee" text,
    "type" text DEFAULT 'standard'::text
);

-- Indexes
CREATE INDEX "siege_salle_idx" ON "sieges" USING btree ("salleId");
CREATE UNIQUE INDEX "siege_unique_idx" ON "sieges" USING btree ("salleId", "numero");

--
-- Class Utilisateur as table utilisateurs
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
    "role" text DEFAULT 'client'::text,
    "pointsFidelite" bigint DEFAULT 0,
    "photoProfil" text
);

-- Indexes
CREATE UNIQUE INDEX "utilisateur_email_idx" ON "utilisateurs" USING btree ("email");
CREATE UNIQUE INDEX "utilisateur_auth_idx" ON "utilisateurs" USING btree ("authUserId");

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" USING btree ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AnonymousAccount as table serverpod_auth_idp_anonymous_account
--
CREATE TABLE "serverpod_auth_idp_anonymous_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- Class AppleAccount as table serverpod_auth_idp_apple_account
--
CREATE TABLE "serverpod_auth_idp_apple_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean NOT NULL,
    "lastRefreshedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_apple_account_identifier" ON "serverpod_auth_idp_apple_account" USING btree ("userIdentifier");

--
-- Class EmailAccount as table serverpod_auth_idp_email_account
--
CREATE TABLE "serverpod_auth_idp_email_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_email" ON "serverpod_auth_idp_email_account" USING btree ("email");

--
-- Class EmailAccountPasswordResetRequest as table serverpod_auth_idp_email_account_password_reset_request
--
CREATE TABLE "serverpod_auth_idp_email_account_password_reset_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "emailAccountId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "challengeId" uuid NOT NULL,
    "setPasswordChallengeId" uuid
);

--
-- Class EmailAccountRequest as table serverpod_auth_idp_email_account_request
--
CREATE TABLE "serverpod_auth_idp_email_account_request" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_email_account_request_email" ON "serverpod_auth_idp_email_account_request" USING btree ("email");

--
-- Class FirebaseAccount as table serverpod_auth_idp_firebase_account
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- Class GitHubAccount as table serverpod_auth_idp_github_account
--
CREATE TABLE "serverpod_auth_idp_github_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userIdentifier" text NOT NULL,
    "email" text,
    "created" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_github_account_user_identifier" ON "serverpod_auth_idp_github_account" USING btree ("userIdentifier");

--
-- Class GoogleAccount as table serverpod_auth_idp_google_account
--
CREATE TABLE "serverpod_auth_idp_google_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text NOT NULL,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_google_account_user_identifier" ON "serverpod_auth_idp_google_account" USING btree ("userIdentifier");

--
-- Class PasskeyAccount as table serverpod_auth_idp_passkey_account
--
CREATE TABLE "serverpod_auth_idp_passkey_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_idp_passkey_account_key_id_base64" ON "serverpod_auth_idp_passkey_account" USING btree ("keyIdBase64");

--
-- Class PasskeyChallenge as table serverpod_auth_idp_passkey_challenge
--
CREATE TABLE "serverpod_auth_idp_passkey_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "challenge" bytea NOT NULL
);

--
-- Class RateLimitedRequestAttempt as table serverpod_auth_idp_rate_limited_request_attempt
--
CREATE TABLE "serverpod_auth_idp_rate_limited_request_attempt" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "domain" text NOT NULL,
    "source" text NOT NULL,
    "nonce" text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone NOT NULL,
    "extraData" json
);

-- Indexes
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "nonce", "attemptedAt");

--
-- Class SecretChallenge as table serverpod_auth_idp_secret_challenge
--
CREATE TABLE "serverpod_auth_idp_secret_challenge" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "challengeCodeHash" text NOT NULL
);

--
-- Class RefreshToken as table serverpod_auth_core_jwt_refresh_token
--
CREATE TABLE "serverpod_auth_core_jwt_refresh_token" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    "method" text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text NOT NULL,
    "lastUpdatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "serverpod_auth_core_jwt_refresh_token_last_updated_at" ON "serverpod_auth_core_jwt_refresh_token" USING btree ("lastUpdatedAt");

--
-- Class UserProfile as table serverpod_auth_core_profile
--
CREATE TABLE "serverpod_auth_core_profile" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "imageId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_profile_user_profile_email_auth_user_id" ON "serverpod_auth_core_profile" USING btree ("authUserId");

--
-- Class UserProfileImage as table serverpod_auth_core_profile_image
--
CREATE TABLE "serverpod_auth_core_profile_image" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "url" text NOT NULL
);

--
-- Class ServerSideSession as table serverpod_auth_core_session
--
CREATE TABLE "serverpod_auth_core_session" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastUsedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    "method" text NOT NULL
);

--
-- Class AuthUser as table serverpod_auth_core_user
--
CREATE TABLE "serverpod_auth_core_user" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_anonymous_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_anonymous_account"
    ADD CONSTRAINT "serverpod_auth_idp_anonymous_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_apple_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_apple_account"
    ADD CONSTRAINT "serverpod_auth_idp_apple_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_password_reset_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_0"
    FOREIGN KEY("emailAccountId")
    REFERENCES "serverpod_auth_idp_email_account"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_1"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_password_reset_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_password_reset_request_fk_2"
    FOREIGN KEY("setPasswordChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_email_account_request" table
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_0"
    FOREIGN KEY("challengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_firebase_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_github_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_github_account"
    ADD CONSTRAINT "serverpod_auth_idp_github_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_google_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_google_account"
    ADD CONSTRAINT "serverpod_auth_idp_google_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_idp_passkey_account" table
--
ALTER TABLE ONLY "serverpod_auth_idp_passkey_account"
    ADD CONSTRAINT "serverpod_auth_idp_passkey_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_jwt_refresh_token" table
--
ALTER TABLE ONLY "serverpod_auth_core_jwt_refresh_token"
    ADD CONSTRAINT "serverpod_auth_core_jwt_refresh_token_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "serverpod_auth_core_profile"
    ADD CONSTRAINT "serverpod_auth_core_profile_fk_1"
    FOREIGN KEY("imageId")
    REFERENCES "serverpod_auth_core_profile_image"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_profile_image" table
--
ALTER TABLE ONLY "serverpod_auth_core_profile_image"
    ADD CONSTRAINT "serverpod_auth_core_profile_image_fk_0"
    FOREIGN KEY("userProfileId")
    REFERENCES "serverpod_auth_core_profile"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_auth_core_session" table
--
ALTER TABLE ONLY "serverpod_auth_core_session"
    ADD CONSTRAINT "serverpod_auth_core_session_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


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
