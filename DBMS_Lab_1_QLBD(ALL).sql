USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE;
GO

--Part 1 : Truy vấn cơ bản
--Câu 1 : Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”:
SELECT CAUTHU.MACT, CAUTHU.HOTEN, CAUTHU.NGAYSINH, CAUTHU.DIACHI, CAUTHU.VITRI
FROM CAUTHU
JOIN CAULACBO ON CAUTHU.MACLB = CAULACBO.MACLB
JOIN QUOCGIA ON CAUTHU.MAQG = QUOCGIA.MAQG
WHERE CAULACBO.TENCLB = N'SHB ĐÀ NẴNG'
AND QUOCGIA.TENQG = N'Brazil';

--Câu 2 : Cho biết tên cầu thủ đã ghi từ 2 bàn thắng trở lên trong một trận đấu:
SELECT CAUTHU.HOTEN
FROM THAMGIA
JOIN CAUTHU ON THAMGIA.MACT = CAUTHU.MACT
WHERE THAMGIA.SOTRAI >= 2;

--Câu 3 : Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu thuộc vòng 3 của mùa bóng năm 2009:
SELECT TRANDAU.MATRAN, TRANDAU.NGAYTD, SANVD.TENSAN, 
       CLB1.TENCLB AS TENCLB1, CLB2.TENCLB AS TENCLB2, TRANDAU.KETQUA
FROM TRANDAU
JOIN SANVD ON TRANDAU.MASAN = SANVD.MASAN
JOIN CAULACBO AS CLB1 ON TRANDAU.MACLB1 = CLB1.MACLB
JOIN CAULACBO AS CLB2 ON TRANDAU.MACLB2 = CLB2.MACLB
WHERE TRANDAU.NAM = 2009 AND TRANDAU.VONG = 3;

--Câu 4 : Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”:
SELECT HUANLUYENVIEN.MAHLV, HUANLUYENVIEN.TENHLV, 
       HUANLUYENVIEN.NGAYSINH, HUANLUYENVIEN.DIACHI, 
       HLV_CLB.VAITRO, CAULACBO.TENCLB
FROM HUANLUYENVIEN
JOIN HLV_CLB ON HUANLUYENVIEN.MAHLV = HLV_CLB.MAHLV
JOIN CAULACBO ON HLV_CLB.MACLB = CAULACBO.MACLB
JOIN QUOCGIA ON HUANLUYENVIEN.MAQG = QUOCGIA.MAQG
WHERE QUOCGIA.TENQG = N'Việt Nam';

--Part 2 : Truy vấn phép toán
--Câu 5 : Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác “Viet Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài.
SELECT CLB.MACLB, CLB.TENCLB, SVD.TENSAN, SVD.DIACHI, COUNT(CT.MACT) AS SoLuongCauThuNuocNgoai
FROM CAULACBO CLB
JOIN SANVD SVD ON CLB.MASAN = SVD.MASAN
JOIN CAUTHU CT ON CLB.MACLB = CT.MACLB
JOIN QUOCGIA QG ON CT.MAQG = QG.MAQG
WHERE QG.TENQG != N'Việt Nam'
GROUP BY CLB.MACLB, CLB.TENCLB, SVD.TENSAN, SVD.DIACHI
HAVING COUNT(CT.MACT) > 2;

--Câu 6 : Số lượng cầu thủ thi đấu ở vị trí tiền đạo tại các câu lạc bộ thuộc tỉnh quản lý:
SELECT TINH.TENTINH, COUNT(CT.MACT) AS SoLuongTienDao
FROM TINH
JOIN CAULACBO CLB ON TINH.MATINH = CLB.MATINH
JOIN CAUTHU CT ON CLB.MACLB = CT.MACLB
WHERE CT.VITRI = N'Tiền Đạo'
GROUP BY TINH.TENTINH;

--Câu 7 : Câu lạc bộ đứng đầu bảng xếp hạng của vòng 3, năm 2009:
SELECT TOP 1 CLB.TENCLB, TINH.TENTINH
FROM BANGXH BXH
JOIN CAULACBO CLB ON BXH.MACLB = CLB.MACLB
JOIN TINH ON CLB.MATINH = TINH.MATINH
WHERE BXH.NAM = 2009 AND BXH.VONG = 3
ORDER BY BXH.HANG ASC;


--Part 3 : Các Toán Tử Nâng Cao
--8. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại.
SELECT HLV.TENHLV 
FROM HUANLUYENVIEN HLV
JOIN HLV_CLB HLVCLB ON HLV.MAHLV = HLVCLB.MAHLV
WHERE HLV.DIENTHOAI IS NULL;

--9. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào.
SELECT HLV.TENHLV 
FROM HUANLUYENVIEN HLV
WHERE MAQG = 'VN' 
  AND MAHLV NOT IN (SELECT MAHLV FROM HLV_CLB);

--10. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3.
SELECT CAUTHU.HOTEN, CAUTHU.MACLB 
FROM CAUTHU
JOIN BANGXH BXH ON CAUTHU.MACLB = BXH.MACLB
WHERE BXH.VONG = 3 
  AND BXH.NAM = 2009 
  AND (BXH.HANG > 6 OR BXH.HANG < 3);

--11. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009.
SELECT TD.NGAYTD, SVD.TENSAN, CLB1.TENCLB AS TENCLB1, CLB2.TENCLB AS TENCLB2, TD.KETQUA
FROM TRANDAU TD
JOIN SANVD SVD ON TD.MASAN = SVD.MASAN
JOIN CAULACBO CLB1 ON TD.MACLB1 = CLB1.MACLB
JOIN CAULACBO CLB2 ON TD.MACLB2 = CLB2.MACLB
WHERE TD.MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH WHERE VONG = 3 AND NAM = 2009 ORDER BY HANG ASC)
   OR TD.MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH WHERE VONG = 3 AND NAM = 2009 ORDER BY HANG ASC);

--Part 4 : Xử lý chuỗi, ngày giờ
--12. Cho biết NGAYSINH, HOTEN, TENCLB của cầu thủ lớn tuổi nhất.
SELECT CT.NGAYSINH, CT.HOTEN, CLB.TENCLB
FROM CAUTHU CT
JOIN CAULACBO CLB ON CT.MACLB = CLB.MACLB
WHERE CT.NGAYSINH = (SELECT MIN(NGAYSINH) FROM CAUTHU);

--13. Cho biết mã số, họ tên, ngày sinh (dd/MM/yyyy) của những cầu thủ có họ lót là “Công”.
SELECT MACT, HOTEN, FORMAT(NGAYSINH, 'dd/MM/yyyy') AS NGAYSINH
FROM CAUTHU
WHERE HOTEN LIKE N'% Công%';

--14. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn”.
SELECT MACT, HOTEN, NGAYSINH
FROM CAUTHU
WHERE HOTEN NOT LIKE N'Nguyễn%';

--15. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35 – 40.
SELECT MAHLV, TENHLV, NGAYSINH, DIACHI
FROM HUANLUYENVIEN
WHERE MAQG = 'VN'
AND DATEDIFF(YEAR, NGAYSINH, GETDATE()) BETWEEN 35 AND 40;

--16. Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 5.
SELECT CLB.TENCLB
FROM HLV_CLB HLC
JOIN HUANLUYENVIEN HLV ON HLC.MAHLV = HLV.MAHLV
JOIN CAULACBO CLB ON HLC.MACLB = CLB.MACLB
WHERE HLV.NGAYSINH = '1972-05-20';


--17. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có số bàn thắng nhiều nhất tính đến hết vòng 3 năm 2009.
SELECT TOP 1 CLB.TENCLB, T.TENTINH
FROM BANGXH BXH
JOIN CAULACBO CLB ON BXH.MACLB = CLB.MACLB
JOIN TINH T ON CLB.MATINH = T.MATINH

--Part 5 : Truy Vấn Con
--18. Mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài
SELECT 
    CL.MACLB, 
    CL.TENCLB, 
    SV.TENSAN, 
    SV.DIACHI, 
    COUNT(A.MAQG) AS SoLuongCauThuNuocNgoai
FROM 
    CAULACBO CL
JOIN 
    SANVD SV ON CL.MASAN = SV.MASAN
JOIN 
    CAUTHU A ON CL.MACLB = A.MACLB
WHERE 
    A.MAQG <> 'VN'
GROUP BY 
    CL.MACLB, CL.TENCLB, SV.TENSAN, SV.DIACHI
HAVING 
    COUNT(A.MAQG) > 2;

--19. Tên câu lạc bộ, tên tỉnh có hiệu số bàn thắng bại cao nhất năm 2009
SELECT 
    CL.TENCLB, 
    T.TENTINH, 
    (SUM(B.THANG) - SUM(B.THUA) * 1.0) AS HieuSo
FROM 
    BANGXH B
JOIN 
    CAULACBO CL ON B.MACLB = CL.MACLB
JOIN 
    TINH T ON CL.MATINH = T.MATINH
WHERE 
    B.NAM = 2009
GROUP BY 
    CL.TENCLB, T.TENTINH
ORDER BY 
    HieuSo DESC
OFFSET 0 ROWS
FETCH NEXT 1 ROWS ONLY;

--20. Danh sách các trận đấu của câu lạc bộ có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
WITH HangThapNhat AS (
    SELECT 
        MACLB
    FROM 
        BANGXH
    WHERE 
        NAM = 2009 AND VONG = 3
    ORDER BY 
        HANG DESC
    OFFSET 0 ROWS
    FETCH NEXT 1 ROWS ONLY
)
SELECT 
    T.NGAYTD, 
    SV.TENSAN, 
    CL1.TENCLB AS TENCLB1, 
    CL2.TENCLB AS TENCLB2, 
    T.KETQUA
FROM 
    TRANDAU T
JOIN 
    CAULACBO CL1 ON T.MACLB1 = CL1.MACLB
JOIN 
    CAULACBO CL2 ON T.MACLB2 = CL2.MACLB
JOIN 
    SANVD SV ON T.MASAN = SV.MASAN
WHERE 
    CL1.MACLB IN (SELECT MACLB FROM HangThapNhat) OR 
    CL2.MACLB IN (SELECT MACLB FROM HangThapNhat);

--21. Mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại
WITH AllClubs AS (
    SELECT DISTINCT MACLB FROM CAULACBO
),
ParticipatedClubs AS (
    SELECT 
        DISTINCT T.MACLB1 AS MACLB FROM TRANDAU T
    UNION
    SELECT 
        DISTINCT T.MACLB2 AS MACLB FROM TRANDAU T
)
SELECT 
    CL.MACLB, 
    CL.TENCLB
FROM 
    CAULACBO CL
WHERE 
    (SELECT COUNT(*) FROM AllClubs) - 1 = 
    (SELECT COUNT(*) FROM ParticipatedClubs WHERE MACLB = CL.MACLB);

--22. Mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (chỉ tính sân nhà)
WITH AllClubs AS (
    SELECT DISTINCT MACLB FROM CAULACBO
),
ParticipatedHomeClubs AS (
    SELECT 
        DISTINCT T.MACLB1 AS MACLB FROM TRANDAU T
)
SELECT 
    CL.MACLB, 
    CL.TENCLB
FROM 
    CAULACBO CL
WHERE 
    (SELECT COUNT(*) FROM AllClubs) - 1 = 
    (SELECT COUNT(*) FROM ParticipatedHomeClubs WHERE MACLB = CL.MACLB);

