# User Management API

API REST para registrar, consultar, actualizar, eliminar y autenticar usuarios. El proyecto separa controladores, servicios, repositorios, entidades y objetos de transferencia de datos para mantener responsabilidades claras.

Este backend se utiliza junto con la aplicación [UserManagement Android Kotlin](https://github.com/sh111n0/UserManagement-Android-Kotlin).

## Funcionalidades

- Registro de usuarios con validación de correo único.
- Consulta de todos los usuarios y consulta individual por identificador.
- Actualización y eliminación de usuarios.
- Inicio de sesión por correo y contraseña.
- Contraseñas almacenadas como hash mediante BCrypt.
- Validación de fechas de nacimiento y semestre.
- Documentación interactiva de endpoints con Swagger en desarrollo.

## Tecnologías

- .NET 8 y ASP.NET Core Web API
- C#
- Entity Framework Core 8
- Pomelo Entity Framework Core para MySQL
- MySQL 8 o superior
- BCrypt.Net
- Swagger / OpenAPI

## Estructura

```text
Controllers/     Endpoints HTTP
DTOs/            Datos de entrada y salida
Entities/        Modelo de usuario
Interfaces/      Contratos de servicios y repositorios
Services/        Reglas de negocio y validaciones
Repositories/    Acceso a datos con Entity Framework Core
Data/            Contexto de base de datos
Database/        Script de creación de MySQL
```

## Endpoints

| Método | Ruta | Descripción |
|---|---|---|
| GET | `/api/Usuarios` | Lista todos los usuarios |
| GET | `/api/Usuarios/{id}` | Consulta un usuario |
| POST | `/api/Usuarios` | Registra un usuario |
| POST | `/api/Usuarios/login` | Valida las credenciales |
| PUT | `/api/Usuarios/{id}` | Actualiza un usuario |
| DELETE | `/api/Usuarios/{id}` | Elimina un usuario |

## Ejecución local

Requisitos:

- SDK de .NET 8
- MySQL 8 o superior

1. Clona el repositorio.

```bash
git clone https://github.com/sh111n0/UserManagement-API-DotNet.git
cd UserManagement-API-DotNet
```

2. Crea la base de datos.

```bash
mysql -u TU_USUARIO -p < Database/crear_base_datos.sql
```

3. Configura `ConnectionStrings:MySql` en `appsettings.json` con tus datos locales. No publiques contraseñas reales.

4. Restaura las dependencias y ejecuta la API.

```bash
dotnet restore
dotnet run
```

5. Abre la dirección de Swagger que aparezca en la consola. Si usas el emulador Android, revisa que el puerto coincida con el configurado en `ApiClient.kt`.

## Decisiones técnicas demostradas

- Uso de DTO para no exponer directamente la entidad.
- Inyección de dependencias mediante interfaces.
- Separación entre acceso a datos y reglas de negocio.
- Operaciones asíncronas con `async` y `await`.
- Hash y verificación de contraseñas con BCrypt.
- Restricción única para el correo en la base de datos.
