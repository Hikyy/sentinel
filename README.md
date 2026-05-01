# Sentinel Hooks

> Gateway webhook sécurisé, self-hosted et open-source. Souveraineté des données, sécurité by design, observabilité complète.

[![CI](https://github.com/Hikyy/sentinel/actions/workflows/ci.yml/badge.svg)](https://github.com/Hikyy/sentinel/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/licence-Apache%202.0-blue.svg)](LICENSE)

## Qu'est-ce que Sentinel Hooks ?

Sentinel Hooks est un gateway webhook self-hosted qui s'intercale entre tes providers (Stripe, GitHub, etc.) et tes services internes. Il vérifie les signatures, re-signe, déduplique et livre de manière fiable chaque webhook — sans que tes données ne quittent ton infrastructure.

**Propriétés fondamentales :**

- **Zéro-trust** : les services internes ne reçoivent jamais le webhook brut — uniquement la version re-signée par le gateway.
- **Souveraineté** : aucune donnée ne quitte ton infrastructure.
- **Auditabilité** : toute action humaine est enregistrée dans un log à chaînage cryptographique.
- **Open core** : le cœur est utilisable en production en open source pur (Apache 2.0).

## Démarrage rapide

```bash
make up          # démarre Postgres + RabbitMQ + backend (hot-reload) + frontend (HMR)
make logs        # suit les logs
make down        # stoppe la stack
```

Services exposés en local :

| Service | URL | Identifiants |
|---|---|---|
| Backend API | http://localhost:8080 | — |
| Frontend dashboard | http://localhost:4200 | — |
| Actuator health | http://localhost:8080/actuator/health | — |
| Métriques Prometheus | http://localhost:8080/actuator/prometheus | — |
| RabbitMQ UI | http://localhost:15672 | sentinel / dev |
| PostgreSQL | localhost:5432 | sentinel / sentinel / dev |

## Prérequis

- **Docker** + Docker Compose v2.22+
- **JDK 21** + **Maven 3.9+** (pour la compilation IDE qui alimente le hot-reload backend)
- **Node 20+** (optionnel, si tu lances le frontend hors Docker)

## Architecture

```
sentinel/
├── apps/
│   ├── backend/       Spring Boot 3.x — DDD/Hexagonal (Java 21)
│   └── frontend/      Angular 21+ — composants standalone + signals
├── sdks/              SDK de re-signature multi-langages (V2+)
└── infra/             Docker Compose, Helm chart (V2)
```

Le **backend** est structuré en monolithe DDD avec des bounded contexts distincts (`webhook-ingestion`, `delivery`, `audit`, `tenant`). Chaque contexte expose des ports (interfaces) et des adapters (implémentations infra).

Le **frontend** est une SPA Angular 21+ avec des composants standalone, des signals natifs et OnPush systématique.

## Hot-reload backend Spring Boot

Le mode dev utilise `spring-boot-devtools` + bind-mount Docker :

1. L'IDE (IntelliJ / Eclipse / VS Code) compile en continu vers `apps/backend/target/classes`.
2. Le container Docker monte ce dossier en lecture seule.
3. `spring-boot-devtools` détecte le changement de classpath → redémarre la JVM en ~1-2 s.

**Configuration IntelliJ** : Settings → Build → Compiler → « Build project automatically » + Registry `compiler.automake.allow.when.app.running` = true.

Le frontend Angular utilise le HMR natif de `@angular/build:dev-server` (~500 ms par modification).

## Contribuer

1. Forke le dépôt et crée une branche de fonctionnalité : `feat/<courte-description>`.
2. Respecte les [Conventional Commits](https://www.conventionalcommits.org/) pour les messages de commit.
3. Ouvre une PR — la CI doit passer avant le merge.
4. Au moins une revue de mainteneur est requise.

## Licence

[Apache License 2.0](LICENSE)
