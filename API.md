# API Documentation

## Overview

The Sinatra URL Shortener provides a RESTful API for programmatic access to link management and analytics.

**Base URL**: `https://your-domain.com/api`

**Authentication**: Session-based (login required for write operations)

## Endpoints

### Links

#### List All Links

```http
GET /api/links
```

**Response** (200 OK):
```json
[
  {
    "id": 1,
    "name": "docs",
    "url": "https://hamzi.dev/docs",
    "hits": 42,
    "category": "documentation",
    "tags": "help,reference"
  }
]
```

#### Get Link Details

```http
GET /api/links/:id
```

**Parameters**:
- `id` (integer, required): Link ID

**Response** (200 OK):
```json
{
  "id": 1,
  "name": "docs",
  "url": "https://hamzi.dev/docs",
  "hits": 42,
  "category": "documentation",
  "tags": "help,reference"
}
```

**Errors**:
- `404 Not Found`: Link does not exist

#### Create Link

```http
POST /api/links
Content-Type: application/json
```

**Request Body**:
```json
{
  "name": "docs",
  "url": "https://hamzi.dev/docs",
  "category": "documentation",
  "tags": "help,reference"
}
```

**Parameters**:
- `name` (string, required): Unique link name
- `url` (string, required): Target URL
- `category` (string, optional): Link category
- `tags` (string, optional): Comma-separated tags

**Response** (200 OK):
```json
{
  "id": 1,
  "name": "docs",
  "url": "https://hamzi.dev/docs",
  "hits": 0
}
```

**Errors**:
- `400 Bad Request`: Invalid input
- `403 Forbidden`: Admin access required

#### Delete Link

```http
DELETE /api/links/:id
```

**Parameters**:
- `id` (integer, required): Link ID

**Response** (200 OK):
```json
{
  "status": "deleted"
}
```

**Errors**:
- `403 Forbidden`: Admin access required
- `404 Not Found`: Link does not exist

### Search

#### Search Links

```http
GET /links/search?q=query&category=docs&tag=help
```

**Parameters**:
- `q` (string, optional): Search query (searches name and URL)
- `category` (string, optional): Filter by category
- `tag` (string, optional): Filter by tag

**Response**: HTML page with search results

#### Link Suggestions

```http
GET /links/suggest?q=doc
```

**Parameters**:
- `q` (string, required): Query prefix

**Response** (200 OK):
```json
[
  "query",
  ["docs", "documentation", "doc-api"]
]
```

### Dashboard

#### Get Dashboard Data

```http
GET /dashboard
```

**Response**: HTML dashboard page with:
- Total links count
- Total hits count
- Top 10 links by hits
- Recent 10 links
- Audit logs

### Authentication

#### Login

```http
POST /login
Content-Type: application/x-www-form-urlencoded
```

**Parameters**:
- `username` (string, required): Username
- `password` (string, required): Password

**Response**: Redirect to home page with session cookie

#### Logout

```http
GET /logout
```

**Response**: Redirect to login page

### OAuth

#### Google OAuth Callback

```http
GET /auth/google_oauth2/callback?code=...&state=...
```

#### GitHub OAuth Callback

```http
GET /auth/github/callback?code=...&state=...
```

#### Disconnect OAuth Provider

```http
GET /auth/disconnect/:provider
```

**Parameters**:
- `provider` (string, required): `google_oauth2` or `github`

## Error Responses

### 400 Bad Request

```json
{
  "error": "Invalid input",
  "message": "Link name cannot be empty"
}
```

### 403 Forbidden

```json
{
  "error": "Forbidden",
  "message": "Admin access required"
}
```

### 404 Not Found

```json
{
  "error": "Not found",
  "message": "Link does not exist"
}
```

### 500 Internal Server Error

```json
{
  "error": "Server error",
  "message": "An unexpected error occurred"
}
```

## Rate Limiting

The API implements rate limiting:

- **General**: 300 requests per 5 minutes per IP
- **Login**: 5 attempts per 20 minutes per IP
- **API**: 100 requests per minute per IP

Rate limit headers:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1234567890
```

## Authentication

### Session-Based

Most endpoints require an authenticated session. Login first:

```bash
curl -c cookies.txt -d "username=admin&password=admin123" \
  https://your-domain.com/login
```

Then use the session cookie:

```bash
curl -b cookies.txt https://your-domain.com/api/links
```

### OAuth

Users can authenticate via Google or GitHub OAuth. After OAuth callback, a session is created automatically.

## Examples

### Create a Link

```bash
curl -X POST https://your-domain.com/api/links \
  -H "Content-Type: application/json" \
  -d '{
    "name": "github",
    "url": "https://github.com/hamdyelbatal122/Sinatra",
    "category": "development",
    "tags": "open-source,ruby"
  }'
```

### List All Links

```bash
curl https://your-domain.com/api/links
```

### Get Link Details

```bash
curl https://your-domain.com/api/links/1
```

### Delete a Link

```bash
curl -X DELETE https://your-domain.com/api/links/1
```

### Search Links

```bash
curl "https://your-domain.com/links/search?q=github&category=development"
```

## Webhooks (Future)

Planned webhook support for:
- Link created
- Link deleted
- Link hit threshold reached

## Versioning

Current API version: **1.0**

Future versions will be available at `/api/v2/`, `/api/v3/`, etc.

## Support

For API issues or questions:
- Check [GitHub Issues](https://github.com/hamdyelbatal122/Sinatra/issues)
- Review [Interactive API Docs](/api/docs/ui)
- See [OpenAPI Spec](/api/docs)
