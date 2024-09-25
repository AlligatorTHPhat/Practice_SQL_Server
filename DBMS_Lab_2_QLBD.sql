--RULE
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
CREATE VIEW PlayerInfo AS
SELECT MaCT, HoTen, NgaySinh, DiaChi, ViTri
FROM CauThu
WHERE CLB = 'SHB Đà Nẵng' AND QuocTich = 'Bra-xin';

-- 28. Kết quả các trận đấu vòng 3 năm 2009
CREATE VIEW MatchResults AS
SELECT MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA
FROM TranDau
WHERE Vong = 3 AND Nam = 2009;

-- 29. Thông tin huấn luyện viên quốc tịch “Việt Nam”
CREATE VIEW CoachInfo AS
SELECT MaHLV, HoTen, NgaySinh, DiaChi, VaiTro, CLB
FROM HuanLuyenVien
WHERE QuocTich = 'Việt Nam';

-- 30. Thông tin các câu lạc bộ có hơn 2 cầu thủ nước ngoài
CREATE VIEW ClubWithForeignPlayers AS
SELECT MaCLB, TenCLB, TenSV, DiaChi, COUNT(*) AS SoLuongCauThuNuocNgoai
FROM CauThu
WHERE QuocTich <> 'Việt Nam'
GROUP BY MaCLB, TenCLB, TenSV, DiaChi
HAVING COUNT(*) > 2;

-- 31. Số lượng cầu thủ tiền đạo theo tỉnh
CREATE VIEW StrikerCountByProvince AS
SELECT TenTinh, COUNT(*) AS SoLuongTienDao
FROM CauThu
WHERE ViTri = 'Tiền đạo'
GROUP BY TenTinh;

-- 32. Câu lạc bộ có vị trí cao nhất bảng xếp hạng vòng 3 năm 2009
CREATE VIEW TopClub AS
SELECT TenCLB, TenTinh
FROM CLB
WHERE Vong = 3 AND Nam = 2009
ORDER BY ViTri DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

-- 33. Tên huấn luyện viên không có số điện thoại
CREATE VIEW CoachesWithoutPhone AS
SELECT HoTen
FROM HuanLuyenVien
WHERE SoDienThoai IS NULL;

--STORE PROCEDURE
-- 35. In ra dòng ‘Xin chào’ + @ten
CREATE PROCEDURE GreetUser(@ten NVARCHAR(50))
AS
BEGIN
    PRINT 'Xin chào ' + @ten;
END

-- 36. Nhập vào 2 số @s1, @s2. In ra tổng
CREATE PROCEDURE SumTwoNumbers(@s1 INT, @s2 INT)
AS
BEGIN
    DECLARE @tg INT;
    SET @tg = @s1 + @s2;
    PRINT 'Tổng là: ' + CAST(@tg AS NVARCHAR);
END

-- 37. Nhập vào 2 số @s1, @s2. Xuất tổng ra tham số @tong
CREATE PROCEDURE OutputSum(@s1 INT, @s2 INT, @tong INT OUTPUT)
AS
BEGIN
    SET @tong = @s1 + @s2;
END

-- 38. Nhập vào 2 số @s1, @s2. In ra số lớn nhất
CREATE PROCEDURE MaxOfTwo(@s1 INT, @s2 INT)
AS
BEGIN
    DECLARE @max INT;
    SET @max = CASE WHEN @s1 > @s2 THEN @s1 ELSE @s2 END;
    PRINT 'Số lớn nhất của ' + CAST(@s1 AS NVARCHAR) + ' và ' + CAST(@s2 AS NVARCHAR) + ' là ' + CAST(@max AS NVARCHAR);
END

-- 39. Nhập vào 2 số @s1, @s2. Xuất min và max
CREATE PROCEDURE MinMaxOfTwo(@s1 INT, @s2 INT, @min INT OUTPUT, @max INT OUTPUT)
AS
BEGIN
    SET @min = CASE WHEN @s1 < @s2 THEN @s1 ELSE @s2 END;
    SET @max = CASE WHEN @s1 > @s2 THEN @s1 ELSE @s2 END;
END

-- 40. Nhập vào số nguyên @n. In ra các số từ 1 đến @n.
CREATE PROCEDURE PrintNumbers(@n INT)
AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @n
    BEGIN
        PRINT @i;
        SET @i = @i + 1;
    END
END

-- 41. Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n
CREATE PROCEDURE CountEvenNumbers(@n INT, @tong INT OUTPUT, @count INT OUTPUT)
AS
BEGIN
    DECLARE @i INT = 1;
    SET @tong = 0;
    SET @count = 0;
    
    WHILE @i <= @n
    BEGIN
        IF @i % 2 = 0
        BEGIN
            SET @tong = @tong + @i;
            SET @count = @count + 1;
        END
        SET @i = @i + 1;
    END
END

-- 42. Bao nhiêu trận đấu hòa nhau ở vòng 3 năm 2009
CREATE PROCEDURE CountDrawMatches
AS
BEGIN
    SELECT COUNT(*) AS SoTranHoa
    FROM TRANDAU
    WHERE KETQUA = 'Hòa' AND Vong = 3 AND Nam = 2009;
END


--TRIGGER
-- 48. Trigger kiểm tra vị trí cầu thủ khi thêm cầu thủ mới
CREATE TRIGGER trg_CheckPlayerPosition
ON CauThu
AFTER INSERT
AS
BEGIN
    DECLARE @position NVARCHAR(50);
    SELECT @position = ViTri FROM inserted;
    IF NOT EXISTS (SELECT * FROM (VALUES ('Thủ môn'), ('Tiền đạo'), ('Tiền vệ'), ('Trung vệ'), ('Hậu vệ')) AS Positions(Pos) WHERE Pos = @position)
    BEGIN
        RAISERROR('Vị trí cầu thủ không hợp lệ!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END

-- 49. Trigger kiểm tra số áo cầu thủ
CREATE TRIGGER trg_CheckUniqueJerseyNumber
ON CauThu
AFTER INSERT
AS
BEGIN
    DECLARE @jerseyNumber INT;
    SELECT @jerseyNumber = SoAo FROM inserted;
    IF EXISTS (SELECT * FROM CauThu WHERE SoAo = @jerseyNumber AND CLB = (SELECT CLB FROM inserted))
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
