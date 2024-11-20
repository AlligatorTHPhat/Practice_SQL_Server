
-- Tạo Cơ Sở Dữ Liệu
CREATE DATABASE QUAN_LY_GIAI_BONG_DA_V_LEAGUE;
GO

USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE;
GO

-- Tạo Bảng
CREATE TABLE QUOCGIA (
    MAQG VARCHAR(5) CONSTRAINT QG_MAQG PRIMARY KEY NOT NULL,

    TENQG NVARCHAR(60) NOT NULL
);

CREATE TABLE TINH (
    MATINH VARCHAR(5) CONSTRAINT TINH_MATINH PRIMARY KEY NOT NULL,
    TENTINH NVARCHAR(100) NOT NULL
);

CREATE TABLE SANVD (
    MASAN VARCHAR(5) CONSTRAINT SAN_MASAN PRIMARY KEY NOT NULL,
    TENSAN NVARCHAR(100) NOT NULL,
    DIACHI NVARCHAR(100)
);

CREATE TABLE CAULACBO (
    MACLB VARCHAR(5) CONSTRAINT CLB_MACLB PRIMARY KEY NOT NULL,
    TENCLB NVARCHAR(100) NOT NULL,
    MASAN VARCHAR(5) NOT NULL CONSTRAINT FK_CLB_MASAN FOREIGN KEY REFERENCES SANVD(MASAN),
    MATINH VARCHAR(5) NOT NULL CONSTRAINT FK_CLB_MATINH FOREIGN KEY REFERENCES TINH(MATINH)
);

CREATE TABLE CAUTHU (
    MACT NUMERIC IDENTITY(1,1) CONSTRAINT PK_CAUTHU_MACT PRIMARY KEY NOT NULL,
    HOTEN NVARCHAR(100) NOT NULL,
    VITRI NVARCHAR(20) NOT NULL,
    NGAYSINH DATETIME,
    DIACHI NVARCHAR(200),
    MACLB VARCHAR(5) NOT NULL CONSTRAINT FK_CAUTHU_MACLB FOREIGN KEY REFERENCES CAULACBO(MACLB),
    MAQG VARCHAR(5) NOT NULL CONSTRAINT FK_CAUTHU_MAQG FOREIGN KEY REFERENCES QUOCGIA(MAQG),
    SO INT NOT NULL
);

CREATE TABLE HUANLUYENVIEN (
    MAHLV VARCHAR(5) CONSTRAINT PK_HLV_MAHLV PRIMARY KEY NOT NULL,
    TENHLV NVARCHAR(100) NOT NULL,
    NGAYSINH DATETIME,
    DIACHI NVARCHAR(100),
    DIENTHOAI NVARCHAR(20),
    MAQG VARCHAR(5) NOT NULL CONSTRAINT FK_HLV_MAQG FOREIGN KEY REFERENCES QUOCGIA(MAQG)
);

CREATE TABLE HLV_CLB (
    MAHLV VARCHAR(5) CONSTRAINT FK_HLV_CLB_MAHLV FOREIGN KEY REFERENCES HUANLUYENVIEN(MAHLV),
    MACLB VARCHAR(5) CONSTRAINT FK_HLV_CLB_MACLB FOREIGN KEY REFERENCES CAULACBO(MACLB),
    VAITRO NVARCHAR(100) NOT NULL,
    PRIMARY KEY (MAHLV, MACLB)
);

CREATE TABLE TRANDAU (
    MATRAN NUMERIC IDENTITY(1,1) CONSTRAINT PK_TRANDAU_MATRAN PRIMARY KEY NOT NULL,
    NAM INT NOT NULL,
    VONG INT NOT NULL,
    NGAYTD DATETIME NOT NULL,
    MACLB1 VARCHAR(5) NOT NULL CONSTRAINT FK_TRANDAU_MACLB1 FOREIGN KEY REFERENCES CAULACBO(MACLB),
    MACLB2 VARCHAR(5) NOT NULL CONSTRAINT FK_TRANDAU_MACLB2 FOREIGN KEY REFERENCES CAULACBO(MACLB),
    MASAN VARCHAR(5) NOT NULL CONSTRAINT FK_TRANDAU_MASAN FOREIGN KEY REFERENCES SANVD(MASAN),
    KETQUA VARCHAR(5) NOT NULL 
);

CREATE TABLE BANGXH (
    MACLB VARCHAR(5) NOT NULL CONSTRAINT FK_BXH_MACLB FOREIGN KEY REFERENCES CAULACBO(MACLB),
    NAM INT NOT NULL, 
    VONG INT NOT NULL,     
    SOTRAN INT NOT NULL, 
    THANG INT NOT NULL,
    HOA INT NOT NULL, 
    THUA INT NOT NULL,
    HIEUSO VARCHAR(5) NOT NULL, 
    DIEM INT NOT NULL, 
    HANG INT NOT NULL,
    PRIMARY KEY(MACLB, NAM, VONG)
);

CREATE TABLE THAMGIA (
    MATD NUMERIC NOT NULL CONSTRAINT FK_THAMGIA_MATD FOREIGN KEY REFERENCES TRANDAU(MATRAN),
    MACT NUMERIC NOT NULL CONSTRAINT FK_THAMGIA_MACT FOREIGN KEY REFERENCES CAUTHU(MACT), 
    SOTRAI INT,
    PRIMARY KEY (MATD, MACT)
);

-- Nhập thông tin
USE QUAN_LY_GIAI_BONG_DA_V_LEAGUE;
GO

INSERT INTO QUOCGIA(MAQG, TENQG)
VALUES 
	('ANH', N'Anh Quốc'),
	('BDN', N'Bồ Đào Nha'),
	('BRA', N'Brazil'),
	('HQ', N'Hàn Quốc'),
	('ITA', N'Ý'),
	('TBN', N'Tây Ban Nha'),
	('THA', N'Thái Lan'),
	('THAI', N'Thái Lan'),
	(N'VN', N'Việt Nam');

INSERT INTO TINH(MATINH, TENTINH)
VALUES
	('BD', N'Bình Dương'),
	('DN', N'Đà Nẵng'),
	('DT', N'Đồng Tháp'),
	('GL', N'Gia Lai'),	
	('HN', N'Hà Nội'),
	('HP', N'Hải Phòng'),
	('KH', N'Khánh Hòa'),
	('LA', N'Long An'),
	('NA', N'Nghệ An'),
	('NB', N'Ninh Bình'),
	('PY', N'Phú Yên'),
	('SG', N'Sài Gòn'),
	('TH', N'Thanh Hóa');

INSERT INTO SANVD(MASAN, TENSAN, DIACHI)
VALUES
	('CL',N'Chi Lăng', N'127 Võ Văn Trần, Đà Nẵng'),
	('CLDT', N'Cao Lãnh', N'134 TX Cao Lãnh, Đồng Tháp'),
	('GD', N'Gò Đậu', N'123 QL1, TX Thủ Dầu Một, Bình Dương'),
	('HD', N'Hàng Đẫy', N'345 Lý Chiêu Hoàng, Bạch Mai, Hà Nội'),
	('LA', N'Long An', N'102 Hùng Vương, Tp Tân An, Long An'),
	('NT', N'Nha Trang', N'128 Phan Chu Trinh, Nha Trang, Khánh Hòa'),
	('PL', N'Pleiku', N'22 Hồ Tùng Mậu, Thống Nhất, Thị Xã Pleiku, Gia Lai'),
	('TH', N'Tuy Hòa', N'57 Trường Chinh, Tuy Hòa, Phú Yên'),
	('TN', N'Thống Nhất', N'123 Lý Thường Kiệt, Quận 5, TpHCM');

INSERT INTO CAULACBO(MACLB, TENCLB, MASAN, MATINH)
VALUES	
	('BBD', N'BECAMEX BÌNH DƯƠNG', 'GD' , 'BD'),
	('CSDT', N'TẬP ĐOÀN CAO SU ĐỒNG THÁP', 'CLDT' , 'DT'),
	('GDT', N'GẠCH ĐỒNG T M LONG AN', 'LA' , 'LA'),
	('HAGL', N'HOÀNG ANH GIA LAI', 'PL' , 'GL'),
	('KKH', N'KHATOCO KHÁNH HÒA', 'NT' , 'KH'),
	('SDN', N'SHB ĐÀ NẴNG', 'CL' , 'DN'),
	('TPY', N'THÉP PHÚ YÊN', 'TH' , 'PY');

SET IDENTITY_INSERT CAUTHU ON;
INSERT INTO CAUTHU (MACT, HOTEN, VITRI, NGAYSINH, MACLB, MAQG, SO)
VALUES 
	('1', N'Nguyễn Vũ Phong', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'BBD', 'VN', '17'),
	('2', N'Nguyễn Công Vinh', N'Tiền Đạo', '2016-10-23 00:00:00.000', 'HAGL', 'VN', '9'),
	('3', 'Nguyễn Hồng Sơn', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'SDN', 'VN', '9'),
	('4', N'Lê Tấn Tài', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'KKH', 'VN', '14'),
	('5', N'Phan Hồng Sơn', 'Thủ Môn', '2016-10-23 00:00:00.000', 'HAGL', 'VN', '1'),
	('6', 'Ronaldo', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'SDN', 'BRA', '7'),
	('7', 'Robinho', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'SDN', 'BRA', '8'),
	('8', 'Vidic', N'Hậu Vệ', '2016-10-23 00:00:00.000', 'HAGL', 'ANH', '3'),
	('9', N'Trần Văn Santos', N'Thủ Môn', '2016-10-23 00:00:00.000', 'BBD', 'BRA', '1'),
	('10', N'Nguyễn Trường Sơn', N'Hậu Vệ', '2016-10-23 00:00:00.000', 'BBD', 'VN', '4'),
	('11', N'Lê Huỳnh Đức', N'Tiền Đạo', '2016-10-23 00:00:00.000', 'BBD', 'VN', '10'),
	('12', N'Huỳnh Hồng Sơn', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'BBD', 'VN', '9'),
	('13', N'Lê Nguyễn', N'Tiền Đạo', '2016-10-23 00:00:00.000', 'BBD', 'VN', '14'),
	('15', N'Lê Huỳnh Đức', N'Thủ Môn', '2016-10-23 00:00:00.000', 'CSDT', 'VN', '1'),
	('16', N'Phan Văn Tài Em', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'GDT', 'VN', '10'),
	('17', N'Lý Tiểu Long', N'Tiền Vệ', '2016-10-23 00:00:00.000', 'TPY', 'VN', '7');
SET IDENTITY_INSERT CAUTHU OFF;
	
INSERT INTO HUANLUYENVIEN(MAHLV, TENHLV, NGAYSINH, DIACHI, DIENTHOAI, MAQG)
VALUES
	('HLV01', 'Vital', '1955-10-15', 'NULL', '0918011075', 'BDN'),
	('HLV02', N'Lê Huỳnh Đức', '1972-5-20', 'NULL', '01223456789', 'VN'),
	('HLV03', N'Kiatisuk', '1970-12-11', 'NULL', '01990123456', 'THA'),
	('HLV04', N'Hoàng Anh Tuấn', '1970-6-10', 'NULL', '0989112233', 'VN'),
	('HLV05', N'Trần Công Minh', '1973-7-7', 'NULL', '0909099990', 'VN'),
	('HLV06', N'Trần Văn Phúc', '1965-3-2', 'NULL', '01650101234', 'VN'),
	('HLV07', 'Yooh-Hwan Cho', '1960-2-2', 'NULL', 'NULL', 'HQ'),
	('HLV08', 'Yun-Kyum Choi', '1962-3-3', 'NULL', 'NULL', 'HQ');

INSERT INTO HLV_CLB(MAHLV, MACLB, VAITRO)
VALUES
	('HLV01', 'GDT', N'HLV Chính'),
	('HLV02', 'SDN', N'HLV Chính'),
	('HLV03', 'HAGL', N'HLV Chính'),
	('HLV04', 'KKH', N'HLV Chính'),
	('HLV05', 'TPY', N'HLV Chính'),
	('HLV06', 'CSDT', N'HLV Chính'),
	('HLV07', 'BBD', N'HLV Chính'),
	('HLV08', 'BBD', N'HLV Thủ Môn');

SET IDENTITY_INSERT TRANDAU ON;
INSERT INTO TRANDAU(MATRAN, NAM, VONG, NGAYTD, MACLB1, MACLB2, MASAN, KETQUA)
VALUES
	('1', '2009', '1', '2009-02-07 00:00:00.000', 'BBD', 'SDN', 'GD', '3-0'),
	('2', '2009', '1', '2009-02-07 00:00:00.000', 'KKH', 'GDT', 'NT', '1-1'),
	('3', '2009', '2', '2009-02-16 00:00:00.000', 'SDN', 'KKH', 'CL', '2-2'),
	('4', '2009', '2', '2009-02-16 00:00:00.000', 'TPY', 'BBD', 'TH', '5-0'),
	('5', '2009', '3', '2009-03-01 00:00:00.000', 'TPY', 'GDT', 'TH', '0-2'),
	('6', '2009', '3', '2009-03-01 00:00:00.000', 'KKH', 'BBD', 'NT', '0-1'),
	('7', '2009', '4', '2009-03-07 00:00:00.000', 'KKH', 'TPY', 'NT', '1-0'),
	('8', '2009', '4', '2009-03-07 00:00:00.000', 'BBD', 'GDT', 'GD', '2-2');
SET IDENTITY_INSERT TRANDAU OFF;

INSERT INTO BANGXH(MACLB, NAM, VONG, SOTRAN, THANG, HOA, THUA, HIEUSO, DIEM, HANG)
VALUES
	('BBD', '2009', '1', '1', '1', '0', '0', '3-0', '3', '1'),
	('KKH', '2009', '1', '1', '0', '1', '0', '1-1', '1', '2'),
	('GDT', '2009', '1', '1', '0', '1', '0', '1-1', '1', '3'),
	('TPY', '2009', '1', '0', '0', '0', '0', '0-0', '0', '4'),
	('SDN', '2009', '1', '1', '0', '0', '1', '0-3', '0', '5'),

	('TPY', '2009', '2', '1', '1', '0', '0', '5-0', '3', '1'),
	('BBD', '2009', '2', '2', '1', '0', '1', '3-5', '3', '2'),
	('KKH', '2009', '2', '2', '0', '2', '0', '3-3', '2', '3'),
	('GDT', '2009', '2', '1', '0', '1', '0', '1-1', '1', '4'),
	('SDN', '2009', '2', '2', '1', '1', '0', '2-5', '1', '5'),

	('BBD', '2009', '3', '3', '2', '0', '1', '4-5', '6', '1'),
	('GDT', '2009', '3', '2', '1', '1', '0', '3-1', '4', '2'),
	('TPY', '2009', '3', '2', '1', '0', '1', '5-2', '3', '3'),
	('KKH', '2009', '3', '3', '0', '2', '1', '3-4', '2', '4'),
	('SDN', '2009', '3', '2', '1', '1', '0', '2-5', '1', '5'),

	('BBD', '2009', '4', '4', '2', '1', '1', '6-7', '7', '1'),
	('GDT', '2009', '4', '3', '1', '2', '0', '5-1', '5', '2'),
	('KKH', '2009', '4', '4', '1', '2', '1', '4-4', '5', '3'),
	('TPY', '2009', '4', '3', '1', '0', '2', '5-3', '3', '4'),
	('SDN', '2009', '4', '2', '1', '1', '0', '2-5', '1', '5');
	
INSERT INTO THAMGIA(MATD, MACT, SOTRAI)
VALUES 
	('1', '1', '2'),
	('1', '11', '1'),
	('2', '4', '1'),
	('2', '16', '1'),
	('3', '3', '1'),
	('3', '4', '2'),
	('3', '7', '1'),
	('4', '17', '5'),
	('5', '16', '2'),
	('6', '13', '1'),
	('7', '4', '1'),
	('8', '12', '2'),
	('8', '16', '2');
