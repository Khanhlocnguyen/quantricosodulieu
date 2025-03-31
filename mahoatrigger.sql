ALTER TABLE NhanVien
ADD SoDienThoai_MaHoa VARBINARY(MAX)
-- ma hoa du lieu co san
UPDATE NhanVien 
SET SoDienThoai_MaHoa = ENCRYPTBYPASSPHRASE('matkhau', Sodienthoai),
	Sodienthoai = null

select * from NhanVien

-- Giai ma
SELECT *,
       CONVERT(CHAR(10), DECRYPTBYPASSPHRASE('matkhau', SoDienThoai_MaHoa)) AS SoDienThoai_Giai
FROM NhanVien;


CREATE OR ALTER TRIGGER trg_NhanVien
ON NhanVien
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE NhanVien
    SET 
        SoDienThoai_MaHoa = ENCRYPTBYPASSPHRASE('matkhau', i.Sodienthoai),
        Sodienthoai = NULL
    FROM NhanVien nv
    INNER JOIN inserted i ON nv.MaNV = i.MaNV; 
END;

----- insert du lieu
insert into NhanVien (MaNV, Hovaten, Sodienthoai, Gioitinh, Diachi,Ngaythangnamsinh, MaChucVu)
values ('NV01233', N'Thanh Tuyết', '0375947136', 1, N'71 Ngũ Hành Sơn', '2004-02-21', 'CV01')

select * from NhanVien

-- giải mã 
SELECT 
    MaNV,
    Hovaten,
	Sodienthoai,
	Diachi, 
    CONVERT(CHAR(10), DECRYPTBYPASSPHRASE('matkhau', SoDienThoai_MaHoa)) AS SoDienThoai_GiaiMa,
    Gioitinh,
    Ngaythangnamsinh,
    MaChucVu
FROM NhanVien;


-- ma hoa mat khau

ALTER TABLE QuanLy
ALTER COLUMN Matkhau VARCHAR(10) NULL;

ALTER TABLE QuanLy
ADD MatKhau_MaHoa VARBINARY(MAX),
    MatKhau_Hash VARBINARY(32)

-- ma hoa mat khau co san trong bang quan ly
UPDATE QuanLy
SET MatKhau_Hash = HASHBYTES ('SHA2_256', Matkhau),
	Matkhau = null

-- so sanh 
SELECT 
    CASE 
        WHEN MatKhau_Hash = HASHBYTES('SHA2_256', '123456789') 
        THEN N'Mật khẩu đúng'
        ELSE N'Mật khẩu sai'
    END AS MatKhau_KiemTra
FROM QuanLy
WHERE Taikhoan = 'admin01';

select * from QuanLy
-- Trigger mã hóa mật khẩu
CREATE OR ALTER TRIGGER trg_QuanLy
ON QuanLy
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE QuanLy
    SET 
        MatKhau_Hash = HASHBYTES('SHA2_256', i.Matkhau),
		Matkhau = null
    FROM QuanLy ql
    INNER JOIN inserted i ON ql.Taikhoan = i.Taikhoan;
END;


select * from QuanLy

INSERT INTO QuanLy (Taikhoan, Matkhau) 
VALUES ('quanly', '12345678')

UPDATE QuanLy 
SET Matkhau = '123456789'


-- so sanh 
SELECT 
    CASE 
        WHEN MatKhau_Hash = HASHBYTES('SHA2_256', '123456789') 
        THEN N'Mật khẩu đúng'
        ELSE N'Mật khẩu sai'
    END AS MatKhau_KiemTra
FROM QuanLy
WHERE Taikhoan = 'quanly';



