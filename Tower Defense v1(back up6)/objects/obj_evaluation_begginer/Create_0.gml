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

// Question data structure
questions = [
    // MODULE 1
    [
        "What does the SELECT statement do in SQL?",
        "Deletes data from a table",
        "Retrieves or displays data from a database table",
        "Updates existing records",
        "Creates a new table",
        1,
        "The SELECT statement is fundamental to SQL and is used to fetch or display data stored in a database table."
    ],
    [
        "What does the asterisk (*) symbol mean in this query: SELECT * FROM Clients;",
        "Multiply all values",
        "Select all fields/columns",
        "Delete all records",
        "Count all rows",
        1,
        "The asterisk (*) is a wildcard symbol in SQL that means 'select all fields.'"
    ],
    [
        "Which of the following is the correct syntax for selecting specific columns?",
        "GET column1, column2 FROM table_name;",
        "SELECT column1, column2 FROM table_name;",
        "RETRIEVE column1, column2 FROM table_name;",
        "FETCH column1, column2 FROM table_name;",
        1,
        "The correct SQL syntax uses the SELECT keyword followed by the column names, then the FROM keyword with the table name."
    ],
    [
        "Why is it recommended to list specific columns instead of using * in production?",
        "It looks more professional",
        "For better performance",
        "To confuse hackers",
        "It's a legal requirement",
        1,
        "Listing specific columns instead of using SELECT * improves performance because the database only retrieves the data you actually need."
    ],
    
    // MODULE 2
    [
        "What is the purpose of the WHERE clause?",
        "To sort data",
        "To filter rows based on specific conditions",
        "To join tables",
        "To group data",
        1,
        "The WHERE clause is used to filter rows that meet specific conditions."
    ],
    [
        "In the query SELECT * FROM Customers WHERE Country = 'Mexico';, what does this return?",
        "All customers from all countries",
        "Only customers from Mexico",
        "All countries except Mexico",
        "The count of Mexican customers",
        1,
        "This query filters the Customers table to return only rows where the Country column equals 'Mexico'."
    ],
    [
        "How should text values be formatted in a WHERE clause?",
        "Without any special formatting",
        "In parentheses",
        "In quotes",
        "In brackets",
        2,
        "Text values in SQL must be enclosed in quotes (single or double, depending on the database)."
    ],
    [
        "Which query correctly filters by a numeric field?",
        "WHERE CustomerID = '1'",
        "WHERE CustomerID = 1",
        "WHERE CustomerID == 1",
        "WHERE CustomerID EQUALS 1",
        1,
        "Numeric values in SQL don't require quotes. The correct syntax uses a single equals sign (=) without quotes around the number."
    ],
    [
        "Which operator would you use to find values NOT equal to a specific value?",
        "!=",
        "<>",
        "NOT=",
        "Both A and B are correct in most databases",
        3,
        "Both <> and != are used to check for inequality in SQL."
    ],
    [
        "Which of these is NOT a common SQL operator mentioned in the lesson?",
        "BETWEEN",
        "LIKE",
        "CONTAINS",
        "IN",
        2,
        "The lesson mentions BETWEEN, LIKE, and IN as common operators. CONTAINS is not a standard SQL operator in the WHERE clause."
    ],
    
    // MODULE 3
    [
        "What does ORDER BY do by default?",
        "Sorts in descending order",
        "Sorts in ascending order",
        "Sorts randomly",
        "Doesn't sort at all",
        1,
        "By default, ORDER BY sorts data in ascending order (A-Z for text, lowest to highest for numbers)."
    ],
    [
        "How do you sort data in descending order?",
        "Add ASC after the column name",
        "Add DESC after the column name",
        "Add DOWN after the column name",
        "Add REVERSE after the column name",
        1,
        "To sort in descending order (Z-A or highest to lowest), you add the DESC keyword after the column name in the ORDER BY clause."
    ],
    [
        "What does this query do? SELECT * FROM Customers ORDER BY Country, CustomerName;",
        "Sorts only by Country",
        "Sorts by Country, then by CustomerName within each country",
        "Sorts only by CustomerName",
        "Creates an error",
        1,
        "When you specify multiple columns in ORDER BY, SQL sorts by the first column, then uses the second column to break ties."
    ],
    [
        "What does LIMIT do in a SQL query?",
        "Limits the number of columns returned",
        "Restricts the number of rows returned",
        "Limits the size of each field",
        "Restricts user permissions",
        1,
        "The LIMIT clause restricts how many rows are returned by a query."
    ],
    [
        "In the query SELECT * FROM Orders LIMIT 10 OFFSET 15;, what happens?",
        "Returns the first 10 rows",
        "Skips the first 15 rows and returns the next 10",
        "Returns rows 10 through 15",
        "Returns 25 total rows",
        1,
        "OFFSET tells SQL to skip a specified number of rows before starting to return results."
    ],
    [
        "What does this query return? SELECT * FROM employees ORDER BY salary DESC LIMIT 5;",
        "The 5 lowest-paid employees",
        "The 5 highest-paid employees",
        "All employees sorted by salary",
        "5 random employees",
        1,
        "This query sorts employees by salary in descending order (highest first) and then limits the results to 5 rows."
    ],
    
    // MODULE 4
    [
        "What do aggregate functions do?",
        "Work on a single row at a time",
        "Work on multiple rows and return a single summary value",
        "Create new tables",
        "Delete data",
        1,
        "Aggregate functions perform calculations across multiple rows of data and return a single result value."
    ],
    [
        "Which aggregate function would you use to count the number of rows?",
        "SUM()",
        "TOTAL()",
        "COUNT()",
        "NUMBER()",
        2,
        "The COUNT() function is specifically designed to count the number of rows in a result set."
    ],
    [
        "What does this query return? SELECT AVG(score) AS avg_score FROM ExamResults WHERE exam_id = 101;",
        "The total of all scores",
        "The average score for exam 101",
        "The number of students who took exam 101",
        "The highest score on exam 101",
        1,
        "The AVG() function calculates the average (mean) of numeric values."
    ],
    [
        "Which function finds the smallest value in a column?",
        "SMALL()",
        "LEAST()",
        "MIN()",
        "BOTTOM()",
        2,
        "The MIN() function returns the minimum (smallest) value from a set of values."
    ],
    [
        "How do aggregate functions handle NULL values?",
        "They convert them to zero",
        "They ignore them (except COUNT(*))",
        "They cause an error",
        "They convert them to empty strings",
        1,
        "Most aggregate functions like SUM(), AVG(), MIN(), and MAX() ignore NULL values in their calculations."
    ],
    [
        "What's the difference between COUNT(*) and COUNT(column_name)?",
        "There is no difference",
        "COUNT(*) counts all rows; COUNT(column_name) counts only non-NULL values",
        "COUNT(*) is faster",
        "COUNT(column_name) counts columns instead of rows",
        1,
        "COUNT(*) counts every row regardless of NULL values, while COUNT(column_name) only counts rows where that specific column has a non-NULL value."
    ],
    
    // MODULE 5
    [
        "What does GROUP BY do?",
        "Deletes duplicate rows",
        "Organizes rows into groups sharing common column values",
        "Sorts data alphabetically",
        "Joins multiple tables",
        1,
        "GROUP BY organizes rows that have the same values in specified columns into summary rows."
    ],
    [
        "In this query, what does it return? SELECT Country, COUNT(CustomerID) AS CustomerCount FROM Customers GROUP BY Country;",
        "All customers listed by country",
        "The number of customers in each country",
        "Only countries with customers",
        "Both B and C are correct",
        3,
        "This query groups customers by country and counts how many customers are in each country."
    ],
    [
        "What is the main difference between WHERE and HAVING?",
        "There is no difference",
        "WHERE filters rows before grouping; HAVING filters groups after aggregation",
        "WHERE is faster",
        "HAVING can only be used with JOIN",
        1,
        "WHERE filters individual rows before they're grouped, while HAVING filters the groups themselves after aggregation has occurred."
    ],
    [
        "Which query correctly uses HAVING?",
        "SELECT Country FROM Customers HAVING Country = 'USA';",
        "SELECT Country, COUNT(*) AS cnt FROM Customers GROUP BY Country HAVING cnt > 5;",
        "SELECT * FROM Customers HAVING CustomerID > 10;",
        "HAVING COUNT(*) > 5 SELECT Country FROM Customers;",
        1,
        "HAVING must be used with GROUP BY and typically filters based on aggregate functions."
    ],
    [
        "What's a key rule about columns in SELECT when using GROUP BY?",
        "You can select any column",
        "Non-aggregated columns in SELECT must appear in GROUP BY",
        "You can only select one column",
        "You must use aliases",
        1,
        "When using GROUP BY, any column in the SELECT clause that isn't used in an aggregate function must be included in the GROUP BY clause."
    ],
    [
        "What does this complete query do? SELECT Country, COUNT(CustomerID) AS CustomerCount FROM Customers GROUP BY Country HAVING COUNT(CustomerID) > 5 ORDER BY CustomerCount DESC;",
        "Shows all countries with their customer counts",
        "Shows countries with more than 5 customers, sorted by count (highest first)",
        "Shows only 5 countries",
        "Creates an error",
        1,
        "This query groups customers by country, counts them, filters to show only countries with more than 5 customers using HAVING, and then sorts the results."
    ],
    
    // MODULE 6
    [
        "What is a JOIN in SQL?",
        "A way to delete data",
        "A clause that combines rows from two or more tables using matching columns",
        "A function to sort data",
        "A type of subquery",
        1,
        "A JOIN combines rows from multiple tables based on a related column between them."
    ],
    [
        "What does an INNER JOIN return?",
        "All rows from both tables",
        "Only rows with matches in both tables",
        "All rows from the left table",
        "All rows from the right table",
        1,
        "INNER JOIN returns only the rows where there is a match in both tables based on the join condition."
    ],
    [
        "What happens with a LEFT JOIN when there's no match in the right table?",
        "The row is excluded",
        "The row appears with NULL values for right table columns",
        "An error occurs",
        "The row is duplicated",
        1,
        "A LEFT JOIN returns all rows from the left table regardless of whether there's a match in the right table."
    ],
    [
        "In this query, what will be returned? SELECT Customers.CustomerName, Orders.OrderID FROM Customers LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;",
        "Only customers who have placed orders",
        "All customers, including those without orders (OrderID will be NULL for customers without orders)",
        "Only orders without customers",
        "All orders",
        1,
        "This LEFT JOIN ensures all customers from the Customers table are returned."
    ],
    [
        "What's the difference between LEFT JOIN and RIGHT JOIN?",
        "There is no difference",
        "LEFT JOIN keeps all rows from the left table; RIGHT JOIN keeps all rows from the right table",
        "LEFT JOIN is faster",
        "RIGHT JOIN requires more memory",
        1,
        "LEFT JOIN preserves all rows from the left (first) table and adds matching data from the right table."
    ],
    [
        "What does a FULL OUTER JOIN return?",
        "Only matching rows",
        "All rows from the left table",
        "All rows from the right table",
        "All rows from both tables, with NULL where no match exists",
        3,
        "FULL OUTER JOIN returns all rows from both tables. When a row in one table doesn't have a match in the other table, the result will contain NULL values."
    ],
    [
        "Why should you prefix columns with table names in JOIN queries?",
        "It's required by SQL syntax",
        "To avoid ambiguity when columns have the same name in different tables",
        "It makes queries run faster",
        "It's only needed for INNER JOIN",
        1,
        "When joining tables, both tables might have columns with the same name. Prefixing with the table name clarifies which table's column you're referring to."
    ],
    [
        "Which type of JOIN would you use to find all employees, including those who haven't handled any orders?",
        "INNER JOIN from Orders to Employees",
        "LEFT JOIN from Employees to Orders",
        "RIGHT JOIN from Orders to Employees",
        "Both B and C are correct",
        3,
        "You could use LEFT JOIN with Employees as the left table and Orders as the right, or RIGHT JOIN with Orders as the left table and Employees as the right."
    ],
    
    // MODULE 7
    [
        "What is a subquery?",
        "A query that runs slower than normal queries",
        "A SQL query placed inside another query",
        "A query that only returns one row",
        "A query without a WHERE clause",
        1,
        "A subquery (or nested query) is a complete SQL query embedded within another query."
    ],
    [
        "Where can subqueries be used?",
        "Only in WHERE clause",
        "Only in SELECT clause",
        "In WHERE, SELECT, FROM clauses and data modification statements",
        "Only in JOIN conditions",
        2,
        "Subqueries are versatile and can appear in multiple places: inside WHERE clauses for filtering, in SELECT clauses for calculations, in FROM clauses as derived tables, and in INSERT, UPDATE, and DELETE statements."
    ],
    [
        "What does this subquery do? SELECT Name, Salary FROM Employees WHERE Salary > (SELECT AVG(Salary) FROM Employees);",
        "Shows all employees",
        "Shows employees earning above average salary",
        "Shows the average salary",
        "Shows the highest salary",
        1,
        "The inner subquery calculates the average salary across all employees. The outer query then filters to show only employees whose salary exceeds this average value."
    ],
    [
        "In this query, what does the subquery return? SELECT EmployeeName, Salary, (SELECT AVG(Salary) FROM Employees) AS AvgSalary FROM Employees;",
        "Each employee's individual average",
        "The overall average salary for all employees (shown for each row)",
        "Only employees above average",
        "The department average",
        1,
        "This subquery in the SELECT clause calculates the overall average salary once and displays it alongside each employee's information."
    ],
    [
        "What is a derived table?",
        "A physical table in the database",
        "A subquery used in the FROM clause that acts as a temporary table",
        "A table that's been deleted",
        "A table created by a JOIN",
        1,
        "A derived table is a subquery placed in the FROM clause that functions as a temporary table for the duration of the query."
    ],
    [
        "What's the difference between correlated and non-correlated subqueries?",
        "Correlated subqueries are faster",
        "Non-correlated subqueries run independently once; correlated subqueries reference the outer query and run repeatedly",
        "There is no difference",
        "Correlated subqueries can't be used in WHERE clauses",
        1,
        "Non-correlated subqueries are independent and execute once. Correlated subqueries reference columns from the outer query and execute once for each row."
    ],
    [
        "Can subqueries be used in INSERT statements?",
        "No, never",
        "Yes, to insert records based on conditions from other tables",
        "Only with INNER JOIN",
        "Only in MySQL",
        1,
        "Subqueries can be used in INSERT statements to add records based on data or conditions from other tables."
    ],
    [
        "What should you watch out for with correlated subqueries?",
        "They always cause errors",
        "Performance issues since they run repeatedly",
        "They can't return NULL values",
        "They only work with numeric data",
        1,
        "Correlated subqueries can have performance implications because they execute once for each row in the outer query."
    ],
    
    // GENERAL/MIXED QUESTIONS
    [
        "Which SQL statement would you use to find the top 3 most expensive products?",
        "SELECT * FROM Products WHERE Price = MAX;",
        "SELECT * FROM Products ORDER BY Price DESC LIMIT 3;",
        "SELECT TOP(3) FROM Products;",
        "SELECT * FROM Products GROUP BY Price LIMIT 3;",
        1,
        "To find the top 3 most expensive products, you need to sort by price in descending order using ORDER BY Price DESC, then limit the results to 3 rows."
    ],
    [
        "What would this query return? SELECT Country, AVG(Salary) as AvgSal FROM Employees WHERE Department = 'Sales' GROUP BY Country HAVING AVG(Salary) > 50000;",
        "All employees in Sales",
        "Countries where Sales employees have an average salary over 50000",
        "All employees with salary over 50000",
        "The total salary for each country",
        1,
        "This query filters for Sales department (WHERE), groups by country, calculates average salary per country, and filters countries where average exceeds 50000 (HAVING)."
    ],
    [
        "Which clause must come first in a SQL SELECT statement?",
        "WHERE",
        "FROM",
        "SELECT",
        "ORDER BY",
        2,
        "The SELECT clause always comes first in a SELECT statement."
    ],
    [
        "What's wrong with this query? SELECT Department, EmployeeName FROM Employees GROUP BY Department;",
        "Nothing, it's correct",
        "EmployeeName must be in GROUP BY or in an aggregate function",
        "GROUP BY should come before SELECT",
        "Missing WHERE clause",
        1,
        "When using GROUP BY, any column in SELECT that isn't part of the GROUP BY clause must be used within an aggregate function."
    ],
    [
        "If you want to find customers who haven't placed any orders, which JOIN type is most appropriate?",
        "INNER JOIN",
        "LEFT JOIN from Customers to Orders, filtering for NULL OrderID",
        "RIGHT JOIN from Orders to Customers",
        "FULL OUTER JOIN",
        1,
        "A LEFT JOIN from Customers to Orders will return all customers. Those without orders will have NULL in the OrderID column."
    ],
    [
        "Which aggregate function would be best to find how many unique countries are in a Customers table?",
        "SUM(Country)",
        "COUNT(*)",
        "COUNT(DISTINCT Country)",
        "AVG(Country)",
        2,
        "COUNT(DISTINCT column_name) counts only the unique values in a column, eliminating duplicates."
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
