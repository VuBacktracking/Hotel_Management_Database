-- Create a function to calculate the total room price
DROP FUNCTION IF EXISTS dbo.Hotel_Restaurant_Management.function_room_price;
CREATE function function_room_price(@booking_id nchar(10))
returns float 
AS
begin
    declare @room_price float;
    Set @room_price = (SELECT b.duration_stay * r.price
                        FROM booking as b 
                        INNER JOIN room as r 
                        ON b.room_booking_id = r.room_id 
                        WHERE booking_id = @booking_id)
    return @room_price
end;

-- Create a function to calculate the total service price
DROP FUNCTION IF EXISTS dbo.Hotel_Restaurant_Management.function_service_price;
CREATE function function_service_price(@booking_id nchar(10))
returns float 
AS
begin
    declare @service_price float; 
    SET @service_price = (SELECT CASE 
                                WHEN (SUM(h.price * s.count)) != 0 then (SUM(h.price * s.count))
                                ELSE 0 END
                    FROM service_used as s
                    INNER JOIn hotel_service as h 
                    ON s.hotel_service_id = h.service_id 
                    WHERE s.service_booking_id = @booking_id)
    return @service_price
end;

-- Create a function to calculate the total meals price
DROP FUNCTION IF EXISTS dbo.Hotel_Restaurant_Management.function_meal_price;
CREATE function function_meal_price(@booking_id nchar(10))
returns float 
AS
begin
    declare @meal_price float;
    SET @meal_price = (SELECT CASE WHEN SUM(md.amount * dn.price)  != 0 THEN SUM(md.amount * dn.price)
                                Else 0 END
                    FROM meal as m 
                    LEFT JOIN meal_detail as md 
                    ON m.meal_id = md.meal_id
                    LEFT JOIN dish_name as dn 
                    ON md.dish_id = dn.dish_id
                    WHERE m.booking_id = @booking_id)
    return @meal_price
end;

-- Tao function cho phep tinh gia tien tong phai tra cua mot ma dat phong
DROP FUNCTION IF EXISTS dbo.Hotel_Restaurant_Management.function_calc_bill;
create function function_calc_bill(@booking_id nchar(10))
returns float 
AS
begin
    declare @total float;
    declare @room_price float;
    declare @service_price float;
    declare @meal_price float;
    SET @room_price = (SELECT dbo.Hotel_Restaurant_Management.function_room_price(@booking_id))
    SET @service_price = (SELECT dbo.Hotel_Restaurant_Management.function_service_price(@booking_id))
    SET @meal_price = (SELECT dbo.Hotel_Restaurant_Management.function_meal_price(@booking_id))
    SET @total = @room_price + @meal_price + @service_price
    return @tongtien
end;

-- Create function to show the table of guests
DROP FUNCTION IF EXISTS dbo.Hotel_Restaurant_Management.Show_guest_to_hotel;
CREATE FUNCTION Show_guest_to_hotel(@hotel_id nchar(20))
returns TABLE 
AS 
    return (SELECT CONCAT(Rtrim(g.last_name), ' ', RTRIM(g.middle_name), ' ', RTRIM(g.first_name)) as full_name,
                    sex, date_of_birth, g.contact_number,b.booking_date, b.duration_stay, h.name as hotel
             FROM guest as g 
             INNER JOIN booking as b
             On g.guest_id = b.guest_booking_id 
             INNER JOIN hotel as h 
             ON b.hotel_booking_id = h.hotel_id
             WHERE b.hotel_booking_id = @hotel_id
            )

-- Create function to show the table of bill
DROP FUNCTION IF EXISTS dbo.Hotel_Restaurant_Management.Show_bill;
CREATE FUNCTION Show_bill(@booking_id nchar(10))
returns Table 
AS 
    return (SELECT CONCAT(Rtrim(g.last_name), ' ', RTRIM(g.middle_name), ' ', RTRIM(g.first_name)) as full_name,
                    sex, date_of_birth, g.contact_number, h.name as hotel, booking_date, duration_stay,
                    dbo.function_calc_bill(@booking_id) as cost
             FROM guest as g 
             INNER JOIN booking as b
             On g.guest_id = b.guest_booking_id 
             INNER JOIN hotel as h 
             ON b.hotel_booking_id = h.hotel_id
             WHERE booking_id =  @booking_id
             )