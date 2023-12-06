-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 06, 2023 at 05:58 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `booking`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserByCredentials` (IN `p_username` VARCHAR(255), IN `p_password` VARCHAR(255))   BEGIN
    SELECT *
    FROM users
    WHERE username = p_username AND password = p_password
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBooking` (IN `p_name` VARCHAR(255), IN `p_band` VARCHAR(255), IN `p_contact` VARCHAR(255), IN `p_services` INT, IN `p_date` DATE, IN `p_time` VARCHAR(255), IN `p_rate` DECIMAL(10,2), IN `p_refNo` VARCHAR(600))   BEGIN
    DECLARE client_id INT;

    -- Insert into client table
    INSERT INTO client(name, band, contact) VALUES (p_name, p_band, p_contact);
    
    -- Get the client ID of the latest insert
    SET client_id = LAST_INSERT_ID();

    -- Insert into bookingdates table
    INSERT INTO bookingdates(clientID, servicesID, date, time, hours, refNumber)
    VALUES (client_id, p_services, p_date, p_time, p_rate, p_refNo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertIntoBilling` (IN `p_bookingID` INT, IN `p_status` VARCHAR(255), IN `p_userID` INT)   BEGIN
    INSERT INTO billing (bookingID, status, userID)
    VALUES (p_bookingID, p_status, p_userID);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetLatestBookingID` () RETURNS INT(11)  BEGIN
    DECLARE latestBookingID INT;
    
    SELECT bookingID INTO latestBookingID
    FROM bookingDates
    ORDER BY bookingID DESC
    LIMIT 1;
    
    RETURN latestBookingID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `approveddates`
--

CREATE TABLE `approveddates` (
  `aID` int(11) NOT NULL,
  `bookingID` int(11) NOT NULL,
  `approvedDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `approveddates`
--

INSERT INTO `approveddates` (`aID`, `bookingID`, `approvedDate`) VALUES
(1, 18, '2023-12-03'),
(2, 15, '2023-12-03'),
(3, 16, '2023-12-03');

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `billID` int(11) NOT NULL,
  `bookingID` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `userID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` (`billID`, `bookingID`, `status`, `userID`) VALUES
(1, 15, 'Approved', 1),
(2, 16, 'Approved', 1),
(3, 17, 'Decline', 1),
(5, 18, 'Approved', 1),
(6, 19, 'Decline', 1),
(7, 20, 'Decline', 1),
(8, 21, 'Decline', 1),
(9, 22, 'Decline', 1),
(10, 23, 'Decline', 1),
(11, 24, 'Decline', 1),
(12, 25, 'Decline', 1),
(13, 26, 'Decline', 1),
(14, 27, 'Decline', 1);

--
-- Triggers `billing`
--
DELIMITER $$
CREATE TRIGGER `after_update_approved` AFTER UPDATE ON `billing` FOR EACH ROW BEGIN
    IF NEW.status = 'Approved' THEN
        INSERT INTO approveddates(approvedDate, bookingID)
        VALUES (NOW(), NEW.bookingID);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_decline` AFTER UPDATE ON `billing` FOR EACH ROW BEGIN
    IF NEW.status = 'Decline' THEN
        INSERT INTO declineddates(declinedDate, bookingID)
        VALUES (NOW(), NEW.bookingID);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bookingdates`
--

CREATE TABLE `bookingdates` (
  `bookingID` int(11) NOT NULL,
  `clientID` int(11) NOT NULL,
  `servicesID` int(11) NOT NULL,
  `date` date NOT NULL,
  `time` varchar(50) NOT NULL,
  `hours` int(11) NOT NULL,
  `refNumber` varchar(600) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookingdates`
--

INSERT INTO `bookingdates` (`bookingID`, `clientID`, `servicesID`, `date`, `time`, `hours`, `refNumber`) VALUES
(15, 15, 1, '2023-12-04', '08:00 AM', 1, 'LN598644725165'),
(16, 16, 1, '2023-12-05', '08:00 AM', 1, 'LN209544265718'),
(17, 17, 1, '2023-12-06', '09:00 AM', 1, 'LN298746543123'),
(18, 18, 1, '2023-12-04', '09:00 AM', 2, 'LN097545782131'),
(19, 19, 1, '2023-12-04', '10:00 AM', 2, 'LN97646781234'),
(20, 20, 1, '2023-12-04', '04:00 PM', 3, 'LN09966627641'),
(21, 21, 1, '2023-12-04', '05:00 PM', 1, 'LN1232131'),
(22, 22, 1, '2023-12-20', '09:00 AM', 1, 'LN1231000001'),
(23, 23, 1, '2023-12-05', '08:00 AM', 1, 'LN000000000'),
(24, 24, 1, '2023-12-01', '08:00 AM', 1, 'LN0000000000'),
(25, 25, 1, '2023-12-30', '01:00 PM', 1, 'LN2131110012'),
(26, 26, 1, '2023-12-04', '01:00 PM', 1, 'LN2131110012'),
(27, 27, 1, '2023-12-04', '08:00 AM', 1, 'LB123213333121');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `clientID` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `band` varchar(100) NOT NULL,
  `contact` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`clientID`, `name`, `band`, `contact`) VALUES
(1, 'Jesmar Acosta', 'Ben&Ben', '09123456789'),
(2, 'Joshua Gregory', 'RedAnthem', '09123123123'),
(3, 'Joshua Scalercio', 'Ace of Spades', '0987654321'),
(4, 'addfdasd', 'dfdsdg', '09638574152'),
(5, 'adwadwadwa', 'wqewqewqewq', '32132132132'),
(6, 'dsffwadw', 'fawdwad', '32134689000'),
(7, 'dsffwadw', 'fawdwad', '32134689000'),
(8, 'dwadsa', 'dwadwadwad', '32134689000'),
(9, 'dwadsa', 'dwadwadwad', '32134689000'),
(10, 'Helbert Ancheta', 'BenBen', '09234521345'),
(11, 'Jesmar Jesmar', 'Music High', '09856377154'),
(12, 'sdfghjkl', 'sdfghjkl', '23456789009'),
(13, 'dfghjklsdfghjk', 'sdfghjkl', '09876543456'),
(14, 'Jesmar', 'JEs', '09865425166'),
(15, 'Joshua Gregory', 'Joshes', '09321345678'),
(16, 'Jesmar Ascota', 'Jessie', '09123123132'),
(17, 'Joshua', 'Omen', '09876542123'),
(18, 'asdfghj', 'asdfghj', '09876543234'),
(19, 'asdfgfdsa', 'sdfgwewq', '09765437999'),
(20, 'Jessie Jessie', 'Jesss', '09878765562'),
(21, 'asdfghj', 'ASDFGHJ', '21345675432'),
(22, 'asdfghjkl', 'sdfghjkl', '09345676543'),
(23, 'asdfghj', 'dswadwa', '97654323456'),
(24, 'asdfghjkl', 'adsfghjkl', '90876546544'),
(25, 'adsfghjkl', 'sdfghjkl', '09234567543'),
(26, 'adsfghjkl', 'sdfghjkl', '09234567543'),
(27, 'adsfghjkl', 'adsfghjkl', '09321321321');

-- --------------------------------------------------------

--
-- Table structure for table `declineddates`
--

CREATE TABLE `declineddates` (
  `dID` int(11) NOT NULL,
  `declinedDate` date NOT NULL,
  `bookingID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `declineddates`
--

INSERT INTO `declineddates` (`dID`, `declinedDate`, `bookingID`) VALUES
(1, '2023-12-06', 17),
(2, '2023-12-06', 20),
(3, '2023-12-06', 21),
(4, '2023-12-06', 19),
(5, '2023-12-07', 22),
(6, '2023-12-07', 23),
(7, '2023-12-07', 24),
(8, '2023-12-07', 25),
(9, '2023-12-07', 26),
(10, '2023-12-07', 27);

-- --------------------------------------------------------

--
-- Table structure for table `sevices`
--

CREATE TABLE `sevices` (
  `servicesID` int(11) NOT NULL,
  `serviceName` varchar(100) NOT NULL,
  `serviceRate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sevices`
--

INSERT INTO `sevices` (`servicesID`, `serviceName`, `serviceRate`) VALUES
(1, 'Band Practice', 150),
(2, 'Music Recording', 250),
(3, 'Music Video Recording', 350);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `username`, `password`) VALUES
(1, 'jesmar', 'jesmar');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approveddates`
--
ALTER TABLE `approveddates`
  ADD PRIMARY KEY (`aID`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`billID`),
  ADD KEY `fk_billing_bookingID` (`bookingID`),
  ADD KEY `fk_billing_userID` (`userID`);

--
-- Indexes for table `bookingdates`
--
ALTER TABLE `bookingdates`
  ADD PRIMARY KEY (`bookingID`),
  ADD KEY `fk_bookingdates_clientID` (`clientID`),
  ADD KEY `fk_bookingdates_serviceID` (`servicesID`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`clientID`);

--
-- Indexes for table `declineddates`
--
ALTER TABLE `declineddates`
  ADD PRIMARY KEY (`dID`);

--
-- Indexes for table `sevices`
--
ALTER TABLE `sevices`
  ADD PRIMARY KEY (`servicesID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approveddates`
--
ALTER TABLE `approveddates`
  MODIFY `aID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `billID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `bookingdates`
--
ALTER TABLE `bookingdates`
  MODIFY `bookingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `clientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `declineddates`
--
ALTER TABLE `declineddates`
  MODIFY `dID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sevices`
--
ALTER TABLE `sevices`
  MODIFY `servicesID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `billing`
--
ALTER TABLE `billing`
  ADD CONSTRAINT `fk_billing_bookingID` FOREIGN KEY (`bookingID`) REFERENCES `bookingdates` (`bookingID`),
  ADD CONSTRAINT `fk_billing_userID` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`);

--
-- Constraints for table `bookingdates`
--
ALTER TABLE `bookingdates`
  ADD CONSTRAINT `fk_bookingdates_clientID` FOREIGN KEY (`clientID`) REFERENCES `client` (`clientID`),
  ADD CONSTRAINT `fk_bookingdates_serviceID` FOREIGN KEY (`servicesID`) REFERENCES `sevices` (`servicesID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
