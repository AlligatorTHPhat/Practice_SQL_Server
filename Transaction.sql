USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- Thêm cầu thủ mới vào bảng CAUTHU
    INSERT INTO CAUTHU (HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
    VALUES (N'Nguyễn Minh Tùng', N'Tiền Đạo', '1995-08-10', N'123 Đường ABC, TP.HCM', 'BBD', 'VN', 11);

    -- Tính toán số lượng cầu thủ trong câu lạc bộ BBD
    DECLARE @SLCAUTHU INT;
    SELECT @SLCAUTHU = COUNT(*) 
    FROM CAUTHU
    WHERE MACLB = 'BBD';

    -- Nếu câu lạc bộ chưa tồn tại trong bảng CAULACBO, thêm câu lạc bộ mới với số lượng là 1
    IF NOT EXISTS (SELECT 1 FROM CAULACBO WHERE MACLB = 'BBD')
    BEGIN
        INSERT INTO CAULACBO (MACLB, SL_THANHVIEN)
        VALUES ('BBD', @SLCAUTHU);
    END
    ELSE
    BEGIN
        -- Cập nhật số lượng thành viên trong câu lạc bộ BBD
        UPDATE CAULACBO
        SET SL_THANHVIEN = @SLCAUTHU
        WHERE MACLB = 'BBD';
    END

    -- Tính toán số lượng cầu thủ theo quốc gia VN
    DECLARE @SLCAUTHU_VN INT;
    SELECT @SLCAUTHU_VN = COUNT(*) 
    FROM CAUTHU
    WHERE MAQG = 'VN';

    -- Cập nhật số lượng cầu thủ quốc gia VN trong bảng QUOCGIA
    UPDATE QUOCGIA
    SET SL_CAUTHU = @SLCAUTHU_VN
    WHERE MAQG = 'VN';

    -- Commit transaction nếu không có lỗi
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Rollback transaction nếu có lỗi và thông báo lỗi
    ROLLBACK TRANSACTION;
    RAISERROR('Lỗi trong quá trình thực hiện giao dịch!', 16, 1);
END CATCH;
