# User Management API

API REST de gestión de usuarios desarrollada con ASP.NET Core y MySQL. Permite registrar, consultar, actualizar, eliminar y autenticar usuarios. Las contraseñas se almacenan como hashes de BCrypt y nunca se devuelven en las respuestas de la API.

Este repositorio contiene el backend. La aplicación Android se encuentra en un repositorio independiente.

## Funcionalidades

- Registro de usuarios con correo único.
- Inicio de sesión mediante correo y contraseña.
- Hash y verificación de contraseñas con BCrypt.
- Consulta, actualización y eliminación de usuarios.
- Registro de fecha de nacimiento, universidad y semestre.
- Cálculo dinámico de la edad desde la fecha de nacimiento.
- Validación de semestre entre 1 y 10.
- Validación de fechas de nacimiento futuras.
- Documentación y pruebas interactivas mediante Swagger.

## Tecnologías

- .NET 8
- ASP.NET Core Web API
- Entity Framework Core
- Pomelo Entity Framework Core para MySQL
- MySQL 8
- BCrypt.Net
- Swagger/OpenAPI

## Arquitectura

```text
Cliente Android o Swagger
          |
          v
UsuariosController
          |
          v
UsuarioService
          |
          v
UsuarioRepository
          |
          v
Entity Framework Core
          |
          v
MySQL
```

## Requisitos previos

Antes de ejecutar el proyecto se necesita:

1. Git.
2. .NET SDK 8.
3. MySQL Server 8 o superior.
4. MySQL Workbench, opcional, para ejecutar el script de forma gráfica.

Comprobar la instalación de .NET:

```powershell
dotnet --version
```

Comprobar que MySQL está disponible:

```powershell
mysql --version
```

Si `mysql` no está agregado al `PATH` en Windows, normalmente se encuentra en:

```text
C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe
```

## 1. Clonar el repositorio

```powershell
git clone https://github.com/navaflav/UserManagement-API-DotNet.git
cd UserManagement-API-DotNet
```

## 2. Crear la base de datos

El archivo [Database/crear_base_datos.sql](Database/crear_base_datos.sql) crea directamente la versión final de la base de datos. No es necesario crear una versión antigua ni ejecutar migraciones intermedias.

### Opción A: MySQL Workbench

1. Abrir MySQL Workbench y conectarse al servidor local.
2. Seleccionar `File > Open SQL Script`.
3. Abrir `Database/crear_base_datos.sql`.
4. Ejecutar todo el script con el botón del rayo.
5. Confirmar que aparece la tabla `Usuarios` dentro de `user_management`.

### Opción B: línea de comandos

Desde Command Prompt (`cmd`) en la carpeta del proyecto:

```bat
mysql -u root -p < Database\crear_base_datos.sql
```

MySQL solicitará la contraseña del usuario `root` y después creará la base de datos y la tabla.

## 3. Crear un usuario de MySQL para la aplicación

Este paso es recomendado para no ejecutar la API con el usuario administrador `root`. En MySQL Workbench o en la consola de MySQL, ejecutar lo siguiente y reemplazar `UNA_PASSWORD_SEGURA`:

```sql
CREATE USER IF NOT EXISTS 'ucompensar'@'localhost'
    IDENTIFIED BY 'UNA_PASSWORD_SEGURA';

GRANT ALL PRIVILEGES
    ON user_management.*
    TO 'ucompensar'@'localhost';

FLUSH PRIVILEGES;
```

Los parámetros creados son:

| Parámetro | Valor de ejemplo | Significado |
|---|---|---|
| Servidor | `localhost` | Equipo donde se ejecuta MySQL |
| Puerto | `3306` | Puerto predeterminado de MySQL |
| Base de datos | `user_management` | Base creada por el script |
| Usuario | `ucompensar` | Cuenta utilizada por la API |
| Contraseña | La elegida anteriormente | Contraseña del usuario de MySQL |

## 4. Configurar la conexión de la API

La propiedad que lee el backend se llama:

```text
ConnectionStrings:MySql
```

La cadena tiene este formato:

```text
server=localhost;port=3306;database=user_management;user=ucompensar;password=UNA_PASSWORD_SEGURA
```

### Método recomendado: variable de entorno temporal

En PowerShell, dentro de la carpeta del proyecto:

```powershell
$env:ConnectionStrings__MySql = "server=localhost;port=3306;database=user_management;user=ucompensar;password=UNA_PASSWORD_SEGURA"
```

Los dos guiones bajos de `ConnectionStrings__MySql` representan los dos puntos de `ConnectionStrings:MySql` en la configuración de .NET.

La variable solo existe en esa terminal. Esto evita guardar la contraseña dentro de Git.

### Método alternativo: appsettings.json

Para una prueba local también se pueden reemplazar temporalmente los marcadores de `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "MySql": "server=localhost;port=3306;database=user_management;user=ucompensar;password=UNA_PASSWORD_SEGURA"
  }
}
```

No se debe hacer commit de una contraseña real. Antes de subir cambios, restaurar los marcadores `TU_BASE_DATOS`, `TU_USUARIO` y `TU_PASSWORD`.

## 5. Restaurar y compilar

```powershell
dotnet restore
dotnet build
```

Una compilación correcta debe terminar con `0 errores`.

## 6. Ejecutar la API

En la misma terminal donde se configuró la variable de entorno:

```powershell
dotnet run --urls http://localhost:62129
```

Swagger estará disponible en:

```text
http://localhost:62129/swagger
```

## 7. Probar el registro en Swagger

Abrir `POST /api/Usuarios`, seleccionar `Try it out` y usar un cuerpo como este:

```json
{
  "nombre": "Ana",
  "apellido": "Gómez",
  "correo": "ana.gomez@example.com",
  "password": "Password123!",
  "fechaNacimiento": "2000-05-20",
  "universidad": "UCompensar",
  "semestre": 5
}
```

Una creación correcta devuelve HTTP `201`. La respuesta incluye la edad calculada, pero no incluye `password` ni `passwordHash`.

## 8. Probar el inicio de sesión

Abrir `POST /api/Usuarios/login` y enviar:

```json
{
  "correo": "ana.gomez@example.com",
  "password": "Password123!"
}
```

- Credenciales correctas: HTTP `200`.
- Correo o contraseña incorrectos: HTTP `401`.

## Endpoints

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/api/Usuarios` | Consultar todos los usuarios |
| `GET` | `/api/Usuarios/{id}` | Consultar un usuario por ID |
| `POST` | `/api/Usuarios` | Crear un usuario |
| `POST` | `/api/Usuarios/login` | Iniciar sesión |
| `PUT` | `/api/Usuarios/{id}` | Actualizar un usuario |
| `DELETE` | `/api/Usuarios/{id}` | Eliminar un usuario |

## Estructura de la tabla Usuarios

| Columna | Tipo | Descripción |
|---|---|---|
| `Id` | `INT` | Identificador autoincremental |
| `Nombre` | `VARCHAR(100)` | Nombre del usuario |
| `Apellido` | `VARCHAR(100)` | Apellido del usuario |
| `Correo` | `VARCHAR(150)` | Correo único |
| `PasswordHash` | `LONGTEXT` | Hash BCrypt de la contraseña |
| `FechaNacimiento` | `DATE` | Fecha utilizada para calcular la edad |
| `Universidad` | `VARCHAR(150)` | Universidad del estudiante |
| `Semestre` | `INT` | Semestre entre 1 y 10 |
| `Activo` | `BOOLEAN` | Estado del usuario |
| `FechaCreacion` | `DATETIME(6)` | Fecha de registro |

## Validaciones importantes

- El correo es obligatorio, debe tener formato válido y no puede repetirse.
- La contraseña debe contener al menos seis caracteres.
- La fecha de nacimiento no puede estar vacía ni estar en el futuro.
- La universidad es obligatoria.
- El semestre debe estar entre 1 y 10.
- La contraseña se transforma en un hash BCrypt antes de almacenarse.
- El hash de la contraseña nunca se devuelve al cliente.

## Conexión desde Android Emulator

Dentro del emulador Android, `localhost` se refiere al propio emulador. Para conectarse a una API que se ejecuta en el computador anfitrión se utiliza:

```text
http://10.0.2.2:62129/
```

El backend está configurado para permitir la práctica local por HTTP y no redirige automáticamente a HTTPS.

## Solución de problemas

### Can't connect to MySQL server o error 10061

El servidor MySQL no está iniciado. Abrir `Services` en Windows e iniciar el servicio de MySQL, o iniciarlo desde MySQL Workbench.

### Access denied for user

El usuario o la contraseña de la cadena de conexión no coinciden con MySQL. Revisar el paso 3 y volver a conceder permisos.

### Unknown database user_management

La base no fue creada. Ejecutar nuevamente `Database/crear_base_datos.sql`.

### Swagger abre, pero los endpoints devuelven error 500

Revisar que MySQL esté iniciado, que la cadena de conexión sea correcta y que la tabla `Usuarios` exista.

### El puerto 62129 está ocupado

Cerrar la otra instancia de la API o ejecutar temporalmente otro puerto:

```powershell
dotnet run --urls http://localhost:5000
```

Si se cambia el puerto, también se debe actualizar la URL utilizada por Android.

## Seguridad

- No guardar contraseñas reales de MySQL en Git.
- No enviar `PasswordHash` en respuestas de la API.
- No insertar contraseñas de usuarios directamente en SQL; deben registrarse mediante la API para generar correctamente el hash BCrypt.
- Los datos utilizados en Swagger deben ser datos de prueba.

## Instalación rápida para evaluación

1. Clonar el repositorio.
2. Ejecutar `Database/crear_base_datos.sql`.
3. Configurar `ConnectionStrings__MySql`.
4. Ejecutar `dotnet restore` y `dotnet run --urls http://localhost:62129`.
5. Abrir `http://localhost:62129/swagger`.
