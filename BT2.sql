--CÂU 35
CREATE PROCEDURE ChaoTen
    @ten NVARCHAR(50) 
AS
BEGIN
    PRINT N'Xin chào ' + @ten;
END;
GO

--CÂU 36
CREATE PROCEDURE TG(@S1 INT, @S2 INT)
AS
BEGIN
    DECLARE @TG INT;
    SET @TG = @S1 + @S2;
    PRINT N'Tổng là: ' + CAST(@TG AS NVARCHAR(50));
	EXEC TG 2, 3;
END;
GO

--CÂU 37
CREATE PROCEDURE TONG(@S1 INT, @S2 INT, @T INT OUTPUT)
AS
BEGIN
    SET @T = @S1 + @S2;

    PRINT N'Tổng là: ' + CAST(@T AS NVARCHAR(50));
END;
GO

DECLARE @TG INT;
SET @TG = 0;

EXECUTE TONG 2, 3, @TG OUTPUT;

SELECT @TG AS TONG2SO;

GO

--CÂU 38
CREATE PROCEDURE SOMAX(@S1 INT, @S2 INT, @MAX INT OUTPUT)
AS 
BEGIN
	SET @S1 = 20;
	SET @S2  = 30;

	SET @MAX = CASE WHEN @S1 > @S2 THEN @S1 ELSE @S2 END;

PRINT N'Số lớn nhất của : ' + CAST(@S1 AS NVARCHAR(50)) + N' và ' + CAST(@S2 AS NVARCHAR(50)) + N' là ' + CAST(@MAX AS NVARCHAR(50));
END;
GO

--CÂU 39
CREATE PROCEDURE MINVAMAX(@S1 INT, @S2 INT, @MAX INT, @MIN INT) 
AS 
BEGIN
	SET @MAX = CASE WHEN @S1 > @S2 THEN @S1 ELSE @S2 END;
	SET @MIN = CASE WHEN @S1 < @S2 THEN @S1 ELSE @S2 END;
PRINT N'Số lớn nhất của : ' + CAST(@S1 AS NVARCHAR(50)) + N' và ' + CAST(@S2 AS NVARCHAR(50)) + N' là ' + CAST(@MAX AS NVARCHAR(50));
PRINT N'Số nhỏ nhất của : ' + CAST(@S1 AS NVARCHAR(50)) + N' và ' + CAST(@S2 AS NVARCHAR(50)) + N' là ' + CAST(@MIN AS NVARCHAR(50));
END;
GO

--CÂU 40
CREATE PROCEDURE DEMSO
	@N INT 
AS 
BEGIN
	DECLARE @I INT

	SET @I = 1;
	WHILE @I < @N 
	BEGIN 
		PRINT @I;
		SET @I = @I + 1;
	END
EXEC DEMSO @N = 10;
END;
GO

--CÂU 41
CREATE PROCEDURE DEMSOCHAN(@N INT, @I INT, @SUM INT OUTPUT)
AS 
BEGIN
	SET @SUM = 0
	WHILE @I < @N
	BEGIN	
		IF @I % 2 = 0
		BEGIN
			SET @SUM = @SUM + @I;
		END
		PRINT N'Tổng hiện tại : ' + CAST(@SUM AS NVARCHAR(50));
		SET @I = @I + 1;
	END
END;
GO

DECLARE @Total INT;
EXEC DEMSOCHAN @N = 10, @I = 1, @SUM = @Total OUTPUT;
PRINT N'Tổng các số chẵn từ 1 đến 10 là: ' + CAST(@Total AS NVARCHAR(50));
