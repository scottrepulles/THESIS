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
questions = [
  // MODULE 1: SQL Window Functions (1-10)
  [
    "Which window function will assign unique sequential integers to rows in each partition based on ordering?",
    "RANK()",
    "ROW_NUMBER()",
    "DENSE_RANK()",
    "NTILE()",
    1,
    "ROW_NUMBER() gives a unique sequential number to each row within its partition in defined order; RANK() leaves gaps for ties, DENSE_RANK() doesn’t leave gaps, NTILE() distributes into buckets."
  ],
  [
    "What result do you get if you use RANK() OVER (PARTITION BY dept ORDER BY salary DESC) and two people tie in salary?",
    "They share same rank; next rank is skipped",
    "They share same rank; next rank continues with next integer",
    "Each gets unique rank anyway",
    "Error due to tie",
    0,
    "RANK() gives the same rank for tied values, and skips rank(s) accordingly for subsequent rows."
  ],
  [
    "Which clause in window functions defines the subset of rows relative to current row (preceding/following)?",
    "PARTITION BY",
    "ORDER BY",
    "frame_definition (ROWS/RANGE BETWEEN …)",
    "WINDOW",
    2,
    "frame_definition (ROWS BETWEEN / RANGE BETWEEN) limits the window relative to the current row; PARTITION BY splits groups, ORDER BY orders them."
  ],
  [
    "What does LAG(sales, 1) OVER (ORDER BY date) return?",
    "Next row's sales",
    "Sales from one row before current",
    "Cumulative sum including current",
    "Null always",
    1,
    "LAG with offset 1 gives the value of 'sales' from the previous row in the ordering defined."
  ],
  [
    "Which window function keeps row count unchanged and gives average per department per row?",
    "AVG(salary)",
    "AVG(salary) OVER (PARTITION BY dept)",
    "SUM(salary) GROUP BY dept",
    "AVG(salary) GROUP BY dept",
    1,
    "Using OVER with PARTITION keeps each row while computing average per department; GROUP BY collapses rows."
  ],
  [
    "What difference between RANK() and DENSE_RANK()?",
    "No difference at all",
    "DENSE_RANK() skips ranks on ties, RANK() doesn’t",
    "RANK() skips ranks on ties; DENSE_RANK() doesn’t",
    "DENSE_RANK() always starts at 2",
    2,
    "RANK() will leave gaps in ranking sequence when there are ties; DENSE_RANK() does not leave gaps."
  ],
  [
    "Which frame gives the running total up to current row inclusive?",
    "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW",
    "ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING",
    "ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING",
    "PARTITION BY only",
    0,
    "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW defines the frame from start till current for running total."
  ],
  [
    "What happens if you omit ORDER BY in OVER clause for a ranking function (e.g., ROW_NUMBER)?",
    "It orders by primary key implicitly",
    "It throws syntax error",
    "It treats all rows as equal, arbitrary order",
    "It uses partition columns only",
    2,
    "Without ORDER BY, rows have no defined order; the database may assign them arbitrarily. Ranking functions require ORDER BY for meaningful ranking."
  ],
  [
    "Which window function picks the first value of a column in each partition, ordered by some field?",
    "FIRST_VALUE(column) OVER (…) ORDER BY …",
    "LAST_VALUE(column) OVER (…) ORDER BY …",
    "MIN(column)",
    "LEAD(column)",
    0,
    "FIRST_VALUE returns the first value in the ordered partition; LAST_VALUE returns last. MIN is aggregate, not window per se."
  ],
  [
    "LEAD(salary, 1) OVER (PARTITION BY dept ORDER BY salary) returns:",
    "Next salary in same department ordered incrementally",
    "Previous salary in same department",
    "First salary of department always",
    "Average salary",
    0,
    "LEAD with offset 1 gives next row’s salary in the ordering within that department."
  ],

  // MODULE 2: Common Table Expressions (CTEs) (11-20)
  [
    "What keyword initiates definition of a CTE?",
    "DEFINE",
    "WITH",
    "CTE",
    "TEMP",
    1,
    "WITH begins the definition of a Common Table Expression."
  ],
  [
    "What’s one advantage of using a CTE vs nested subqueries?",
    "CTEs are faster always",
    "CTEs improve readability and can be referenced multiple times",
    "CTEs persist after query runs",
    "CTEs allow DML inside SELECT",
    1,
    "CTEs improve readability and avoid duplicating complex logic; they exist only during query execution."
  ],
  [
    "What is a recursive CTE useful for?",
    "Sorting data",
    "Hierarchical data like organizational chart",
    "Formatting dates",
    "Improving indexing",
    1,
    "Recursive CTEs handle hierarchical or tree-structured data like manager-employee hierarchies."
  ],
  [
    "Syntax for recursive CTE must include:",
    "FILTER clause",
    "UNION or UNION ALL combining anchor and recursive member",
    "TRIGGER",
    "WINDOW FUNCTION",
    1,
    "Recursive CTEs have an anchor member, then UNION ALL to combine recursive member that references the CTE itself."
  ],
  [
    "Which CTE can refer to itself?",
    "Non-recursive CTE",
    "Recursive CTE",
    "Temporary table CTE",
    "Named subquery",
    1,
    "Recursive CTEs refer to themselves to build up result sets iteratively."
  ],
  [
    "Could you reference a CTE multiple times in the same query?",
    "No, only once",
    "Yes, multiple times",
    "Only in WHERE clause",
    "Only in JOIN",
    1,
    "CTEs are named result sets: once defined, you can use them many times within that query."
  ],
  [
    "Does a CTE automatically create an index on its result?",
    "Yes",
    "No",
    "Only in MySQL",
    "Only for recursive CTEs",
    1,
    "CTEs are virtual, temporary result sets; they do not have implicit indexes unless materialized by the database optimizer."
  ],
  [
    "What happens if your CTE has no referencing outside SELECT or JOIN?",
    "It’s ignored / optimized away",
    "It still runs twice",
    "It causes error",
    "Stored in DB permanently",
    0,
    "Unused CTEs may be optimized away by the query planner (not executed if not referenced)."
  ],
  [
    "WITH RECURSIVE path AS ( … ) SELECT * FROM path; This returns …",
    "Just base rows",
    "Rows built via recursion",
    "Error if recursion depth zero",
    "Only totals",
    1,
    "Recursive CTEs accumulate rows via anchor and recursive member, so final result includes both sets."
  ],
  [
    "Can CTEs improve performance always?",
    "Yes, always",
    "No, sometimes they add overhead if materialized poorly",
    "Only on large datasets",
    "Only in Oracle",
    1,
    "CTEs aid readability and logic, but performance depends on optimizer and whether CTE is materialized or inlined."
  ],

  // MODULE 3: Stored Procedures & Triggers (21-30)
  [
    "What is the main difference between a stored procedure and a trigger?",
    "Procedures run automatically, triggers manually",
    "Procedures are reusable blocks; triggers act automatically on data events",
    "Triggers can take parameters, procedures cannot",
    "Procedures can only SELECT",
    1,
    "Stored procedures are invoked manually or via code; triggers execute automatically on specified events (INSERT/UPDATE/DELETE)."
  ],
  [
    "Which is a potential danger of poorly designed triggers?",
    "They can boost performance significantly",
    "They can create infinite loops",
    "They ignore constraints",
    "They never rollback",
    1,
    "Triggers that call actions causing themselves to fire again can lead to infinite recursive loops, causing errors or performance issues."
  ],
  [
    "Stored procedure with parameters allows:",
    "Hardcoding all values",
    "Dynamic behavior based on inputs",
    "Triggers inside procedures",
    "Auto-commit always",
    1,
    "Parameters make stored procedures more flexible and reusable, enabling dynamic behavior."
  ],
  [
    "What timing options are supported for triggers in most databases?",
    "BEFORE or AFTER data event",
    "ONLY BEFORE INSERT",
    "Only AFTER SELECT",
    "Simultaneously BEFORE & AFTER always",
    0,
    "Triggers can typically be defined as BEFORE or AFTER an INSERT, UPDATE, or DELETE event."
  ],
  [
    "Can a trigger modify data in another table?",
    "No, only current table",
    "Yes, triggers often log or update related tables",
    "Only if foreign keys exist",
    "Only in stored procedures",
    1,
    "Triggers can execute any DML including modifying other tables—commonly used for logging or cascade updates."
  ],
  [
    "Are stored procedures transactional by default?",
    "Always yes",
    "Depends on database and how they are written",
    "Never",
    "Only in Oracle",
    1,
    "Stored procedures run inside transactions; whether implicitly or explicitly transactional depends on database configuration."
  ],
  [
    "Which is best practice when using triggers a lot?",
    "Put all logic in triggers",
    "Keep triggers simple and minimal",
    "Disable all triggers",
    "Write all logic in client side",
    1,
    "Triggers fire automatically and can impact performance; keeping them simple helps maintainability and performance."
  ],
  [
    "Can stored procedures return result sets and output parameters?",
    "No",
    "Yes, both result sets and OUTPUT parameters are possible",
    "Only in MySQL",
    "Only if SELECT only",
    1,
    "Most RDBMS support returning result sets and output parameters from stored procedures."
  ],
  [
    "Triggers are fired per row or per statement? Which?",
    "Always per row",
    "Per statement or per row depending on definition",
    "Only per statement",
    "Only per column",
    1,
    "Some triggers are defined FOR EACH ROW or FOR EACH STATEMENT; behavior depends on RDBMS and trigger definition."
  ],
  [
    "Does a trigger always commit automatically outside transactions?",
    "Yes",
    "No, it is part of the same transaction as the triggering statement",
    "Triggers cannot run inside transactions",
    "Depends on SQL dialect",
    1,
    "Triggers execute within the same transaction as the operation that caused them; their actions are rolled back if the transaction fails."
  ],

  // MODULE 4: MySQL Query Optimizer & Cost Model (31-40)
  [
    "What is ‘table scan’ in query execution?",
    "Using only index to find rows",
    "Reading entire table row by row",
    "Skipping partitions",
    "Sorting before returning",
    1,
    "Table scan (type ALL) means the database reads every row because no suitable index was used."
  ],
  [
    "What makes a query ‘sargable’?",
    "Using functions on indexed columns",
    "Using non-equality comparisons only",
    "Writing predicates that allow use of indexes (e.g. column BETWEEN … AND …)",
    "Using subqueries",
    2,
    "Sargable predicates allow efficient use of indexes; wrapping indexed columns in functions prevents index usage."
  ],
  [
    "What role do statistics and histograms play in MySQL’s optimizer?",
    "They decorate output only",
    "They provide data distribution info so optimizer can estimate costs",
    "They replace indexes",
    "They slow down queries",
    1,
    "Statistics (and histograms) help the optimizer estimate row counts and selectivity, which affects join orders and index usage."
  ],
  [
    "In EXPLAIN output, what does type = “ref” mean?",
    "Table full scan",
    "Using index for equality conditions with non-unique keys",
    "Using primary key lookup always",
    "Range scan",
    1,
    "‘ref’ indicates access via index for non-unique equality or prefix matches; better than ALL but not as strong as const."
  ],
  [
    "What is cost-based optimization (CBO)?",
    "Always minimal CPU use",
    "Choosing execution plan based on estimated costs (CPU, IO)",
    "Using only indexes",
    "Ignoring query structure",
    1,
    "Cost-based optimization chooses between multiple query plans by estimating resource costs."
  ],
  [
    "Why might an index scan on disk be worse than a full table scan?",
    "Because disk I/O is expensive and random reads dominate",
    "Because indexes are always slower",
    "Because disk is faster than memory",
    "It isn't worse",
    0,
    "Index scans may cause many random disk I/O operations; full scans can be more sequential and thus faster on disk."
  ],
  [
    "What does EXPLAIN FORMAT=JSON add over tabular EXPLAIN in MySQL?",
    "Nothing extra",
    "It shows cost estimates, used key parts, pushed conditions etc.",
    "It forces index usage",
    "It only works with MySQL 5.6",
    1,
    "FORMAT=JSON gives richer information like cost, which index parts are used, conditions pushed down etc."
  ],
  [
    "What is an optimizer hint used for?",
    "To bypass optimizer entirely",
    "To influence choices like join order, index usage, or access methods",
    "To execute stored procedures",
    "To create temporary tables",
    1,
    "Hints allow developers to influence optimizer behavior when default plan is suboptimal (e.g. FORCE INDEX, JOIN_ORDER)."
  ],
  [
    "What are multi-column indexes best used for?",
    "Queries filtering on first column and optionally subsequent columns in left-most order",
    "Random combinations of columns",
    "Always any two columns together",
    "Only ORDER BY clauses",
    0,
    "Multi-column indexes are most useful when query predicates use leftmost column(s); other orders or omitted columns reduce usefulness."
  ],
  [
    "Why does MySQL need to update histogram statistics?",
    "Only for aesthetics",
    "To maintain accurate selectivity estimates as data changes",
    "To drop old data automatically",
    "It doesn’t matter",
    1,
    "Histograms help optimizer estimate how filter predicates divide data; if stale, optimizer may misestimate and pick bad plans."
  ],

  // MODULE 5: Query Optimization Tools & Techniques (41-50)
  [
    "What is the Slow Query Log in MySQL used for?",
    "Logging successful queries only",
    "Recording queries that exceed defined execution time threshold",
    "Blocking slow queries",
    "Optimizing automatically",
    1,
    "Slow Query Log captures queries whose execution time exceeds a configurable threshold; helpful to identify performance bottlenecks."
  ],
  [
    "What does EXPLAIN output “possible_keys” show?",
    "Keys definitely used",
    "Keys that the optimizer considers could be used",
    "All existing keys in database",
    "Keys that are invalid",
    1,
    "possible_keys lists indexes the optimizer might use; “key” shows the one actually used in the execution plan."
  ],
  [
    "What is the Performance Schema for?",
    "Storing backup files",
    "Monitoring internal server execution and performance metrics",
    "Creating visual dashboards only",
    "Encrypting storage",
    1,
    "Performance Schema allows collection of fine-grained performance data (I/O waits, statements history, index usage etc.) for diagnosing issues."
  ],
  [
    "When would FORCING JOIN_ORDER be useful?",
    "Always",
    "When optimizer picks a suboptimal join order for complex multi-table joins",
    "Never",
    "Only in recursive queries",
    1,
    "If optimizer misorders joins due to poor statistics, forcing join order with hints may improve performance."
  ],
  [
    "What makes a query not use an index even if index exists on column in WHERE?",
    "Column comparison using functions, e.g. YEAR(date_col) = 2020",
    "Using BETWEEN",
    "Using IN clause",
    "Ordering by the indexed column",
    0,
    "Using functions on indexed column invalidates index usage as it changes the values before comparison; non-sargable."
  ],
  [
    "How can query_rewrite plugin help performance?",
    "Rewrite queries without changing application code",
    "Only change queries manually",
    "Rewrite only SELECT statements",
    "Disable optimizer",
    0,
    "Query rewrite plugin allows defining replacement rules so application SQL queries are rewritten before optimization."
  ],
  [
    "Which tool/view helps identify unused indexes?",
    "INFORMATION_SCHEMA.TABLES",
    "sys.schema_unused_indexes (or similar)",
    "EXPLAIN SELECT …",
    "Performance Schema events only",
    1,
    "MySQL sys schema has views that show index usage and help identify indexes that are rarely or never used for potential removal."
  ],
  [
    "Best practice for keeping optimizer statistics fresh is to:",
    "Never run ANALYZE",
    "Run ANALYZE TABLE or update HISTOGRAM periodically",
    "Disable histograms",
    "Only collect stats on primary keys",
    1,
    "Regularly updating statistics and histograms ensures optimizer makes well-informed decisions."
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