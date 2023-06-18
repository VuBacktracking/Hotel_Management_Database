-- Create procedure to insert into booking table.
DROP Procedure Proc_InsertBooking IF EXIST;
CREATE procedure Proc_InsertBooking(@booking_id nchar(10), @hotel_booking_id nchar(20), @guest_booking_id nchar(10),
                                @room_booking_id nchar(10), @booking_date DATE, @duration_stay int, @checkin_date date,
                                @checkout_date date, @payment_type nvarchar(20))
AS 
BEGIN
    IF EXISTS (SELECT hotel_id FROM hotel where hotel_id = @hotel_booking_id)
    BEGIN
        IF EXISTS (SELECT room_id FROM room WHERE room_id = @room_booking_id)
        BEGIN
            Insert into booking(booking_id, hotel_booking_id, guest_booking_id, room_booking_id,booking_date, duration_stay, checkin_date, checkout_date, payment_type)
            VALUES (@booking_id, @hotel_booking_id, @guest_booking_id, @room_booking_id, @booking_date, @duration_stay, @checkin_date, @checkout_date, @payment_type)
            print N'Successfully Added'
        END
        ELSE 
            print N'Room ID ' + RTRIM(@room_booking_id) + N' does not exist.'
    END 
    ELSE 
        print N'Hotel ID '+ RTRIM(@hotel_booking_id) + N' does not exist.'
END;

-- Create procedure to update guest table.
DROP Procedure Proc_Updateguest IF EXIST;
CREATE PROCEDURE Proc_Updateguest(@guest_id nchar(10), @contact_number nchar(20))
AS 
BEGIN 
    IF EXISTS (SELECT guest_id FROM guest WHERE guest_id = @guest_id)
    BEGIN 
        update guest SET contact_number = @contact_number WHERE guest_id = @guest_id
        print N'Cập nhật thành công'
    END
    ELSE 
        print N'Không tồn tại mã khách hàng ' + RTRIM(@guesT_id)
        
END;

-- Create procedure to insert into meal detail table
DROP DROP Procedure Proc_InsertMeal_detail IF EXIST;
CREATE Procedure Proc_InsertMeal_detail(@meal_id nchar(10), @dish_id nchar(10), @amount int)
AS 
BEGIN
    IF EXISTS (SELECT meal_id FROM meal WHERE meal_id = @meal_id)
    BEGIN
        IF EXISTS (SELECT dish_id FROM dish_name WHERE dish_id = @dish_id)
        BEGIN
            INSERT INTO meal_detail(meal_id, dish_id, amount)
            VALUES  (@meal_id, @dish_id, @amount)
            print N'Thêm vào thành công'
        END  
        ELSE 
            print N'Mã món ăn ' + RTRIM(@dish_id) + N' không tồn tại hoặc chưa được ghi nhận.'
    END 
    ELSE 
        print N'Mã bữa ăn ' + RTRIM(@meal_id) + N' chưa được ghi nhận'
END;