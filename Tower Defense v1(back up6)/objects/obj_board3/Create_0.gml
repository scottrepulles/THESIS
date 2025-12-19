// Keep existing sprite from object properties
lesson_type = "Introduction to SQL and Database"; // Default lesson type
lesson_title = "SQL DEFENDER";
lesson_text = "Learning Materials\n\n" +
              "Introduction to SQL and Database\n\n\n" +
              "What is SQL?\n\n" +
              "  • SQL (Structured Query Language) is a standard programming\n" +
              "    language designed for managing and manipulating data stored\n" +
              "    in relational database systems (RDBMS).\n\n" +
              "  • It allows users to create, read, update, and delete data\n" +
              "    commonly referred to as CRUD operations.\n\n" +
              "  • SQL is the foundation of how most databases work today,\n" +
              "    serving as the universal language of data.";

// Flash effect
alpha_flash = 1; // Start visible since it's in the room
flash_speed = 0.1;
is_flashing = false;

// Scroll variables
scroll_y = 0;
scroll_speed = 20;
max_scroll = 0;
content_height = 0;
is_mouse_over = false;

// Initialize surface variable
content_surface = -1;

// --- ADDED ---
current_evaluation_instance = noone; // Tracks the currently visible evaluation object
evaluation_object_to_spawn = noone; // Tracks WHICH object to spawn
// --- END ---

// Scrollbar drag variables
scrollbar_dragging = false;
scrollbar_drag_offset = 0;
scrollbar_hover = false;

// Content swipe/drag variables
content_dragging = false;
drag_start_y = 0;
drag_start_scroll = 0;
drag_velocity = 0;
drag_last_y = 0;

// Function to set lesson content
set_lesson_content = function(type) {
    lesson_type = type;
    
    // Reset scroll when changing content
    scroll_y = 0;
    drag_velocity = 0;
    content_dragging = false;
    
    // Trigger flash effect
    alpha_flash = 0;
    is_flashing = true;
    
    // --- MODIFIED SECTION ---
    // 1. Destroy any evaluation object that might already exist
    if (instance_exists(current_evaluation_instance)) {
        instance_destroy(current_evaluation_instance);
    }
    current_evaluation_instance = noone; // Reset the tracker

    
    // Set content based on lesson type
    switch(lesson_type) {
        case "history":
            lesson_title = "HISTORY";
            lesson_text = "[center]The Origins and History of SQL[/center]\n\n" +
                          "[bold]Early Development[/bold]\n" +
                          "• In 1970, Dr. Edgar F. Codd, a computer scientist at IBM, published a groundbreaking paper titled A Relational Model of Data for Large Shared Data Banks. This paper introduced the concept of relational databases, where data is stored in tables (rows and columns) that can be related to one another.\n" +
                          "• Inspired by Codd's model, IBM researchers Donald D. Chamberlin and Raymond F. Boyce developed a new language in the early 1970s to interact with relational databases. This language was originally called SEQUEL (Structured English Query Language).\n" +
                          "• However, due to a trademark conflict with a British company (Hawker Siddeley's \"SEQUEL\" aircraft), IBM shortened the name to SQL pronounced as \"ess-cue-el\".\n\n" +
                          "[bold](SQL Standardization and Recognition)[/bold]\n" +
                          "SQL quickly became popular because of its simplicity and effectiveness in handling data.\n" +
                          "As different companies started creating their own versions (IBM, Oracle, Microsoft, etc.), a standard was needed to ensure compatibility between systems.\n\n" +
                          "Here's how SQL became a universal standard:\n" +
                          "• 1979: Oracle Corporation (then called Relational Software, Inc.) released the first commercial SQL-based RDBMS, called Oracle V2. This marked the first official use of SQL in a commercial product.\n" +
                          "• 1981: IBM released its own SQL-based system named SQL/DS, followed by DB2 in 1983.\n" +
                          "• 1986: The American National Standards Institute (ANSI) officially declared SQL as the standard database language.\n" +
                          "• 1987: The International Organization for Standardization (ISO) also adopted SQL as an international standard.\n" +
                          "These standards ensured that all SQL-based systems would follow common rules and syntax, even if companies added their own extensions.";
            break;
        
        case "beginner":
            lesson_title = "BEGINNER LEVEL LESSONS";
            lesson_text = "[bold]Welcome to the Beginner Level![/bold]\n\n" +
                          "Master the fundamentals of SQL through 7 comprehensive modules:\n\n" +
                          
                          "[bold]📘 MODULE 1: The SQL SELECT Statement[/bold]\n" +
                          "Learn how to retrieve data from database tables using SELECT.\n\n" +
                          
                          "[bold]What is SELECT?[/bold]\n" +
                          "The SELECT statement fetches or displays data stored in a database table. " +
                          "You can choose specific columns or retrieve all information.\n\n" +
                          
                          "[bold]Example:[/bold]\n" +
                          "SELECT ClientName, City FROM Clients;\n" +
                          "This shows only 'ClientName' and 'City' columns.\n\n" +
                          
                          "[bold]General Syntax:[/bold]\n" +
                          "SELECT column1, column2 FROM table_name;\n\n" +
                          
                          "[bold]Select All Columns:[/bold]\n" +
                          "SELECT * FROM Clients;\n" +
                          "The asterisk (*) means 'select all fields'.\n\n" +
                          
                          "💡 [bold]Tip:[/bold] In production, list specific columns instead of using * for better performance.\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📗 MODULE 2: The SQL WHERE Clause[/bold]\n" +
                          "Filter rows based on specific conditions.\n\n" +
                          
                          "[bold]What is WHERE?[/bold]\n" +
                          "The WHERE clause lets you filter rows that meet specific conditions.\n\n" +
                          
                          "[bold]Syntax:[/bold]\n" +
                          "SELECT column1, column2 FROM table_name WHERE condition;\n\n" +
                          
                          "[bold]Example:[/bold]\n" +
                          "SELECT * FROM Customers WHERE Country = 'Mexico';\n" +
                          "Returns only customers from Mexico.\n\n" +
                          
                          "[bold]Text vs Numeric Fields:[/bold]\n" +
                          "• Text values need quotes: WHERE Country = 'Mexico'\n" +
                          "• Numbers don't: WHERE CustomerID = 1\n\n" +
                          
                          "[bold]Common Operators:[/bold]\n" +
                          "= (equal), > (greater), < (less), >= (greater/equal)\n" +
                          "<= (less/equal), <> (not equal), BETWEEN, LIKE, IN\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📙 MODULE 3: ORDER BY & LIMIT[/bold]\n" +
                          "Sort and limit your query results.\n\n" +
                          
                          "[bold]ORDER BY:[/bold]\n" +
                          "Sorts rows based on one or more columns.\n\n" +
                          
                          "[bold]Syntax:[/bold]\n" +
                          "SELECT * FROM Customers ORDER BY Country;\n" +
                          "Default is ascending. Use DESC for descending:\n" +
                          "SELECT * FROM Customers ORDER BY Country DESC;\n\n" +
                          
                          "[bold]Multiple columns:[/bold]\n" +
                          "SELECT * FROM Customers ORDER BY Country, CustomerName;\n\n" +
                          
                          "[bold]LIMIT:[/bold]\n" +
                          "Restricts number of rows returned.\n\n" +
                          
                          "[bold]Syntax:[/bold]\n" +
                          "SELECT * FROM Customers LIMIT 20;\n" +
                          "Returns first 20 rows only.\n\n" +
                          
                          "[bold]With OFFSET (for pagination):[/bold]\n" +
                          "SELECT * FROM Orders LIMIT 10 OFFSET 15;\n" +
                          "Skips first 15 rows, returns next 10.\n\n" +
                          
                          "[bold]Combined Example:[/bold]\n" +
                          "SELECT * FROM employees ORDER BY salary DESC LIMIT 5;\n" +
                          "Returns top 5 highest-paid employees.\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📕 MODULE 4: SQL Aggregate Functions[/bold]\n" +
                          "Perform calculations on sets of values.\n\n" +
                          
                          "[bold]What are Aggregate Functions?[/bold]\n" +
                          "Functions that work on multiple rows and return a single summary value.\n\n" +
                          
                          "[bold]Common Functions:[/bold]\n" +
                          "• COUNT() - Counts rows\n" +
                          "• SUM() - Adds values\n" +
                          "• AVG() - Calculates average\n" +
                          "• MIN() - Finds smallest value\n" +
                          "• MAX() - Finds largest value\n\n" +
                          
                          "[bold]Examples:[/bold]\n" +
                          "COUNT: SELECT COUNT(*) AS total_customers FROM Customers;\n\n" +
                          
                          "SUM: SELECT SUM(amount) AS total_sales FROM Orders WHERE order_date = '2025-11-01';\n\n" +
                          
                          "AVG: SELECT AVG(score) AS avg_score FROM ExamResults WHERE exam_id = 101;\n\n" +
                          
                          "MIN/MAX: SELECT MIN(salary), MAX(salary) FROM Employees WHERE dept_id = 10;\n\n" +
                          
                          "[bold]Combined:[/bold]\n" +
                          "SELECT COUNT(*) AS orders, SUM(total) AS sum, AVG(total) AS avg, MAX(total) AS max, MIN(total) AS min FROM Orders;\n\n" +
                          
                          "💡 Aggregate functions ignore NULL values (except COUNT(*)).\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📓 MODULE 5: GROUP BY & HAVING[/bold]\n" +
                          "Organize and filter grouped data.\n\n" +
                          
                          "[bold]GROUP BY:[/bold]\n" +
                          "Organizes rows into groups sharing common column values.\n\n" +
                          
                          "[bold]Syntax:[/bold]\n" +
                          "SELECT Country, COUNT(CustomerID) AS CustomerCount FROM Customers GROUP BY Country;\n" +
                          "Groups customers by country and counts them.\n\n" +
                          
                          "[bold]With sorting:[/bold]\n" +
                          "SELECT Country, COUNT(CustomerID) AS CustomerCount FROM Customers GROUP BY Country ORDER BY CustomerCount DESC;\n\n" +
                          
                          "[bold]HAVING:[/bold]\n" +
                          "Filters groups after aggregation (WHERE filters before grouping).\n\n" +
                          
                          "[bold]Syntax:[/bold]\n" +
                          "SELECT Country, COUNT(CustomerID) AS CustomerCount FROM Customers GROUP BY Country HAVING COUNT(CustomerID) > 5;\n" +
                          "Returns only countries with more than 5 customers.\n\n" +
                          
                          "[bold]Complete Example:[/bold]\n" +
                          "SELECT Country, COUNT(CustomerID) AS CustomerCount FROM Customers GROUP BY Country HAVING COUNT(CustomerID) > 5 ORDER BY CustomerCount DESC;\n\n" +
                          
                          "[bold]Key Differences:[/bold]\n" +
                          "• WHERE filters rows before grouping\n" +
                          "• HAVING filters groups after aggregation\n" +
                          "• Non-aggregated columns in SELECT must appear in GROUP BY\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📔 MODULE 6: SQL JOINs[/bold]\n" +
                          "Combine rows from two or more tables.\n\n" +
                          
                          "[bold]What is a JOIN?[/bold]\n" +
                          "A JOIN clause combines rows from multiple tables using matching columns. " +
                          "This lets you merge related records to see data in a unified way.\n\n" +
                          
                          "[bold]Common Types of JOINs:[/bold]\n\n" +
                          
                          "[bold]INNER JOIN[/bold] - Returns only rows with matches in both tables.\n" +
                          "[bold]LEFT (OUTER) JOIN[/bold] - Returns all rows from left table, matching rows from right. NULL if no match.\n" +
                          "[bold]RIGHT (OUTER) JOIN[/bold] - Returns all rows from right table, matching rows from left. NULL if no match.\n" +
                          "[bold]FULL (OUTER) JOIN[/bold] - Returns rows when there's a match in either table. Shows all rows from both.\n\n" +
                          
                          "[bold]INNER JOIN Example:[/bold]\n" +
                          "SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate\n" +
                          "FROM Orders\n" +
                          "INNER JOIN Customers\n" +
                          "  ON Orders.CustomerID = Customers.CustomerID;\n\n" +
                          "Returns only orders with corresponding customers.\n\n" +
                          
                          "[bold]LEFT JOIN Example:[/bold]\n" +
                          "SELECT Customers.CustomerName, Orders.OrderID\n" +
                          "FROM Customers\n" +
                          "LEFT JOIN Orders\n" +
                          "  ON Customers.CustomerID = Orders.CustomerID\n" +
                          "ORDER BY Customers.CustomerName;\n\n" +
                          "Returns all customers, even those without orders (NULL for OrderID).\n\n" +
                          
                          "[bold]RIGHT JOIN Example:[/bold]\n" +
                          "SELECT Orders.OrderID, Employees.LastName, Employees.FirstName\n" +
                          "FROM Orders\n" +
                          "RIGHT JOIN Employees\n" +
                          "  ON Orders.EmployeeID = Employees.EmployeeID\n" +
                          "ORDER BY Orders.OrderID;\n\n" +
                          "Returns all employees, even those who haven't handled orders.\n\n" +
                          
                          "[bold]FULL OUTER JOIN Example:[/bold]\n" +
                          "SELECT Customers.CustomerName, Orders.OrderID\n" +
                          "FROM Customers\n" +
                          "FULL OUTER JOIN Orders\n" +
                          "  ON Customers.CustomerID = Orders.CustomerID\n" +
                          "ORDER BY Customers.CustomerName;\n\n" +
                          "Returns all customers and all orders. NULL where no match exists.\n\n" +
                          
                          "[bold]Things to Remember:[/bold]\n" +
                          "• Prefix columns with table names to avoid ambiguity\n" +
                          "• Choose join type based on needed results\n" +
                          "• INNER JOIN = only matching records\n" +
                          "• LEFT/RIGHT = all from one side + matches from other\n" +
                          "• FULL OUTER = everything from both tables\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📖 MODULE 7: SQL Subqueries[/bold]\n" +
                          "Use queries within queries for complex operations.\n\n" +
                          
                          "[bold]What is a Subquery?[/bold]\n" +
                          "A subquery (nested query) is a SQL query placed inside another query. " +
                          "The outer query uses the inner query's result to filter or process data.\n\n" +
                          
                          "[bold]Where Can You Use Subqueries?[/bold]\n" +
                          "• Inside WHERE clause (filter based on dynamic calculations)\n" +
                          "• In SELECT clause (compute a value for each row)\n" +
                          "• Inside FROM clause (create derived table)\n" +
                          "• In INSERT, UPDATE, DELETE statements\n\n" +
                          
                          "[bold]Basic Example:[/bold]\n" +
                          "Find employees earning above average salary:\n\n" +
                          "SELECT Name, Salary\n" +
                          "FROM Employees\n" +
                          "WHERE Salary > (\n" +
                          "    SELECT AVG(Salary)\n" +
                          "    FROM Employees\n" +
                          ");\n\n" +
                          
                          "Inner query computes average; outer query filters using that value.\n\n" +
                          
                          "[bold]Subquery in SELECT Clause:[/bold]\n" +
                          "SELECT EmployeeName, Salary,\n" +
                          "    (SELECT AVG(Salary) FROM Employees) AS AvgSalary\n" +
                          "FROM Employees;\n\n" +
                          "Shows each employee with overall average salary alongside.\n\n" +
                          
                          "[bold]Derived Table (Subquery in FROM):[/bold]\n" +
                          "SELECT Department, AvgSalary\n" +
                          "FROM (\n" +
                          "    SELECT Department, AVG(Salary) AS AvgSalary\n" +
                          "    FROM Employees\n" +
                          "    GROUP BY Department\n" +
                          ") AS DeptStats\n" +
                          "WHERE AvgSalary > 50000;\n\n" +
                          "Inner query computes department averages; outer query filters them.\n\n" +
                          
                          "[bold]Using with INSERT, UPDATE, DELETE:[/bold]\n" +
                          "• INSERT: Add high earners based on subquery condition\n" +
                          "• UPDATE: Modify records matching subquery results\n" +
                          "• DELETE: Remove records based on subquery criteria\n\n" +
                          
                          "[bold]Correlated vs Non-Correlated:[/bold]\n" +
                          "• [bold]Non-correlated:[/bold] Runs independently, executes once\n" +
                          "• [bold]Correlated:[/bold] References outer query columns, runs repeatedly\n\n" +
                          
                          "[bold]Quick Summary:[/bold]\n" +
                          "• Subqueries enable complex, dynamic conditions\n" +
                          "• Can appear in SELECT, FROM, WHERE, and data modification statements\n" +
                          "• Use when you need calculations based on other query results\n" +
                          "• Watch performance with correlated subqueries\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]🎯 SUMMARY:[/bold]\n" +
                          "You've learned:\n" +
                          "✓ SELECT - Retrieve data\n" +
                          "✓ WHERE - Filter rows\n" +
                          "✓ ORDER BY & LIMIT - Sort and limit results\n" +
                          "✓ Aggregate Functions - Summarize data\n" +
                          "✓ GROUP BY & HAVING - Group and filter aggregated data\n" +
                          "✓ JOINs - Combine data from multiple tables\n" +
                          "✓ Subqueries - Create complex nested queries\n\n" +
                          
                          "[bold]Now you're ready to defend databases with your SQL knowledge![/bold]\n\n" +
                          "[center][bold]📊 EVALUATION SECTION[/bold][/center]\n\n"+
						  
						  " .\n\n";
            
            // --- ADDED ---
            // 3. Create the beginner evaluation object
            evaluation_object_to_spawn = obj_evaluation_begginer;
			// --- END ---
            break;
        
        case "sql":
            lesson_title = "About SQL Defender";
            lesson_text = "Welcome to SQL Defender!\n" +
                          "This educational tower defense game transforms database learning into strategic gameplay. You'll defend virtual data base from cyberattack mosnter by answering optimized and secure SQL queries.\n" +
                          "What You'll Learn:\n" +
                          "• SQL query optimization and performance tuning\n" +
                          "• SQL injection prevention and security practices\n" +
                          "• Database design and normalization techniques\n" +
                          "• Real-world cybersecurity scenarios\n\n" +
                          "Progress through levels designed to match industry standards and academic curricula—building practical skills that prepare you for both academic excellence and professional database management.\n\n" +
                          "Let's defend some databases!";
            break;
        
        case "intermediate":
            lesson_title = "INTERMEDIATE LEVEL LESSONS";
            lesson_text = "[bold]Level Up Your Skills![/bold]\n\n" +
                          "Master intermediate SQL concepts through 4 comprehensive modules:\n\n" +
                          
                          "[bold]📘 MODULE 1: Data Manipulation in SQL[/bold]\n" +
                          "Learn to add, modify, and remove data from tables.\n\n" +
                          
                          "[bold]What is Data Manipulation?[/bold]\n" +
                          "Data manipulation refers to operations that change or retrieve actual data stored in tables. " +
                          "These tasks fall under Data Manipulation Language (DML).\n\n" +
                          
                          "[bold]Key DML Commands:[/bold]\n\n" +
                          
                          "[bold]INSERT INTO[/bold] - Add new rows to a table\n" +
                          "Syntax:\n" +
                          "INSERT INTO table_name (column1, column2)\n" +
                          "VALUES (value1, value2);\n\n" +
                          
                          "[bold]UPDATE[/bold] - Modify existing values\n" +
                          "Syntax:\n" +
                          "UPDATE table_name\n" +
                          "SET column1 = new_value1, column2 = new_value2\n" +
                          "WHERE some_condition;\n\n" +
                          
                          "[bold]DELETE FROM[/bold] - Remove rows from a table\n" +
                          "Syntax:\n" +
                          "DELETE FROM table_name\n" +
                          "WHERE some_condition;\n\n" +
                          
                          "[bold]Example Uses:[/bold]\n\n" +
                          
                          "Inserting a new row:\n" +
                          "INSERT INTO Employees (EmployeeID, Name, Department, Salary)\n" +
                          "VALUES (101, 'Jane Doe', 'Marketing', 65000);\n\n" +
                          
                          "Updating existing data:\n" +
                          "UPDATE Employees\n" +
                          "SET Salary = 70000\n" +
                          "WHERE EmployeeID = 101;\n\n" +
                          
                          "Deleting data:\n" +
                          "DELETE FROM Employees\n" +
                          "WHERE Department = 'Marketing' AND Salary < 50000;\n\n" +
                          
                          "[bold]Why Use Data Manipulation?[/bold]\n" +
                          "• Add new entries (customers, orders, students)\n" +
                          "• Change existing data (update addresses, correct names)\n" +
                          "• Remove outdated entries (deleted accounts, expired records)\n" +
                          "• Retrieve information for display or processing\n\n" +
                          
                          "[bold]Things to Keep in Mind:[/bold]\n" +
                          "⚠️ Always use WHERE clause with UPDATE and DELETE to avoid affecting all rows\n" +
                          "• Ensure INSERT values match column data types and constraints\n" +
                          "• Use transaction control (COMMIT/ROLLBACK) for data integrity\n" +
                          "• Consider performance and security for bulk operations\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📗 MODULE 2: Table Schemas & Keys in SQL[/bold]\n" +
                          "Understand database structure and relationships.\n\n" +
                          
                          "[bold]Table Schema (Structure of a Table)[/bold]\n" +
                          "A schema defines the table structure: columns, data types, and constraints.\n\n" +
                          
                          "[bold]Creating a Table:[/bold]\n" +
                          "CREATE TABLE Persons (\n" +
                          "    PersonID    INT,\n" +
                          "    LastName    VARCHAR(255),\n" +
                          "    FirstName   VARCHAR(255),\n" +
                          "    Address     VARCHAR(255),\n" +
                          "    City        VARCHAR(255)\n" +
                          ");\n\n" +
                          
                          "[bold]Altering Schema:[/bold]\n" +
                          "ALTER TABLE Customers\n" +
                          "ADD Email VARCHAR(255);\n\n" +
                          
                          "[bold]Dropping a Table:[/bold]\n" +
                          "DROP TABLE Shippers;\n\n" +
                          
                          "[bold]Keys in a Table Schema[/bold]\n" +
                          "Keys enforce uniqueness, identify relationships, and support data integrity.\n\n" +
                          
                          "[bold]1. Primary Key[/bold]\n" +
                          "Ensures each row can be uniquely identified. Must be unique and NOT NULL.\n" +
                          "A table can have only one primary key.\n\n" +
                          
                          "Example:\n" +
                          "CREATE TABLE Persons (\n" +
                          "    ID        INT NOT NULL,\n" +
                          "    LastName  VARCHAR(255) NOT NULL,\n" +
                          "    FirstName VARCHAR(255),\n" +
                          "    Age       INT,\n" +
                          "    PRIMARY KEY (ID)\n" +
                          ");\n\n" +
                          
                          "[bold]2. Foreign Key[/bold]\n" +
                          "Links a field in one table to the primary key in another table.\n" +
                          "Maintains referential integrity between tables.\n\n" +
                          
                          "Example:\n" +
                          "CREATE TABLE Orders (\n" +
                          "    OrderID     INT NOT NULL,\n" +
                          "    OrderNumber INT NOT NULL,\n" +
                          "    PersonID    INT,\n" +
                          "    PRIMARY KEY (OrderID),\n" +
                          "    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)\n" +
                          ");\n\n" +
                          
                          "[bold]3. Other Key Types[/bold]\n" +
                          "• [bold]Unique Key[/bold] - Ensures distinct values (may allow NULL)\n" +
                          "• [bold]Alternate Key[/bold] - Candidate key not chosen as primary\n" +
                          "• [bold]Composite Key[/bold] - Key made of 2+ columns together\n\n" +
                          
                          "[bold]Why Schemas & Keys Matter:[/bold]\n" +
                          "• Define how data is organized\n" +
                          "• Ensure uniqueness and valid relationships\n" +
                          "• Enable efficient querying and data consistency\n" +
                          "• Foundation for JOINs, indexing, and normalization\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📙 MODULE 3: Transactions & Concurrency[/bold]\n" +
                          "Ensure data integrity with multi-step operations.\n\n" +
                          
                          "[bold]What is a Transaction?[/bold]\n" +
                          "A transaction is a set of operations treated as a single logical unit.\n" +
                          "All operations either complete together or none happen at all.\n\n" +
                          
                          "[bold]Example Transaction:[/bold]\n" +
                          "Money transfer between accounts:\n\n" +
                          "BEGIN;\n" +
                          "UPDATE accounts\n" +
                          "SET balance = balance - 100\n" +
                          "WHERE id = 1;\n\n" +
                          
                          "UPDATE accounts\n" +
                          "SET balance = balance + 100\n" +
                          "WHERE id = 2;\n\n" +
                          
                          "COMMIT;\n\n" +
                          
                          "• [bold]BEGIN[/bold] - Starts the transaction\n" +
                          "• [bold]COMMIT[/bold] - Saves changes permanently\n" +
                          "• [bold]ROLLBACK[/bold] - Cancels all changes if something fails\n\n" +
                          
                          "[bold]Why Use Transactions?[/bold]\n" +
                          "• Prevent data loss or corruption\n" +
                          "• Ensure consistency during critical operations\n" +
                          "• Allow recovery from system failures\n\n" +
                          
                          "[bold]ACID Properties:[/bold]\n" +
                          "1. [bold]Atomicity[/bold] - All or nothing (if one fails, all undo)\n" +
                          "2. [bold]Consistency[/bold] - Database remains valid before and after\n" +
                          "3. [bold]Isolation[/bold] - Transactions are independent\n" +
                          "4. [bold]Durability[/bold] - Committed changes persist permanently\n\n" +
                          
                          "[bold]Concurrency in Databases[/bold]\n" +
                          "Multiple transactions running simultaneously in multi-user systems.\n\n" +
                          
                          "[bold]Concurrency Problems:[/bold]\n" +
                          "• [bold]Lost Updates[/bold] - Transactions overwrite each other's data\n" +
                          "• [bold]Dirty Reads[/bold] - Reading uncommitted data from another transaction\n" +
                          "• [bold]Inconsistent Data[/bold] - Partial updates make data unreliable\n\n" +
                          
                          "[bold]Concurrency Control Mechanisms:[/bold]\n" +
                          "• [bold]Locking[/bold] - Restrict access until transaction finishes\n" +
                          "• [bold]Isolation Levels[/bold] - Control visibility of changes (READ COMMITTED, SERIALIZABLE)\n\n" +
                          
                          "[bold]Safe Transaction Example:[/bold]\n" +
                          "BEGIN TRANSACTION;\n\n" +
                          
                          "UPDATE accounts SET balance = balance - 100 WHERE id = 1;\n" +
                          "UPDATE accounts SET balance = balance + 100 WHERE id = 2;\n\n" +
                          
                          "COMMIT;\n\n" +
                          
                          "Database locks both accounts during updates, preventing conflicts.\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📕 MODULE 4: Performance Tuning - Indexes & Query Plans[/bold]\n" +
                          "Optimize database performance with strategic indexing.\n\n" +
                          
                          "[bold]The Role of Indexes[/bold]\n" +
                          "Indexes act like a book's index: instead of scanning every row,\n" +
                          "the database engine uses indexes to find relevant rows faster.\n\n" +
                          
                          "[bold]Creating an Index:[/bold]\n" +
                          "CREATE INDEX idx_columnname\n" +
                          "ON table_name (columnname);\n\n" +
                          
                          "Example:\n" +
                          "CREATE INDEX idx_grade\n" +
                          "ON students (grade);\n\n" +
                          
                          "[bold]A Word of Caution:[/bold]\n" +
                          "⚠️ Indexes improve search speed but slow down INSERT, UPDATE, DELETE\n" +
                          "• Each modification must also update the index\n" +
                          "• Only index frequently searched, sorted, or joined columns\n" +
                          "• Avoid indexing every column indiscriminately\n\n" +
                          
                          "[bold]Understanding Query Plans[/bold]\n" +
                          "A query plan (execution plan) shows the route the database takes\n" +
                          "to retrieve or modify data when you run a SQL statement.\n\n" +
                          
                          "[bold]By Examining Query Plans You Can:[/bold]\n" +
                          "• See if database uses indexes or does full table scans\n" +
                          "• Identify bottlenecks or inefficient operations\n" +
                          "• Modify schema, indexes, or query structure to improve performance\n\n" +
                          
                          "[bold]Practical Example:[/bold]\n" +
                          "For a table with millions of rows, searching by grade frequently:\n\n" +
                          
                          "CREATE INDEX idx_grade ON students (grade);\n\n" +
                          
                          "After creating the index, the engine jumps to relevant rows quickly.\n\n" +
                          
                          "[bold]Performance Summary:[/bold]\n" +
                          "Concept | Key Point\n" +
                          "Index | Improves retrieval speed\n" +
                          "Index cost | May slow writes/updates\n" +
                          "Query plan | Shows how query executes\n" +
                          "Tip | Index WHERE, JOIN, ORDER BY columns\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]🎯 INTERMEDIATE SUMMARY:[/bold]\n" +
                          "You've mastered:\n" +
                          "✓ Data Manipulation - INSERT, UPDATE, DELETE operations\n" +
                          "✓ Table Schemas & Keys - Primary, Foreign, and Composite keys\n" +
                          "✓ Transactions & Concurrency - ACID properties and data integrity\n" +
                          "✓ Performance Tuning - Indexes and query optimization\n\n" +
						  "[bold]Now you're ready to defend databases with your SQL knowledge![/bold]\n\n" +

                          "[center][bold]📊 EVALUATION SECTION[/bold][/center]\n\n"+
				          ".\n\n";

            // --- ADDED ---
            // 3. SET which object to spawn, but don't create it
            evaluation_object_to_spawn = obj_evaluation_intermidiate;
            break;
        
        case "expert":
            lesson_title = "EXPERT LEVEL LESSONS";
            lesson_text = "[bold]Master Advanced SQL Techniques![/bold]\n\n" +
                          "Take your skills to expert level with 5 advanced modules:\n\n" +
                          
                          "[bold]📘 MODULE 1: SQL Window Functions[/bold]\n" +
                          "Perform calculations across related rows while retaining individual row identity.\n\n" +
                          
                          "[bold]What are Window Functions?[/bold]\n" +
                          "Window functions perform calculations across a set of rows related to the current row,\n" +
                          "without collapsing them into a single result like aggregate functions.\n\n" +
                          
                          "[bold]Basic Syntax:[/bold]\n" +
                          "SELECT column1,\n" +
                          "  window_function(column2) OVER (\n" +
                          "    [PARTITION BY partition_column]\n" +
                          "    [ORDER BY sort_column]\n" +
                          "    [frame_definition]\n" +
                          "  ) AS alias_name\n" +
                          "FROM table_name;\n\n" +
                          
                          "• [bold]PARTITION BY[/bold] - Divides data into partitions\n" +
                          "• [bold]ORDER BY[/bold] - Defines ordering within each partition\n" +
                          "• [bold]frame_definition[/bold] - Restricts rows in each window\n\n" +
                          
                          "[bold]Why Use Them?[/bold]\n" +
                          "• Running totals\n" +
                          "• Ranking rows within a group\n" +
                          "• Comparing current row to previous/next rows\n" +
                          "• Show averages/sums over partitions without losing detail\n\n" +
                          
                          "[bold]Common Types:[/bold]\n\n" +
                          
                          "[bold]Aggregate Window Functions:[/bold] SUM(), AVG(), COUNT()\n" +
                          "[bold]Ranking Functions:[/bold] ROW_NUMBER(), RANK(), DENSE_RANK()\n" +
                          "[bold]Value Functions:[/bold] LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()\n\n" +
                          
                          "[bold]Running Total Example:[/bold]\n" +
                          "SELECT OrderID, OrderDate, Amount,\n" +
                          "  SUM(Amount) OVER (ORDER BY OrderDate) AS RunningTotal\n" +
                          "FROM Orders;\n\n" +
                          
                          "[bold]Partitioned Calculation:[/bold]\n" +
                          "SELECT Department, EmployeeID, Salary,\n" +
                          "  AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary\n" +
                          "FROM Employees;\n\n" +
                          
                          "[bold]Ranking Example:[/bold]\n" +
                          "SELECT EmployeeID, Department, Salary,\n" +
                          "  ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RankInDept\n" +
                          "FROM Employees;\n\n" +
                          
                          "[bold]Key Points:[/bold]\n" +
                          "• Window functions don't reduce row count\n" +
                          "• Use PARTITION BY for separate group calculations\n" +
                          "• Use ORDER BY for row ordering within windows\n" +
                          "• Frame definitions define exact rows to include\n" +
                          "• Monitor performance with large partitions\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📗 MODULE 2: Common Table Expressions (CTEs)[/bold]\n" +
                          "Create temporary named result sets for cleaner queries.\n\n" +
                          
                          "[bold]What is a CTE?[/bold]\n" +
                          "A CTE is a temporary, named result set defined within a SQL statement using WITH.\n" +
                          "Think of it as a 'virtual table' that exists only during query execution.\n\n" +
                          
                          "[bold]When & Why Use It:[/bold]\n" +
                          "• Break complex queries into logical, readable pieces\n" +
                          "• Reference same intermediate result multiple times\n" +
                          "• Work with hierarchical or recursive data\n" +
                          "• Prefer clarity over nested sub-queries\n\n" +
                          
                          "[bold]Basic Syntax:[/bold]\n" +
                          "WITH cte_name (optional_column_list) AS (\n" +
                          "  SELECT …\n" +
                          "  FROM table_name\n" +
                          "  WHERE …\n" +
                          ")\n" +
                          "SELECT …\n" +
                          "FROM cte_name\n" +
                          "WHERE …;\n\n" +
                          
                          "[bold]Example:[/bold]\n" +
                          "WITH HighEarners AS (\n" +
                          "  SELECT EmployeeID, FirstName, LastName, Salary\n" +
                          "  FROM Employees\n" +
                          "  WHERE Salary > 50000\n" +
                          ")\n" +
                          "SELECT EmployeeID, FirstName, LastName\n" +
                          "FROM HighEarners;\n\n" +
                          
                          "[bold]Recursive CTEs[/bold]\n" +
                          "Used for hierarchical data (like manager-employee relationships).\n\n" +
                          
                          "[bold]Structure:[/bold]\n" +
                          "WITH RECURSIVE cte_name (columns) AS (\n" +
                          "  -- anchor member (base case)\n" +
                          "  SELECT … FROM table_name WHERE …\n\n" +
                          
                          "  UNION ALL\n\n" +
                          
                          "  -- recursive member\n" +
                          "  SELECT … FROM table_name JOIN cte_name ON …\n" +
                          ")\n" +
                          "SELECT … FROM cte_name;\n\n" +
                          
                          "[bold]Key Takeaways:[/bold]\n" +
                          "• CTEs name temporary result sets for cleaner queries\n" +
                          "• Improve readability and manage complex logic\n" +
                          "• Last only for query duration (don't persist)\n" +
                          "• Recursive CTEs elegantly handle hierarchies\n" +
                          "• Focus on clarity, not always performance\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📙 MODULE 3: Stored Procedures & Triggers[/bold]\n" +
                          "Automate logic and enforce rules with reusable code.\n\n" +
                          
                          "[bold]Stored Procedures[/bold]\n" +
                          "Reusable block of SQL code saved in the database.\n\n" +
                          
                          "[bold]Why Use Them:[/bold]\n" +
                          "• Centralize logic for consistency and maintenance\n" +
                          "• Pass parameters for dynamic handling\n" +
                          "• Improve security and performance\n\n" +
                          
                          "[bold]Basic Syntax:[/bold]\n" +
                          "CREATE PROCEDURE procedure_name\n" +
                          "AS\n" +
                          "  sql_statement;\n" +
                          "GO;\n\n" +
                          
                          "-- Execute:\n" +
                          "EXEC procedure_name;\n\n" +
                          
                          "[bold]With Parameters:[/bold]\n" +
                          "CREATE PROCEDURE procedure_name\n" +
                          "  @Param1 datatype,\n" +
                          "  @Param2 datatype\n" +
                          "AS\n" +
                          "  SELECT * FROM SomeTable\n" +
                          "  WHERE Column1 = @Param1 AND Column2 = @Param2;\n" +
                          "GO;\n\n" +
                          
                          "-- Call:\n" +
                          "EXEC procedure_name @Param1 = value1, @Param2 = value2;\n\n" +
                          
                          "[bold]Triggers[/bold]\n" +
                          "Special procedures that run automatically on database events.\n\n" +
                          
                          "[bold]Why Use Them:[/bold]\n" +
                          "• Automate tasks (like logging)\n" +
                          "• Enforce business rules on data changes\n" +
                          "• Maintain data integrity automatically\n" +
                          "• Respond to changes and propagate effects\n\n" +
                          
                          "[bold]Basic Syntax:[/bold]\n" +
                          "CREATE TRIGGER trigger_name\n" +
                          "  AFTER | BEFORE { INSERT | UPDATE | DELETE }\n" +
                          "  ON table_name\n" +
                          "  FOR EACH ROW\n" +
                          "BEGIN\n" +
                          "  INSERT INTO logs (message, changed_at)\n" +
                          "  VALUES ('Grade updated', CURRENT_TIMESTAMP);\n" +
                          "END;\n\n" +
                          
                          "[bold]Example:[/bold]\n" +
                          "CREATE TRIGGER trg_Students_GradeUpdate\n" +
                          "AFTER UPDATE ON students\n" +
                          "FOR EACH ROW\n" +
                          "BEGIN\n" +
                          "  INSERT INTO logs (log_message, log_time)\n" +
                          "  VALUES ('Grade updated', NOW());\n" +
                          "END;\n\n" +
                          
                          "[bold]Important Points:[/bold]\n" +
                          "• Stored procedures execute manually; triggers run automatically\n" +
                          "• Triggers can impact performance on every change\n" +
                          "• Use triggers for automatic rule enforcement\n" +
                          "• Use procedures for reusable intentional logic\n" +
                          "• Beware of infinite loops and side-effects\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📕 MODULE 4: MySQL Query Optimizer & Cost Model[/bold]\n" +
                          "Understand how MySQL optimizes queries and execution plans.\n\n" +
                          
                          "[bold]What is the MySQL Optimizer?[/bold]\n" +
                          "The optimizer chooses the most efficient way to execute queries using:\n" +
                          "• Cost-based optimizations and heuristics\n" +
                          "• Cost model (CPU, IO)\n" +
                          "• Table/index metadata from data dictionary\n" +
                          "• Statistics from storage engines\n\n" +
                          
                          "[bold]Example Query:[/bold]\n" +
                          "SELECT a, b\n" +
                          "FROM t1, t2, t3\n" +
                          "WHERE t1.a = t2.b\n" +
                          "  AND t2.b = t3.c\n" +
                          "  AND t2.d > 20\n" +
                          "  AND t2.d < 30;\n\n" +
                          
                          "[bold]Access Methods:[/bold]\n" +
                          "• Table scan - Read entire table\n" +
                          "• Range scan - Scan index range\n" +
                          "• Ref access - Lookup via index equality\n" +
                          "• Index merge - Combine multiple indexes\n\n" +
                          
                          "[bold]Cost-Based Optimization[/bold]\n" +
                          "Optimizer assigns costs to:\n" +
                          "• Access methods\n" +
                          "• Subquery strategies\n" +
                          "• Join orders\n" +
                          "Then searches for lowest cost plan.\n\n" +
                          
                          "[bold]Cost Model (MySQL 5.7+):[/bold]\n" +
                          "Cost estimates computed using formulas for:\n\n" +
                          
                          "[bold]Table Scan:[/bold]\n" +
                          "IO cost = #pages × IO_BLOCK_READ_COST\n" +
                          "CPU cost = #rows × ROW_EVALUATE_COST\n\n" +
                          
                          "[bold]Range Scan (Secondary Index):[/bold]\n" +
                          "IO cost = #rows_in_range × IO_BLOCK_READ_COST\n" +
                          "CPU cost = #rows_in_range × ROW_EVALUATE_COST\n\n" +
                          
                          "[bold]Example Query:[/bold]\n" +
                          "SELECT SUM(o_totalprice) FROM orders\n" +
                          "WHERE o_orderdate BETWEEN '1994-01-01' AND '1994-12-31';\n\n" +
                          
                          "[bold]EXPLAIN Analysis:[/bold]\n\n" +
                          
                          "Query 1 (no index used):\n" +
                          "type: ALL (table scan)\n" +
                          "rows: 15,000,000\n" +
                          "filtered: 29.93%\n" +
                          "Extra: Using where\n\n" +
                          
                          "Query 2 (with narrower range):\n" +
                          "type: range\n" +
                          "key: i_o_orderdate\n" +
                          "rows: 2,235,118\n" +
                          "filtered: 100%\n" +
                          "Extra: Using index condition\n\n" +
                          
                          "[bold]Cost Model vs Real World:[/bold]\n" +
                          "Execution times vary dramatically based on storage:\n\n" +
                          
                          "Data in memory:\n" +
                          "• Table scan: 6.8s\n" +
                          "• Index scan: 5.2s\n\n" +
                          
                          "Data on disk:\n" +
                          "• Table scan: 36s\n" +
                          "• Index scan: 2.5 hours!\n\n" +
                          
                          "Data on SSD:\n" +
                          "• Table scan: 15s\n" +
                          "• Index scan: 30 min\n\n" +
                          
                          "[bold]Key Insight:[/bold] Index scans require more random I/O,\n" +
                          "which is expensive on disk but cheap in memory.\n\n" +
                          
                          "[bold]MySQL 8.0 Improvements:[/bold]\n" +
                          "• New cost constants (memory = 0.25 vs disk = 1.0)\n" +
                          "• InnoDB reports % of table/index cached in buffer pool\n" +
                          "• Plans may change based on cache state\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]📓 MODULE 5: Query Optimization Tools & Techniques[/bold]\n" +
                          "Master tools and strategies to optimize query performance.\n\n" +
                          
                          "[bold]Useful Tools:[/bold]\n" +
                          "• MySQL Enterprise Monitor & Query Analyzer\n" +
                          "• Performance Schema\n" +
                          "• MySQL sys schema\n" +
                          "• EXPLAIN (tabular, JSON, visual)\n" +
                          "• Optimizer trace\n" +
                          "• Slow query log\n" +
                          "• Status variables\n\n" +
                          
                          "[bold]Performance Schema Tables:[/bold]\n\n" +
                          
                          "[bold]Statement Events:[/bold]\n" +
                          "• events_statements_history\n" +
                          "• events_statements_history_long\n" +
                          "• events_statements_summary_by_digest\n\n" +
                          
                          "[bold]File I/O:[/bold]\n" +
                          "• file_summary_by_event_name\n\n" +
                          
                          "[bold]Table/Index I/O:[/bold]\n" +
                          "• table_io_waits_summary_by_table\n" +
                          "• table_io_waits_summary_by_index_usage\n\n" +
                          
                          "[bold]Statement Digest:[/bold]\n" +
                          "Normalizes queries with same structure:\n\n" +
                          
                          "Original queries:\n" +
                          "SELECT * FROM orders WHERE o_custkey=10 AND o_totalprice>20\n" +
                          "SELECT * FROM orders WHERE o_custkey=20 AND o_totalprice>100\n\n" +
                          
                          "Normalized:\n" +
                          "SELECT * FROM orders WHERE o_custkey = ? AND o_totalprice > ?\n\n" +
                          
                          "[bold]MySQL sys Schema:[/bold]\n" +
                          "Views, procedures, and functions to simplify Performance Schema:\n" +
                          "• File IO usage per user\n" +
                          "• Unused indexes\n" +
                          "• Queries with full table scans\n" +
                          "• Useful functions: format_time(), format_bytes(), format_statement()\n\n" +
                          
                          "[bold]EXPLAIN: Understanding Query Plans[/bold]\n\n" +
                          
                          "[bold]Tabular EXPLAIN:[/bold]\n" +
                          "EXPLAIN SELECT * FROM t1\n" +
                          "JOIN t2 ON t1.a = t2.a\n" +
                          "WHERE b > 10 AND c > 10;\n\n" +
                          
                          "Output shows:\n" +
                          "• select_type (SIMPLE, SUBQUERY, etc.)\n" +
                          "• type (ALL, range, ref, eq_ref, const)\n" +
                          "• possible_keys and key used\n" +
                          "• rows examined\n" +
                          "• filtered percentage\n" +
                          "• Extra information\n\n" +
                          
                          "[bold]Structured EXPLAIN (JSON):[/bold]\n" +
                          "EXPLAIN FORMAT=JSON\n" +
                          "SELECT * FROM t1 WHERE b > 10 AND c > 10;\n\n" +
                          
                          "Provides richer information:\n" +
                          "• Cost estimates (query_cost, read_cost, eval_cost)\n" +
                          "• Used key parts\n" +
                          "• Pushed conditions\n" +
                          "• Rows produced per join\n" +
                          "• Index conditions vs attached conditions\n\n" +
                          
                          "[bold]Visual EXPLAIN (MySQL Workbench):[/bold]\n" +
                          "• Accumulated cost visualization\n" +
                          "• Cost per table\n" +
                          "• Rows per lookup\n" +
                          "• Tables and indexes used\n\n" +
                          
                          "[bold]Optimizer Trace:[/bold]\n" +
                          "Explains WHY optimizer chose a specific plan:\n\n" +
                          
                          "SET optimizer_trace = 'enabled=on';\n" +
                          "SELECT * FROM t1,t2 WHERE f1 = 1 AND f1 = f2 AND f2 > 0;\n" +
                          "SELECT trace FROM information_schema.optimizer_trace;\n" +
                          "SET optimizer_trace = 'enabled=off';\n\n" +
                          
                          "[bold]Selecting Access Methods:[/bold]\n\n" +
                          
                          "[bold]Ref Access:[/bold]\n" +
                          "Equality to primary key:\n" +
                          "SELECT * FROM customer WHERE c_custkey = 570887;\n" +
                          "Result: type = const, rows = 1\n\n" +
                          
                          "Equality to secondary index:\n" +
                          "SELECT * FROM orders WHERE o_orderdate = '1992-09-12';\n" +
                          "Result: type = ref, rows ~ 6271\n\n" +
                          
                          "[bold]Range Optimizer:[/bold]\n" +
                          "Finds minimal ranges per index:\n\n" +
                          
                          "SELECT * FROM t1\n" +
                          "WHERE (key1 > 10 AND key1 < 20) AND key2 > 30;\n\n" +
                          
                          "Evaluates both INDEX(key1) and INDEX(key2).\n\n" +
                          
                          "[bold]Sargable Queries (Search ARGument ABLE):[/bold]\n\n" +
                          
                          "[bold]❌ Bad (not sargable):[/bold]\n" +
                          "SELECT * FROM orders\n" +
                          "WHERE YEAR(o_orderdate) = 1997\n" +
                          "  AND MONTH(o_orderdate) = 5;\n" +
                          "Result: type = ALL, rows = 15M, ~8.91 sec\n\n" +
                          
                          "[bold]✓ Good (sargable):[/bold]\n" +
                          "SELECT * FROM orders\n" +
                          "WHERE o_orderdate BETWEEN '1997-05-01' AND '1997-05-31';\n" +
                          "Result: type = range, rows = 376K, ~0.91 sec\n\n" +
                          
                          "[bold]Multi-Column Indexes:[/bold]\n" +
                          "For INDEX idx(a, b, c):\n\n" +
                          
                          "Equality on first column allows refinement:\n" +
                          "WHERE a IN (10, 11, 13) AND (b = 2 OR b = 4)\n" +
                          "✓ Uses both a and b in range\n\n" +
                          
                          "Non-equality on first column:\n" +
                          "WHERE a > 10 AND a < 13 AND (b = 2 OR b = 4)\n" +
                          "⚠️ Only uses a for range, b checked separately\n\n" +
                          
                          "[bold]Join Optimizer:[/bold]\n" +
                          "Goal: Find best join order for N tables\n\n" +
                          
                          "[bold]Strategy:[/bold]\n" +
                          "• Start with all 1-table plans\n" +
                          "• Expand each plan with remaining tables (depth-first)\n" +
                          "• Prune if partial plan cost > best plan\n" +
                          "• Use heuristics (optimizer_prune_level)\n\n" +
                          
                          "[bold]Example:[/bold]\n" +
                          "EXPLAIN SELECT *\n" +
                          "FROM customers\n" +
                          "JOIN orders ON c_custkey = o_custkey\n" +
                          "WHERE c_acctbal < -1000\n" +
                          "  AND o_orderdate < '1993-01-01';\n\n" +
                          
                          "Optimizer may choose:\n" +
                          "orders → customer (start with filtered orders)\n" +
                          "vs\n" +
                          "customer → orders (start with filtered customers)\n\n" +
                          
                          "[bold]Forcing Join Order:[/bold]\n" +
                          "STRAIGHT_JOIN (older method):\n" +
                          "SELECT STRAIGHT_JOIN *\n" +
                          "FROM customer\n" +
                          "JOIN orders ON c_custkey = o_custkey\n" +
                          "WHERE ...\n\n" +
                          
                          "MySQL 8.0 Hint (recommended):\n" +
                          "SELECT /*+ JOIN_ORDER(customer, orders) */ *\n" +
                          "FROM customer\n" +
                          "JOIN orders ...\n\n" +
                          "[bold]MySQL 8.0: Histograms[/bold]\n" +
                          "Improve selectivity estimates:\n\n" +
                          
                          "ANALYZE TABLE customer\n" +
                          "UPDATE HISTOGRAM ON c_acctbal WITH 1024 BUCKETS;\n\n" +
                          
                          "Result: Better filtering estimates → improved join order.\n\n" +
                          
                          "[bold]Influencing the Optimizer:[/bold]\n\n" +
                          
                          "[bold]1. Add Indexes[/bold]\n" +
                          "CREATE INDEX idx_name ON table(column);\n\n" +
                          
                          "[bold]2. Force Index Usage[/bold]\n" +
                          "• USE INDEX (idx_name)\n" +
                          "• FORCE INDEX (idx_name)\n" +
                          "• IGNORE INDEX (idx_name)\n\n" +
                          
                          "[bold]3. Optimizer Hints (MySQL 5.7+):[/bold]\n" +
                          "SELECT /*+ HINT1(args) HINT2(args) */ ...\n\n" +
                          
                          "Available hints:\n" +
                          "• BKA/NO_BKA - Batched Key Access\n" +
                          "• BNL/NO_BNL - Block Nested Loop\n" +
                          "• MRR/NO_MRR - Multi-Range Read\n" +
                          "• SEMIJOIN/NO_SEMIJOIN\n" +

                          "• INDEX_MERGE/NO_INDEX_MERGE\n" +
                          "• JOIN_ORDER(tables)\n" +
                          "• JOIN_PREFIX(tables)\n" +
                          "• JOIN_SUFFIX(tables)\n" +
                          "• MERGE/NO_MERGE (for derived tables)\n\n" +
                          
                          "[bold]4. Set Session Variables Per Query:[/bold]\n" +
                          "SELECT /*+ SET_VAR(sort_buffer_size = 16M) */ name\n" +
                          "FROM people\n" +
                          "ORDER BY name;\n\n" +
                          
                          "SELECT /*+ SET_VAR(optimizer_switch = 'condition_fanout_filter=off') */ *\n" +
                          "FROM customer\n" +
                          "JOIN orders ...\n\n" +
                          
                          "[bold]Query Rewrite Plugin:[/bold]\n" +
                          "Rewrite problematic queries without changing application:\n\n" +
                          
                          "INSERT INTO query_rewrite.rewrite_rules (pattern, replacement) VALUES\n" +
                          "('SELECT * FROM t1 WHERE a > ? AND b = ?',\n" +
                          " 'SELECT * FROM t1 FORCE INDEX (a_idx) WHERE a > ? AND b = ?');\n\n" +
                          
                          "[bold]Best Practices Summary:[/bold]\n" +
                          "✓ Use EXPLAIN to understand query plans\n" +
                          "✓ Create indexes on frequently queried columns\n" +
                          "✓ Write sargable queries (avoid functions on indexed columns)\n" +
                          "✓ Consider multi-column indexes for common query patterns\n" +
                          "✓ Use Performance Schema to identify slow queries\n" +
                          "✓ Test different join orders for complex queries\n" +
                          "✓ Use optimizer hints when necessary\n" +
                          "✓ Monitor disk vs memory access patterns\n" +
                          "✓ Update statistics and histograms regularly\n\n" +
                          
                          "----------------------------------------------------------\n\n" +
                          
                          "[bold]🎯 EXPERT SUMMARY:[/bold]\n" +
                          "You've mastered:\n" +
                          "✓ Window Functions - Advanced row-based calculations\n" +
                          "✓ CTEs - Recursive and temporary result sets\n" +
                          "✓ Stored Procedures & Triggers - Automated database logic\n" +
                          "✓ MySQL Optimizer & Cost Model - Query execution internals\n" +
                          "✓ Query Optimization Tools - EXPLAIN, Performance Schema, sys schema\n" +
                          "✓ Access Methods - Ref, range, index optimization\n" +
                          "✓ Join Optimization - Order selection and forcing\n" +
                          "✓ Optimizer Hints - Fine-grained query control\n\n" +
                          
                          "[bold]You are now an SQL expert ready for any database challenge![/bold]\n\n" +
                          
                          "[bold]Additional Resources:[/bold]\n" +
                          "• MySQL Server Team Blog: mysqlserverteam.com\n" +
                          "• MySQL Forums: Optimizer & Parser, Performance\n" +
                          "• Practice with EXPLAIN and optimizer trace on real queries\n" +
                          "• Monitor Performance Schema in production environments"+
						  "[bold]Now you're ready to defend databases with your SQL knowledge![/bold]\n\n" +
                  
                          "[center][bold]📊 EVALUATION SECTION[/bold][/center]\n\n"+
				          ".\n\n";

            // 3. SET which object to spawn, but don't create it
            evaluation_object_to_spawn = obj_evaluation_expert;
            break;
        
        default:
            lesson_title = "SQL DEFENDER";
            lesson_text = "Learning Materials\n\n" +
                          "Introduction to SQL and Database\n\n\n" +
                          "What is SQL?\n\n" +
                          "  • SQL (Structured Query Language) is a standard programming\n" +
                          "    language designed for managing and manipulating data stored\n" +
                          "    in relational database systems (RDBMS).\n\n" +
                          "  • It allows users to create, read, update, and delete data\n" +
                          "    commonly referred to as CRUD operations.\n\n" +
                          "  • SQL is the foundation of how most databases work today,\n" +
                          "    serving as the universal language of data.";
            break;
    }
}