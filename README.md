# 🎬 CinéVent — Réservation Cinéma & Événements

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Serverpod](https://img.shields.io/badge/Serverpod-3.4.3-22C55E?style=for-the-badge&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.6-764ABC?style=for-the-badge&logoColor=white)
![GoRouter](https://img.shields.io/badge/GoRouter-14.x-FF6B35?style=for-the-badge&logoColor=white)

**Application mobile full-stack de réservation de billets de cinéma et d'événements culturels**

*Projet de fin d'année — Module Développement Mobile | ENSA Tétouan 2025-2026*

</div>

---

## 🇫🇷 Français | 🇬🇧 [English below](#-english)

---

## 📱 Aperçu

CinéVent est une application multi-plateforme (Android, iOS, Web) permettant aux utilisateurs de consulter les programmes de cinéma, réserver leurs places, assister à des événements culturels et gérer leurs billets numériques.

---

## ✨ Fonctionnalités principales

### 👤 Espace Client
- 🏠 **Accueil personnalisé** — films à l'affiche, événements, recommandations selon l'historique, offres promotionnelles
- 🎬 **Catalogue films** — recherche, filtrage par genre, notation et avis
- 🎭 **Événements** — deux types : dans un cinéma (sélection de siège) et extérieurs (choix du nombre de tickets)
- 🪑 **Réservation interactive** — plan de salle avec sièges Standard et VIP
- 🛒 **Panier** — ajout d'options supplémentaires (snacks, boissons), codes promotionnels
- 💳 **Paiement multi-modes** — carte bancaire, PayPal, espèces
- 🎫 **Billets numériques** — QR code généré après paiement
- 🏆 **Programme de fidélité** — 3 niveaux : Bronze / Argent / Or avec avantages exclusifs
- ❤️ **Favoris** — films et cinémas sauvegardés
- ⭐ **Notation** — noter les films de 1 à 5 étoiles

### 🔐 Authentification & Sécurité
- Inscription avec vérification email (code OTP)
- Mot de passe oublié avec code de confirmation
- Protection anti-brute force (limitation des tentatives)
- Désactivation et suppression de compte sécurisées

### 👑 Espace Super Admin
- Tableau de bord global (films, événements, réservations, utilisateurs)
- Gestion des cinémas et salles
- Gestion des rôles utilisateurs (super_admin, admin_local, respo_evenements, client)
- Codes promotionnels avec statistiques d'utilisation
- FAQ et support client
- Rapports d'activité et revenus globaux

### 🏢 Espace Admin Local
- Tableau de bord du cinema assigné
- Gestion des films, séances et sièges
- Snacks et options supplémentaires
- Revenus et réservations du cinema

### 🎪 Espace Responsable Événements
- Création et gestion d'événements (dans cinema ou extérieurs)
- Suivi des réservations et revenues
- Statistiques de remplissage

---

## 🏗️ Architecture

```
ProjetDevMobileCineReservationEvenement/
└── cine_reservation/
    ├── cine_reservation_server/      ← Backend Serverpod (Dart)
    │   ├── lib/src/endpoints/        ← API endpoints
    │   ├── lib/src/models/           ← Modèles de données (.yaml)
    │   ├── lib/src/generated/        ← Code auto-généré
    │   └── migrations/               ← Migrations PostgreSQL
    ├── cine_reservation_client/      ← Client généré automatiquement
    └── cine_reservation_flutter/     ← Application Flutter
        └── lib/
            ├── core/                 ← Thème, routing, constantes
            └── features/             ← Modules par fonctionnalité
                ├── auth/
                ├── home/
                ├── programmation/
                ├── evenements/
                ├── reservation/
                ├── paiement/
                ├── billets/
                ├── profil/
                ├── admin/
                ├── admin_tanger/
                ├── admin_events/
                ├── faq/
                └── support/
```

---

## 🛠️ Stack technique

| Couche | Technologie |
|--------|-------------|
| Frontend | Flutter 3.x |
| State Management | Riverpod 2.6 |
| Navigation | GoRouter 14.x |
| Backend | Serverpod 3.4.3 (Dart) |
| Base de données | PostgreSQL 14+ |
| Authentification | Serverpod Auth (JWT + OTP) |
| Images | CachedNetworkImage |
| Versioning | Git (workflow multi-branches) |

---

## 🚀 Installation et démarrage

### Prérequis

- Flutter SDK 3.x
- Dart SDK 3.x
- Serverpod CLI 3.4.x — `dart pub global activate serverpod_cli`
- PostgreSQL 14+
- Git

### 1. Cloner le projet

```bash
git clone https://github.com/wissal2002-gif/ProjetDevMobileCineReservationEvenement.git
cd ProjetDevMobileCineReservationEvenement/cine_reservation
```

### 2. Installer les dépendances

```bash
dart pub get
```

### 3. Configurer PostgreSQL

```sql
CREATE DATABASE cine_reservation;
```

Modifier `cine_reservation_server/config/development.yaml` :

```yaml
database:
  host: localhost
  port: 5432
  name: cine_reservation
  user: postgres
  password: votre_mot_de_passe
```

### 4. Générer le code Serverpod

```bash
cd cine_reservation_server
serverpod generate
```

### 5. Appliquer les migrations

```bash
dart run bin/main.dart --apply-migrations
```

### 6. Démarrer le serveur

```bash
dart run bin/main.dart
```

### 7. Lancer l'application Flutter

```bash
cd ../cine_reservation_flutter

# Web
flutter run -d chrome

# Android / iOS
flutter run
```

### 8. Créer un compte administrateur

Après inscription dans l'app :

```sql
UPDATE utilisateurs SET role = 'super_admin' WHERE email = 'votre@email.com';
```

---

## 👥 Équipe

| Développeuse | Modules |
|---|---|
| **Wissal Khalid** | Auth, Profil, Réservation, Paiement, Billets, Fidélité, Favoris |
| **Imane El Bouzidi** | Films, Séances, Cinémas, Événements, Admin, Support, FAQ |

**Encadrant :** Pr. El Hajjamy
**Établissement :** ENSA Tétouan — 2025/2026

---

---

## 🇬🇧 English

## 📱 Overview

CinéVent is a cross-platform (Android, iOS, Web) application for booking cinema tickets and attending cultural events. Users can browse programs, reserve seats, manage their digital tickets, and benefit from a loyalty program.

---

## ✨ Key Features

### 👤 Client Space
- 🏠 **Personalized home** — featured films, events, recommendations based on history, promo offers
- 🎬 **Film catalog** — search, genre filtering, ratings and reviews
- 🎭 **Events** — two types: in-cinema (seat selection) and outdoor (ticket quantity)
- 🪑 **Interactive booking** — seat map with Standard and VIP seats
- 🛒 **Cart** — add extras (snacks, drinks), promo codes
- 💳 **Multi-payment** — credit card, PayPal, cash
- 🎫 **Digital tickets** — QR code generated after payment
- 🏆 **Loyalty program** — 3 levels: Bronze / Silver / Gold with exclusive perks
- ❤️ **Favorites** — saved films and cinemas
- ⭐ **Ratings** — rate films from 1 to 5 stars

### 🔐 Authentication & Security
- Registration with email verification (OTP code)
- Password reset with confirmation code
- Brute force protection (attempt limiting)
- Secure account deactivation and deletion

### 👑 Super Admin Space
- Global dashboard (films, events, bookings, users)
- Cinema and hall management
- User role management (super_admin, admin_local, respo_evenements, client)
- Promo codes with usage statistics
- FAQ and customer support
- Activity reports and global revenue

### 🏢 Local Admin Space
- Dashboard for assigned cinema
- Film, screening and seat management
- Snacks and extras management
- Revenue and booking tracking

### 🎪 Events Manager Space
- Create and manage events (in-cinema or outdoor)
- Booking and revenue tracking
- Capacity statistics

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.x |
| State Management | Riverpod 2.6 |
| Navigation | GoRouter 14.x |
| Backend | Serverpod 3.4.3 (Dart) |
| Database | PostgreSQL 14+ |
| Auth | Serverpod Auth (JWT + OTP) |
| Versioning | Git (multi-branch workflow) |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK 3.x
- Serverpod CLI — `dart pub global activate serverpod_cli`
- PostgreSQL 14+

### Quick Start

```bash
# Clone
git clone https://github.com/wissal2002-gif/ProjetDevMobileCineReservationEvenement.git
cd ProjetDevMobileCineReservationEvenement/cine_reservation

# Install dependencies
dart pub get

# Generate Serverpod code
cd cine_reservation_server && serverpod generate

# Apply migrations
dart run bin/main.dart --apply-migrations

# Start backend
dart run bin/main.dart

# Start Flutter app
cd ../cine_reservation_flutter && flutter run -d chrome
```

---

## 👥 Team

| Developer | Modules |
|---|---|
| **Wissal Khalid** | Auth, Profile, Booking, Payment, Tickets, Loyalty, Favorites |
| **Imane El Bouzidi** | Films, Screenings, Cinemas, Events, Admin, Support, FAQ |

**Supervisor:** Pr. El Hajjamy
**Institution:** ENSA Tétouan — 2025/2026

---

<div align="center">

Made with ❤️ at ENSA Tétouan

</div>