-- Database Creation
CREATE DATABASE library_db;
use library_db;

-- Create table "branch"
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);

-- Create table "Employees"
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);

-- Create table "members"
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);

-- Create table "books"
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);

-- Create table "status"
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);

-- Create table "return_status"
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

-- Create New Records
INSERT INTO branch VALUES ('B001', 'M101', 'Delhi Central', '9876543210');
INSERT INTO branch VALUES ('B002', 'M102', 'Mumbai West', '9876543211');
INSERT INTO branch VALUES ('B003', 'M103', 'Bangalore East', '9876543212');
INSERT INTO branch VALUES ('B004', 'M104', 'Chennai South', '9876543213');
INSERT INTO branch VALUES ('B005', 'M105', 'Kolkata North', '9876543214');

INSERT INTO employees VALUES ('E101', 'Amit Sharma', 'Librarian', 50000.00, 'B001');
INSERT INTO employees VALUES ('E102', 'Priya Singh', 'Assistant', 30000.00, 'B002');
INSERT INTO employees VALUES ('E103', 'Rahul Verma', 'Manager', 60000.00, 'B003');
INSERT INTO employees VALUES ('E104', 'Sneha Iyer', 'Clerk', 25000.00, 'B004');
INSERT INTO employees VALUES ('E105', 'Karan Mehta', 'Assistant', 32000.00, 'B005');

INSERT INTO members VALUES ('M001', 'Rohit Kumar', 'Delhi', '2023-01-15');
INSERT INTO members VALUES ('M002', 'Anjali Gupta', 'Mumbai', '2023-02-20');
INSERT INTO members VALUES ('M003', 'Vikas Rao', 'Bangalore', '2023-03-10');
INSERT INTO members VALUES ('M004', 'Neha Kapoor', 'Chennai', '2023-04-05');
INSERT INTO members VALUES ('M005', 'Arjun Das', 'Kolkata', '2023-05-12');

INSERT INTO books VALUES ('ISBN001', 'Database Systems', 'Education', 50.00, 'Available', 'Korth', 'McGraw Hill');
INSERT INTO books VALUES ('ISBN002', 'Python Basics', 'Programming', 40.00, 'Available', 'Guido', 'OReilly');
INSERT INTO books VALUES ('ISBN003', 'Data Science 101', 'Education', 60.00, 'Issued', 'Smith', 'Pearson');
INSERT INTO books VALUES ('ISBN004', 'Machine Learning', 'AI', 70.00, 'Available', 'Andrew Ng', 'Stanford Press');
INSERT INTO books VALUES ('ISBN005', 'Operating Systems', 'Education', 55.00, 'Issued', 'Galvin', 'Wiley');

INSERT INTO issued_status VALUES ('I001', 'M001', 'Database Systems', '2023-06-01', 'ISBN001', 'E101');
INSERT INTO issued_status VALUES ('I002', 'M002', 'Python Basics', '2023-06-05', 'ISBN002', 'E102');
INSERT INTO issued_status VALUES ('I003', 'M003', 'Data Science 101', '2023-06-10', 'ISBN003', 'E103');
INSERT INTO issued_status VALUES ('I004', 'M004', 'Machine Learning', '2023-06-15', 'ISBN004', 'E104');
INSERT INTO issued_status VALUES ('I005', 'M005', 'Operating Systems', '2023-06-20', 'ISBN005', 'E105');

INSERT INTO return_status VALUES ('R001', 'I001', 'Database Systems', '2023-06-10', 'ISBN001');
INSERT INTO return_status VALUES ('R002', 'I002', 'Python Basics', '2023-06-12', 'ISBN002');
INSERT INTO return_status VALUES ('R003', 'I003', 'Data Science 101', '2023-06-18', 'ISBN003');
INSERT INTO return_status VALUES ('R004', 'I004', 'Machine Learning', '2023-06-25', 'ISBN004');
INSERT INTO return_status VALUES ('R005', 'I005', 'Operating Systems', '2023-06-30', 'ISBN005');


-- Viewing the record
select * FROM books;


-- Update an Existing Member's Address
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'M003';


-- Delete a Record from the Issued Status Table
DELETE FROM issued_status WHERE   issued_id =   'I005';


-- List Members Who Have Issued More Than One Book
SELECT issued_emp_id,COUNT(*) FROM issued_status GROUP BY 1 HAVING COUNT(*) > 1;

-- Create Summary Tables
CREATE TABLE books_issued_count AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

select*from books_issued_count;

-- Retrieve All Books in a Specific Category
SELECT * FROM books WHERE category = 'Programming';

--  Find Total Rental Income by Category
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;

-- Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

UPDATE branch SET manager_id = 'E101' WHERE branch_id = 'B001';
UPDATE branch SET manager_id = 'E102' WHERE branch_id = 'B002';
UPDATE branch SET manager_id = 'E103' WHERE branch_id = 'B003';
UPDATE branch SET manager_id = 'E104' WHERE branch_id = 'B004';
UPDATE branch SET manager_id = 'E105' WHERE branch_id = 'B005';

-- List Employees with their branch details
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.branch_id,
    b.branch_address,
    b.contact_no,
    e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
    ON e1.branch_id = b.branch_id    
JOIN employees AS e2
    ON e2.emp_id = b.manager_id;

-- Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE expensivebook AS
SELECT * FROM books
WHERE rental_price > 50;

select*from expensivebook;

-- Identify Members with Overdue Books
SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF(CURRENT_DATE, ist.issued_date) AS over_dues_days
FROM issued_status AS ist
JOIN members AS m
    ON m.member_id = ist.issued_member_id
JOIN books AS bk
    ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
WHERE rs.return_date IS NULL
  AND DATEDIFF(CURRENT_DATE, ist.issued_date) > 2
ORDER BY ist.issued_member_id;

 -- Branch Performance Report
CREATE TABLE branchreports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branchreports;





