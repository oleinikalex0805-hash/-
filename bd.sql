CREATE DATABASE OrgRequests;
GO
USE OrgRequests;
GO

CREATE TABLE Roles (
Id INT IDENTITY(1,1) CONSTRAINT PK_Roles PRIMARY KEY,
Name NVARCHAR(50) NOT NULL CONSTRAINT UQ_Roles_Name UNIQUE
);

CREATE TABLE Departments (
Id INT IDENTITY(1,1) CONSTRAINT PK_Departments PRIMARY KEY,
Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_Departments_Name UNIQUE,
Description NVARCHAR(500) NULL
);

CREATE TABLE Users (
Id INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
FullName NVARCHAR(150) NOT NULL,
Email NVARCHAR(150) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
PasswordHash NVARCHAR(255) NOT NULL,
RoleId INT NOT NULL CONSTRAINT FK_Users_Roles REFERENCES Roles(Id),
DepartmentId INT NOT NULL CONSTRAINT FK_Users_Departments REFERENCES Departments(Id),
IsActive BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT 1,
CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT SYSUTCDATETIME(),
CONSTRAINT CK_Users_Email CHECK (Email LIKE '%_@_%._%')
);

CREATE TABLE Categories (
Id INT IDENTITY(1,1) CONSTRAINT PK_Categories PRIMARY KEY,
Name NVARCHAR(100) NOT NULL CONSTRAINT UQ_Categories_Name UNIQUE,
Description NVARCHAR(500) NULL
);

CREATE TABLE Resources (
Id INT IDENTITY(1,1) CONSTRAINT PK_Resources PRIMARY KEY,
Name NVARCHAR(150) NOT NULL,
Type NVARCHAR(30) NOT NULL,
InventoryNumber NVARCHAR(50) NOT NULL CONSTRAINT UQ_Resources_Inv UNIQUE,
Status NVARCHAR(30) NOT NULL CONSTRAINT DF_Resources_Status DEFAULT 'Available',
Location NVARCHAR(150) NULL,
DepartmentId INT NOT NULL CONSTRAINT FK_Resources_Departments REFERENCES Departments(Id),
CONSTRAINT CK_Resources_Type CHECK (Type IN ('Room','Equipment','Vehicle','Software')),
CONSTRAINT CK_Resources_Status CHECK (Status IN ('Available','InUse','Maintenance','WrittenOff'))
);

CREATE TABLE Requests (
Id INT IDENTITY(1,1) CONSTRAINT PK_Requests PRIMARY KEY,
Title NVARCHAR(200) NOT NULL,
Description NVARCHAR(2000) NULL,
Status NVARCHAR(20) NOT NULL CONSTRAINT DF_Requests_Status DEFAULT 'New',
Priority NVARCHAR(20) NOT NULL CONSTRAINT DF_Requests_Priority DEFAULT 'Medium',
CategoryId INT NOT NULL CONSTRAINT FK_Requests_Categories REFERENCES Categories(Id),
CreatorId INT NOT NULL CONSTRAINT FK_Requests_Creator REFERENCES Users(Id),
AssigneeId INT NULL CONSTRAINT FK_Requests_Assignee REFERENCES Users(Id),
CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Requests_CreatedAt DEFAULT SYSUTCDATETIME(),
UpdatedAt DATETIME2 NULL,
DueDate DATETIME2 NULL,
ClosedAt DATETIME2 NULL,
CONSTRAINT CK_Requests_Status CHECK (Status IN ('New','InProgress','OnHold','Closed','Rejected')),
CONSTRAINT CK_Requests_Priority CHECK (Priority IN ('Low','Medium','High','Critical')),
CONSTRAINT CK_Requests_Due CHECK (DueDate IS NULL OR DueDate >= CreatedAt),
CONSTRAINT CK_Requests_Closed CHECK (ClosedAt IS NULL OR Status IN ('Closed','Rejected'))
);

CREATE TABLE RequestResources (
Id INT IDENTITY(1,1) CONSTRAINT PK_RequestResources PRIMARY KEY,
RequestId INT NOT NULL CONSTRAINT FK_RR_Requests REFERENCES Requests(Id) ON DELETE CASCADE,
ResourceId INT NOT NULL CONSTRAINT FK_RR_Resources REFERENCES Resources(Id),
ReservedFrom DATETIME2 NOT NULL,
ReservedTo DATETIME2 NOT NULL,
CONSTRAINT UQ_RR_Request_Resource UNIQUE (RequestId, ResourceId),
CONSTRAINT CK_RR_Period CHECK (ReservedTo > ReservedFrom)
);

CREATE TABLE Comments (
Id INT IDENTITY(1,1) CONSTRAINT PK_Comments PRIMARY KEY,
RequestId INT NOT NULL CONSTRAINT FK_Comments_Requests REFERENCES Requests(Id) ON DELETE CASCADE,
AuthorId INT NOT NULL CONSTRAINT FK_Comments_Users REFERENCES Users(Id),
Text NVARCHAR(2000) NOT NULL,
CreatedAt DATETIME2 NOT NULL CONSTRAINT DF_Comments_CreatedAt DEFAULT SYSUTCDATETIME()
);

CREATE INDEX IX_Requests_Status_Priority ON Requests(Status, Priority);
CREATE INDEX IX_Requests_CreatedAt ON Requests(CreatedAt);
CREATE INDEX IX_Requests_Assignee ON Requests(AssigneeId);
GO
