CREATE FUNCTION FN_DECIMAL_TO_BINARY (@IncomingNumber int)
RETURNS varchar(200)
as
BEGIN

        DECLARE @BinNumber        VARCHAR(200)
        SET @BinNumber = ''

        WHILE @IncomingNumber <> 0
        BEGIN
                SET @BinNumber = SUBSTRING('0123456789', (@IncomingNumber % 2) + 1, 1) + @BinNumber
                SET @IncomingNumber = @IncomingNumber / 2
        END

        RETURN @BinNumber

END 