create database icleaf_capstone_project_TASK_1


CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100),
    AUTHOR VARCHAR(100),
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT
);


CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    PHONE_NO VARCHAR(15),
    ADDRESS TEXT,
    MEMBERSHIP_DATE DATE
);

CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

-- 2. Sample Data Insertion

INSERT INTO Books VALUES
(1, 'The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 3),
(2, '1984', 'George Orwell', 'Dystopian', 1949, 2),
(3, 'To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 1),
(4, 'Sapiens', 'Yuval Noah Harari', 'History', 2011, 4),
(5, 'Clean Code', 'Robert C. Martin', 'Programming', 2008, 5);

INSERT INTO Members VALUES
(101, 'Alice Johnson', 'alice@gmail.com', '1234567890', 'NY, USA', '2023-01-01'),
(102, 'Bob Smith', 'bob@gmail.com', '2345678901', 'CA, USA', '2023-02-15'),
(103, 'Charlie Lee', 'charlie@gmail.com', '3456789012', 'TX, USA', '2023-03-20'),
(104, 'Daisy Ray', 'daisy@gmail.com', '4567890123', 'FL, USA', '2023-04-10');

INSERT INTO BorrowingRecords VALUES
(1, 101, 1, '2023-06-01', NULL),
(2, 101, 2, '2023-05-10', '2023-06-10'),
(3, 102, 3, '2023-06-15', NULL),
(4, 102, 4, '2023-05-01', '2023-06-01'),
(5, 103, 5, '2023-07-01', NULL),
(6, 103, 2, '2023-03-01', '2023-04-01'),
(7, 103, 1, '2023-04-01', '2023-05-01'),
(8, 104, 4, '2023-03-01', NULL);

-- 3. Queries

-- a) Books currently borrowed by a member
-- Replace 101 with desired MEMBER_ID
SELECT B.TITLE, BR.BORROW_DATE
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
WHERE BR.MEMBER_ID = 101 AND BR.RETURN_DATE IS NULL;

-- b) Members with overdue books
SELECT DISTINCT M.MEMBER_ID, M.NAME
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
WHERE BR.RETURN_DATE IS NULL AND BR.BORROW_DATE <= CURRENT_DATE - INTERVAL '30' DAY;

-- c) Books by genre with count of available copies
SELECT GENRE, COUNT(*) AS TOTAL_BOOKS, SUM(AVAILABLE_COPIES) AS TOTAL_AVAILABLE_COPIES
FROM Books
GROUP BY GENRE;

-- d) Most borrowed book(s)
SELECT B.TITLE, COUNT(*) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY B.BOOK_ID, B.TITLE
ORDER BY TIMES_BORROWED DESC
LIMIT 1;

-- e) Members who borrowed from at least 3 genres
SELECT M.MEMBER_ID, M.NAME
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
GROUP BY M.MEMBER_ID, M.NAME
HAVING COUNT(DISTINCT B.GENRE) >= 3;

-- Reporting and Analytics

-- a) Books borrowed per month
SELECT 
    DATE_FORMAT(BORROW_DATE, '%Y-%m') AS MONTH,
    COUNT(*) AS TOTAL_BORROWED
FROM 
    BorrowingRecords
GROUP BY 
    MONTH
ORDER BY 
    MONTH;

-- b) Top 3 most active members
SELECT M.MEMBER_ID, M.NAME, COUNT(*) AS BOOKS_BORROWED
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
GROUP BY M.MEMBER_ID, M.NAME
ORDER BY BOOKS_BORROWED DESC
LIMIT 3;

-- c) Authors with 10+ borrows
SELECT B.AUTHOR, COUNT(*) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY B.AUTHOR
HAVING COUNT(*) >= 10;

-- d) Members who never borrowed a book
SELECT M.MEMBER_ID, M.NAME
FROM Members M
LEFT JOIN BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
WHERE BR.BORROW_ID IS NULL;
