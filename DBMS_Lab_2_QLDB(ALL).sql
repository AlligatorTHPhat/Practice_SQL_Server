--RULE
-- 23. Tạo quy tắc kiểm tra vị trí cầu thủ
ALTER TABLE CAUTHU
ADD CONSTRAINT CHK_CAUTHU_VITRI CHECK (VITRI IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ'));

-- 24. Tạo quy tắc kiểm tra vai trò huấn luyện viên
ALTER TABLE HLV_CLB
ADD CONSTRAINT CHK_HLV_CLB_VAITRO CHECK (VAITRO IN (N'HLV Chính', N'HLV Phụ', N'HLV Thể lực', N'HLV Thủ môn'));

-- 25. Tạo quy tắc kiểm tra tuổi cầu thủ
ALTER TABLE CAUTHU
ADD CONSTRAINT CHK_CAUTHU_NGAYSINH CHECK (DATEDIFF(YEAR, NGAYSINH, GETDATE()) >= 18);

-- 26. Tạo quy tắc kiểm tra số trái bóng ghi được
ALTER TABLE THAMGIA
ADD CONSTRAINT CHK_THAMGIA_SOTRAI CHECK (SOTRAI > 0);

--VIEW
--27.Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”.
CREATE VIEW VIEW_CAUTHU_BRAZIL AS
SELECT 
    CAUTHU.MACT,
    CAUTHU.HOTEN,
    CAUTHU.NGAYSINH,
    CAUTHU.DIACHI,
    CAUTHU.VITRI
FROM 
    CAUTHU
JOIN 
    CAULACBO ON CAUTHU.MACLB = CAULACBO.MACLB
WHERE 
    CAULACBO.TENCLB = N'SHB ĐÀ NẴNG' AND 
    CAUTHU.MAQG = 'BRA';

--28.Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 3 của mùa bóng năm 2009.
CREATE VIEW VIEW_KETQUA_TRANDAU_VONG3 AS
SELECT 
    TRANDAU.MATRAN,
    TRANDAU.NGAYTD,
    SANVD.TENSAN,
    CAULACBO1.TENCLB AS TENCLB1,
    CAULACBO2.TENCLB AS TENCLB2,
    TRANDAU.KETQUA
FROM 
    TRANDAU
JOIN 
    SANVD ON TRANDAU.MASAN = SANVD.MASAN
JOIN 
    CAULACBO AS CAULACBO1 ON TRANDAU.MACLB1 = CAULACBO1.MACLB
JOIN 
    CAULACBO AS CAULACBO2 ON TRANDAU.MACLB2 = CAULACBO2.MACLB
WHERE 
    TRANDAU.VONG = 3 AND 
    TRANDAU.NAM = 2009;

--29.Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”.
CREATE VIEW VIEW_HLV_VIETNAM AS
SELECT 
    HUANLUYENVIEN.MAHLV,
    HUANLUYENVIEN.TENHLV,
    HUANLUYENVIEN.NGAYSINH,
    HUANLUYENVIEN.DIACHI,
    HLV_CLB.VAITRO,
    CAULACBO.TENCLB
FROM 
    HUANLUYENVIEN
JOIN 
    HLV_CLB ON HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
JOIN 
    CAULACBO ON HLV_CLB.MACLB = CAULACBO.MACLB
WHERE 
    HUANLUYENVIEN.MAQG = 'VN';

--30.Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.
CREATE VIEW VIEW_CLB_NGUOITA AS
SELECT 
    CAULACBO.MACLB,
    CAULACBO.TENCLB,
    SANVD.TENSAN,
    SANVD.DIACHI,
    COUNT(CAUTHU.MAQG) AS SO_CAUTHU_NGUOAI
FROM 
    CAULACBO
JOIN 
    SANVD ON CAULACBO.MASAN = SANVD.MASAN
JOIN 
    CAUTHU ON CAULACBO.MACLB = CAUTHU.MACLB
WHERE 
    CAUTHU.MAQG <> 'VN'  -- Filter for foreign players
GROUP BY 
    CAULACBO.MACLB, 
    CAULACBO.TENCLB, 
    SANVD.TENSAN, 
    SANVD.DIACHI
HAVING 
    COUNT(CAUTHU.MAQG) > 2;  -- More than 2 foreign players

--31.Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý.
CREATE VIEW VIEW_CAUTHU_TIENDAO_BY_TINH AS
SELECT 
    TINH.TENTINH,
    COUNT(CAUTHU.MACT) AS SO_CAUTHU_TIENDAO
FROM 
    TINH
JOIN 
    CAULACBO ON TINH.MATINH = CAULACBO.MATINH
JOIN 
    CAUTHU ON CAULACBO.MACLB = CAUTHU.MACLB
WHERE 
    CAUTHU.VITRI = N'Tiền Đạo'  -- Filter for forwards
GROUP BY 
    TINH.TENTINH;

--32.Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng của vòng 3, năm 2009.
SELECT 
    CLB.TENCLB, 
    T.TENTINH
FROM 
    BANGXH BXH
JOIN 
    CAULACBO CLB ON BXH.MACLB = CLB.MACLB
JOIN 
    TINH T ON CLB.MATINH = T.MATINH
WHERE 
    BXH.NAM = 2009 
    AND BXH.VONG = 3 
    AND BXH.HANG = (
        SELECT MIN(HANG) 
        FROM BANGXH 
        WHERE NAM = 2009 AND VONG = 3
    );

--33.Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại. 
SELECT 
    HLV.TENHLV
FROM 
    HUANLUYENVIEN HLV
JOIN 
    HLV_CLB HLVCLB ON HLV.MAHLV = HLVCLB.MAHLV
WHERE 
    HLV.DIENTHOAI IS NULL;

--PROCEDURE
--35. In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên của bạn.
CREATE PROCEDURE Greeting
    @ten NVARCHAR(100)
AS
BEGIN
    PRINT 'Xin chào ' + @ten;
END;

-- Execute and test the procedure
EXEC Greeting @ten = N'Tên của bạn';

DROP PROCEDURE Greeting;

--a) Cho thực thi và in giá trị của các tham số này để kiểm tra.

--36. Nhập vào 2 số @s1,@s2. In ra câu ‘tổng là : @tg ‘ với @tg =@s1+@s2
CREATE PROCEDURE SumTwoNumbers
    @s1 INT,
    @s2 INT
AS
BEGIN
    DECLARE @tg INT;
    SET @tg = @s1 + @s2;
    PRINT 'Tổng là: ' + CAST(@tg AS NVARCHAR(10));
END;

-- Execute and test the procedure
EXEC SumTwoNumbers @s1 = 5, @s2 = 10;

DROP PROCEDURE SumTwoNumbers;

--37. Nhập vào 2 số @s1,@s2. Xuat tong @s1+@s2 ra tham so @tong.
CREATE PROCEDURE OutputSum
    @s1 INT,
    @s2 INT,
    @tong INT OUTPUT
AS
BEGIN
    SET @tong = @s1 + @s2;
END;

-- Execute and test the procedure
DECLARE @result INT;
EXEC OutputSum @s1 = 5, @s2 = 10, @tong = @result OUTPUT;
PRINT 'Tổng là: ' + CAST(@result AS NVARCHAR(10));

DROP PROCEDURE OutputSum;

--38. Nhập vào 2 số @s1,@s2. In ra câu ‘Số lớn nhất của @s1 và @s2 là max’ với @s1,@s2,max là các giá trị tương ứng.
CREATE PROCEDURE MaxOfTwoNumbers
    @s1 INT,
    @s2 INT
AS
BEGIN
    DECLARE @max INT;
    SET @max = CASE WHEN @s1 > @s2 THEN @s1 ELSE @s2 END;
    PRINT 'Số lớn nhất của ' + CAST(@s1 AS NVARCHAR(10)) + ' và ' + CAST(@s2 AS NVARCHAR(10)) + ' là ' + CAST(@max AS NVARCHAR(10));
END;

-- Execute and test the procedure
EXEC MaxOfTwoNumbers @s1 = 5, @s2 = 10;

DROP PROCEDURE MaxOfTwoNumbers;

--39. Nhập vào 2 số @s1,@s2. Xuất min và max của chúng ra tham so @max. Cho thực thi và in giá trị của các tham số này để kiểm tra.
CREATE PROCEDURE MinMaxOfTwoNumbers
    @s1 INT,
    @s2 INT,
    @min INT OUTPUT,
    @max INT OUTPUT
AS
BEGIN
    SET @min = CASE WHEN @s1 < @s2 THEN @s1 ELSE @s2 END;
    SET @max = CASE WHEN @s1 > @s2 THEN @s1 ELSE @s2 END;
    PRINT 'Số nhỏ nhất là: ' + CAST(@min AS NVARCHAR(10)) + ', Số lớn nhất là: ' + CAST(@max AS NVARCHAR(10));
END;

-- Execute and test the procedure
DECLARE @minResult INT, @maxResult INT;
EXEC MinMaxOfTwoNumbers @s1 = 5, @s2 = 10, @min = @minResult OUTPUT, @max = @maxResult OUTPUT;
PRINT 'Min: ' + CAST(@minResult AS NVARCHAR(10)) + ', Max: ' + CAST(@maxResult AS NVARCHAR(10));

DROP PROCEDURE MinMaxOfTwoNumbers;

--40. Nhập vào số nguyên @n. In ra các số từ 1 đến @n.
CREATE PROCEDURE PrintNumbers
    @n INT
AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @n
    BEGIN
        PRINT @i;
        SET @i = @i + 1;
    END
END;

-- Execute and test the procedure
EXEC PrintNumbers @n = 5;

DROP PROCEDURE PrintNumbers;

--41. Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n
--b) Cho thực thi và in giá trị của các tham số này để kiểm tra.
CREATE PROCEDURE CalculateEvenSumCount
    @n INT
AS
BEGIN
    DECLARE @sum INT = 0;
    DECLARE @count INT = 0;
    
    -- Calculate sum and count of even numbers
    DECLARE @i INT = 1;
    WHILE @i <= @n
    BEGIN
        IF @i % 2 = 0
        BEGIN
            SET @sum = @sum + @i;
            SET @count = @count + 1;
        END
        SET @i = @i + 1;
    END
    
    PRINT 'Tổng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR(10)) + ' là: ' + CAST(@sum AS NVARCHAR(10));
    PRINT 'Số lượng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR(10)) + ' là: ' + CAST(@count AS NVARCHAR(10));
END

DROP PROCEDURE CalculateEvenSumCount;

--42. Cho biết có bao nhiêu trận đấu hòa nhau ở vòng 3 năm 2009.
CREATE PROCEDURE CountDrawMatches
AS
BEGIN
    DECLARE @drawCount INT;

    SELECT @drawCount = COUNT(*)
    FROM TRANDAU
    WHERE VONG = 3 AND NAM = 2009 AND KETQUA LIKE '%-%';

    PRINT 'Số trận đấu hòa ở vòng 3 năm 2009 là: ' + CAST(@drawCount AS NVARCHAR(10));
END

--43. Viết store procedure tương ứng với các câu ở phần View. Sau đó cho thực hiện để kiểm tra kết quả.
CREATE PROCEDURE ViewMatches
AS
BEGIN
    SELECT * FROM TRANDAU;
END
EXEC ViewMatches;

--44. Viết các thủ tục để nhập số liệu cho CSDL trên (các số liệu được thêm vào thông qua tham số thủ tục).
CREATE PROCEDURE InsertPlayer
    @HOTEN NVARCHAR(100),
    @VITRI NVARCHAR(20),
    @NGAYSINH DATETIME,
    @DIACHI NVARCHAR(200),
    @MACLB VARCHAR(5),
    @MAQG VARCHAR(5),
    @SO INT
AS
BEGIN
    INSERT INTO CAUTHU (HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
    VALUES (@HOTEN, @VITRI, @NGAYSINH, @DIACHI, @MACLB, @MAQG, @SO);
END

--45. Nhập vào mã cầu thủ (@MaCT), cho biết thông tin các trận đấu (MaTD, TenTD, NgayTD) mà cầu thủ này đã tham gia.
CREATE PROCEDURE GetPlayerMatches
    @MaCT NUMERIC
AS
BEGIN
    SELECT TRANDAU.MATRAN, TRANDAU.NGAYTD
    FROM TRANDAU
    JOIN THAMGIA ON TRANDAU.MATRAN = THAMGIA.MATD
    WHERE THAMGIA.MACT = @MaCT;
END

--46. Nhập vào mã trận đấu (@MaCT), cho biết danh sách cầu thủ ghi bàn trong trận đấu này.
CREATE PROCEDURE GetScorersByMatch
    @MaTD NUMERIC
AS
BEGIN
    SELECT CAUTHU.HOTEN
    FROM THAMGIA
    JOIN CAUTHU ON THAMGIA.MACT = CAUTHU.MACT
    WHERE THAMGIA.MATD = @MaTD AND THAMGIA.SOTRAI IS NOT NULL; -- Assuming SOTRAI is the number of goals scored
END

--47. Cho biết có tất cả bao nhiêu trận đấu hòa nhau.
CREATE PROCEDURE CountAllDrawMatches
AS
BEGIN
    DECLARE @totalDraws INT;

    SELECT @totalDraws = COUNT(*)
    FROM TRANDAU
    WHERE KETQUA LIKE '%-%';

    PRINT 'Tổng số trận đấu hòa là: ' + CAST(@totalDraws AS NVARCHAR(10));
END

EXEC CalculateEvenSumCount @n = 10; -- For example, to calculate even numbers up to 10
EXEC CountDrawMatches;
EXEC ViewMatches;
EXEC InsertPlayer @HOTEN = N'Nguyễn Văn A', @VITRI = N'Tiền Đạo', @NGAYSINH = '2000-01-01', @DIACHI = N'Đà Nẵng', @MACLB = 'BBD', @MAQG = 'VN', @SO = 9;
EXEC GetPlayerMatches @MaCT = 1;
EXEC GetScorersByMatch @MaTD = 1;
EXEC CountAllDrawMatches;

