-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 21, 2024 at 07:41 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_barang_fariz`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `hargajual` (`hargaModal` INT UNSIGNED, `keuntungan` DECIMAL(10,2)) RETURNS INT(11) BEGIN
DECLARE besarKeuntungan INT UNSIGNED;
SET besarKeuntungan = hargaModal * (keuntungan/100);
RETURN (hargaModal+besarKeuntungan);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hargaTotal` (`hargaSatuan` INT UNSIGNED, `jumlah` INT UNSIGNED) RETURNS INT(11) BEGIN
RETURN (hargaSatuan*jumlah);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hargaTotalKeuntungan` (`hargaModal` INT UNSIGNED, `total` INT UNSIGNED, `keuntungan` DECIMAL(10,2)) RETURNS INT(11) BEGIN
DECLARE hargaModalTotal INT UNSIGNED;
DECLARE besarKeuntungan INT UNSIGNED;
SET hargaModalTotal = hargaModal * total;
SET besarKeuntungan = hargaModalTotal * (keuntungan/100);
RETURN (hargaModalTotal + besarKeuntungan); 
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `insertBarang` (`namaBarang` VARCHAR(100), `kodeBarang` VARCHAR(200), `harga` INT UNSIGNED) RETURNS INT(11) BEGIN
INSERT INTO BARANG (nama_barang,kode,harga) VALUES (namaBarang,kodeBarang,harga);
return 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(10) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `kode` varchar(200) NOT NULL,
  `harga` int(20) NOT NULL,
  `keterangan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `nama_barang`, `kode`, `harga`, `keterangan`) VALUES
(1, 'motor listrik', '2j34hb', 9000000, NULL),
(2, 'tutup toples', '1123v', 10000, NULL),
(3, 'bedak gatel', '234g', 7000, NULL),
(4, 'tali sepatu', '123jn', 5000, NULL),
(5, 'motor listrik', '2j34h', 9000000, NULL);

--
-- Triggers `barang`
--
DELIMITER $$
CREATE TRIGGER `BarangStokInsert` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
INSERT INTO stok (id_barang,jumlah) VALUES (new.id_barang, 0);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `NambahStok` AFTER INSERT ON `barang` FOR EACH ROW BEGIN
insert into logs(pesan,tanggal) VALUES (CONCAT('Item ',new.nama_barang,
' berhasil di tambah, dengan id = ',
new.id_barang,' dengan harga sebesar ',new.harga),current_timestamp());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `beli`
--

CREATE TABLE `beli` (
  `id_beli` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah_beli` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `harga` int(10) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `beli`
--
DELIMITER $$
CREATE TRIGGER `BeliBarang` AFTER INSERT ON `beli` FOR EACH ROW BEGIN
insert into logs (pesan,tanggal) VALUES (CONCAT('Item ',
(SELECT br.nama_barang from barang br where br.id_barang=new.id_barang),
' berhasil di beli sebanyak ',new.jumlah_beli,
' dengan harga ',new.harga,' dan total ',new.total,' yang dilakukan pada tanggal '),
current_timestamp());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `BeliStok` AFTER INSERT ON `beli` FOR EACH ROW BEGIN
UPDATE stok SET jumlah = jumlah + new.jumlah_beli WHERE id_barang =
new.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `jual`
--

CREATE TABLE `jual` (
  `id_jual` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah_jual` int(10) NOT NULL,
  `tanggal` date NOT NULL,
  `harga` int(10) NOT NULL,
  `total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `jual`
--
DELIMITER $$
CREATE TRIGGER `JualStok` AFTER INSERT ON `jual` FOR EACH ROW BEGIN
UPDATE stok SET jumlah = jumlah - new.jumlah_jual WHERE id_barang =
new.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `jualBarang` AFTER INSERT ON `jual` FOR EACH ROW BEGIN
insert into logs (pesan,tanggal) VALUES (CONCAT('Item ',
(SELECT br.nama_barang from barang br where br.id_barang=new.id_barang),
' berhasil di beli sebanyak ',new.jumlah_jual,
' dengan harga ',new.harga,' dan total ',new.total,' yang dilakukan pada tanggal '),
current_timestamp());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id_logs` int(10) NOT NULL,
  `pesan` text NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id_logs`, `pesan`, `tanggal`) VALUES
(1, 'Item motor listrik berhasil di tambah, dengan id = 1 dengan harga sebesar 9000000', '2024-02-21'),
(2, 'Item tutup toples berhasil di tambah, dengan id = 2 dengan harga sebesar 10000', '2024-02-21'),
(3, 'Item bedak gatel berhasil di tambah, dengan id = 3 dengan harga sebesar 7000', '2024-02-21'),
(4, 'Item tali sepatu berhasil di tambah, dengan id = 4 dengan harga sebesar 5000', '2024-02-21'),
(5, 'Item motor listrik berhasil di tambah, dengan id = 5 dengan harga sebesar 9000000', '2024-02-21');

-- --------------------------------------------------------

--
-- Table structure for table `stok`
--

CREATE TABLE `stok` (
  `id_stok` int(10) NOT NULL,
  `id_barang` int(10) NOT NULL,
  `jumlah` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `stok`
--

INSERT INTO `stok` (`id_stok`, `id_barang`, `jumlah`) VALUES
(1, 1, 0),
(2, 2, 0),
(3, 3, 0),
(4, 4, 0),
(5, 5, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`);

--
-- Indexes for table `beli`
--
ALTER TABLE `beli`
  ADD PRIMARY KEY (`id_beli`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `jual`
--
ALTER TABLE `jual`
  ADD PRIMARY KEY (`id_jual`),
  ADD KEY `id_barang` (`id_barang`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id_logs`);

--
-- Indexes for table `stok`
--
ALTER TABLE `stok`
  ADD PRIMARY KEY (`id_stok`),
  ADD UNIQUE KEY `id_barang` (`id_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `beli`
--
ALTER TABLE `beli`
  MODIFY `id_beli` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jual`
--
ALTER TABLE `jual`
  MODIFY `id_jual` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id_logs` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `stok`
--
ALTER TABLE `stok`
  MODIFY `id_stok` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `beli`
--
ALTER TABLE `beli`
  ADD CONSTRAINT `beli_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `jual`
--
ALTER TABLE `jual`
  ADD CONSTRAINT `jual_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `stok`
--
ALTER TABLE `stok`
  ADD CONSTRAINT `stok_ibfk_1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
