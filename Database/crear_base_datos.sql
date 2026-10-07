-- =============================================================
-- UserManagement API
-- Instalacion final de la base de datos para MySQL 8 o superior
-- =============================================================

CREATE DATABASE IF NOT EXISTS user_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE user_management;

CREATE TABLE IF NOT EXISTS Usuarios
(
    Id INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Apellido VARCHAR(100) NOT NULL,
    Correo VARCHAR(150) NOT NULL,
    PasswordHash LONGTEXT NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Universidad VARCHAR(150) NOT NULL,
    Semestre INT NOT NULL,
    Activo BOOLEAN NOT NULL DEFAULT TRUE,
    FechaCreacion DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),

    CONSTRAINT PK_Usuarios PRIMARY KEY (Id),
    CONSTRAINT UQ_Usuarios_Correo UNIQUE (Correo),
    CONSTRAINT CK_Usuarios_Semestre CHECK (Semestre BETWEEN 1 AND 10)
);

-- Comprobacion visible al terminar la instalacion.
DESCRIBE Usuarios;
