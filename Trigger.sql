CREATE TRIGGER InsertBoooking1
ON booking 
FOR INSERT
AS 
BEGIN
    declare @temp int 
    set @temp = (SELECT COUNT(*) FROM inserted 
                WHERE DAY(checkin_date) - DAY(booking_date) > 7)
    if @temp > 0
    begin
        print N'The date of arrival must not exceed 7 days of booking'
        Rollback tran 
    end 
END 

Create TRIGGER InsertGuest 
ON guest 
FOR INSERT
AS 
BEGIN 
    IF EXISTS (SELECT a.contact_number
                FROM guest as a, inserted as b
                WHERE a.guest_id = b.guest_id 
                AND a.contact_number = b.contact_number)
    BEGIN
        print N'Can not add guests due to the same phone number'
        Rollback tran 
    END 
END;
