# User Management — Android + .NET

Copia completa del proyecto de gestión de usuarios. Este repositorio contiene la aplicación móvil Android y la API que utiliza para almacenar y consultar usuarios.

## Estructura

```text
UserManagement-Android-DotNet/
├── frontend-android/   Aplicación Android en Kotlin
└── backend-dotnet/     API REST en ASP.NET Core 8
```

## Tecnologías

### Frontend

- Kotlin
- Android Studio
- Retrofit y Gson
- Vistas XML

### Backend

- ASP.NET Core 8
- Entity Framework Core
- MariaDB/MySQL
- BCrypt
- Swagger

## Ejecutar el backend

1. Iniciar MySQL desde XAMPP.
2. Abrir una terminal en `backend-dotnet`.
3. Configurar la conexión local la primera vez:

```powershell
dotnet user-secrets set "ConnectionStrings:MySql" "server=localhost;port=3306;database=user_management;user=root;password="
```

4. Ejecutar la API:

```powershell
dotnet restore
dotnet run
```

Swagger queda disponible en `http://localhost:62129/swagger`.

## Ejecutar la aplicación Android

1. Abrir `frontend-android` con Android Studio.
2. Esperar la sincronización de Gradle.
3. Iniciar primero el backend.
4. Ejecutar la aplicación en el emulador.

El frontend ya apunta a `http://10.0.2.2:62129/`, que representa el computador anfitrión desde el emulador Android.

Consulta las instrucciones específicas en los README de cada componente.
