﻿--CÂU 1
USE [dbXe]
GO

CREATE PROCEDURE CAU1 
	@LOAIGPLX NVARCHAR(50)
AS
	
BEGIN 
	DECLARE @MABANGLAI NVARCHAR(4)
	DECLARE @NGAYCAP DATE
	DECLARE @MATAIXE NVARCHAR(4)
	DECLARE @HOTENTAIXE NVARCHAR(50)
	DECLARE @NGAYSINH DATE
	DECLARE @DIACHI NVARCHAR(100)
	
	 DECLARE CUR_CAU1 CURSOR FOR
    SELECT 
        BL.MABANGLAI, BL.MATAIXE, BL.NGAYCAP, 
			TX.HOTENTAIXE, TX.NGAYSINH, TX.DIACHI
    FROM 
        BANGLAI BL
    JOIN 
        TAIXE TX ON BL.MATAIXE = TX.MATAIXE
    WHERE 
        BL.LOAIGPLX = @LOAIGPLX AND YEAR(BL.NGAYCAP) = 2024

    OPEN CUR_CAU1

    FETCH NEXT FROM CUR_CAU1 INTO @MABANGLAI, @MATAIXE, @NGAYCAP, @HOTENTAIXE, @NGAYSINH, @DIACHI

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT N'Mã Bằng Lái: ' + @MABANGLAI + N', Mã Tài Xế: ' + @MATAIXE + 
              N', Ngày Cấp: ' + CONVERT(VARCHAR, @NGAYCAP, 103) +
              N', Họ Tên: ' + @HOTENTAIXE + 
              N', Ngày Sinh: ' + CONVERT(VARCHAR, @NGAYSINH, 103) +
              N', Địa Chỉ: ' + @DIACHI

        FETCH NEXT FROM CUR_CAU1 INTO @MABANGLAI, @MATAIXE, @NGAYCAP, @HOTENTAIXE, @NGAYSINH, @DIACHI
    END

    CLOSE CUR_CAU1
    DEALLOCATE CUR_CAU1
END
GO

--CÂU 2
USE [dbXe]
GO

CREATE TRIGGER TRG_CAU2
ON BANGLAI

AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM BANGLAI BL
        INNER JOIN INSERTED I ON BL.MABANGLAI = I.MaBangLai
        INNER JOIN TAIXE TX ON BL.MATAIXE = TX.MATAIXE
        WHERE (YEAR(I.NGAYCAP) - YEAR(TX.NGAYSINH)) <= 20
    )
    BEGIN
        RAISERROR (N'Không hợp lệ! Tài xế phải trên 20 tuổi tại thời điểm cấp bằng lái!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

--CÂU 3
USE [dbXe]
GO

ALTER TABLE TAIXE
ADD SOBANGLAI INT DEFAULT 0;
GO


USE [dbXe]
GO

CREATE TRIGGER TRG_CAU3
ON BANGLAI
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM INSERTED)
    BEGIN
        UPDATE TAIXE
        SET SOBANGLAI = (
            SELECT COUNT(*)
            FROM BANGLAI BL
            WHERE BL.MATAIXE = TAIXE.MATAIXE
        )
        WHERE MATAIXE IN (SELECT MATAIXE FROM INSERTED);
    END

    IF EXISTS (SELECT 1 FROM DELETED)
    BEGIN
        UPDATE TAIXE
        SET SOBANGLAI = (
            SELECT COUNT(*)
            FROM BANGLAI BL
            WHERE BL.MATAIXE = TAIXE.MATAIXE
        )
        WHERE MATAIXE IN (SELECT MATAIXE FROM DELETED);
    END
END;
GO
