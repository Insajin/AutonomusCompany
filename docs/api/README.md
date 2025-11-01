# API Documentation

This directory contains API documentation for the project.

## Structure

```
api/
├── README.md           # This file
├── endpoints.md        # API endpoint specifications
├── authentication.md   # Authentication and authorization
├── data-models.md      # Request/response data models
└── examples.md         # Usage examples and code samples
```

## Documentation Standards

### Endpoint Documentation Format

For each endpoint, document:

```markdown
## GET /api/users/:id

Get user by ID.

**Authentication**: Required (JWT)

**Parameters**:
- `id` (path, required): User ID

**Query Parameters**:
- `include` (optional): Comma-separated list of relations to include (e.g., "profile,orders")

**Response** (200 OK):
```json
{
  "id": "123",
  "email": "user@example.com",
  "profile": {
    "name": "John Doe",
    "avatar": "https://..."
  }
}
```

**Errors**:
- `404 Not Found`: User does not exist
- `401 Unauthorized`: Missing or invalid authentication token
- `403 Forbidden`: User does not have permission to access this resource

**Example**:
```bash
curl -H "Authorization: Bearer <token>" \
  https://api.example.com/api/users/123?include=profile
```
```

### Data Model Documentation Format

```markdown
## User

**Fields**:
- `id` (string, required): Unique user identifier
- `email` (string, required): User email address (must be valid email format)
- `createdAt` (datetime, required): Account creation timestamp
- `profile` (Profile, optional): User profile information

**Validation**:
- Email must be unique
- Email format: RFC 5322 compliant
- ID format: UUID v4

**Relationships**:
- Has one Profile
- Has many Orders
```

## Automatic Documentation Updates

This documentation is kept in sync with code changes through the `docs-sync.yml` workflow:

1. Code changes merged to `main`
2. Workflow analyzes diff for API changes
3. Claude generates documentation updates
4. PR created with updated documentation
5. Team reviews and merges doc PR

## Contributing

When adding new API endpoints:

1. Add endpoint documentation to `endpoints.md`
2. Update data models in `data-models.md` if needed
3. Add usage examples to `examples.md`
4. Test all examples before committing

## Related Documentation

- [Architecture](../architecture.md) - System design overview
- [Quickstart](../../specs/001-ai-monorepo-template/quickstart.md) - Getting started
- [Troubleshooting](../troubleshooting.md) - Common issues
