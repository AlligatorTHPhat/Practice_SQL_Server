--RULE
--23
CREATE RULE R_VITRI

AS @VITRI IN ('HLV chính', 'HLV phụ', 'HLV thể lực', 'HLV thủ môn')

SP_BINDRULE 'R_VITRI', 'CAUTHU.VITRI'
-- 23. Kiểm tra vị trí cầu thủ khi thêm cầu thủ mới
CREATE FUNCTION CheckPlayerPosition(@position NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    IF @position IN ('Thủ môn', 'Tiền đạo', 'Tiền vệ', 'Trung vệ', 'Hậu vệ')
        RETURN 1; -- Hợp lệ
    RETURN 0; -- Không hợp lệ
END

-- 24. Kiểm tra vai trò huấn luyện viên
CREATE FUNCTION CheckCoachRole(@role NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    IF @role IN ('HLV chính', 'HLV phụ', 'HLV thể lực', 'HLV thủ môn')
        RETURN 1; -- Hợp lệ
    RETURN 0; -- Không hợp lệ
END

-- 25. Kiểm tra tuổi cầu thủ
CREATE FUNCTION CheckPlayerAge(@birthYear INT)
RETURNS BIT
AS
BEGIN
    IF (YEAR(GETDATE()) - @birthYear) >= 18
        RETURN 1; -- Hợp lệ
    RETURN 0; -- Không hợp lệ
END

-- 26. Kiểm tra số trái bóng ghi được
CREATE FUNCTION CheckGoals(@goals INT)
RETURNS BIT
AS
BEGIN
    IF @goals > 0
        RETURN 1; -- Hợp lệ
    RETURN 0; -- Không hợp lệ
END

--VIEW
-- 27. Thông tin cầu thủ thuộc đội bóng “SHB Đà Nẵng” và quốc tịch “Bra-xin”
USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE
GO

CREATE VIEW VIEW1 AS
SELECT 
		CT.MACT AS MaCauThu,
		CT.HOTEN AS HoTen,
		CT.VITRI AS ViTri,
		CT.NGAYSINH AS NgaySinh,
		CT.DIACHI AS DiaChi
	FROM 
		CAUTHU CT
	INNER JOIN 
		CAULACBO CLB ON CT.MACLB = CLB.MACLB
	WHERE 
		 CLB.TENCLB = N'SHB Đà Nẵng' AND CT.MAQG = 'BRA';
GO

-- 28. Kết quả các trận đấu vòng 3 năm 2009
USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE
GO

CREATE VIEW VIEW2 AS
SELECT 
		TD.MATRAN AS MATRANDAU,
		TD.NGAYTD AS NGAYTHACHDAU,
		TD.MASAN AS TENSANBONG
	FROM 
		TRANDAU TD
	INNER JOIN 
		CAULACBO CLB1 ON TD.MACLB1 = CLB1.MACLB
	INNER JOIN
		CAULACBO CLB2 ON TD.MACLB1 = CLB2.MACLB
	WHERE 
		 TD.VONG = 3 AND TD.NAM = 2009 ;
GO

-- 29. Thông tin huấn luyện viên quốc tịch “Việt Nam”
CREATE VIEW VIEW3 AS
SELECT
	HLV.MAHLV AS MAHLV,
	HLV.TENHLV AS TENHLV,
	HLV.NGAYSINH AS NGAYSINH,
	HLV.DIACHI AS DIACHI,
	HLVCLB.VAITRO 
	FROM
		HUANLUYENVIEN HLV
	INNER JOIN
		HLV_CLB HLVCLB ON HLV.MAHLV = HLVCLB.MAHLV
	INNER JOIN
		CAULACBO CLB ON HLVCLB.MACLB = CLB.MACLB
	WHERE
		HLV.MAQG = N'VN'


-- 30. Thông tin các câu lạc bộ có hơn 2 cầu thủ nước ngoài
CREATE VIEW VIEW4 AS
SELECT 
	CLB.MACLB AS MACLB,
	CLB.TENCLB AS TENCLB,
	CLB.MASAN AS MASAN,
	CLB.MATINH AS MATINH,
	COUNT(CT.MACT) AS SOLUONGCAUTHU
	FROM	
		CAULACBO CLB
	JOIN
		CAUTHU CT ON CT.MACLB = CLB.MACLB
	WHERE
		CT.MAQG <> N'Việt Nam'
	GROUP BY 
		CLB.MaCLB, CLB.TenCLB, CLB.MASAN, CLB.MATINH
	HAVING
		COUNT(CT.MACT) > 2

-- 31. Số lượng cầu thủ tiền đạo theo tỉnh
CREATE VIEW VIEW5 AS
SELECT
	CLB.MATINH AS MATINH,
	COUNT(CT.MACT) AS SLCAUTHU

	FROM
		CAULACBO CLB
	JOIN
		CAUTHU CT ON CT.MACLB = CLB.MACLB
	WHERE
		CT.VITRI = N'Tiền đạo'
	GROUP BY
		CLB.MATINH
	HAVING
		COUNT(CT.MACT) > 1

-- 32. Câu lạc bộ có vị trí cao nhất bảng xếp hạng vòng 3 năm 2009
CREATE VIEW VIEW6 AS
SELECT TOP 1
	CLB.TENCLB,
	CLB.MATINH
	FROM
		CAULACBO CLB
	JOIN
		BANGXH BXH ON BXH.MACLB = CLB.MACLB
	WHERE
		BXH.VONG = 3 AND BXH.NAM = 2009
	ORDER BY
		BXH.MACLB ASC;

-- 33. Tên huấn luyện viên không có số điện thoại
CREATE VIEW VIEW7 AS
SELECT 
	HLV.TENHLV AS TENHLV

	FROM 
		HUANLUYENVIEN HLV
	JOIN 
		HLV_CLB HLVCLB ON HLVCLB.MAHLV = HLV.MAHLV
	WHERE
		HLV.DIENTHOAI = 'NULL' --IS NULL

--STORE PROCEDURE
-- 35. In ra dòng ‘Xin chào’ + @ten
CREATE PROCEDURE
	GREETUSER(@NAME NVARCHAR(50))
AS

BEGIN
	PRINT(N'XIN CHAO ') + @NAME
END

-- 36. Nhập vào 2 số @s1, @s2. In ra tổng
CREATE PROCEDURE 
	SUM1(@S1 INT, @S2 INT) 
AS 

BEGIN 
	DECLARE @TG INT; 
	SET @TG = @S1 + @S2; 

	PRINT N'Tổng là: ' + CAST(@TG AS NVARCHAR);
END; 
	
EXEC SUM1 @S1 = 5, @S2 = 7;	

-- 37. Nhập vào 2 số @s1, @s2. Xuất tổng ra tham số @tong
CREATE PROCEDURE 
	SUM2(@S1 INT, @S2 INT) 
AS 

BEGIN 
	DECLARE @TONG INT; 
	SET @TONG = @S1 + @S2; 

	PRINT CAST(@TONG AS NVARCHAR);
END; 
	
EXEC SUM2 @S1 = 5, @S2 = 7;	

-- 38. Nhập vào 2 số @s1, @s2. In ra số lớn nhất
CREATE PROCEDURE 
	COMPARE1(@S1 INT, @S2 INT)
AS

BEGIN
	DECLARE @MAX INT;

	SET @MAX = CASE WHEN @S1 > @S2 THEN @S1 ELSE @S2 END;

	PRINT N'Số lớn nhất của ' + CAST(@S1 AS NVARCHAR) 
		+ N' và ' + CAST(@S2 AS NVARCHAR) + 
		N' là '+ CAST(@MAX AS NVARCHAR)
END

EXEC COMPARE1 @S1 = 5, @S2 =7;
		
-- 39. Nhập vào 2 số @s1, @s2. Xuất min và max
CREATE PROCEDURE 
	COMPARE2(@S1 INT, @S2 INT)
AS

BEGIN
	DECLARE @MAX INT;
	DECLARE @MIN INT;

	SET @MAX = CASE WHEN @S1 > @S2 THEN @S1 ELSE @S2 END;

	PRINT N'Số lớn nhất của ' + CAST(@S1 AS NVARCHAR) 
		+ N' và ' + CAST(@S2 AS NVARCHAR) + 
		N' là '+ CAST(@MAX AS NVARCHAR)

	SET @MIN = CASE WHEN @S1 < @S2 THEN @S1 ELSE @S2 END;

	PRINT N'Số nhỏ nhất của ' + CAST(@S1 AS NVARCHAR) 
		+ N' và ' + CAST(@S2 AS NVARCHAR) + 
		N' là '+ CAST(@MIN AS NVARCHAR)
END

EXEC COMPARE2 @S1 = 5, @S2 = 7;
-- 40. Nhập vào số nguyên @n. In ra các số từ 1 đến @n.
CREATE PROCEDURE 
	FOR1(@S1 INT)
AS

BEGIN
	DECLARE @I INT = 1;

	WHILE (@I <= @S1)
		BEGIN
			PRINT  @I;
			SET @I = @I + 1;
		END
END
			
EXEC FOR1 @S1 = 5;

-- 41. Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n
CREATE PROCEDURE 
	FOR2(@S1 INT)
AS

BEGIN
	DECLARE @I INT = 1;

	WHILE (@I <= @S1)
		BEGIN
			IF (@I % 2 = 0)
			BEGIN
				PRINT  @I;
			END
			SET @I = @I + 1;
		END
END
			
EXEC FOR2 @S1 = 8;

-- 42. Bao nhiêu trận đấu hòa nhau ở vòng 3 năm 2009
USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE
GO

CREATE PROCEDURE 
	DRAWMATCH
AS

BEGIN
	SELECT CAST(COUNT(*) AS NVARCHAR) AS SOTRANHOA
	FROM TRANDAU 
	WHERE KETQUA = N'Hòa' AND VONG = 3 AND NAM = 2009;

END

USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE
GO

EXEC DRAWMATCH;

--43. Viết store procedure tương ứng với các câu ở phần View. Sau đó cho thực hiện để kiểm tra kết quả.
--A
CREATE PROCEDURE BT2A AS
BEGIN
	SELECT * FROM VIEW1;
END

GO

--B
CREATE PROCEDURE BT2C AS
BEGIN
	SELECT * FROM VIEW3;
END

GO

--C
CREATE PROCEDURE BT2C AS
BEGIN
	SELECT * FROM VIEW3;
END

GO

--D
CREATE PROCEDURE BT2D AS
BEGIN
	SELECT * FROM VIEW4;
END

GO

--E
CREATE PROCEDURE BT2E AS
BEGIN
	SELECT * FROM VIEW5;
END

--F
CREATE PROCEDURE BT2F AS
BEGIN
	SELECT * FROM VIEW6;
END

--H
CREATE PROCEDURE BT2H AS
BEGIN
	SELECT * FROM VIEW7;
END
	
--44. Viết các thủ tục để nhập số liệu cho CSDL trên (các số liệu được thêm vào thông qua tham số thủ tục).
-- Thủ tục thêm quốc gia
CREATE PROCEDURE SP_THEM_QUOCGIA
    @MAQG VARCHAR(5),
    @TENQG NVARCHAR(60)
AS
BEGIN
    INSERT INTO QUOCGIA(MAQG, TENQG)
    VALUES (@MAQG, @TENQG);
END;
GO

-- Thủ tục thêm tỉnh
CREATE PROCEDURE SP_THEM_TINH
    @MATINH VARCHAR(5),
    @TENTINH NVARCHAR(100)
AS
BEGIN
    INSERT INTO TINH(MATINH, TENTINH)
    VALUES (@MATINH, @TENTINH);
END;
GO

-- Thủ tục thêm sân vận động
CREATE PROCEDURE SP_THEM_SANVD
    @MASAN VARCHAR(5),
    @TENSAN NVARCHAR(100),
    @DIACHI NVARCHAR(100)
AS
BEGIN
    INSERT INTO SANVD(MASAN, TENSAN, DIACHI)
    VALUES (@MASAN, @TENSAN, @DIACHI);
END;
GO

-- Thủ tục thêm câu lạc bộ
CREATE PROCEDURE SP_THEM_CAULACBO
    @MACLB VARCHAR(5),
    @TENCLB NVARCHAR(100),
    @MASAN VARCHAR(5),
    @MATINH VARCHAR(5)
AS
BEGIN
    INSERT INTO CAULACBO(MACLB, TENCLB, MASAN, MATINH)
    VALUES (@MACLB, @TENCLB, @MASAN, @MATINH);
END;
GO

-- Thủ tục thêm cầu thủ
CREATE PROCEDURE SP_THEM_CAUTHU
    @HOTEN NVARCHAR(100),
    @VITRI NVARCHAR(20),
    @NGAYSINH DATETIME,
    @DIACHI NVARCHAR(200),
    @MACLB VARCHAR(5),
    @MAQG VARCHAR(5),
    @SO INT
AS
BEGIN
    INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
    VALUES (@HOTEN, @VITRI, @NGAYSINH, @DIACHI, @MACLB, @MAQG, @SO);
END;
GO

-- Thủ tục thêm huấn luyện viên
CREATE PROCEDURE SP_THEM_HUANLUYENVIEN
    @MAHLV VARCHAR(5),
    @TENHLV NVARCHAR(100),
    @NGAYSINH DATETIME,
    @DIACHI NVARCHAR(100),
    @DIENTHOAI NVARCHAR(20),
    @MAQG VARCHAR(5)
AS
BEGIN
    INSERT INTO HUANLUYENVIEN(MAHLV, TENHLV, NGAYSINH, DIACHI, DIENTHOAI, MAQG)
    VALUES (@MAHLV, @TENHLV, @NGAYSINH, @DIACHI, @DIENTHOAI, @MAQG);
END;
GO

-- Thủ tục thêm trận đấu
CREATE PROCEDURE SP_THEM_TRANDAU
    @NAM INT,
    @VONG INT,
    @NGAYTD DATETIME,
    @MACLB1 VARCHAR(5),
    @MACLB2 VARCHAR(5),
    @MASAN VARCHAR(5),
    @KETQUA VARCHAR(5)
AS
BEGIN
    INSERT INTO TRANDAU(NAM, VONG, NGAYTD, MACLB1, MACLB2, MASAN, KETQUA)
    VALUES (@NAM, @VONG, @NGAYTD, @MACLB1, @MACLB2, @MASAN, @KETQUA);
END;
GO

-- Thủ tục thêm tham gia
CREATE PROCEDURE SP_THEM_THAMGIA
    @MATD NUMERIC,
    @MACT NUMERIC,
    @SOTRAI INT
AS
BEGIN
    INSERT INTO THAMGIA(MATD, MACT, SOTRAI)
    VALUES (@MATD, @MACT, @SOTRAI);
END;
GO

EXEC SP_THEM_QUOCGIA 'USA', N'Mỹ';
EXEC SP_THEM_TINH 'HCM', N'Hồ Chí Minh';
EXEC SP_THEM_SANVD 'SV01', N'Sân Mỹ Đình', N'Hà Nội';
EXEC SP_THEM_CAULACBO 'CLB01', N'Hà Nội FC', 'SV01', 'HN';
EXEC SP_THEM_CAUTHU N'Nguyễn Văn A', N'Tiền đạo', '1990-01-01', N'Hà Nội', 'CLB01', 'VN', 10;
EXEC SP_THEM_HUANLUYENVIEN 'HLV01', N'Park Hang-seo', '1959-10-01', N'Hà Nội', '0912345678', 'HQ';
EXEC SP_THEM_TRANDAU 2024, 1, '2024-01-01', 'CLB01', 'CLB02', 'SV01', '1-0';
EXEC SP_THEM_THAMGIA 1, 1, 3;

--45. Nhập vào mã cầu thủ (@MaCT), cho biết thông tin các trận đấu (MaTD, TenTD, NgayTD) mà cầu thủ này đã tham gia.
CREATE PROCEDURE SP_LayThongTinTranDauCauThu
    @MaCT NUMERIC -- Tham số đầu vào: Mã cầu thủ
AS
BEGIN
    -- Bắt đầu một khối xử lý an toàn
    BEGIN TRY
        -- Lấy thông tin trận đấu
        SELECT 
            TD.MATRAN AS MaTD,
            CONCAT('CLB ', CLB1.TENCLB, ' vs ', CLB2.TENCLB) AS TenTD,
            TD.NGAYTD AS NgayTD
        FROM 
            THAMGIA TG
        INNER JOIN TRANDAU TD ON TG.MATD = TD.MATRAN
        INNER JOIN CAULACBO CLB1 ON TD.MACLB1 = CLB1.MACLB
        INNER JOIN CAULACBO CLB2 ON TD.MACLB2 = CLB2.MACLB
        WHERE 
            TG.MACT = @MaCT;
    END TRY
    BEGIN CATCH
        -- Xử lý lỗi (nếu có)
        PRINT 'Đã xảy ra lỗi khi lấy thông tin.';
    END CATCH
END;
GO

EXEC SP_LayThongTinTranDauCauThu @MaCT = 1;

--46. Nhập vào mã trận đấu (@MaCT), cho biết danh sách cầu thủ ghi bàn trong trận đấu này.
CREATE PROCEDURE SP_LayDanhSachCauThuGhiBan
    @MaCT NUMERIC
AS
BEGIN
    -- Lấy danh sách cầu thủ ghi bàn trong trận đấu
    SELECT 
        CT.HOTEN AS TenCauThu,
        CT.VITRI AS ViTri,
        CT.MACLB AS MaCLB,
        CLB.TENCLB AS TenCLB,
        TG.SOTRAI AS SoBanThang
    FROM 
        THAMGIA TG
    INNER JOIN 
        CAUTHU CT ON TG.MACT = CT.MACT
    INNER JOIN 
        CAULACBO CLB ON CT.MACLB = CLB.MACLB
    WHERE 
        TG.MATD = @MaCT AND TG.SOTRAI > 0 -- Chỉ lấy các cầu thủ có số bàn thắng > 0
    ORDER BY 
        TG.SOTRAI DESC; -- Sắp xếp theo số bàn thắng giảm dần
END;
GO
EXEC SP_LayDanhSachCauThuGhiBan @MaCT = 1;

--47. Cho biết có tất cả bao nhiêu trận đấu hòa nhau.
CREATE PROCEDURE SP_COUNT_DRAW_MATCHES
AS
BEGIN
    -- Sử dụng hàm PATINDEX để kiểm tra kết quả có dạng 'x-x'
    SELECT COUNT(*) AS TotalDrawMatches
    FROM TRANDAU
    WHERE KETQUA LIKE '%-%'
          AND LEFT(KETQUA, CHARINDEX('-', KETQUA) - 1) = 
              RIGHT(KETQUA, LEN(KETQUA) - CHARINDEX('-', KETQUA));
END;
GO

EXEC SP_COUNT_DRAW_MATCHES;



--TRIGGER
-- 48. Trigger kiểm tra vị trí cầu thủ khi thêm cầu thủ mới
CREATE TRIGGER TRG_KTRA_VITRI_CAUTHU

ON CAUTHU
AFTER INSERT
AS 
BEGIN
	DECLARE @vitri NVARCHAR(20);
	SELECT @vitri = VITRI FROM INSERTED;
	IF NOT EXISTS (SELECT * FROM (VALUES 
		(N'Thủ Môn'), (N'Tiền Đạo'), (N'Tiền Vệ'), (N'Trung Vệ'), (N'Hậu vệ')) 
			AS POSITIONS(Pos) WHERE Pos = @vitri)
	BEGIN 
		RAISERROR (N'Vị trí cầu thủ không hợp lệ!', 16, 1);
		ROLLBACK TRANSACTION;
	END
END

-- 49. Trigger kiểm tra số áo cầu thủ
CREATE TRIGGER TRG_KTRA_SOAO_CAUTHU

ON CAUTHU
AFTER INSERT

AS

BEGIN
	DECLARE @SOAO INT;
	SELECT @SOAO = SO FROM INSERTED;

	IF EXISTS(SELECT * FROM CAUTHU WHERE SO = @SOAO AND MACLB = (SELECT MACLB FROM INSERTED))
	BEGIN
		RAISERROR('Số áo cầu thủ đã tồn tại!', 16, 1);
		ROLLBACK TRANSACTION;
	END
END


-- 50. Trigger thông báo khi thêm cầu thủ mới
CREATE TRIGGER trg_NotifyNewPlayer
ON CauThu
AFTER INSERT
AS
BEGIN
    PRINT 'Đã thêm cầu thủ mới';
END

-- 51. Trigger kiểm tra số lượng cầu thủ nước ngoài
CREATE TRIGGER trg_CheckForeignPlayers
ON CauThu
AFTER INSERT
AS
BEGIN
    DECLARE @club NVARCHAR(50);
    SELECT @club = CLB FROM inserted;
    DECLARE @foreignCount INT;
    SELECT @foreignCount = COUNT(*) FROM CauThu WHERE QuocTich <> 'Việt Nam' AND CLB = @club;

    IF @foreignCount > 8
    BEGIN
        RAISERROR('Số lượng cầu thủ nước ngoài tối đa là 8!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

-- 52. Trigger kiểm tra tên quốc gia
CREATE TRIGGER trg_CheckUniqueCountryName
ON QuocGia
AFTER INSERT
AS
BEGIN
    DECLARE @countryName NVARCHAR(50);
    SELECT @countryName = TenQuocGia FROM inserted;
    IF EXISTS (SELECT * FROM QuocGia WHERE TenQuocGia = @countryName)
    BEGIN
        RAISERROR('Tên quốc gia đã tồn tại!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

-- 53. Trigger kiểm tra tên tỉnh thành
CREATE TRIGGER trg_CheckUniqueProvinceName
ON TinhThanh
AFTER INSERT
AS
BEGIN
    DECLARE @provinceName NVARCHAR(50);
    SELECT @provinceName = TenTinh FROM inserted;
    IF EXISTS (SELECT * FROM TinhThanh WHERE TenTinh = @provinceName)
    BEGIN
        RAISERROR('Tên tỉnh thành đã tồn tại!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

-- 54. Trigger không cho sửa kết quả trận đấu đã diễn ra
CREATE TRIGGER trg_PreventResultChange
ON TranDau
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @matchDate DATE;
    SELECT @matchDate = NgayTD FROM inserted;

    IF @matchDate < GETDATE()
    BEGIN
        RAISERROR('Không thể sửa kết quả của trận đấu đã diễn ra!', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        UPDATE TranDau SET KETQUA = inserted.KETQUA WHERE MATRAN = inserted.MATRAN;
    END
END

-- 55. Trigger phân công huấn luyện viên
CREATE TRIGGER trg_CheckCoachRole
ON HuanLuyenVien
AFTER INSERT
AS
BEGIN
    DECLARE @role NVARCHAR(50);
    SELECT @role = VaiTro FROM inserted;
    IF NOT EXISTS (SELECT * FROM (VALUES ('HLV chính'), ('HLV phụ'), ('HLV thể lực'), ('HLV thủ môn')) AS Roles(Role) WHERE Role = @role)
    BEGIN
        RAISERROR('Vai trò huấn luyện viên không hợp lệ!', 16, 1);
        ROLLBACK TRANSACTION;
    END

    -- Kiểm tra số lượng HLV chính
    DECLARE @club NVARCHAR(50);
    SELECT @club = CLB FROM inserted;
    DECLARE @headCoachCount INT;
    SELECT @headCoachCount = COUNT(*) FROM HuanLuyenVien WHERE VaiTro = 'HLV chính' AND CLB = @club;

    IF @headCoachCount >= 2
    BEGIN
        RAISERROR('Mỗi câu lạc bộ chỉ có tối đa 2 HLV chính!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

-- 56. Trigger kiểm tra câu lạc bộ trùng tên
CREATE TRIGGER trg_CheckDuplicateClubName
ON CLB
AFTER INSERT
AS
BEGIN
    DECLARE @clubName NVARCHAR(50);
    SELECT @clubName = TenCLB FROM inserted;
    IF EXISTS (SELECT * FROM CLB WHERE TenCLB = @clubName)
    BEGIN
        PRINT 'Câu lạc bộ đã tồn tại, nhưng vẫn cho phép thêm.';
    END
END

-- 57. Trigger sửa tên cầu thủ
CREATE TRIGGER trg_LogPlayerNameChange
ON CauThu
AFTER UPDATE
AS
BEGIN
    DECLARE @playerId INT;
    DECLARE @oldName NVARCHAR(50);
    DECLARE @newName NVARCHAR(50);
    
    SELECT @playerId = MaCT, @oldName = deleted.HoTen, @newName = inserted.HoTen FROM inserted INNER JOIN deleted ON inserted.MaCT = deleted.MaCT;
    
    PRINT 'Vừa sửa thông tin của cầu thủ có mã số ' + CAST(@playerId AS NVARCHAR);
    PRINT 'Mã cầu thủ: ' + CAST(@playerId AS NVARCHAR) + ', Tên cũ: ' + @oldName + ', Tên mới: ' + @newName;
END
