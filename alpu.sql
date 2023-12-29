-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 28 Des 2023 pada 06.43
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `alpu`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `id` varchar(18) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `foto` varchar(255) NOT NULL,
  `kata_sandi` varchar(256) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nomor_telepon` varchar(12) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`id`, `nama_lengkap`, `foto`, `kata_sandi`, `email`, `nomor_telepon`, `alamat`) VALUES
('1234567890', 'Admin RS', 'images (6).jpg', '$2y$10$kA6ZUe./EmPvFf3U/BS6wOpLR5Zx0xGiUQRgVfrzxEViL0U41LNv6', 'admin@gmail.com', '082171475115', 'Jalan Melati No. 123');

-- --------------------------------------------------------

--
-- Struktur dari tabel `dokter`
--

CREATE TABLE `dokter` (
  `nip_dokter` varchar(18) NOT NULL,
  `id_admin` varchar(18) NOT NULL,
  `id_poliklinik` varchar(10) NOT NULL,
  `nama_dokter` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `no_telepon` varchar(12) NOT NULL,
  `foto` varchar(255) NOT NULL,
  `status` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `dokter`
--

INSERT INTO `dokter` (`nip_dokter`, `id_admin`, `id_poliklinik`, `nama_dokter`, `alamat`, `no_telepon`, `foto`, `status`) VALUES
('21238790678935', '1234567890', 'P002', 'Dr. Chelsea', 'Batu aji baru ', '089870279567', 'FOto2.jpg', 0),
('2171115607019007', '1234567890', 'P003', 'Dr Tama', 'Batu aji ', '082171475991', 'FOto2.jpg', 1),
('23456789001231', '1234567890', 'P003', 'Dr.Alexa S', 'Bengkong palapa', '08215689098', 'Foto1.jpg', 1),
('23456789001232', '1234567890', 'P004', 'Dr.Jhonatan', 'Batam center ', '081345678901', 'foto6.jpg', 1),
('23456789001233', '1234567890', 'P005', 'Dr.Jesika', 'Baloi', '081356890087', 'foto4.jpg', 1),
('23456789001234', '1234567890', 'P004', 'Dr. Richard', 'Batam center ', '082178000710', 'foto6.jpg', 1),
('23456789001239', '1234567890', 'P004', 'DR. Ratih', 'Bengkong', '082156789076', 'foto4.jpg', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `jadwal_dokter`
--

CREATE TABLE `jadwal_dokter` (
  `id` int(11) NOT NULL,
  `nip_dokter` varchar(18) NOT NULL,
  `id_poliklinik` varchar(10) NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `hari` varchar(10) NOT NULL,
  `tanggal` date NOT NULL,
  `id_admin` varchar(18) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `jadwal_dokter`
--

INSERT INTO `jadwal_dokter` (`id`, `nip_dokter`, `id_poliklinik`, `jam_mulai`, `jam_selesai`, `hari`, `tanggal`, `id_admin`) VALUES
(16, '23456789001233', 'P005', '06:00:00', '16:00:00', 'Wednesday', '2023-12-13', '1234567890'),
(17, '23456789001234', 'P004', '08:00:00', '16:00:00', 'Tuesday', '2023-12-26', '1234567890');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pasien`
--

CREATE TABLE `pasien` (
  `nik` varchar(16) NOT NULL,
  `id_admin` varchar(18) NOT NULL,
  `nomor_rekam_medis` int(20) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `foto` varchar(255) NOT NULL,
  `kata_sandi` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `no_telepon` varchar(15) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pasien`
--

INSERT INTO `pasien` (`nik`, `id_admin`, `nomor_rekam_medis`, `nama_lengkap`, `foto`, `kata_sandi`, `email`, `no_telepon`, `alamat`) VALUES
('2171115607019007', '1234567890', 1, 'Tamaris Roulina S', 'IMG_20231008_134641.jpg', '$2y$10$cvkqqWib8aIjvP7OnI.cS.WlKrbLxa2csJ25kVmkdrQSzk/9y1nmy', 'tamarissilitonga@gmail.com', '082171475991', 'Batu Aji Baru Blok B 15 no 32 '),
('2171115607019009', '1234567890', 4, 'Tamaris', 'IMG_20231008_134641.jpg', '$2y$10$wVgydw6a8uUzTWvaywEKuOd7RidbI8mlxMqoD9nXGBN2mzhoixB4a', 'tamarissilitonga@gmail.com', '082171475990', 'Batu aji baru'),
('2171115709020002', '1234567890', 3, 'Elsa Marina S', 'IMG_20230608_135532_851.webp', '$2y$10$A6w30DmtETRrNjNbbyVF5O9pl3W/Cnd84dFtijicujCIhqTE8fIky', 'elsa@gmail.com', '082178907655', 'Buana impian blok a no 12 a');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pendaftaran`
--

CREATE TABLE `pendaftaran` (
  `id_pendaftaran` int(11) NOT NULL,
  `nik_pasien` varchar(16) NOT NULL,
  `id_poliklinik` varchar(10) NOT NULL,
  `nip_dokter` varchar(18) NOT NULL,
  `tanggal_kunjungan` date NOT NULL,
  `status` enum('belum_dikonfirmasi','hadir','tidak_hadir') NOT NULL DEFAULT 'belum_dikonfirmasi',
  `id_admin` varchar(18) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pendaftaran`
--

INSERT INTO `pendaftaran` (`id_pendaftaran`, `nik_pasien`, `id_poliklinik`, `nip_dokter`, `tanggal_kunjungan`, `status`, `id_admin`) VALUES
(44, '2171115607019007', 'P003', '23456789001231', '2023-12-20', 'belum_dikonfirmasi', NULL),
(45, '2171115607019007', 'P004', '23456789001232', '2023-12-21', 'tidak_hadir', '1234567890'),
(46, '2171115607019007', 'P004', '23456789001234', '2023-12-21', 'hadir', '1234567890'),
(47, '2171115607019007', 'P004', '23456789001234', '2023-12-21', 'hadir', '1234567890'),
(48, '2171115607019007', 'P004', '23456789001239', '2023-12-21', 'hadir', '1234567890'),
(49, '2171115607019007', 'P004', '23456789001232', '2023-12-21', 'hadir', '1234567890'),
(50, '2171115607019007', 'P004', '23456789001234', '2023-12-21', 'tidak_hadir', '1234567890'),
(51, '2171115607019007', 'P004', '23456789001239', '2023-12-21', 'hadir', '1234567890'),
(52, '2171115607019007', 'P005', '23456789001233', '2023-12-21', 'belum_dikonfirmasi', NULL),
(53, '2171115607019007', 'P004', '23456789001232', '2023-12-21', 'tidak_hadir', '1234567890'),
(54, '2171115607019007', 'P004', '23456789001234', '2023-12-21', 'belum_dikonfirmasi', NULL),
(55, '2171115607019007', 'P004', '23456789001232', '2023-12-22', 'hadir', '1234567890'),
(56, '2171115709020002', 'P002', '21238790678935', '2023-12-23', 'belum_dikonfirmasi', NULL),
(57, '2171115607019007', 'P004', '23456789001232', '2023-12-23', 'hadir', '1234567890'),
(58, '2171115607019007', 'P004', '23456789001234', '2023-12-23', 'tidak_hadir', '1234567890'),
(59, '2171115607019007', 'P004', '23456789001234', '2023-12-23', 'belum_dikonfirmasi', NULL),
(60, '2171115607019007', 'P004', '23456789001232', '2023-12-26', 'hadir', '1234567890'),
(61, '2171115607019007', 'P004', '23456789001234', '2023-12-26', 'hadir', '1234567890'),
(62, '2171115607019007', 'P004', '23456789001239', '2023-12-26', 'tidak_hadir', '1234567890'),
(63, '2171115607019007', 'P004', '23456789001232', '2023-12-26', 'hadir', '1234567890'),
(64, '2171115607019007', 'P004', '23456789001239', '2023-12-26', 'tidak_hadir', '1234567890'),
(65, '2171115607019007', 'P004', '23456789001239', '2023-12-26', 'tidak_hadir', '1234567890'),
(66, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'tidak_hadir', '1234567890'),
(67, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'hadir', '1234567890'),
(68, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'hadir', '1234567890'),
(69, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'belum_dikonfirmasi', NULL),
(70, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'belum_dikonfirmasi', NULL),
(71, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'belum_dikonfirmasi', NULL),
(72, '2171115607019007', 'P004', '23456789001232', '2023-12-26', 'belum_dikonfirmasi', NULL),
(73, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'belum_dikonfirmasi', NULL),
(74, '2171115607019007', 'P003', '23456789001231', '2023-12-26', 'belum_dikonfirmasi', NULL),
(75, '2171115607019007', 'P005', '23456789001233', '2023-12-26', 'belum_dikonfirmasi', NULL),
(76, '2171115607019007', 'P004', '23456789001239', '2023-12-26', 'belum_dikonfirmasi', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `poliklinik`
--

CREATE TABLE `poliklinik` (
  `id_poliklinik` varchar(10) NOT NULL,
  `nama_poliklinik` varchar(50) NOT NULL,
  `detail` text NOT NULL,
  `foto_logo` varchar(255) NOT NULL,
  `foto_rs` varchar(255) NOT NULL,
  `id_admin` varchar(18) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `poliklinik`
--

INSERT INTO `poliklinik` (`id_poliklinik`, `nama_poliklinik`, `detail`, `foto_logo`, `foto_rs`, `id_admin`, `status`) VALUES
('P002', 'Poliklinik Anak', 'Poliklinik anak di rumah sakit ini adalah unit kesehatan khusus yang menawarkan pelayanan medis untuk anak-anak, mulai dari bayi hingga remaja. Dipimpin oleh dokter anak dan tim medis terlatih, poliklinik ini menyediakan perawatan, diagnosa, dan manajemen berbagai kondisi kesehatan anak, termasuk infeksi, masalah pertumbuhan dan perkembangan, vaksinasi, gangguan nutrisi, serta masalah kesehatan umum lainnya yang sering dialami oleh anak-anak. Layanan yang ditawarkan mencakup pemeriksaan rutin, konsultasi dengan dokter anak, vaksinasi, diagnosis penyakit, serta pengobatan dan edukasi bagi orang tua terkait perawatan dan kesehatan anak mereka. Poliklinik ini berfokus pada pelayanan khusus untuk kebutuhan kesehatan dan perkembangan anak.\n', 'IMG-20231208-WA0012.jpg', 'IMG-20231208-WA0016.jpg', '1234567890', 1),
('P003', 'Poliklinik Jantung ', 'Poliklinik jantung di rumah sakit merupakan fasilitas khusus yang menyediakan layanan diagnosa, perawatan, dan pemantauan bagi pasien dengan masalah kardiovaskular. Dipimpin oleh tim dokter spesialis kardiologi dan tenaga medis terlatih, poliklinik ini dilengkapi dengan ruang konsultasi dokter, tes diagnostik seperti EKG dan Echocardiogram, serta bertujuan untuk merencanakan perawatan yang sesuai dengan kebutuhan individu pasien untuk mengelola kondisi jantung mereka secara holistik.', 'IMG-20231208-WA0015.jpg', 'IMG-20231208-WA0016.jpg', '1234567890', 1),
('P004', 'Poliklinik Gigi ', 'Poliklinik gigi di rumah sakit ini adalah fasilitas khusus yang menyediakan layanan perawatan gigi dan mulut. Dipimpin oleh dokter gigi dan staf medis terlatih, poliklinik ini menangani berbagai masalah mulai dari pemeriksaan gigi rutin, perawatan karies, pembersihan gigi, hingga perawatan periodontal dan prosedur restoratif seperti penambalan dan penempelan mahkota gigi. Selain itu, poliklinik gigi juga bisa menyediakan layanan konsultasi, edukasi tentang perawatan gigi, dan pencegahan masalah kesehatan gigi di masa mendatang.', 'IMG-20231208-WA0019.jpg', 'IMG-20231208-WA0018.jpg', '1234567890', 1),
('P005', 'Poliklinik Kulit', 'Poliklinik kulit di rumah sakit ini adalah unit medis yang menangani masalah kesehatan kulit, rambut, dan kuku. Dipimpin oleh dokter spesialis kulit (dermatolog) dan tim medis terlatih, poliklinik ini menyediakan diagnosa, perawatan, dan manajemen untuk berbagai kondisi kulit seperti jerawat, alergi kulit, dermatitis, psoriasis, kanker kulit, dan gangguan lainnya. Layanan yang ditawarkan mencakup pemeriksaan kulit, terapi obat, prosedur bedah minor, pengobatan laser, serta konseling terkait perawatan kulit dan pencegahan masalah dermatologis.', 'IMG-20231208-WA0013.jpg', 'IMG-20231208-WA0020.jpg', '1234567890', 1),
('P007', 'Poliklinik THT', 'Poliklinik THT (Telinga, Hidung, Tenggorokan) di rumah sakit adalah unit medis yang spesialis dalam diagnosis, perawatan, dan manajemen masalah yang berkaitan dengan telinga, hidung, dan tenggorokan. Dipimpin oleh dokter spesialis THT atau otolaringolog, poliklinik ini menangani berbagai kondisi seperti infeksi telinga, gangguan pendengaran, sinusitis, masalah pernapasan, gangguan pada pita suara, serta penyakit dan gangguan lain pada area THT. Layanan yang ditawarkan meliputi pemeriksaan fisik, prosedur diagnostik seperti endoskopi, perawatan medis, terapi rehabilitasi, dan jika diperlukan, tindakan bedah kecil pada area THT. Poliklinik ini bertujuan untuk memberikan diagnosis yang tepat dan perawatan yang efektif bagi masalah kesehatan THT pasien.', 'poli_THT.png', 'poli_THT.jpg', '1234567890', 1),
('P010', 'Poliklinik Umum', 'Poliklinik umum di rumah sakit ini adalah unit pelayanan medis yang menyediakan layanan diagnosa, perawatan, dan pengelolaan awal untuk berbagai keluhan kesehatan umum. Biasanya dipimpin oleh dokter umum atau dokter spesialis tertentu, poliklinik ini menangani beragam kondisi medis non-darurat seperti flu, infeksi ringan, gangguan pencernaan, tekanan darah tinggi, dan penyakit umum lainnya. Pasien dapat berkonsultasi dengan dokter untuk pemeriksaan fisik, diagnosis awal, resep obat, dan jika diperlukan, dirujuk ke spesialis tertentu atau fasilitas medis lain untuk perawatan lanjutan.', 'IMG-20231208-WA0015.jpg', 'IMG-20231208-WA0020.jpg', '1234567890', 1),
('P011', 'Poliklinik Bedah', 'Poliklinik bedah di rumah sakit ini adalah unit medis yang mengkhususkan diri dalam penanganan berbagai kondisi medis yang memerlukan intervensi atau prosedur bedah. Dipimpin oleh dokter bedah dan tim medis terlatih, poliklinik ini menangani berbagai kasus mulai dari operasi minor hingga prosedur bedah yang lebih kompleks. Layanan yang ditawarkan mencakup diagnosis, evaluasi pra-bedah, persiapan pasca-operasi, serta tindakan bedah untuk kondisi seperti cedera, tumor, masalah pencernaan, jantung, tulang, dan berbagai masalah kesehatan lainnya. Poliklinik bedah berperan penting dalam memberikan perawatan bedah yang tepat dan menyeluruh kepada pasien.', 'IMG-20231208-WA0015.jpg', 'IMG-20231208-WA0022.jpg', '1234567890', 1);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`nip_dokter`),
  ADD KEY `id_admin` (`id_admin`),
  ADD KEY `id_poliklinik` (`id_poliklinik`);

--
-- Indeks untuk tabel `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nip_dokter` (`nip_dokter`),
  ADD KEY `id_poliklinik` (`id_poliklinik`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indeks untuk tabel `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`nik`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indeks untuk tabel `pendaftaran`
--
ALTER TABLE `pendaftaran`
  ADD PRIMARY KEY (`id_pendaftaran`),
  ADD KEY `nik_pasien` (`nik_pasien`),
  ADD KEY `id_poliklinik` (`id_poliklinik`),
  ADD KEY `nip_dokter` (`nip_dokter`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indeks untuk tabel `poliklinik`
--
ALTER TABLE `poliklinik`
  ADD PRIMARY KEY (`id_poliklinik`),
  ADD KEY `id_admin` (`id_admin`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT untuk tabel `pendaftaran`
--
ALTER TABLE `pendaftaran`
  MODIFY `id_pendaftaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `dokter`
--
ALTER TABLE `dokter`
  ADD CONSTRAINT `dokter_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dokter_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `poliklinik` (`id_poliklinik`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  ADD CONSTRAINT `jadwal_dokter_ibfk_1` FOREIGN KEY (`nip_dokter`) REFERENCES `dokter` (`nip_dokter`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `jadwal_dokter_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `poliklinik` (`id_poliklinik`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `jadwal_dokter_ibfk_3` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pasien`
--
ALTER TABLE `pasien`
  ADD CONSTRAINT `pasien_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pendaftaran`
--
ALTER TABLE `pendaftaran`
  ADD CONSTRAINT `pendaftaran_ibfk_1` FOREIGN KEY (`nik_pasien`) REFERENCES `pasien` (`nik`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pendaftaran_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `poliklinik` (`id_poliklinik`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pendaftaran_ibfk_3` FOREIGN KEY (`nip_dokter`) REFERENCES `dokter` (`nip_dokter`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pendaftaran_ibfk_4` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `poliklinik`
--
ALTER TABLE `poliklinik`
  ADD CONSTRAINT `poliklinik_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
