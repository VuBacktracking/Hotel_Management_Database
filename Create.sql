Create database Hotel_Restaurant_Management;
USe Hotel_Restaurant_Management;

/*Create table head_office (
    headoffice_id nchar(20) primary key not null,
    name nvarchar(50), 
    contact_number nchar(10),
    emailaddress nvarchar(30),
    address nvarchar(100)
)*/
-- Tạo bảng adress
CREATE table address(
    address_id nchar(10) primary key not null,
    city nvarchar(20),
    district nvarchar(20),
    ward nvarchar(20),
    street nvarchar(20)
)
Create table hotel (
    -- head_office_id nchar(20),
    hotel_id nchar(20) primary key not null,
    address_hotel_id nchar(10),
    name nvarchar(100),
    contact_number nchar(10),
    floor_count int,
    room_count int,
    email nvarchar(30),
    star_rating nchar(10),
    open_time time,
    close_time time,
    -- foreign key (head_office_id) references head_office (headoffice_id),
    foreign key (address_hotel_id) references address (address_id)
)
/*Alter table hotels 
Add CONSTRAINT fk_star_rating foreign key (star_rating) references star_rating(star_point);*/

CREATE table department (
    department_id nchar(10) primary key not null,
    name_depart nvarchar(20),
    description nvarchar(50)
)
Create table employee (
    employee_id nchar(10)not null,
    emp_hotel_id nchar(20) not null,
    last_name nvarchar(20),
    middle_name nvarchar(20),
    first_name nvarchar(20),
    date_ob Date,
    sex nvarchar(5),
    contact_num nchar(10),
    emp_department_id nchar(10),
    Constraint PK_employee PRIMARY KEY (employee_id, emp_hotel_id),
    foreign key  (emp_hotel_id) REFERENCES hotel(hotel_id),
    foreign key (emp_department_id) references department(department_id)
)

Create TABLE room (
    room_id nchar(10) primary key not null,
    hotel_id nchar(20) not null,
    room_number int not null,
    room_type_id nchar(10),
    price float,
    
    -- Constraint PK_room PRIMARY KEY (room_id, hotel_id),
    foreign key (hotel_id) references hotel(hotel_id)
)
Alter table room
ALter COLUMN room_number nvarchar(5);

Create table room_type (
    room_type_id nchar(10) primary key not null,
    name nvarchar(50),
    capacity int,
)
Alter table room
Add constraint fk_room_type foreign key (room_type_id) references room_type(room_type_id);

Create table guest(
    guest_id nchar(10) primary key not NULL,
    last_name nvarchar(20),
    middle_name nvarchar(20),
    first_name nvarchar(20),
    date_of_birth Date,
    sex nvarchar(5),
    contact_number nchar(10)
)
/*create table guests_to_hotel(
    id nchar primary key not null,
    guest_id nchar(10),
    hotel_id nchar(20),
)
Alter table guests_to_hotel 
Add CONSTRAINT fk_guest_id_to_hotel foreign key (guest_id) references guests(guest_id);
Alter table guests_to_hotel 
Add CONSTRAINT fk_hotel_id_guest foreign key (hotel_id) references hotels(hotel_id);*/

Create table booking (
    booking_id nchar(10) primary key not null,
    hotel_booking_id nchar(20) not null,
    guest_booking_id nchar(10) not null,
    room_booking_id nchar(10),
    booking_date Date,
    duration_stay int,
    checkin_date Date,
    checkout_date Date,
    payment_type nvarchar(20),
    -- Constraint pk_booking primary key (booking_id, hotel_booking_id, guest_booking_id),
    foreign key (guest_booking_id) references guest(guest_id),
    foreign key (hotel_booking_id) REFERENCES hotel(hotel_id),
    foreign key (room_booking_id) REFERENCES room(room_id)
)
/*
create TABLE room_booked (
    room_booked_id nchar(20) not NULL,
    booking_id nchar(10) not null,
    room_id nchar(10),
    Constraint PK_room_booked PRIMARY KEY (room_booked_id, booking_id, room_id),
    foreign key (room_id) references room(room_id),
    foreign key (booking_id) references booking(booking_id)
)
*/
create TABLE hotel_service (
    service_id nchar(10) primary key not null,
    hotel_id nchar(20) not null,
    service_name nvarchar(20),
    price float,
    description nvarchar(100),

    foreign key (hotel_id) references hotel(hotel_id)
)
create table service_used(
    service_used_id nchar(10) not null,
    hotel_service_id nchar(10) not null,
    service_booking_id nchar(10) not null,
    count int,

    Constraint PK_services_use Primary key (service_used_id, hotel_service_id, service_booking_id),
    foreign key (hotel_service_id) references hotel_service(service_id),
    foreign key (service_booking_id) references booking (booking_id)
)

Create Table restaurant(
    res_id nchar(10) primary key not null,
    hotel_id nchar(20) not null,
    name nvarchar(50),
    contact nchar(10),

    foreign key (hotel_id) references hotel(hotel_id)
)
Alter table restaurant
ALter COLUMN contact nvarchar(50);

create table menu(
    menu_id nchar(20) primary key not null,
    res_id nchar(10) not null,
    name nvarchar(50),
    foreign key (res_id) REFERENCES restaurant(res_id)
)
Create table dish_name(
    dish_id nchar(10) primary key not null,
    menu_id nchar(20) not null,
    dish_name nvarchar(50),
    price float,
    description nvarchar(100),

    foreign key (menu_id) REFERENCES menu(menu_id)
)
create table meal(
    meal_id nchar(10) primary key not null,
    booking_id nchar(10),
    menu_id nchar(20),
    time nvarchar(10),

    foreign key (booking_id) references booking(booking_id),
    foreign key (menu_id) references menu(menu_id)
)
CREATE Table meal_detail(
    meal_id nchar(10) not null,
    dish_id nchar(10) not null,
    amount int,

    Constraint PK_meal_detail Primary Key(meal_id, dish_id),
    foreign key (meal_id) references meal(meal_id),
    foreign key (dish_id) references dish_name(dish_id) 
)

create table waiter(
    waiter_id nvarchar(20) primary key not null,
    res_id nchar(10) not null,
    lname nvarchar(100),
    mname nvarchar(100),
    fname nvarchar(100),
    dob date,
    sex nvarchar(5),

    Foreign Key (res_id) REFERENCES restaurant(res_id)
)
Alter table waiter
ALTER COLUMN waiter_id nvarchar(20);

create table serve(
    waiter_id nvarchar(20) not null,
    meal_id nchar(10) not null,

    Constraint PK_serve PRIMARY KEY (waiter_id, meal_id),
    foreign key (waiter_id) references waiter(waiter_id),
    foreign key (meal_id) references meal(meal_id)
)
Alter table serve
ALTER COLUMN waiter_id nvarchar(20);
Use master;
DROP database Hotel_Restaurant_Management;