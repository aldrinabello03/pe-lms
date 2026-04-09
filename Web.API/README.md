# PELMS Web API

A .NET 8 REST API backend for the Physical Education Learning Management System (PELMS) mobile app.

## Prerequisites

- .NET 8 SDK
- SQL Server (with `pelms_db` database from the existing MVC app)

## Configuration

Update `appsettings.json` with your database connection string and JWT settings.

## Running the API

```bash
cd Web.API
dotnet run
```

The API will be available at `https://localhost:5001` or `http://localhost:5000`.

Swagger UI: `https://localhost:5001/swagger`

## API Endpoints

### Authentication
- `POST /api/auth/login` — Login
- `POST /api/auth/register` — Register

### Student Profile (Student role required)
- `GET /api/student-profile`
- `POST /api/student-profile`
- `PUT /api/student-profile`

### Teacher Profile (Teacher role required)
- `GET /api/teacher-profile`
- `POST /api/teacher-profile`
- `PUT /api/teacher-profile`

### Tests (Student role required)
- `GET /api/tests`
- `GET /api/tests/{testKey}`

### Scores (Student role required)
- `POST /api/scores`
- `GET /api/scores`
- `GET /api/scores/{testTitle}`

### Dashboard
- `GET /api/dashboard/student` (Student role)
- `GET /api/dashboard/student/{userAccountId}` (Teacher role)
- `GET /api/dashboard/students` (Teacher role)

### Export (Teacher role required)
- `GET /api/export/student/{userAccountId}`
- `GET /api/export/students`
