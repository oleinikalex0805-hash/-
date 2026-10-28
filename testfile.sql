USE OrgRequests;
GO

INSERT INTO Roles(Name) VALUES (N'Admin'), (N'Manager'), (N'Employee');

INSERT INTO Departments(Name, Description) VALUES
(N'IT', N'Информационные технологии'),
(N'Бухгалтерия', N'Финансы и учёт'),
(N'АХО', N'Административно-хозяйственный отдел'),
(N'HR', N'Управление персоналом');

INSERT INTO Users(FullName, Email, PasswordHash, RoleId, DepartmentId) VALUES
(N'Иванов Иван', 'ivanov@org.local', 'hash_1', 1, 1),
(N'Петрова Анна', 'petrova@org.local', 'hash_2', 2, 3),
(N'Смирнов Алексей', 'smirnov@org.local', 'hash_5', 2, 1);

INSERT INTO Categories(Name, Description) VALUES
(N'Техподдержка', N'Проблемы с ПК и ПО'),
(N'Бронирование', N'Переговорные, транспорт'),
(N'Закупки', N'Заявки на оборудование'),
(N'Хозяйственные', N'Ремонт, уборка, мебель');

INSERT INTO Resources(Name, Type, InventoryNumber, Status, Location, DepartmentId) VALUES
(N'Переговорная №1', 'Room', 'R-001', 'Available', N'2 этаж', 3),
(N'Переговорная №2', 'Room', 'R-002', 'Available', N'3 этаж', 3),
(N'Проектор Epson', 'Equipment', 'E-101', 'Available', N'Склад', 1),
(N'Ноутбук Lenovo T14', 'Equipment', 'E-102', 'InUse', N'IT', 1),
(N'Служебный авто Kia', 'Vehicle', 'V-201', 'Available', N'Парковка',3);

INSERT INTO Requests(Title, Description, Status, Priority, CategoryId, CreatorId, AssigneeId, CreatedAt, DueDate, ClosedAt) VALUES
(N'Не работает принтер', N'Не печатает на 1 этаже', 'InProgress','High', 1, 3, 1, '2026-10-01', '2026-10-05', NULL),
(N'Забронировать переговорную', N'Совещание 15.10', 'Closed', 'Medium', 2, 4, 2, '2026-10-02', '2026-10-15', '2026-10-14'),
(N'Закупка мониторов', N'5 шт. 27"', 'New', 'Low', 3, 3, NULL,'2026-10-03', '2026-11-01', NULL),
(N'Сломан кондиционер', N'Кабинет 204', 'New', 'Critical',4, 4, 2, '2026-10-04', '2026-10-08', NULL),
(N'Установить Visual Studio', N'Для нового разработчика','Closed', 'Medium', 1, 5, 1, '2026-10-05', '2026-10-07', '2026-10-06'),
(N'Нужен проектор на семинар', N'20.10, 10:00', 'InProgress','Medium', 2, 4, 2, '2026-10-06', '2026-10-20', NULL),
(N'Заказ канцтоваров', N'Бумага, ручки', 'OnHold', 'Low', 3, 3, 2, '2026-10-07', NULL, NULL);

INSERT INTO RequestResources(RequestId, ResourceId, ReservedFrom, ReservedTo) VALUES
(2, 1, '2026-10-15 10:00', '2026-10-15 12:00'),
(6, 3, '2026-10-20 09:00', '2026-10-20 13:00'),
(5, 6, '2026-10-06 00:00', '2026-12-31 00:00');

INSERT INTO Comments(RequestId, AuthorId, Text) VALUES
(1, 1, N'Принято в работу, проверяю картридж'),
(1, 3, N'Спасибо, жду'),
(2, 2, N'Переговорная забронирована'),
(4, 2, N'Вызван специалист по кондиционерам'),
(11,1, N'Нужен список пользователей для VPN');
GO
