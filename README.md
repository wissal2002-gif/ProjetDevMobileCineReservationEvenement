# 🎬 CineReservation — Guide de démarrage complet

Projet de réservation de billets de cinéma — Flutter + Serverpod + PostgreSQL

---

## 👥 Équipe

| Personne | Tâches |
|----------|--------|
| **Wissal** | Auth, Profil, Réservation, Paiement, Billets |
| **Binôme** | Films, Séances, Cinémas, Salles, Admin, Support |

---

## 📋 Prérequis

Avant de commencer, installe ces outils :

- [Flutter](https://flutter.dev/docs/get-started/install) (version stable)
- [Dart](https://dart.dev/get-dart)
- [PostgreSQL](https://www.postgresql.org/download/) (version 14+)
- [Git](https://git-scm.com/)
- [VS Code](https://code.visualstudio.com/) ou Android Studio
- Serverpod CLI :

```powershell
dart pub global activate serverpod_cli
```

Vérifie les installations :

```powershell
flutter --version
dart --version
psql --version
serverpod version
```

---

## 🚀 Étape 1 — Cloner le projet

```powershell
cd C:\Users\TON_NOM\StudioProjects
git clone https://github.com/wissal2002-gif/ProjetDevMobileCineReservationEvenement.git
cd ProjetDevMobileCineReservationEvenement
```

---

## 🗄️ Étape 2 — Créer la base de données

```powershell
psql -U postgres -c "CREATE DATABASE cine_reservation;"
```

---

## ⚙️ Étape 3 — Configurer les fichiers de config

### 3.1 — Créer `passwords.yaml`

```powershell
cd cine_reservation\cine_reservation_server
code config\passwords.yaml
```

Colle ce contenu (remplace `TON_MOT_DE_PASSE` par ton mot de passe PostgreSQL) :

```yaml
development:
  database: 'TON_MOT_DE_PASSE'
  serviceSecret: 'myServiceSecret12345678901234567890'
  jwtRefreshTokenHashPepper: 'myJwtRefreshTokenHashPepper1234567890'
  jwtHmacSha512PrivateKey: 'myJwtHmacSha512PrivateKey1234567890abcdefghijklmnopqrstuvwxyz12345'
  emailSecretHashPepper: 'myEmailSecretHashPepper1234567890'
```

> ⚠️ **IMPORTANT** : Ne jamais commiter ce fichier sur GitHub ! Il est déjà dans `.gitignore`.

### 3.2 — Vérifier `development.yaml`

Ouvre `config\development.yaml` et vérifie que la section `database` est :

```yaml
database:
  host: localhost
  port: 5432
  name: cine_reservation
  user: postgres
```

> ⚠️ Le port doit être **5432** (PostgreSQL), pas 8080 ou 8090.

---

## 📦 Étape 4 — Installer les dépendances

```powershell
# Server
cd cine_reservation\cine_reservation_server
dart pub get

# Client
cd ..\cine_reservation_client
dart pub get

# Flutter
cd ..\cine_reservation_flutter
flutter pub get
```

---

## 🗃️ Étape 5 — Appliquer les migrations

```powershell
cd cine_reservation\cine_reservation_server
dart run bin/main.dart --apply-migrations
```

Tu devrais voir :
```
Applied database migration: XXXXXXXXXXXX
Webserver listening on http://localhost:8082
```

Stoppe avec **Ctrl+C**.

---

## ▶️ Étape 6 — Lancer le serveur

```powershell
cd cine_reservation\cine_reservation_server
dart run bin/main.dart
```

Serveur disponible sur :
- **API** : http://localhost:8080
- **Web** : http://localhost:8082

---

## 📱 Étape 7 — Lancer l'app Flutter

Dans un **nouveau terminal** :

```powershell
cd cine_reservation\cine_reservation_flutter
flutter run
```

---

## 🏗️ Architecture du projet

```
ProjetDevMobileCineReservationEvenement/
└── cine_reservation/
    ├── cine_reservation_server/     ← Backend Serverpod
    │   ├── bin/main.dart
    │   ├── config/
    │   │   ├── development.yaml
    │   │   └── passwords.yaml       ← NE PAS commiter !
    │   ├── lib/src/
    │   │   ├── endpoints/
    │   │   ├── models/
    │   │   └── generated/           ← NE PAS modifier !
    │   └── migrations/
    ├── cine_reservation_client/     ← NE PAS modifier !
    └── cine_reservation_flutter/
        └── lib/
            ├── core/
            └── features/
                ├── auth/
                ├── profil/
                ├── programmation/
                ├── reservation/
                ├── paiement/
                ├── billets/
                ├── admin/
                └── support/
```

### Structure d'une feature (Clean Architecture)

```
features/auth/
├── data/
│   ├── datasources/        ← Appels API Serverpod
│   └── repositories/       ← Implémentation
├── domain/
│   ├── entities/           ← Classes métier
│   ├── repositories/       ← Interfaces
│   └── usecases/           ← Logique métier
└── presentation/
    ├── pages/              ← Écrans
    ├── widgets/            ← Composants
    └── providers/          ← État Riverpod
```

---

## 🔄 Workflow quotidien

### Modifier un modèle `.spy.yaml`

```powershell
cd cine_reservation\cine_reservation_server
serverpod generate
serverpod create-migration
dart run bin/main.dart --apply-migrations
```

### Git quotidien

```powershell
git pull origin main
git checkout -b feature/nom-de-ta-feature
# ... coder ...
git add .
git commit -m "feat: description"
git push origin feature/nom-de-ta-feature
# Créer une Pull Request sur GitHub
```

---

## 📊 Tables de la base de données

| Table | Description |
|-------|-------------|
| `utilisateurs` | Comptes utilisateurs |
| `films` | Films en programmation |
| `cinemas` | Cinémas |
| `salles` | Salles de cinéma |
| `seances` | Séances |
| `sieges` | Sièges par salle |
| `reservations` | Réservations |
| `reservation_sieges` | Sièges réservés |
| `paiements` | Paiements |
| `billets` | E-billets |
| `favoris` | Cinémas favoris |
| `codes_promo` | Codes de réduction |
| `faqs` | FAQ |
| `demandes_support` | Support utilisateurs |

---

## ⚠️ Règles importantes

1. **Ne jamais modifier** `generated/` et `cine_reservation_client/`
2. **Toujours lancer** `serverpod generate` après modification d'un `.spy.yaml`
3. **Ne jamais commiter** `config/passwords.yaml`
4. **Toujours faire** `git pull` avant de commencer
5. **Travailler sur des branches** — jamais directement sur `main`

---

## 🐛 Problèmes fréquents

**"Missing password"** → Vérifier `config/passwords.yaml` avec la clé `development:`

**Erreur connexion BD** → Vérifier que PostgreSQL tourne + mot de passe correct + BD existe

**Port 8080 occupé** → Changer dans `development.yaml` : `port: 8090`

**`serverpod generate` échoue** → Vérifier que la version CLI = version packages `pubspec.yaml`
