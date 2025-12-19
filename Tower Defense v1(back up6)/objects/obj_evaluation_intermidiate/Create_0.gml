/// Create Event of obj_evaluation

// Initialize variables
current_question = 0;
score = 0;
total_questions = 50;
answered = false;
selected_answer = -1;
show_result = false;
evaluation_complete = false;

// Set the sprite
sprite_index = spr_evaluation;
image_speed = 0;
image_index = 0;

// IMPORTANT: Set depth so object is always on top
depth = -1000;

// Make sure the object is visible and active
visible = true;
persistent = false;

// Box properties for question display
box_width = 900;
box_height = 700;
box_x = room_width / 2;
box_y = room_height / 2;
box_color = c_dkgray;
box_border_color = c_white;

// X button properties
x_button_size = 40;
x_button_color = c_red;
x_button_hover_color = c_maroon;

// Question data structure: [question, optionA, optionB, optionC, optionD, correct_answer(0-3), explanation]
// Question data structure: [question, optionA, optionB, optionC, optionD, correct_answer(0-3), explanation]
questions = [
    // MODULE 1: Data Manipulation in SQL (Questions 1-13)
    [
        "Which DML command is used to add new rows to a table?",
        "UPDATE",
        "INSERT INTO",
        "ADD ROW",
        "CREATE",
        1,
        "INSERT INTO is the correct DML command for adding new rows to a table. The syntax is INSERT INTO table_name (columns) VALUES (values);"
    ],
    [
        "What is the main risk of omitting the WHERE clause in an UPDATE statement?",
        "Syntax error",
        "All rows in the table will be updated",
        "Only the first row will be updated",
        "The database will crash",
        1,
        "Without a WHERE clause, the UPDATE statement affects every row in the table, which can lead to unintended data changes across the entire table."
    ],
    [
        "Which command permanently removes rows from a table?",
        "REMOVE",
        "DROP",
        "DELETE FROM",
        "TRUNCATE",
        2,
        "DELETE FROM is the DML command that removes specific rows from a table based on a WHERE condition. DROP removes the entire table structure."
    ],
    [
        "What does DML stand for?",
        "Data Management Language",
        "Data Manipulation Language",
        "Database Modification Language",
        "Direct Manipulation Logic",
        1,
        "DML (Data Manipulation Language) refers to SQL commands that change or retrieve actual data stored in tables, including INSERT, UPDATE, and DELETE."
    ],
    [
        "Which statement correctly inserts a new employee?",
        "INSERT Employees VALUES (101, 'John');",
        "ADD INTO Employees (ID, Name) VALUES (101, 'John');",
        "INSERT INTO Employees (ID, Name) VALUES (101, 'John');",
        "UPDATE Employees SET ID=101, Name='John';",
        2,
        "The correct syntax requires INSERT INTO followed by the table name, column list in parentheses, and VALUES with corresponding data."
    ],
    [
        "What should you verify before inserting data into a table?",
        "Table color scheme",
        "Data types and constraints match",
        "Number of users online",
        "Database version",
        1,
        "INSERT values must match column data types and constraints (like NOT NULL, UNIQUE) to successfully add data without errors."
    ],
    [
        "Which command is used to modify existing data in a table?",
        "MODIFY",
        "CHANGE",
        "UPDATE",
        "ALTER",
        2,
        "UPDATE is the DML command used to modify existing values in table rows, typically used with SET and WHERE clauses."
    ],
    [
        "What is COMMIT used for in data manipulation?",
        "To delete all changes",
        "To save changes permanently",
        "To create a new table",
        "To lock the database",
        1,
        "COMMIT is part of transaction control that permanently saves all changes made during a transaction to the database."
    ],
    [
        "What does ROLLBACK do?",
        "Saves all changes",
        "Cancels all changes since last COMMIT",
        "Creates a backup",
        "Deletes the table",
        1,
        "ROLLBACK undoes all changes made during the current transaction, reverting the database to its state before the transaction began."
    ],
    [
        "Which operation is NOT a DML command?",
        "INSERT",
        "UPDATE",
        "DELETE",
        "CREATE",
        3,
        "CREATE is a DDL (Data Definition Language) command used to create database objects like tables, not to manipulate data within tables."
    ],
    [
        "What happens if you execute: DELETE FROM Employees; without a WHERE clause?",
        "Syntax error occurs",
        "Only inactive employees are deleted",
        "All rows in the Employees table are deleted",
        "Nothing happens",
        2,
        "Without a WHERE clause, DELETE FROM removes every row from the table, though the table structure remains intact."
    ],
    [
        "Why is transaction control important for data manipulation?",
        "It makes queries run faster",
        "It ensures data integrity and allows rollback on errors",
        "It creates automatic backups",
        "It prevents users from logging in",
        1,
        "Transaction control (COMMIT/ROLLBACK) maintains data integrity by ensuring changes are either fully completed or completely undone if errors occur."
    ],
    [
        "Which scenario best demonstrates proper UPDATE usage?",
        "UPDATE Employees SET Salary = Salary + 5000;",
        "UPDATE Employees SET Salary = 70000 WHERE EmployeeID = 101;",
        "UPDATE SET Salary = 70000;",
        "Employees UPDATE Salary = 70000;",
        1,
        "This uses proper syntax with table name, SET clause for the change, and WHERE clause to target a specific employee, preventing unintended updates."
    ],
    
    // MODULE 2: Table Schemas & Keys (Questions 14-26)
    [
        "What does a table schema define?",
        "User permissions only",
        "Table structure: columns, data types, and constraints",
        "Query execution speed",
        "Number of rows allowed",
        1,
        "A schema defines the complete structure of a table including what columns exist, their data types, and any constraints applied to them."
    ],
    [
        "Which SQL command creates a new table?",
        "MAKE TABLE",
        "NEW TABLE",
        "CREATE TABLE",
        "BUILD TABLE",
        2,
        "CREATE TABLE is the DDL command used to define and create a new table with its columns, data types, and constraints."
    ],
    [
        "What command adds a new column to an existing table?",
        "ADD COLUMN table_name",
        "ALTER TABLE table_name ADD column_name datatype",
        "INSERT COLUMN INTO table_name",
        "UPDATE TABLE ADD column_name",
        1,
        "ALTER TABLE is used to modify existing table structures, including adding new columns with specified data types."
    ],
    [
        "What does DROP TABLE do?",
        "Removes all rows but keeps the structure",
        "Deletes specific columns",
        "Completely removes the table and its structure",
        "Hides the table temporarily",
        2,
        "DROP TABLE permanently deletes the entire table including its structure, data, and all associated objects."
    ],
    [
        "What is a Primary Key?",
        "The first column in a table",
        "A unique identifier for each row, must be unique and NOT NULL",
        "A key that can have duplicate values",
        "An optional field",
        1,
        "A Primary Key uniquely identifies each row in a table and cannot contain NULL values or duplicates. Each table can have only one primary key."
    ],
    [
        "How many primary keys can a table have?",
        "Unlimited",
        "Two",
        "Only one",
        "Depends on number of columns",
        2,
        "A table can have only one primary key, though that primary key can consist of multiple columns (composite key)."
    ],
    [
        "What is a Foreign Key used for?",
        "To store encrypted data",
        "To link a field to a primary key in another table",
        "To create backup tables",
        "To speed up queries",
        1,
        "A Foreign Key establishes and enforces a relationship between two tables by referencing the primary key of another table, maintaining referential integrity."
    ],
    [
        "What does referential integrity mean?",
        "All columns must have data",
        "Tables must have indexes",
        "Relationships between tables remain valid and consistent",
        "All queries must use JOIN",
        2,
        "Referential integrity ensures that foreign key values always reference valid primary key values, preventing orphaned records and maintaining data consistency."
    ],
    [
        "Which key type ensures distinct values but may allow NULL?",
        "Primary Key",
        "Foreign Key",
        "Unique Key",
        "Composite Key",
        2,
        "A Unique Key constraint ensures all values in a column are distinct, but unlike Primary Keys, it can allow NULL values."
    ],
    [
        "What is a Composite Key?",
        "A key made of 2 or more columns together",
        "A key that references multiple tables",
        "An encrypted primary key",
        "A temporary key",
        0,
        "A Composite Key uses multiple columns combined to uniquely identify rows when no single column can serve as a unique identifier alone."
    ],
    [
        "In the Orders table example, what does FOREIGN KEY (PersonID) REFERENCES Persons(PersonID) do?",
        "Copies data from Persons table",
        "Creates a link ensuring PersonID in Orders matches a PersonID in Persons",
        "Deletes matching records",
        "Merges both tables",
        1,
        "This foreign key constraint ensures that every PersonID in the Orders table must correspond to a valid PersonID in the Persons table."
    ],
    [
        "What is an Alternate Key?",
        "A backup primary key",
        "A candidate key not chosen as the primary key",
        "A foreign key in another table",
        "A temporary key",
        1,
        "An Alternate Key is a candidate key (could uniquely identify rows) that was not selected as the primary key but still maintains uniqueness."
    ],
    [
        "Why are schemas and keys important?",
        "They make tables colorful",
        "They define organization, ensure uniqueness, and enable efficient querying",
        "They are required only for large databases",
        "They slow down the database",
        1,
        "Schemas and keys are fundamental for organizing data, ensuring data integrity, establishing relationships, and enabling efficient JOINs and queries."
    ],
    
    // MODULE 3: Transactions & Concurrency (Questions 27-38)
    [
        "What is a transaction in SQL?",
        "A bank transfer only",
        "A set of operations treated as a single logical unit",
        "A backup operation",
        "A user login session",
        1,
        "A transaction is a sequence of operations that either all complete successfully together or all fail together, ensuring data consistency."
    ],
    [
        "Which command starts a transaction?",
        "START",
        "BEGIN",
        "INITIATE",
        "TRANSACTION",
        1,
        "BEGIN (or BEGIN TRANSACTION) is the command that starts a new transaction block, grouping subsequent operations together."
    ],
    [
        "What does the 'A' in ACID stand for?",
        "Availability",
        "Atomicity",
        "Authentication",
        "Acceleration",
        1,
        "Atomicity means that all operations in a transaction are treated as a single unit—either all succeed or all fail, with no partial completion."
    ],
    [
        "What does Durability in ACID ensure?",
        "Transactions run quickly",
        "Committed changes persist permanently even after system failures",
        "Multiple users can access data",
        "Data is encrypted",
        1,
        "Durability guarantees that once a transaction is committed, the changes are permanently saved and will survive system crashes or power failures."
    ],
    [
        "What does Isolation in ACID mean?",
        "Transactions are completely independent of each other",
        "Data is stored separately",
        "Users work alone",
        "Tables cannot be joined",
        0,
        "Isolation ensures that concurrent transactions don't interfere with each other, each operating as if it's the only transaction running."
    ],
    [
        "What is Consistency in ACID?",
        "All data must be the same",
        "Database remains valid before and after transactions",
        "Transactions run at the same speed",
        "All tables must have the same structure",
        1,
        "Consistency ensures that transactions move the database from one valid state to another, maintaining all rules, constraints, and integrity."
    ],
    [
        "What is a 'Dirty Read' in concurrency?",
        "Reading corrupted data",
        "Reading uncommitted data from another transaction",
        "Reading deleted records",
        "Reading encrypted data",
        1,
        "A Dirty Read occurs when a transaction reads data that another transaction has modified but not yet committed, which might be rolled back."
    ],
    [
        "What is a 'Lost Update' problem?",
        "Data is accidentally deleted",
        "Transactions overwrite each other's data",
        "Updates fail to save",
        "The database crashes",
        1,
        "Lost Updates occur when two transactions read the same data and then update it based on the read value, causing one update to overwrite the other."
    ],
    [
        "What is locking in database concurrency?",
        "Encrypting the database",
        "Restricting access to data until a transaction finishes",
        "Preventing user logins",
        "Closing the database",
        1,
        "Locking prevents other transactions from accessing data being modified, ensuring that concurrent transactions don't create conflicts or inconsistencies."
    ],
    [
        "In the money transfer example, why is a transaction necessary?",
        "To make it faster",
        "To ensure both debit and credit complete together or not at all",
        "To encrypt the amounts",
        "To notify users",
        1,
        "A transaction ensures atomicity—if money is deducted from one account, it must be added to another; if either fails, both operations are rolled back."
    ],
    [
        "What are isolation levels used for?",
        "To control visibility of changes between concurrent transactions",
        "To speed up queries",
        "To create backups",
        "To assign user permissions",
        0,
        "Isolation levels (like READ COMMITTED, SERIALIZABLE) determine how and when changes made by one transaction become visible to other concurrent transactions."
    ],
    [
        "What happens if an error occurs in a transaction before COMMIT?",
        "Partial changes are saved",
        "ROLLBACK can undo all changes in the transaction",
        "The database crashes",
        "Only the error is saved",
        1,
        "If an error occurs, ROLLBACK can be executed to undo all operations in the transaction, returning the database to its state before BEGIN."
    ],
    
    // MODULE 4: Performance Tuning (Questions 39-50)
    [
        "What is the primary purpose of an index?",
        "To store data",
        "To speed up data retrieval by avoiding full table scans",
        "To encrypt data",
        "To create backups",
        1,
        "Indexes act like a book's index, allowing the database to quickly locate rows without scanning every row in the table."
    ],
    [
        "Which command creates an index?",
        "MAKE INDEX idx_name ON table(column);",
        "CREATE INDEX idx_name ON table(column);",
        "ADD INDEX idx_name TO table(column);",
        "NEW INDEX idx_name FOR table(column);",
        1,
        "CREATE INDEX is the correct syntax for creating an index on specified columns of a table to improve query performance."
    ],
    [
        "What is a drawback of having too many indexes?",
        "Tables become read-only",
        "INSERT, UPDATE, DELETE operations become slower",
        "Data becomes encrypted",
        "Queries always fail",
        1,
        "Each index must be updated whenever data is inserted, updated, or deleted, which adds overhead and slows down write operations."
    ],
    [
        "Which types of columns should typically be indexed?",
        "All columns in every table",
        "Columns frequently used in WHERE, JOIN, ORDER BY clauses",
        "Only primary key columns",
        "Text columns only",
        1,
        "Indexing columns that are frequently searched, joined, or sorted provides the most performance benefit while minimizing the overhead of maintaining unnecessary indexes."
    ],
    [
        "What is a query plan (execution plan)?",
        "A backup schedule",
        "Shows the route the database takes to retrieve or modify data",
        "A list of all queries",
        "User access permissions",
        1,
        "A query plan reveals how the database engine executes a query, including whether it uses indexes, performs table scans, and how it joins tables."
    ],
    [
        "What can you identify by examining a query plan?",
        "User passwords",
        "Bottlenecks and whether indexes are being used",
        "Table colors",
        "Number of users",
        1,
        "Query plans help identify performance issues like full table scans, missing indexes, and inefficient operations that slow down query execution."
    ],
    [
        "What is a full table scan?",
        "Encrypting all data in a table",
        "Reading every row in a table to find matching records",
        "Deleting all rows",
        "Creating a table backup",
        1,
        "A full table scan occurs when the database reads every row in a table because no suitable index exists, which is slow for large tables."
    ],
    [
        "For a table with millions of rows, what improves search performance on the 'grade' column?",
        "Adding more rows",
        "Creating an index on the grade column",
        "Deleting old data",
        "Renaming the table",
        1,
        "An index on the grade column allows the database to quickly locate rows with specific grades without scanning all millions of rows."
    ],
    [
        "When should you avoid creating an index?",
        "On columns frequently searched",
        "On small tables or columns rarely queried",
        "On primary keys",
        "On foreign keys",
        1,
        "Indexes add overhead; on small tables, full scans are already fast, and indexing rarely-used columns wastes resources without providing benefits."
    ],
    [
        "What happens after creating an index on a frequently searched column?",
        "All data is deleted",
        "The database can jump directly to relevant rows",
        "The table becomes read-only",
        "Searches become slower",
        1,
        "With an index, the database engine can use it like a roadmap to quickly locate relevant rows instead of scanning the entire table."
    ],
    [
        "Which statement about indexes is TRUE?",
        "Indexes always improve all database operations",
        "Indexes improve retrieval but may slow down write operations",
        "Every column should always be indexed",
        "Indexes have no drawbacks",
        1,
        "Indexes optimize read operations (SELECT) but add overhead to write operations (INSERT, UPDATE, DELETE) because the indexes must also be maintained."
    ],
    [
        "What is the recommended approach to indexing?",
        "Index every column for maximum speed",
        "Never use indexes",
        "Strategically index only frequently queried, joined, or sorted columns",
        "Index only on Mondays",
        2,
        "Strategic indexing balances read performance improvements against write operation overhead by targeting columns that provide the most query performance benefits."
    ]
];


// Shuffle questions
for (var i = array_length(questions) - 1; i > 0; i--) {
    var j = irandom(i);
    var temp = questions[i];
    questions[i] = questions[j];
    questions[j] = temp;
}

// Answer button properties
answer_button_width = 800;
answer_button_height = 50;
answer_button_spacing = 15;

// UI properties
ui_animation_speed = 0.15;
ui_scale_target = 1.0;
ui_scale_current = 1.0;
box_alpha = 0.0;
box_alpha_target = 1.0;
progress_bar_width = 800;
progress_bar_height = 8;
progress_bar_radius = 4;

// Color scheme
primary_color = make_color_rgb(30, 30, 45);
secondary_color = make_color_rgb(45, 45, 65);
accent_color = make_color_rgb(100, 150, 255);
accent_hover_color = make_color_rgb(120, 170, 255);
success_color = make_color_rgb(76, 175, 80);
error_color = make_color_rgb(244, 67, 54);
warning_color = make_color_rgb(255, 193, 7);
text_primary = c_white;
text_secondary = make_color_rgb(200, 200, 220);
text_muted = make_color_rgb(150, 150, 170);

// Button states
button_hover_scale = 1.02;
button_press_scale = 0.98;

// Shadow states
shadow_alpha = 0.0;
shadow_size = sprite_get_width(spr_evaluation) / 2;

// Corner radius
corner_radius = 20;