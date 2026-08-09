# 🚀 Ruby DDD CQRS - Chat Application

[![Ruby](https://img.shields.io/badge/Ruby-3.4.10-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.1.2-red.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7.2.0-red.svg)](https://redis.io/)
[![RabbitMQ](https://img.shields.io/badge/RabbitMQ-3.12-green.svg)](https://www.rabbitmq.com/)
[![Kafka](https://img.shields.io/badge/Redpanda%20(Kafka)-v24.2-red.svg)](https://redpanda.com/)
[![Docker](https://img.shields.io/badge/Docker-✓-blue.svg)](https://www.docker.com/)
[![RSpec](https://img.shields.io/badge/RSpec-✓-green.svg)](https://rspec.info/)

A modern, scalable chat application built with **Domain-Driven Design (DDD)** and **Command Query Responsibility Segregation (CQRS)** patterns using Ruby on Rails 8.

## 🏗️ Architecture Overview

This application demonstrates clean architecture principles with a clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Layer                           │
├─────────────────────────────────────────────────────────────┤
│                  Controllers (Rails)                        │
├─────────────────────────────────────────────────────────────┤
│                Application Layer (CQRS)                     │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │   Commands      │  │     Queries     │                   │
│  │ (Write/Postgres)│  │ (Read/Redis)    │                   │
│  └─────────────────┘  └─────────────────┘                   │
├─────────────────────────────────────────────────────────────┤
│                  Domain Layer (DDD)                         │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │   Aggregates    │  │  Value Objects  │                   │
│  │   Domain Events │  │   Repositories  │                   │
│  └─────────────────┘  └─────────────────┘                   │
├─────────────────────────────────────────────────────────────┤
│               Infrastructure Layer                          │
│  ┌─────────────────┐  ┌─────────────────┐                   │
│  │   PostgreSQL    │  │      Redis      │                   │
│  │   RabbitMQ      │  │     Gemini      │                   │
│  │   Kafka         │  │ Kafka Connect   │                   │
│  │   (Redpanda)    │  │  (JDBC sink)    │                   │
│  └─────────────────┘  └─────────────────┘                   │
└─────────────────────────────────────────────────────────────┘
```

### 📊 Analytics Pipeline

The `analytics` bounded context follows an event-driven **Message State** flow instead of in-memory projections:

```
 MessageSent
  domain event
      │
      ▼
 MessageStatePublisher
  (Kafka producer)
      │
      ▼
 chat.message.state   (compacted topic)
      │
      ▼
 Kafka Connect        (JDBC sink → analytics DB)
      │
      ▼
 message_records      (analytics Postgres DB)
      │
      ▼
 SQL Read Models      (ChatActivity / UserEngagement)
```

Rails reads analytics from a dedicated **analytics database** managed via Rails multi-database, while the JDBC sink only writes — the Rails schema owns the table.

## ✨ Key Features

- **🎯 Domain-Driven Design**: Clean domain models with aggregates, value objects, and domain events
- **⚡ CQRS Pattern**: Separate command and query models for optimal performance
- **🏗️ Clean Architecture**: Clear separation between domain, application, and infrastructure layers
- **📡 Event-Driven Analytics**: Message state published to a compacted Kafka topic and synced via Kafka Connect JDBC sink
- **🗄️ Multi-Database**: Dedicated analytics database integrated with Rails multi-database
- **🐳 Docker Support**: Complete containerized development environment
- **📱 Real-time Chat**: WebSocket support with Action Cable
- **🧪 Comprehensive Testing**: RSpec test suite with proper test isolation
- **🔒 Security**: Brakeman security scanning and best practices

## 🛠️ Technology Stack

### Backend
- **Ruby 3.4.10** - Ruby programming language
- **Rails 8.1.2** - Ruby on Rails framework
- **PostgreSQL 15** - Robust relational database (primary + analytics)
- **Redis 7.2.0** - In-memory data structure store
- **RabbitMQ 3.12** - Message broker for event-driven architecture
- **Redpanda (Kafka)** - Kafka-compatible message streaming platform
- **Kafka Connect** - JDBC sink connector that streams message state into the analytics database
- **Gemini** - LLM / Embeddings service used for RAG (Retrieval-Augmented Generation)

### Development & Testing
- **RSpec** - Framework for testing
- **RuboCop** - Ruby code style checker
- **Brakeman** - Security vulnerability scanner
- **Faker** - Test data generation
- **Docker Compose** - Multi-container development environment

### Architecture Patterns
- **Domain Events** - Event-driven communication between aggregates
- **Aggregate Roots** - Consistency boundaries for domain objects
- **Value Objects** - Immutable domain concepts
- **Repository Pattern** - Domain-focused data access abstraction that acts as a collection of aggregates and hides infrastructure details.
- **Command/Query Separation** - Optimized read/write operations

## 🚀 Quick Start

### Prerequisites
- Ruby 3.4.10
- Docker & Docker Compose
- PostgreSQL client (optional)

### 1. Clone the Repository
```bash
git clone https://github.com/mapeveri/ruby-ddd-cqrs.git
cd ruby-ddd-cqrs
```

### 2. Environment Setup
```bash
cp env.example .env
# Edit .env with your configuration
```

### 3. Start Services with Docker
```bash
docker-compose up -d
```

### 4. Install Dependencies
```bash
bundle install
```

### 5. Database Setup
Creates and migrates both the primary and analytics databases:
```bash
bin/rails db:create db:migrate
```

### 6. Bootstrap Kafka Infrastructure
```bash
# Creates the compacted `chat.message.state` topic
bin/bootstrap_kafka

# Registers the JDBC sink connector
bin/register_sink_connector.sh
```

### 7. Start the Application
```bash
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000) to see your application!

### Backfilling Message State
Republish the full state of every existing message to the Kafka topic (idempotent upsert):
```bash
bin/backfill_messages
```

### Consuming Messages

**Kafka (Redpanda)** - inspect the message state topic using `rpk`:
```bash
# Follow new messages as they arrive
docker exec -it redpanda rpk topic consume chat.message.state

# Read the topic from the beginning
docker exec -it redpanda rpk topic consume chat.message.state -o beginning

# List all topics
docker exec -it redpanda rpk topic list
```

> **Note:** The JDBC sink connector (`messages-jdbc-sink`) consumes the topic automatically and persists every message into the analytics database (`message_records`). The `rpk` commands above are only for inspecting/debugging raw messages — they are not part of the persistence flow.

**RabbitMQ** - consume domain events and dispatch them to their handlers:
```bash
bin/rabbit_mq_consumer
```

## 🏛️ Project Structure

```
src/
├── shared/                    # Shared domain components
│   ├── domain/
│   │   ├── aggregate_root.rb  # Base aggregate root class
│   │   ├── domain_events/     # Domain event infrastructure
│   │   ├── bus/               # Event bus implementation
│   │   └── value_objects/     # Shared value objects
│   └── infrastructure/        # Shared infrastructure
│       └── messaging/kafka/   # Kafka client wrapper
├── chat/                      # Chat bounded context
│   ├── domain/                # Domain layer
│   │   ├── message/           # Message aggregate
│   │   └── user/              # User aggregate
│   ├── application/           # Application layer (CQRS)
│   │   └── message/
│   │       ├── commands/      # Write operations
│   │       └── queries/       # Read operations
│   └── infrastructure/        # Infrastructure layer
│       ├── messaging/kafka/   # Message state publisher
│       └── subscribers/       # Domain event subscribers
└── analytics/                 # Analytics bounded context
    ├── domain/                # Domain layer
    ├── application/           # Queries (read models)
    └── infrastructure/
        └── persistence/
            ├── redis/         # Caching
            └── analytics_db/  # Message state records + SQL read models

db/
├── migrate/                   # Primary database migrations
├── analytics_migrate/         # Analytics database migrations
└── analytics_schema.rb        # Analytics database schema

docker/
├── kafka-connect/             # Kafka Connect image + connector config
└── analytics_db/              # Analytics DB init scripts
```

## 🧪 Testing

Run the complete test suite:
```bash
bundle exec rspec
```

Run specific test files:
```bash
bundle exec rspec spec/chat/domain/message
```

## 🐳 Docker Development

### Services
- **PostgreSQL (primary)**: `localhost:5435`
- **PostgreSQL (analytics)**: `localhost:5436`
- **Redis**: `localhost:6379`
- **Redis Test**: `localhost:6380`
- **RabbitMQ**: `localhost:5672`
- **RabbitMQ Management**: `localhost:15672`
- **Redpanda (Kafka)**: `localhost:9092`
- **Kafka Connect REST API**: `localhost:8083`

### Useful Commands
```bash
# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Stop all services
docker-compose down

# Rebuild containers
docker-compose up --build

# Inspect the analytics connector status
curl localhost:8083/connectors/messages-jdbc-sink/status
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
