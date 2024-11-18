create database vechiledbms;
use vechiledbms;
create table users(
user_id varchar(36) primary key,
user_name varchar(50),
Email varchar(50) unique,
phone_no varchar(14),
address varchar(60),
userpass varchar(255) not null
);

-- truncate users;
-- drop table users;
-- compalint_registeration
create table vehicle(
user_id varchar(36) not null,
owner_name varchar(50),
vehicle_id varchar(36) primary key not null unique,
make varchar(60),
model varchar(60),
make_year year,
vehicle_identification_number varchar(10),
licence_number varchar(20),
foreign key (user_id) references users(user_id) on delete cascade on update cascade
);

-- truncate vehicle;

CREATE TABLE registration_documents (
    registration_id varchar(36) primary key not null,
    vehicle_id varchar(36) not null,
    document_name varchar(50),
    document_number varchar(20) unique,
    expiration_date date,
    foreign  key (vehicle_id) references Vehicle(vehicle_id) on delete cascade on update cascade
);

-- truncate  registration_documents;
-- drop table registration_documents;

create table insurance_documents (
    insurance_id int primary key not null,
    vehicle_id varchar(36) not null,
    policy_number varchar(40),
    expire_date date,
    file_document_path varchar(255),
    docs_status VARCHAR(20),
    upload_date DATE,
	foreign  key (vehicle_id) references Vehicle(vehicle_id) on delete cascade on update cascade
);

-- truncate  insurance_documents;
-- drop table insurance_documents;

CREATE TABLE inspection_documents (
    inspection_id varchar(36) PRIMARY KEY NOT NULL,
    vehicle_id varchar(36) NOT NULL,
    certificate_number VARCHAR(30),
    expiration_date DATE,
    inspection_station VARCHAR(100),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- truncate  inspection_documents;
-- drop table inspection_documents;

CREATE TABLE EmissionDocuments (
    emission_id varchar(36) PRIMARY KEY NOT NULL,
    vehicle_id varchar(36) NOT NULL,
    certificate_number VARCHAR(30),
    issue_date DATE,
    expiration_date DATE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- truncate  EmissionDocuments;

create table Compalint_Registeration(
    vehicle_id varchar(36) not null,
    complaint varchar(500) not null,
    complaint_date datetime,
    file_document_path VARCHAR(255),
    upload_date DATE,
    file_type VARCHAR(10),
    file_size INT,
    resolved boolean default false,
	FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- truncate  Compalint_Registeration;
-- Insert data into the "users" table
-- Add data to the "users" table
INSERT INTO users (user_id, user_name, Email, phone_no, address,userpass)
VALUES
    (1, 'John Doe', 'johndoe@example.com', '555-123-4567', '123 Main St',"abc123"),
    (2, 'Jane Smith', 'janesmith@example.com', '555-987-6543', '456 Elm St',"abc123"),
    (3, 'Bob Johnson', 'bob@example.com', '555-555-5555', '789 Oak St',"abc123"),
    (4, 'Alice Brown', 'alice@example.com', '555-111-2222', '321 Pine St',"abc123"),
    (5, 'Chris Wilson', 'chris@example.com', '555-999-8888', '654 Maple St',"abc123");

-- Add data to the "vehicle" table
INSERT INTO vehicle (user_id, owner_name, vehicle_id, make, model, make_year, vehicle_identification_number, licence_number)
VALUES
    ("1", 'John Doe', "101", 'Toyota', 'Camry', 2019, 'ABC123456', 'XYZ789'),
    ("2", 'Jane Smith',"102", 'Honda', 'Civic', 2020, 'DEF789012', 'UVW987'),
    ("3", 'Bob Johnson', "103", 'Ford', 'F-150', 2018, 'GHI456789', 'LMN123'),
    ("4", 'Alice Brown', "104", 'Chevrolet', 'Malibu', 2017, 'OPQ987654', 'RST456'),
    ("5", 'Chris Wilson', "105", 'Nissan', 'Altima', 2022, 'UVW123456', 'XYZ987');

-- Add data to the "registration_documents" table
INSERT INTO registration_documents (registration_id, vehicle_id, document_number, expiration_date)
VALUES
    ("1", "101", 'REG123', '2023-12-31'),
    ("2", "102", 'REG456', '2023-11-30'),
    ("3", "103", 'REG789', '2023-09-15'),
    ("4", "104", 'REG987', '2023-10-31'),
    ("5", "105", 'REG555', '2023-08-20');

-- Add data to the "insurance_documents" table
INSERT INTO insurance_documents (insurance_id, vehicle_id, policy_number, expire_date, file_document_path, docs_status, upload_date)
VALUES
    ("1", "101", 'POLICY789', '2023-12-31', '/path/to/insurance1.pdf', 'Active', '2023-10-01'),
    ("2", "102", 'POLICY987', '2023-11-30', '/path/to/insurance2.pdf', 'Active', '2023-09-15'),
    ("3", "103", 'POLICY123', '2023-09-30', '/path/to/insurance3.pdf', 'Active', '2023-08-10'),
    ("4", "104", 'POLICY456', '2023-10-15', '/path/to/insurance4.pdf', 'Active', '2023-07-25'),
    ("5", "105", 'POLICY555', '2023-08-31', '/path/to/insurance5.pdf', 'Active', '2023-06-05');

-- Add data to the "inspection_documents" table
INSERT INTO inspection_documents (inspection_id, vehicle_id, certificate_number, expiration_date, inspection_station)
VALUES
    ("1", "101", 'INSPECT123', '2023-12-31', 'ABC Inspection Center'),
    ("2", "102", 'INSPECT456', '2023-11-30', 'XYZ Inspection Services'),
    ("3", "103", 'INSPECT789', '2023-09-15', '123 Inspection Center'),
    ("4", "104", 'INSPECT987', '2023-10-31', '456 Inspection Services'),
    ("5", "105", 'INSPECT555', '2023-08-20', '789 Inspection Center');

-- Add data to the "EmissionDocuments" table
INSERT INTO EmissionDocuments (emission_id, vehicle_id, certificate_number, issue_date, expiration_date)
VALUES
    ("1", "101", 'EMISSION123', '2023-01-15', '2023-12-31'),
    ("2", "102", 'EMISSION456', '2023-02-20', '2023-11-30'),
    ("3", "103", 'EMISSION789', '2023-03-10', '2023-09-15'),
    ("4", "104", 'EMISSION987', '2023-04-25', '2023-10-31'),
    ("5", "105", 'EMISSION555', '2023-05-05', '2023-08-20');

-- Add data to the "Complaint_Registeration" table
INSERT INTO Compalint_Registeration (vehicle_id, complaint, complaint_date, file_document_path, upload_date, file_type, file_size)
VALUES
    ("101", 'The vehicle had a strange noise during the last drive.', '2023-10-20 15:30:00', '/path/to/complaint1.pdf', '2023-10-21', 'PDF', 1024),
    ("102", 'I observed a vibration in the steering wheel.', '2023-09-28 10:15:00', '/path/to/complaint2.pdf', '2023-09-29', 'PDF', 2048),
    ("103", 'The engine is making a knocking sound.', '2023-08-15 11:45:00', '/path/to/complaint3.pdf', '2023-08-16', 'PDF', 1536),
    ("104", 'Brakes need replacement.', '2023-07-30 14:20:00', '/path/to/complaint4.pdf', '2023-07-31', 'PDF', 2560),
    ("105", 'Air conditioning is not working properly.', '2023-06-10 09:00:00', '/path/to/complaint5.pdf', '2023-06-11', 'PDF', 2048);


select *from users;
select *from vehicle;
select *from registration_documents;
select *from insurance_documents;
select *from inspection_documents;
select *from EmissionDocuments;
select *from Compalint_Registeration;