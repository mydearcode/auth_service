# Auth Service

Authentication service built with Ruby on Rails, featuring:
- JWT-based authentication
- Redis-based rate limiting
- Secure password management
- API throttling

## Features
- User registration and authentication
- JWT token management
- Rate limiting (1000 requests/minute)
- Redis integration
- Secure password handling

## Setup

### Prerequisites
- Ruby 3.3.6
- Rails 7.2.2
- Redis
- PostgreSQL

### Installation

### Environment Variables
Create a `.env` file in the root directory:

```env
REDIS_URL=redis://localhost:6379/0
JWT_SECRET=your_jwt_secret
DATABASE_URL=postgresql://localhost/auth_service
```

## API Endpoints
- POST /api/v1/register - User registration
- POST /api/v1/login - User login
- DELETE /api/v1/logout - User logout
- GET /api/v1/me - Get current user

## Rate Limiting
- General API: 1000 requests/minute
- Login: 20 requests/5 minutes
- Register: 5 requests/hour

## Contributing
Pull requests are welcome.

## License
MIT
