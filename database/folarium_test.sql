-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 08, 2022 at 04:14 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `folarium_test`
--

-- --------------------------------------------------------

--
-- Table structure for table `md_loc0_country`
--

CREATE TABLE `md_loc0_country` (
  `country_id` int(11) NOT NULL,
  `country_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `md_loc0_country`
--

INSERT INTO `md_loc0_country` (`country_id`, `country_name`) VALUES
(1, 'Indonesia'),
(2, 'Singapura'),
(3, 'Hongkong'),
(4, 'India');

-- --------------------------------------------------------

--
-- Table structure for table `md_loc1_province`
--

CREATE TABLE `md_loc1_province` (
  `prov_id` int(11) NOT NULL,
  `country_id` int(11) NOT NULL,
  `prov_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `md_loc1_province`
--

INSERT INTO `md_loc1_province` (`prov_id`, `country_id`, `prov_name`) VALUES
(1, 1, 'Banten'),
(2, 1, 'Jawa Barat'),
(3, 1, 'Jawa Tengah'),
(4, 1, 'Yogyakarta'),
(5, 1, 'Jawa Timur'),
(6, 1, 'DKI jakarta');

-- --------------------------------------------------------

--
-- Table structure for table `md_loc2_city`
--

CREATE TABLE `md_loc2_city` (
  `city_id` int(11) NOT NULL,
  `prov_id` int(11) NOT NULL,
  `city_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `md_loc2_city`
--

INSERT INTO `md_loc2_city` (`city_id`, `prov_id`, `city_name`) VALUES
(1, 1, 'Cilegon'),
(2, 1, 'Tangerang'),
(3, 1, 'Tangerang Selatan'),
(4, 2, 'Bandung'),
(5, 2, 'Bekasi'),
(6, 2, 'Bogor'),
(7, 3, 'Semarang'),
(8, 3, 'Magelang'),
(9, 3, 'Batang'),
(10, 5, 'Madiun'),
(11, 5, 'Surabaya'),
(12, 4, 'Sleman'),
(13, 4, 'Kota Yogyakarta'),
(14, 4, 'Bantul'),
(15, 6, 'Jakarta Utara'),
(16, 6, 'Jakarta Selatan'),
(17, 6, 'Jakarta Pusat');

-- --------------------------------------------------------

--
-- Table structure for table `md_profession0`
--

CREATE TABLE `md_profession0` (
  `profs_id` int(11) NOT NULL,
  `profs_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `md_profession0`
--

INSERT INTO `md_profession0` (`profs_id`, `profs_name`) VALUES
(1, 'Sales & Marketing'),
(2, 'Finance & Accounting'),
(3, 'Human Resource'),
(4, 'Software engineering');

-- --------------------------------------------------------

--
-- Table structure for table `mg_company0`
--

CREATE TABLE `mg_company0` (
  `co_id` int(11) NOT NULL,
  `city_id` int(11) NOT NULL,
  `co_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mg_company0`
--

INSERT INTO `mg_company0` (`co_id`, `city_id`, `co_name`) VALUES
(1, 3, 'PT. ABC Indonesia'),
(2, 11, 'PT. KLM Indonesia'),
(3, 14, 'PT. XYZ Indonesia'),
(4, 1, 'PT. HIJ Indonesia'),
(5, 6, 'PT. WXY Indonesia'),
(6, 13, 'PT. QRS Indonesia'),
(7, 16, 'PT. DEF Indonesia'),
(8, 16, 'PT. GHI Indonesia'),
(9, 17, 'PT. CDE Indonesia');

-- --------------------------------------------------------

--
-- Table structure for table `mg_jobs0`
--

CREATE TABLE `mg_jobs0` (
  `jobs_id` int(11) NOT NULL,
  `profs_id` int(11) NOT NULL,
  `co_id` int(11) NOT NULL,
  `city_id` int(11) NOT NULL,
  `jobs_title` varchar(255) DEFAULT NULL,
  `jobs_register` timestamp NOT NULL DEFAULT current_timestamp(),
  `jobs_sts` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mg_jobs0`
--

INSERT INTO `mg_jobs0` (`jobs_id`, `profs_id`, `co_id`, `city_id`, `jobs_title`, `jobs_register`, `jobs_sts`) VALUES
(1, 2, 1, 17, 'Admin Keuangan', '2022-01-30 04:51:16', 1),
(2, 2, 7, 3, 'FA Manager', '2022-01-30 04:51:16', 1),
(3, 4, 1, 17, 'System Analyst', '2022-01-30 10:54:35', 1),
(4, 1, 3, 13, 'Sales Promotion', '2022-01-30 10:54:35', 1),
(5, 1, 4, 11, 'Sales Supervisor', '2022-01-30 10:54:35', 1);

-- --------------------------------------------------------

--
-- Table structure for table `mg_jobs1_apply`
--

CREATE TABLE `mg_jobs1_apply` (
  `joply_id` int(11) NOT NULL,
  `jobs_id` int(11) NOT NULL,
  `city_id` int(11) NOT NULL,
  `joply_name` varchar(255) DEFAULT NULL,
  `joply_register` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mg_jobs1_apply`
--

INSERT INTO `mg_jobs1_apply` (`joply_id`, `jobs_id`, `city_id`, `joply_name`, `joply_register`) VALUES
(1, 2, 9, 'Joni Haryadi', '2022-01-30 10:59:20'),
(2, 1, 11, 'Anisa Handayani', '2022-01-30 10:59:20'),
(3, 4, 12, 'Tirta Sista', '2022-01-30 10:59:20'),
(4, 5, 12, 'Hendra Arwandi', '2022-03-06 05:56:40'),
(5, 5, 3, 'Joko Cahyono', '2022-01-30 10:59:20'),
(6, 2, 10, 'Nisa Ninatun', '2022-01-30 10:59:20');

-- --------------------------------------------------------

--
-- Table structure for table `users_bio`
--

CREATE TABLE `users_bio` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `current_location` varchar(255) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `token_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `md_loc0_country`
--
ALTER TABLE `md_loc0_country`
  ADD PRIMARY KEY (`country_id`);

--
-- Indexes for table `md_loc1_province`
--
ALTER TABLE `md_loc1_province`
  ADD PRIMARY KEY (`prov_id`);

--
-- Indexes for table `md_loc2_city`
--
ALTER TABLE `md_loc2_city`
  ADD PRIMARY KEY (`city_id`);

--
-- Indexes for table `md_profession0`
--
ALTER TABLE `md_profession0`
  ADD PRIMARY KEY (`profs_id`);

--
-- Indexes for table `mg_company0`
--
ALTER TABLE `mg_company0`
  ADD PRIMARY KEY (`co_id`);

--
-- Indexes for table `mg_jobs0`
--
ALTER TABLE `mg_jobs0`
  ADD PRIMARY KEY (`jobs_id`);

--
-- Indexes for table `mg_jobs1_apply`
--
ALTER TABLE `mg_jobs1_apply`
  ADD PRIMARY KEY (`joply_id`);

--
-- Indexes for table `users_bio`
--
ALTER TABLE `users_bio`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `md_loc0_country`
--
ALTER TABLE `md_loc0_country`
  MODIFY `country_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `md_loc1_province`
--
ALTER TABLE `md_loc1_province`
  MODIFY `prov_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `md_loc2_city`
--
ALTER TABLE `md_loc2_city`
  MODIFY `city_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `md_profession0`
--
ALTER TABLE `md_profession0`
  MODIFY `profs_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `mg_company0`
--
ALTER TABLE `mg_company0`
  MODIFY `co_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `mg_jobs0`
--
ALTER TABLE `mg_jobs0`
  MODIFY `jobs_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mg_jobs1_apply`
--
ALTER TABLE `mg_jobs1_apply`
  MODIFY `joply_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users_bio`
--
ALTER TABLE `users_bio`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
