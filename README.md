# User Management API

Backend REST para la aplicación Android de gestión de usuarios. Está desarrollado con ASP.NET Core 8, Entity Framework Core y MySQL/MariaDB.

## Requisitos

- SDK de .NET 8
- MySQL o MariaDB en el puerto 3306
- En este equipo se utiliza MariaDB incluido con XAMPP

## Configuración local

La conexión a la base de datos se guarda mediante secretos de usuario y no se sube a GitHub.

```powershell
dotnet user-secrets set "ConnectionStrings:MySql" "server=localhost;port=3306;database=user_management;user=root;password="
```

Si el usuario `root` tiene contraseña, debe escribirse después de `password=`.

## Ejecutar

1. Iniciar MySQL desde XAMPP.
2. Abrir una terminal en la carpeta del proyecto.
3. Ejecutar:

```powershell
dotnet restore
dotnet run
```

Durante el arranque en modo Development se aplican automáticamente las migraciones pendientes. La documentación interactiva queda disponible en:

- `http://localhost:62129/swagger`
- `https://localhost:62128/swagger`

El emulador Android debe usar `http://10.0.2.2:62129/`, que ya está configurado en el proyecto móvil.

## Endpoints

| Método | Endpoint | Descripción |
|---|---|---|
| GET | `/api/Usuarios` | Consultar usuarios |
| GET | `/api/Usuarios/{id}` | Consultar un usuario |
| POST | `/api/Usuarios` | Crear un usuario |
| POST | `/api/Usuarios/login` | Iniciar sesión |
| PUT | `/api/Usuarios/{id}` | Actualizar un usuario |
| DELETE | `/api/Usuarios/{id}` | Eliminar un usuario |

Las contraseñas se almacenan como hashes BCrypt; nunca se devuelven en las respuestas de la API.
