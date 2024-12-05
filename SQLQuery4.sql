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
