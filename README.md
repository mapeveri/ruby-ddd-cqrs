# 🚀 Ruby DDD CQRS - Chat Application

[![Ruby](https://img.shields.io/badge/Ruby-3.3.0-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7.2.0-red.svg)](https://redis.io/)
[![RabbitMQ](https://img.shields.io/badge/RabbitMQ-3.12-green.svg)](https://www.rabbitmq.com/)
[![Docker](https://img.shields.io/badge/Docker-✓-blue.svg)](https://www.docker.com/)
[![RSpec](https://img.shields.io/badge/RSpec-✓-green.svg)](https://rspec.info/)

A modern, scalable chat application built with **Domain-Driven Design (DDD)** and **Command Query Responsibility Segregation (CQRS)** patterns using Ruby on Rails 8.

## 🏗️ Architecture Overview

This application demonstrates clean architecture principles with a clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Layer                          │
├─────────────────────────────────────────────────────────────┤
│                  Controllers (Rails)                       │
├─────────────────────────────────────────────────────────────┤
│                Application Layer (CQRS)                    │
│  ┌─────────────────┐  ┌─────────────────┐                │
│  │   Commands      │  │     Queries     │                │
│  │   (Write)       │  │     (Read)      │                │
│  └─────────────────┘  └─────────────────┘                │
├─────────────────────────────────────────────────────────────┤
│                  Domain Layer (DDD)                        │
│  ┌─────────────────┐  ┌─────────────────┐                │
│  │   Aggregates    │  │  Value Objects  │                │
│  │   Domain Events │  │   Repositories  │                │
│  └─────────────────┘  └─────────────────┘                │
├─────────────────────────────────────────────────────────────┤
│               Infrastructure Layer                         │
│  ┌─────────────────┐  ┌─────────────────┐                │
│  │   PostgreSQL    │  │      Redis      │                │
│  │   RabbitMQ      │  │   Event Store   │                │
│  └─────────────────┘  └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## ✨ Key Features

- **🎯 Domain-Driven Design**: Clean domain models with aggregates, value objects, and domain events
- **⚡ CQRS Pattern**: Separate command and query models for optimal performance
- **🏗️ Clean Architecture**: Clear separation between domain, application, and infrastructure layers
- **🐳 Docker Support**: Complete containerized development environment
- **📱 Real-time Chat**: WebSocket support with Action Cable
- **🧪 Comprehensive Testing**: RSpec test suite with proper test isolation
- **🔒 Security**: Brakeman security scanning and best practices
- **📊 Monitoring**: Redis Stack for caching and analytics

## 🛠️ Technology Stack

### Backend
- **Ruby 3.3.0** - Modern Ruby with performance improvements
- **Rails 8.0.2** - Latest Rails with solid_queue, solid_cache, solid_cable
- **PostgreSQL 15** - Robust relational database
- **Redis 7.2.0** - In-memory data structure store
- **RabbitMQ 3.12** - Message broker for event-driven architecture

### Development & Testing
- **RSpec** - Behavior-driven development framework
- **RuboCop** - Ruby code style checker
- **Brakeman** - Security vulnerability scanner
- **Faker** - Test data generation
- **Docker Compose** - Multi-container development environment

### Architecture Patterns
- **Domain Events** - Event-driven communication between aggregates
- **Aggregate Roots** - Consistency boundaries for domain objects
- **Value Objects** - Immutable domain concepts
- **Repository Pattern** - Data access abstraction
- **Command/Query Separation** - Optimized read/write operations

## 🚀 Quick Start

### Prerequisites
- Ruby 3.3.0
- Docker & Docker Compose
- PostgreSQL client (optional)

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/ruby-ddd-cqrs.git
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
```bash
bin/rails db:create db:migrate
```

### 6. Start the Application
```bash
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000) to see your application!

## 🏛️ Project Structure

```
src/
├── shared/                    # Shared domain components
│   ├── domain/
│   │   ├── aggregate_root.rb # Base aggregate root class
│   │   ├── domain_events/    # Domain event infrastructure
│   │   ├── bus/             # Event bus implementation
│   │   └── value_objects/   # Shared value objects
│   └── infrastructure/       # Shared infrastructure
├── chat/                     # Chat bounded context
│   ├── domain/              # Domain layer
│   │   ├── message/         # Message aggregate
│   │   └── user/            # User aggregate
│   ├── application/         # Application layer (CQRS)
│   │   └── message/
│   │       ├── commands/    # Write operations
│   │       └── queries/     # Read operations
│   └── infrastructure/      # Infrastructure layer
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
- **PostgreSQL**: `localhost:5435`
- **Redis**: `localhost:6379`
- **Redis Test**: `localhost:6380`
- **RabbitMQ**: `localhost:5672`
- **RabbitMQ Management**: `localhost:15672`

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
```

## 📚 Architecture Patterns in Action

### Domain Events
```ruby
# Domain event example
class Chat::Domain::Message::MessageSent < Shared::Domain::DomainEvent
  def initialize(message)
    @message_id = message.id
    @sender_id = message.sender_id
    @receiver_id = message.receiver_id
    @content = message.content
    @chat_id = message.chat_id
    @occurred_on = Time.now
  end
end
```

### CQRS Implementation
```ruby
# Command (Write)
class SendMessageCommand
  attr_reader :sender_id, :receiver_id, :content, :chat_id
end

# Query (Read)
class SearchMessagesQuery
  attr_reader :chat_id, :limit, :offset
end
```

### Aggregate Root
```ruby
class Chat::Domain::Message::Message < Shared::Domain::AggregateRoot
  def self.send(id:, sender_id:, receiver_id:, content:, chat_id:)
    message = new(...)
    message.record(Chat::Domain::Message::MessageSent.from(message))
    message
  end
end
```

## 🔧 Configuration

### Environment Variables
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `RABBITMQ_URL` - RabbitMQ connection string

### Database Configuration
The application uses PostgreSQL with UUID primary keys and proper indexing for CQRS read models.

## 🚀 Deployment

This application is configured for deployment using **Kamal**:

```bash
# Deploy to production
bundle exec kamal deploy

# Deploy to staging
bundle exec kamal deploy --config config/deploy.staging.yml
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
