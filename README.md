# Wk-8-Database_Assignment

## Library Management System Database

A comprehensive relational database system designed for managing library operations, built with MySQL.

### 📋 Project Overview

This project implements a complete Library Management System with the following features:
- **Book Management**: Cataloging, categorization, and inventory tracking
- **Member Management**: User registration and membership handling
- **Staff Management**: Library personnel and role management
- **Loan System**: Book borrowing and return tracking
- **Reservation System**: Book reservation functionality
- **Fine Management**: Overdue tracking and penalty system
- **Advanced Features**: Views, stored procedures, and triggers for automation

### 🗄️ Database Schema

#### Core Tables

1. **Authors** - Stores author information
   - Author details, nationality, biography
   - Supports multiple authors per book

2. **Categories** - Book categorization system
   - Fiction, Non-Fiction, Science, History, etc.
   - Hierarchical organization support

3. **Publishers** - Publisher information management
   - Contact details, address, website
   - Publication tracking

4. **Books** - Main book catalog
   - ISBN, title, publication details
   - Copy management (available/total)
   - Location tracking

5. **Members** - Library users
   - Personal information, membership type
   - Borrowing limits, status tracking

6. **Staff** - Library personnel
   - Employee details, positions, departments
   - Access levels and permissions

7. **Loans** - Book borrowing records
   - Loan/return dates, due dates
   - Fine calculations, status tracking

8. **Reservations** - Book reservation system
   - Queue management, priority handling
   - Expiration and notification system

9. **Fines** - Penalty management
   - Fine calculation, payment tracking
   - Outstanding balance management

#### Junction Tables

- **Book_Authors** - Many-to-Many relationship between books and authors

### 🔗 Relationships

- **One-to-Many**: Books → Categories, Publishers → Books, Members → Loans
- **Many-to-Many**: Books ↔ Authors (via Book_Authors junction table)
- **Self-Referencing**: Categories can have subcategories (hierarchical)

### 📊 Key Features

#### Indexes for Performance
- Optimized queries for book searches
- Member lookup optimization
- Loan status tracking
- Due date monitoring

#### Views for Common Queries
- **AvailableBooks**: Currently available books with details
- **OverdueLoans**: Books past their due date with fine calculations
- **PopularBooks**: Most borrowed books statistics

#### Stored Procedures
- **LoanBook**: Automated book lending process
- **ReturnBook**: Book return with fine calculation

#### Triggers for Data Integrity
- Automatic availability updates
- Fine calculation on late returns
- Data validation and constraints

### 📝 Sample Data

The database includes comprehensive sample data:
- 6 book categories (Fiction, Non-Fiction, Science, History, Children, Reference)
- 3 major publishers (Penguin Books, HarperCollins, Scholastic)
- 4 renowned authors (J.K. Rowling, George Orwell, Harper Lee, Stephen King)
- 4 popular books with complete details
- 3 sample members with different membership types
- 3 library staff members
- Sample loans, reservations, and fines

### 🚀 Usage Instructions

#### Prerequisites
- MySQL Server 8.0 or higher
- MySQL Workbench (recommended) or any MySQL client

#### Installation Steps

1. **Install MySQL Server**
   ```bash
   # Using winget (Windows)
   winget install Oracle.MySQL

   # Or download from https://dev.mysql.com/downloads/mysql/
   ```

2. **Start MySQL Service**
   ```bash
   # Windows
   net start mysql

   # Or use MySQL Workbench to start the service
   ```

3. **Create Database**
   ```bash
   # Connect to MySQL
   mysql -u root -p

   # Run the SQL script
   source library_management_system.sql
   ```

4. **Verify Installation**
   ```sql
   USE library_management_system;
   SHOW TABLES;
   SELECT COUNT(*) FROM Books;
   ```

#### Testing the System

1. **Basic Operations**
   ```sql
   -- View available books
   SELECT * FROM AvailableBooks;

   -- Check overdue loans
   SELECT * FROM OverdueLoans;

   -- View popular books
   SELECT * FROM PopularBooks;
   ```

2. **Using Stored Procedures**
   ```sql
   -- Loan a book
   CALL LoanBook(1, 1, 1, 30);

   -- Return a book
   CALL ReturnBook(1, 1);
   ```

3. **Sample Queries**
   ```sql
   -- Find books by author
   SELECT b.title, CONCAT(a.first_name, ' ', a.last_name) AS author
   FROM Books b
   JOIN Book_Authors ba ON b.book_id = ba.book_id
   JOIN Authors a ON ba.author_id = a.author_id
   WHERE a.last_name = 'Rowling';

   -- Get member loan history
   SELECT m.first_name, m.last_name, b.title, l.loan_date, l.return_date
   FROM Members m
   JOIN Loans l ON m.member_id = l.member_id
   JOIN Books b ON l.book_id = b.book_id
   WHERE m.member_id = 1;

   -- Calculate total fines for a member
   SELECT m.first_name, m.last_name, SUM(f.fine_amount) AS total_fines
   FROM Members m
   JOIN Fines f ON m.member_id = f.member_id
   WHERE f.status = 'Unpaid'
   GROUP BY m.member_id, m.first_name, m.last_name;
   ```

### 📋 Assignment Requirements Met

✅ **Database Creation**: Complete CREATE DATABASE statement
✅ **Table Structure**: 10 well-structured tables with proper naming
✅ **Constraints**: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE constraints
✅ **Relationships**: One-to-One, One-to-Many, Many-to-Many relationships
✅ **Advanced Features**: Views, stored procedures, triggers, indexes
✅ **Sample Data**: Comprehensive test data for all tables
✅ **Documentation**: Complete README with usage instructions

### 🎯 Learning Objectives

This project demonstrates:
- **Database Design Principles**: Normalization, relationship modeling
- **SQL Proficiency**: Complex queries, stored procedures, triggers
- **Data Integrity**: Constraints, validation, error handling
- **Performance Optimization**: Indexing, query optimization
- **Real-world Application**: Practical library management system

### 📞 Support

For questions or issues:
1. Check MySQL error logs
2. Verify table relationships and constraints
3. Test with sample data before production use
4. Ensure proper user permissions are set

### 📄 File Structure

```
Wk-8-Database_Assignment/
├── README.md                           # This documentation file
└── library_management_system.sql       # Complete database schema
```

---

**Note**: This database schema is designed for educational purposes and can be extended with additional features like:
- User authentication and authorization
- Advanced search functionality
- Reporting and analytics
- Integration with library management software
- Mobile app API endpoints
