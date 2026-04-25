# PottyTracker

A dog potty tracking application built with Elixir Phoenix (backend) and Flutter (mobile app). The backend uses hexagonal architecture for clean separation of concerns and is containerized with Docker.

## Features

- Track dog pee and poop events with timestamps
- Record walk duration
- RESTful API for mobile app integration
- Hexagonal architecture for maintainable code
- PostgreSQL database with Ecto ORM
- Docker containerization

## Architecture

The backend follows hexagonal architecture (ports & adapters):

- **Domain Layer**: Core business logic and entities
- **Application Layer**: Use cases and services
- **Infrastructure Layer**: External concerns (database, web framework)
- **Presentation Layer**: REST API controllers and views

## API Endpoints

### Walk Events

- `GET /api/walk_events` - List all walk events
- `POST /api/walk_events` - Create a new walk event
- `GET /api/walk_events/:id` - Get a specific walk event
- `PUT /api/walk_events/:id` - Update a walk event
- `DELETE /api/walk_events/:id` - Delete a walk event
- `GET /api/walk_events/stats` - Get statistics

### Request/Response Format

```json
{
  "id": "uuid",
  "timestamp": "2024-01-01T10:00:00Z",
  "duration_minutes": 30,
  "pee_count": 2,
  "poop_count": 1,
  "notes": "Walk in the park"
}
```

## Development Setup

### Prerequisites

- Elixir 1.15+
- PostgreSQL
- Docker (optional)

### Local Development

1. Install dependencies:
   ```bash
   mix deps.get
   ```

2. Create and migrate database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

3. Start the server:
   ```bash
   mix phx.server
   ```

The API will be available at `http://localhost:4000`

### Docker Development

1. Start services:
   ```bash
   docker-compose up
   ```

2. Run migrations:
   ```bash
   docker-compose exec web mix ecto.migrate
   ```

## Testing

Run the test suite:

```bash
mix test
```

## Deployment

Build the Docker image:

```bash
docker build -t potty-tracker .
```

## Mobile App

The Flutter mobile app is located in the `mobile/` directory. It provides a user-friendly interface for tracking dog potty events on iOS and Android.

## License

This project is licensed under the MIT License.
def deps do
  [
    {:potty_tracker, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/potty_tracker>.

