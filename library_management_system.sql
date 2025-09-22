-- Library Management System Database by Peter Mwaura
-- Complete relational database schema for library management

-- Create Database
CREATE DATABASE IF NOT EXISTS library_management_system;
USE library_management_system;

-- Create Authors table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Categories table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Publishers table
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Books table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR,
    pages INT,
    language VARCHAR(50) DEFAULT 'English',
    description TEXT,
    available_copies INT NOT NULL DEFAULT 1,
    total_copies INT NOT NULL DEFAULT 1,
    location VARCHAR(100), -- e.g., "Fiction A1", "Reference B2"
    category_id INT,
    publisher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL
);

-- Create Book_Authors junction table (Many-to-Many relationship)
CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- Create Members table
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address VARCHAR(255),
    date_of_birth DATE,
    membership_date DATE NOT NULL,
    membership_type ENUM('Student', 'Regular', 'Premium', 'Senior') DEFAULT 'Regular',
    status ENUM('Active', 'Inactive', 'Suspended') DEFAULT 'Active',
    max_books_allowed INT DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Staff table
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Loans table
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    staff_id INT, -- Staff who processed the loan
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Active', 'Returned', 'Overdue') DEFAULT 'Active',
    fine_amount DECIMAL(5,2) DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE SET NULL
);

-- Create Reservations table
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    status ENUM('Pending', 'Ready', 'Cancelled', 'Expired') DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- Create Fines table
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    member_id INT NOT NULL,
    fine_amount DECIMAL(5,2) NOT NULL,
    reason VARCHAR(255),
    paid_amount DECIMAL(5,2) DEFAULT 0.00,
    payment_date DATE,
    status ENUM('Unpaid', 'Partially Paid', 'Paid') DEFAULT 'Unpaid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_isbn ON Books(isbn);
CREATE INDEX idx_books_category ON Books(category_id);
CREATE INDEX idx_members_email ON Members(email);
CREATE INDEX idx_members_status ON Members(status);
CREATE INDEX idx_loans_member ON Loans(member_id);
CREATE INDEX idx_loans_book ON Loans(book_id);
CREATE INDEX idx_loans_status ON Loans(status);
CREATE INDEX idx_loans_due_date ON Loans(due_date);
CREATE INDEX idx_reservations_member ON Reservations(member_id);
CREATE INDEX idx_reservations_book ON Reservations(book_id);
CREATE INDEX idx_reservations_status ON Reservations(status);

-- Insert sample data for testing

-- Sample Categories
INSERT INTO Categories (category_name, description) VALUES
('Fiction', 'Fictional stories and novels'),
('Non-Fiction', 'Educational and factual books'),
('Science', 'Scientific and technical books'),
('History', 'Historical books and biographies'),
('Children', 'Books for children'),
('Reference', 'Reference materials and dictionaries');

-- Sample Publishers
INSERT INTO Publishers (publisher_name, address, phone, email) VALUES
('Penguin Books', 'New York, USA', '+1-212-555-0100', 'contact@penguin.com'),
('HarperCollins', 'London, UK', '+44-20-555-0200', 'info@harpercollins.co.uk'),
('Scholastic', 'New York, USA', '+1-212-555-0300', 'orders@scholastic.com');

-- Sample Authors
INSERT INTO Authors (first_name, last_name, date_of_birth, nationality) VALUES
('J.K.', 'Rowling', '1965-07-31', 'British'),
('George', 'Orwell', '1903-06-25', 'British'),
('Harper', 'Lee', '1926-04-28', 'American'),
('Stephen', 'King', '1947-09-21', 'American');

-- Sample Books
INSERT INTO Books (isbn, title, publication_year, pages, language, description, available_copies, total_copies, location, category_id, publisher_id) VALUES
('978-0439708180', 'Harry Potter and the Sorcerer\'s Stone', 1997, 309, 'English', 'First book in the Harry Potter series', 5, 5, 'Fiction A1', 1, 1),
('978-0451524935', '1984', 1949, 328, 'English', 'Dystopian social science fiction novel', 3, 3, 'Fiction B2', 1, 2),
('978-0061120084', 'To Kill a Mockingbird', 1960, 376, 'English', 'Classic American novel', 4, 4, 'Fiction C3', 1, 2),
('978-0307743657', 'The Shining', 1977, 447, 'English', 'Horror novel by Stephen King', 2, 2, 'Fiction D4', 1, 1);

-- Sample Members
INSERT INTO Members (first_name, last_name, email, phone, address, date_of_birth, membership_date, membership_type, max_books_allowed) VALUES
('John', 'Doe', 'john.doe@email.com', '+1-555-0101', '123 Main St, City', '1990-05-15', '2023-01-15', 'Regular', 3),
('Jane', 'Smith', 'jane.smith@email.com', '+1-555-0102', '456 Oak Ave, City', '1985-08-22', '2023-02-20', 'Premium', 5),
('Bob', 'Johnson', 'bob.johnson@email.com', '+1-555-0103', '789 Pine Rd, City', '1995-12-10', '2023-03-10', 'Student', 2);

-- Sample Staff
INSERT INTO Staff (first_name, last_name, email, phone, position, department, hire_date) VALUES
('Alice', 'Brown', 'alice.brown@library.com', '+1-555-0201', 'Librarian', 'Circulation', '2020-06-01'),
('Charlie', 'Wilson', 'charlie.wilson@library.com', '+1-555-0202', 'Assistant Librarian', 'Reference', '2021-03-15'),
('Diana', 'Davis', 'diana.davis@library.com', '+1-555-0203', 'Manager', 'Administration', '2019-01-10');

-- Sample Book-Author relationships
INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1), -- Harry Potter by J.K. Rowling
(2, 2), -- 1984 by George Orwell
(3, 3), -- To Kill a Mockingbird by Harper Lee
(4, 4); -- The Shining by Stephen King

-- Sample Loans
INSERT INTO Loans (book_id, member_id, staff_id, loan_date, due_date, status) VALUES
(1, 1, 1, '2024-01-15', '2024-02-15', 'Active'),
(2, 2, 1, '2024-01-10', '2024-02-10', 'Active'),
(3, 3, 2, '2024-01-20', '2024-02-20', 'Returned');

-- Sample Reservations
INSERT INTO Reservations (book_id, member_id, reservation_date, status) VALUES
(4, 1, '2024-01-25', 'Pending'),
(1, 3, '2024-01-26', 'Pending');

-- Sample Fines
INSERT INTO Fines (loan_id, member_id, fine_amount, reason, status) VALUES
(3, 3, 2.50, 'Returned 3 days late', 'Paid');

-- Create views for common queries

-- View for available books
CREATE VIEW AvailableBooks AS
SELECT
    b.book_id,
    b.isbn,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    c.category_name,
    p.publisher_name,
    b.available_copies,
    b.location
FROM Books b
LEFT JOIN Book_Authors ba ON b.book_id = ba.book_id
LEFT JOIN Authors a ON ba.author_id = a.author_id
LEFT JOIN Categories c ON b.category_id = c.category_id
LEFT JOIN Publishers p ON b.publisher_id = p.publisher_id
WHERE b.available_copies > 0;

-- View for overdue loans
CREATE VIEW OverdueLoans AS
SELECT
    l.loan_id,
    b.title AS book_title,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    l.loan_date,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) AS days_overdue,
    (DATEDIFF(CURDATE(), l.due_date) * 0.50) AS calculated_fine
FROM Loans l
JOIN Books b ON l.book_id = b.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE l.status = 'Active' AND l.due_date < CURDATE();

-- View for popular books (most loaned)
CREATE VIEW PopularBooks AS
SELECT
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    c.category_name,
    COUNT(l.loan_id) AS total_loans,
    b.available_copies
FROM Books b
LEFT JOIN Book_Authors ba ON b.book_id = ba.book_id
LEFT JOIN Authors a ON ba.author_id = a.author_id
LEFT JOIN Categories c ON b.category_id = c.category_id
LEFT JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name, c.category_name, b.available_copies
ORDER BY total_loans DESC;

-- Create stored procedures

-- Procedure to loan a book
DELIMITER //
CREATE PROCEDURE LoanBook(
    IN p_book_id INT,
    IN p_member_id INT,
    IN p_staff_id INT,
    IN p_loan_days INT
)
BEGIN
    DECLARE book_available INT DEFAULT 0;
    DECLARE member_active INT DEFAULT 0;
    DECLARE current_loans INT DEFAULT 0;
    DECLARE due_date DATE;

    -- Check if book is available
    SELECT available_copies INTO book_available FROM Books WHERE book_id = p_book_id;

    -- Check if member is active
    SELECT COUNT(*) INTO member_active FROM Members WHERE member_id = p_member_id AND status = 'Active';

    -- Check current active loans for member
    SELECT COUNT(*) INTO current_loans FROM Loans WHERE member_id = p_member_id AND status = 'Active';

    -- Check member's max books limit
    SELECT max_books_allowed INTO @max_books FROM Members WHERE member_id = p_member_id;

    IF book_available > 0 AND member_active > 0 AND current_loans < @max_books THEN
        SET due_date = DATE_ADD(CURDATE(), INTERVAL p_loan_days DAY);

        -- Insert loan record
        INSERT INTO Loans (book_id, member_id, staff_id, loan_date, due_date)
        VALUES (p_book_id, p_member_id, p_staff_id, CURDATE(), due_date);

        -- Update book availability
        UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = p_book_id;

        SELECT 'Book loaned successfully' AS message, LAST_INSERT_ID() AS loan_id;
    ELSE
        SELECT 'Cannot loan book: Book not available, member inactive, or loan limit exceeded' AS message;
    END IF;
END //
DELIMITER ;

-- Procedure to return a book
DELIMITER //
CREATE PROCEDURE ReturnBook(
    IN p_loan_id INT,
    IN p_staff_id INT
)
BEGIN
    DECLARE book_id INT;
    DECLARE member_id INT;
    DECLARE due_date DATE;
    DECLARE return_date DATE;
    DECLARE days_late INT DEFAULT 0;
    DECLARE fine_amount DECIMAL(5,2) DEFAULT 0.00;

    -- Get loan details
    SELECT l.book_id, l.member_id, l.due_date, CURDATE()
    INTO book_id, member_id, due_date, return_date
    FROM Loans l WHERE l.loan_id = p_loan_id AND l.status = 'Active';

    IF book_id IS NOT NULL THEN
        -- Calculate fine if returned late
        IF return_date > due_date THEN
            SET days_late = DATEDIFF(return_date, due_date);
            SET fine_amount = days_late * 0.50; -- $0.50 per day

            -- Insert fine record
            INSERT INTO Fines (loan_id, member_id, fine_amount, reason)
            VALUES (p_loan_id, member_id, fine_amount, CONCAT('Returned ', days_late, ' days late'));
        END IF;

        -- Update loan record
        UPDATE Loans
        SET return_date = return_date, status = 'Returned', staff_id = p_staff_id, fine_amount = fine_amount
        WHERE loan_id = p_loan_id;

        -- Update book availability
        UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = book_id;

        SELECT 'Book returned successfully' AS message, fine_amount AS fine_charged;
    ELSE
        SELECT 'Loan not found or already returned' AS message;
    END IF;
END //
DELIMITER ;

-- Create triggers

-- Trigger to update book availability when loan is deleted
DELIMITER //
CREATE TRIGGER after_loan_delete
AFTER DELETE ON Loans
FOR EACH ROW
BEGIN
    UPDATE Books SET available_copies = available_copies + 1 WHERE book_id = OLD.book_id;
END //
DELIMITER ;

-- Trigger to prevent negative book availability
DELIMITER //
CREATE TRIGGER before_book_update
BEFORE UPDATE ON Books
FOR EACH ROW
BEGIN
    IF NEW.available_copies < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Available copies cannot be negative';
    END IF;
END //
DELIMITER ;

-- Create user and grant permissions (for production use)
-- Note: Replace 'your_username' and 'your_password' with actual credentials

-- CREATE USER 'library_user'@'localhost' IDENTIFIED BY 'your_password';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON library_management_system.* TO 'library_user'@'localhost';
-- FLUSH PRIVILEGES;

-- Display completion message
SELECT 'Library Management System database created successfully!' AS completion_message;
