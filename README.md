# Chat System

## Environment Setup
1. Prerequisites
  - Docker
    - Docker: https://docs.docker.com/engine/install/ubuntu/
    - Compose: https://docs.docker.com/compose/install/
2. Clone the repo
```bash
git clone https://github.com/SherifRafik/chat-system.git
```
3. Build the docker containers
```bash
docker-compose up
```

After finished the build, you can access the application using http://localhost:3000

You can access Sidekiq dashboard through http://localhost:3000/sidekiq

## Environment
  - Ruby 3.0.3
  - Rails 7.1.2
  - RSpec
  - Docker Compose v3
  - Redis
  - Sidekiq
  - Sidekiq Scheduler
  - ElasticSearch

## API Documentation
### Applications
#### Create application
- Endpoint: `POST api/v1/applications/`
- Body: 
  ```json
  {
      "application": {
          "name": "The first application"
      }
  }
  ```
- Response
  ```json
  {
    "token": "8aabf7e9f4223c6180aea70f953329a06b06e149ae9fa922",
    "name": "The first application",
    "chats_count": 0,
    "created_at": "2023-12-13 23:58:45 UTC",
    "updated_at": "2023-12-13 23:58:45 UTC"
  }
  ```

#### Get all applications
- Endpoint: `GET api/v1/applications/`
- Response
  ```json
  [
    {
        "token": "3262141a7231fa50665225970203bf54989bd552ef306719",
        "name": "Application #1",
        "chats_count": 2,
        "created_at": "2023-12-13 23:01:53 UTC",
        "updated_at": "2023-12-13 23:03:19 UTC"
    },
    {
        "token": "7062d77045a5e56c76b8c63c8eff2b78908e18e20a6af462",
        "name": "Application #2",
        "chats_count": 0,
        "created_at": "2023-12-13 23:08:02 UTC",
        "updated_at": "2023-12-13 23:08:02 UTC"
    },
    {
        "token": "8aabf7e9f4223c6180aea70f953329a06b06e149ae9fa922",
        "name": "The first application",
        "chats_count": 0,
        "created_at": "2023-12-13 23:58:45 UTC",
        "updated_at": "2023-12-13 23:58:45 UTC"
    }
  ]
  ```

#### Update application
- Endpoint: `PUT api/v1/applications/:token`
- Body: 
  ```json
  {
      "application": {
          "name": "Edited name"
      }
  }
  ```
- Response:
  ```json
  {
      "token": "8aabf7e9f4223c6180aea70f953329a06b06e149ae9fa922",
      "name": "Edited name",
      "chats_count": 0,
      "created_at": "2023-12-13 23:58:45 UTC",
      "updated_at": "2023-12-14 00:01:54 UTC"
  }
  ```

#### Get application
- Endpoint: `GET api/v1/applications/:token`
- Response:
  ```json
  {
      "token": "8aabf7e9f4223c6180aea70f953329a06b06e149ae9fa922",
      "name": "Edited name",
      "chats_count": 0,
      "created_at": "2023-12-13 23:58:45 UTC",
      "updated_at": "2023-12-14 00:01:54 UTC"
  }
  ```

#### Delete application
- Endpoint: `DELETE api/v1/applications/:token`
- Response:
  ```json
  ```

### Chats
#### Create chat for a specific application
- Endpoint: `POST /api/v1/applications/:token/chats`
- Response:
  ```json
  {
    "number": 1
  }
  ```

#### List all chats for a specific application
- Endpoint: `GET /api/v1/applications/:token/chats`
- Response:
  ```json
  [
      {
          "number": 1,
          "application_token": "7062d77045a5e56c76b8c63c8eff2b78908e18e20a6af462",
          "messages_count": 0,
          "created_at": "2023-12-14 00:06:24 UTC",
          "updated_at": "2023-12-14 00:06:24 UTC"
      }
  ]
  ```

#### Get chat for a specific application
- Endpoint: `GET /api/v1/applications/:token/chats/:number`
- Response:
  ```json
  {
    "number": 1,
    "application_token": "7062d77045a5e56c76b8c63c8eff2b78908e18e20a6af462",
    "messages_count": 0,
    "created_at": "2023-12-14 00:06:24 UTC",
    "updated_at": "2023-12-14 00:06:24 UTC"
  }
  ```

#### Delete chat for a specific application
- Endpoint: `DELETE /api/v1/applications/:token/chats/:number`
- Response:
  ```json
  ```

### Messages
#### Create a message for a specific chat
- Endpoint: `POST /api/v1/applications/:token/chats/:chatNumber/messages/`
- Body:
  ```json
  {
    "message": {
      "body": "The is a new message"
    }
  }
  ```
- Response:
  ```json
  {
    "number": 6
  }
  ```
#### Update a message for a specific chat
- Endpoint: `PUT /api/v1/applications/:token/chats/:chatNumber/messages/:number`
- Body:
  ```json
  {
    "message": {
      "body": "The chanchan man - Edited"
    }
  }
  ```
- Response:
  ```json
  {
    "number": 2,
    "body": "The chanchan man - Edited"
  }
  ```

#### Get all messages for a specific chat
- Endpoint: `GET /api/v1/applications/:token/chats/:chatNumber/messages`
- Response:
  ```json
  [
    {
        "number": 1,
        "chat_number": 2,
        "body": "Message #1",
        "created_at": "2023-12-13 23:03:12 UTC",
        "updated_at": "2023-12-13 23:03:12 UTC"
    },
    {
        "number": 2,
        "chat_number": 2,
        "body": "The chanchan man",
        "created_at": "2023-12-13 23:47:42 UTC",
        "updated_at": "2023-12-13 23:47:42 UTC"
    },
    {
        "number": 4,
        "chat_number": 2,
        "body": "Is the searching feature working?",
        "created_at": "2023-12-13 23:47:53 UTC",
        "updated_at": "2023-12-13 23:47:53 UTC"
    },
    {
        "number": 5,
        "chat_number": 2,
        "body": "Let's try maching on feat",
        "created_at": "2023-12-13 23:47:59 UTC",
        "updated_at": "2023-12-13 23:47:59 UTC"
    }
  ]
  ```

#### Get message for a specific chat
- Endpoint: `GET /api/v1/applications/:token/chats/:chatNumber/messages/:number`
- Response:
  ```json
  {
      "number": 2,
      "chat_number": 2,
      "body": "The chanchan man",
      "created_at": "2023-12-13 23:47:42 UTC",
      "updated_at": "2023-12-13 23:47:42 UTC"
  }
  ```

#### Partial search all the messages of a specific chat
- Endpoint: `GET /api/v1/applications/:token/chats/:chatNumber/messages/search`
- Body:
  ```json
  {
    "message": {
        "query": "feat"
    }
  }
  ```
- Response
  ```json
  [
    {
        "number": 4,
        "chat_number": 2,
        "body": "Is the searching feature working?",
        "created_at": "2023-12-13 23:47:53 UTC",
        "updated_at": "2023-12-13 23:47:53 UTC"
    },
    {
        "number": 5,
        "chat_number": 2,
        "body": "Let's try maching on feat",
        "created_at": "2023-12-13 23:47:59 UTC",
        "updated_at": "2023-12-13 23:47:59 UTC"
    }
  ]
  ```
