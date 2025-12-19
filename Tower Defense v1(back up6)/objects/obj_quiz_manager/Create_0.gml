	// ============================================================
	// 🧠 SQL Defender - Quiz & Tutorial Manager
	// ============================================================

	// =======================
	// Quiz system variables
	// =======================
	global.quiz_active = false;
	global.quiz_question = "";
	global.quiz_options = [];
	global.quiz_correct_answer = 0;
	global.quiz_difficulty = "easy"; // easy, medium, hard
	global.quiz_timer = 0;
	global.quiz_time_limit = 0;
	global.quiz_reward = 0;
	global.quiz_answered = false;
	global.quiz_correct = false;
	global.quiz_attempts = 2; // Limit to 2 attempts per quiz
	quiz_last_wrong = false; // Was last answer wrong, to show message
	global.quiz_selected_index = -1; // Track last selected option
	room_quiz_limit = irandom_range(5, 9); // Limit quizzes per room (random 3-5)
	room_quiz_count = 0; // Track how many quizzes shown in this room

	// Extreme quiz typing variables
	global.quiz_typing_answer = ""; // Current typed answer for extreme quizzes
	global.quiz_correct_answer_text = ""; // Correct answer text for extreme quizzes

	// =======================
	// Tutorial (Guide) system
	// =======================
	global.tutorial_active = true;
	global.tutorial_step = 0;
	global.tutorial_message = "";
	global.tutorial_visible = true;

	// Tutorial messages (basic guide for beginners)
	tutorial_messages = [
	    "👋 Welcome to SQL Defender! Let's learn how to defend your database.",
	    "💡 Your goal is to protect the database by answering SQL questions correctly.",
	    "🧱 Each correct answer strengthens your defense towers.",
	    "⚠️ Wrong answers will spawn enemies — be careful!",
	    "📜 Example: To get all towers, you use 'SELECT * FROM tower;'",
	    "🏗️ Ready? Let's start your Beginner Quiz!"
	];

	// =======================
	// Quiz random popup system
	// =======================
	// quiz_next_time = irandom_range(room_speed * 20, room_speed * 40); // 20-40 sec (now set in start_next_wave)
	quiz_warning_time = 5 * room_speed;
	quiz_warning_active = false;
	quiz_warning_timer = 0;
	quiz_warning_difficulty = "easy";
	quiz_next_time = -1;
	global.quiz_active = false;

	show_debug_message("Quiz manager created successfully!");
	if (variable_global_exists("quiz_next_time")) {
	    show_debug_message("Next quiz in: " + string(quiz_next_time / room_speed) + " seconds");
	}

	// =======================
	// Quiz Questions Database
	// =======================
	quiz_questions = [
	    // EASY QUESTIONS
	    {
	        question: "What SQL statement would you use to get all rows from the tower table?",
	        options: ["SELECT * FROM tower;", "GET ALL FROM tower;", "SHOW tower;", "SELECT tower_type FROM tower;"],
	        correct: 0,
	        difficulty: "easy"
	    },
	    {
	        question: "Which query would return only the row for the archer tower?",
	        options: ["SELECT * FROM tower WHERE tower_type = 'archer';", "SELECT * FROM tower WHERE tower_type = 'Archer';", "SELECT * FROM tower WHERE Id = 2;", "SELECT archer FROM tower;"],
	        correct: 0,
	        difficulty: "easy"
	    },
	    {
	        question: "How do you sort the towers alphabetically by type?",
	        options: ["SELECT * FROM tower ORDER BY tower_type;", "SELECT * FROM tower SORT BY tower_type;", "SELECT * FROM tower GROUP BY tower_type;", "SELECT * FROM tower WHERE tower_type = 'archer';"],
	        correct: 0,
	        difficulty: "easy"
	    },
	    {
	        question: "What is the most secure way to prevent SQL injection in user input?",
	        options: ["Use prepared statements", "Remove all quotes from input", "Convert input to uppercase", "Add extra semicolons"],
	        correct: 0,
	        difficulty: "easy"
	    },
	    {
	        question: "Which of these is a common SQL injection attack pattern?",
	        options: ["'; DROP TABLE users; --", "SELECT * FROM users", "WHERE id = 1", "ORDER BY name"],
	        correct: 0,
	        difficulty: "easy"
	    },
		{
    question: "What SQL statement would you use to get all rows from the tower table?",
    options: ["SELECT * FROM tower;", "GET ALL FROM tower;", "SHOW tower;", "SELECT tower_type FROM tower;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which query would return only the row for the archer tower?",
    options: ["SELECT * FROM tower WHERE tower_type = 'archer';", "SELECT * FROM tower WHERE tower_type = 'Archer';", "SELECT * FROM tower WHERE Id = 2;", "SELECT archer FROM tower;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How do you sort the towers alphabetically by type?",
    options: ["SELECT * FROM tower ORDER BY tower_type;", "SELECT * FROM tower SORT BY tower_type;", "SELECT * FROM tower GROUP BY tower_type;", "SELECT * FROM tower WHERE tower_type = 'archer';"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What is the most secure way to prevent SQL injection in user input?",
    options: ["Use prepared statements", "Remove all quotes from input", "Convert input to uppercase", "Add extra semicolons"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which of these is a common SQL injection attack pattern?",
    options: ["'; DROP TABLE users; --", "SELECT * FROM users", "WHERE id = 1", "ORDER BY name"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which SQL keyword is used to filter rows based on a condition?",
    options: ["WHERE", "FILTER", "IF", "CONDITION"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What does the SELECT keyword do in SQL?",
    options: ["Retrieves data from database", "Deletes data from database", "Updates data in database", "Creates new table"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How would you retrieve only the tower_type column from the tower table?",
    options: ["SELECT tower_type FROM tower;", "GET tower_type FROM tower;", "SELECT * FROM tower_type;", "SHOW tower_type;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which SQL statement is used to add new data to a table?",
    options: ["INSERT INTO", "ADD TO", "CREATE IN", "APPEND TO"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What does the asterisk symbol mean in SELECT queries?",
    options: ["Select all columns", "Select all rows", "Multiply values", "Comment marker"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which keyword removes duplicate rows from query results?",
    options: ["DISTINCT", "UNIQUE", "SINGLE", "NODUPE"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How do you limit results to show only the first five rows?",
    options: ["SELECT * FROM tower LIMIT 5;", "SELECT * FROM tower TOP 5;", "SELECT * FROM tower MAX 5;", "SELECT * FROM tower COUNT 5;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What SQL command is used to modify existing data in a table?",
    options: ["UPDATE", "MODIFY", "CHANGE", "EDIT"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which operator checks if a value is NULL in SQL?",
    options: ["IS NULL", "= NULL", "== NULL", "EQUALS NULL"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How do you delete all rows from the tower table?",
    options: ["DELETE FROM tower;", "REMOVE FROM tower;", "DROP tower;", "CLEAR tower;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which keyword sorts query results in descending order?",
    options: ["DESC", "DOWN", "REVERSE", "DESCENDING"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What does SQL stand for?",
    options: ["Structured Query Language", "Simple Question Language", "System Quality Language", "Standard Query List"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which statement creates a new database table?",
    options: ["CREATE TABLE", "NEW TABLE", "MAKE TABLE", "BUILD TABLE"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How do you select towers with damage greater than fifty?",
    options: ["SELECT * FROM tower WHERE damage > 50;", "SELECT * FROM tower WHERE damage = 50;", "SELECT * FROM tower IF damage > 50;", "SELECT * FROM tower DAMAGE > 50;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which clause combines multiple conditions with logical AND in SQL?",
    options: ["WHERE condition1 AND condition2", "WHERE condition1 + condition2", "WHERE condition1 WITH condition2", "WHERE condition1, condition2"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What keyword retrieves the highest value from a column?",
    options: ["MAX", "HIGHEST", "TOP", "MAXIMUM"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How do you count the total number of rows in the tower table?",
    options: ["SELECT COUNT(*) FROM tower;", "SELECT TOTAL(*) FROM tower;", "SELECT NUMBER(*) FROM tower;", "SELECT SUM(*) FROM tower;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which operator checks if a value matches any value in a list?",
    options: ["IN", "ANY", "MATCH", "EQUALS"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What does the LIKE operator do in SQL queries?",
    options: ["Pattern matching in strings", "Exact string comparison", "Numerical comparison", "Date comparison"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which wildcard character represents any sequence of characters in LIKE patterns?",
    options: ["%", "*", "?", "#"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "What does the MIN function return from a column?",
    options: ["Lowest value", "Minimum length", "First row", "Smallest table"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which statement permanently removes a table from the database?",
    options: ["DROP TABLE tower;", "DELETE TABLE tower;", "REMOVE TABLE tower;", "DESTROY TABLE tower;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "How do you calculate the average damage of all towers?",
    options: ["SELECT AVG(damage) FROM tower;", "SELECT AVERAGE(damage) FROM tower;", "SELECT MEAN(damage) FROM tower;", "SELECT SUM(damage)/COUNT(*) FROM tower;"],
    correct: 0,
    difficulty: "easy"
},
{
    question: "Which keyword combines results from two SELECT statements?",
    options: ["UNION", "COMBINE", "MERGE", "JOIN"],
    correct: 0,
    difficulty: "easy"
},

	    // MEDIUM QUESTIONS
	    {
	        question: "Which query counts the number of tower types?",
	        options: ["SELECT COUNT(*) FROM tower;", "SELECT SUM(*) FROM tower;", "SELECT COUNT(tower_type) FROM tower WHERE tower_type = 'archer';", "SELECT tower_type FROM tower;"],
	        correct: 0,
	        difficulty: "medium"
	    },
	    {
	        question: "How do you rename the column tower_type to type in your result?",
	        options: ["SELECT tower_type AS type FROM tower;", "SELECT tower_type type FROM tower;", "SELECT type FROM tower;", "SELECT tower_type RENAME type FROM tower;"],
	        correct: 0,
	        difficulty: "medium"
	    },
	    {
	        question: "Which query shows the number of each tower type?",
	        options: ["SELECT tower_type, COUNT(*) FROM tower GROUP BY tower_type;", "SELECT COUNT(tower_type) FROM tower;", "SELECT * FROM tower GROUP BY tower_type;", "SELECT tower_type FROM tower;"],
	        correct: 0,
	        difficulty: "medium"
	    },
	    {
	        question: "What is the purpose of parameterized queries in preventing SQL injection?",
	        options: ["Separate SQL code from data", "Make queries run faster", "Reduce memory usage", "Enable better caching"],
	        correct: 0,
	        difficulty: "medium"
	    },
	    {
	        question: "Which character sequence is commonly used to comment out the rest of a SQL query?",
	        options: ["--", "/*", "//", "#"],
	        correct: 0,
	        difficulty: "medium"
	    },
	    {
	        question: "What does UNION-based SQL injection exploit?",
	        options: ["The ability to combine results from multiple SELECT statements", "Database connection pooling", "Query optimization", "Index usage"],
	        correct: 0,
	        difficulty: "medium"
	    },
	    // HARD QUESTIONS
	    {
	        question: "Which query finds all towers except those of type 'defense'?",
	        options: ["SELECT * FROM tower WHERE tower_type <> 'defense';", "SELECT * FROM tower WHERE tower_type = 'defense';", "SELECT * FROM tower WHERE NOT tower_type = 'defense';", "SELECT * FROM tower WHERE tower_type != 'defense';"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "If you had another table tower_stats with a foreign key tower_id, how would you join it to get all tower types and their stats?",
	        options: ["SELECT * FROM tower INNER JOIN tower_stats ON tower.Id = tower_stats.tower_id;", "SELECT * FROM tower, tower_stats;", "SELECT * FROM tower LEFT JOIN tower_stats;", "SELECT * FROM tower JOIN tower_stats;"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "Which SQL command would you use to permanently remove the tower table and all its data?",
	        options: ["DROP TABLE tower;", "DELETE FROM tower;", "REMOVE tower;", "TRUNCATE tower;"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "How would you ensure that changes to the tower table can be undone if something goes wrong?",
	        options: ["START TRANSACTION; ... ROLLBACK;", "BEGIN; ... END;", "SAVEPOINT; ... COMMIT;", "UNDO; ... REDO;"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "What is the primary difference between blind SQL injection and error-based SQL injection?",
	        options: ["Blind injection doesn't return visible errors, error-based does", "Blind injection is faster", "Error-based injection is more secure", "There is no difference"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "Which technique is used in time-based blind SQL injection attacks?",
	        options: ["SLEEP() or WAITFOR DELAY functions", "UNION statements", "Subqueries", "JOIN operations"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "What is the main purpose of input validation in preventing SQL injection?",
	        options: ["To sanitize and validate user input before processing", "To make queries run faster", "To improve database performance", "To enable better error handling"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    {
	        question: "Which SQL injection technique uses boolean-based queries to extract data?",
	        options: ["Boolean-based blind SQL injection", "Union-based injection", "Error-based injection", "Time-based injection"],
	        correct: 0,
	        difficulty: "hard"
	    },
	    // EXTREME QUESTIONS (typing answers)
	    {
	        question: "Write a SQL query to find all towers with damage greater than 50, sorted by damage descending, and limit to top 5 results.",
	        answer: "SELECT * FROM tower WHERE damage > 50 ORDER BY damage DESC LIMIT 5;",
	        difficulty: "extreme"
	    },
	    {
	        question: "Create a query that joins tower and tower_stats tables, groups by tower_type, and shows average damage for each type.",
	        answer: "SELECT tower_type, AVG(damage) FROM tower t JOIN tower_stats ts ON t.id = ts.tower_id GROUP BY tower_type;",
	        difficulty: "extreme"
	    },
	    {
	        question: "Write a query to update all archer towers to have 25% more damage using a subquery.",
	        answer: "UPDATE tower SET damage = damage * 1.25 WHERE tower_type = 'archer';",
	        difficulty: "extreme"
	    },
	    {
	        question: "Create a view that shows tower efficiency (damage per cost) for all towers with cost > 100.",
	        answer: "CREATE VIEW efficient_towers AS SELECT tower_type, damage/cost AS efficiency FROM tower WHERE cost > 100;",
	        difficulty: "extreme"
	    },
	    {
	        question: "Write a query using window functions to rank towers by damage within each tower type.",
	        answer: "SELECT tower_type, damage, RANK() OVER (PARTITION BY tower_type ORDER BY damage DESC) as rank FROM tower;",
	        difficulty: "extreme"
	    },
	    {
	        question: "Write a secure prepared statement to prevent SQL injection when querying user data by ID.",
	        answer: "PREPARE stmt FROM 'SELECT * FROM users WHERE id = ?'; SET @user_id = ?; EXECUTE stmt USING @user_id;",
	        difficulty: "extreme"
	    },
	    {
	        question: "Write a query to detect potential SQL injection attempts by finding suspicious patterns in user input.",
	        answer: "SELECT * FROM user_input WHERE input LIKE '%--%' OR input LIKE '%UNION%' OR input LIKE '%DROP%' OR input LIKE '%;%';",
	        difficulty: "extreme"
	    },
	    {
	        question: "Create a stored procedure that safely handles user authentication with parameterized queries.",
	        answer: "CREATE PROCEDURE AuthenticateUser(IN username VARCHAR(255), IN password VARCHAR(255)) BEGIN SELECT * FROM users WHERE username = username AND password = password; END;",
	        difficulty: "extreme"
	    },
	    {
	        question: "Write a query to implement input sanitization by escaping special characters in user input.",
	        answer: "SELECT REPLACE(REPLACE(REPLACE(user_input, '''', ''''''), ';', ''), '--', '') AS sanitized_input FROM user_data;",
	        difficulty: "extreme"
	    }
	];

	// =======================
	// UI variables
	// =======================
	quiz_alpha = 0;
	quiz_target_alpha = 0;
	box_width = 700;
	box_height = 400;

	// ============================================================
	// 🧾 QUIZ & TUTORIAL FUNCTIONS
	// ============================================================

	// --- Function: Start Tutorial ---
	function start_tutorial() {
	    global.tutorial_active = true;
	    global.tutorial_step = 0;
	    global.tutorial_message = tutorial_messages[0];
	    global.tutorial_visible = true;
	    show_debug_message("Tutorial started");
	}

	// --- Function: Advance Tutorial ---
	function advance_tutorial() {
	    if (!global.tutorial_active) return;
	    global.tutorial_step += 1;

	    if (global.tutorial_step < array_length(tutorial_messages)) {
	        global.tutorial_message = tutorial_messages[global.tutorial_step];
	    } else {
	        global.tutorial_active = false;
	        global.tutorial_visible = false;
	        show_debug_message("Tutorial finished. Starting Beginner Quiz...");
	        if (wave_is_running()) {
	            start_quiz("easy");
	        }
	        // If not, don't show the quiz until the wave is started
	    }
	}

	// --- Function: Start Quiz ---
	function start_quiz(difficulty) {
	    show_debug_message("start_quiz() called with difficulty: " + difficulty);

	    global.quiz_active = true;
	    global.quiz_difficulty = difficulty;
	    global.quiz_answered = false;
	    global.quiz_correct = false;
	    quiz_last_wrong = false;
	    global.quiz_selected_index = -1;
	    room_quiz_count += 1; // Increment counter when quiz starts

	    // Set time limit, reward, and attempts by room
	    switch (room) {
	        case rm_rank_bronze:
	            global.quiz_time_limit = 60 * room_speed; 
	            global.quiz_reward = 50; 
	            global.quiz_attempts = 2;
	            break;
			case rm_rank_bronze_2:
	            global.quiz_time_limit = 60 * room_speed; 
	            global.quiz_reward = 50; 
	            global.quiz_attempts = 2;
	            break;	
				
				
	        case rm_rank_silver:
	            global.quiz_time_limit = 45 * room_speed; 
	            global.quiz_reward = 100; 
	            global.quiz_attempts = 2;
	            break;
			case rm_rank_platinum:
	            global.quiz_time_limit = 45 * room_speed; 
	            global.quiz_reward = 100; 
	            global.quiz_attempts = 2;
	            break;
				
	        case rm_rank_gold:
	            global.quiz_time_limit = 30 * room_speed; 
	            global.quiz_reward = 200; 
	            global.quiz_attempts = 2;
	            break;
			case rm_rank_gold_2:
	            global.quiz_time_limit = 30 * room_speed; 
	            global.quiz_reward = 200; 
	            global.quiz_attempts = 2;
	            break;	
				
	        case rm_rank_platinum111:
	            global.quiz_time_limit = 60 * room_speed; 
	            global.quiz_reward = 500; 
	            global.quiz_attempts = 1;
	            break;
			case rm_rank_platinum_2:
	            global.quiz_time_limit = 60 * room_speed; 
	            global.quiz_reward = 500; 
	            global.quiz_attempts = 1;
	            break;
	        default:
	            // Fallback for other rooms
	            switch (difficulty) {
	                case "easy": global.quiz_time_limit = 40 * room_speed; global.quiz_reward = 50; break;
	                case "medium": global.quiz_time_limit = 35 * room_speed; global.quiz_reward = 40; break;
	                case "hard": global.quiz_time_limit = 30 * room_speed; global.quiz_reward = 30; break;
	                case "extreme": global.quiz_time_limit = 25 * room_speed; global.quiz_reward = 30; break;
	            }
	            global.quiz_attempts = 1;
	            break;
	    }

	    global.quiz_timer = global.quiz_time_limit;

	    var available_questions = [];
	    for (var i = 0; i < array_length(quiz_questions); i++) {
	        if (quiz_questions[i].difficulty == difficulty) array_push(available_questions, i);
	    }

	    if (array_length(available_questions) > 0) {
	        var random_index = available_questions[irandom(array_length(available_questions) - 1)];
	        var selected_question = quiz_questions[random_index];

	        global.quiz_question = selected_question.question;
        
	        // Handle extreme difficulty (typing) vs multiple choice
	        if (difficulty == "extreme") {
	            global.quiz_options = []; // No options for typing
	            global.quiz_correct_answer = -1; // No correct index for typing
	            global.quiz_correct_answer_text = selected_question.answer;
	            global.quiz_typing_answer = ""; // Reset typing answer
	        } else {
	            global.quiz_options = selected_question.options;
	            global.quiz_correct_answer = selected_question.correct;
	            global.quiz_correct_answer_text = ""; // No text answer for multiple choice
	        }
	    }

	    quiz_target_alpha = 1;
	    // Pause all enemies' movement/animation while quiz is active
	    with (obj_enemy_parent) {
	        if (!variable_instance_exists(id, "saved_path_speed")) saved_path_speed = path_speed;
	        path_speed = 0; // stop following path
	        if (!variable_instance_exists(id, "saved_image_speed")) saved_image_speed = image_speed;
	        image_speed = 0; // pause walk animation
	        // Also freeze manual motion if any
	        hspeed = 0;
	        vspeed = 0;
	    }
	    show_debug_message("Quiz started: " + difficulty);
	}

	// --- Function: Answer Quiz ---
	function answer_quiz(selected_option) {
	    // End on time out
	    if (selected_option == -1) {
	        global.quiz_answered = true;
	        global.quiz_correct = false;
	        quiz_last_wrong = false;
	        if (global.quiz_difficulty == "extreme") {
	            show_debug_message("❌ Time's up! The correct answer was: " + global.quiz_correct_answer_text);
	        } else {
	            show_debug_message("❌ Time's up! The correct answer was: " + global.quiz_options[global.quiz_correct_answer]);
	        }
	        spawn_penalty_monster();
	        alarm[0] = 3 * room_speed;
	        return;
	    }
	    if (global.quiz_answered) return;
    
	    // Handle extreme difficulty (typing) vs multiple choice
	    var is_correct = false;
	    if (global.quiz_difficulty == "extreme") {
	        // For extreme, check if typed answer matches (case insensitive, trimmed)
	        is_correct = (string_upper(string_trim(global.quiz_typing_answer)) == string_upper(string_trim(global.quiz_correct_answer_text)));
	    } else {
	        // For multiple choice, check selected option
	        is_correct = (selected_option == global.quiz_correct_answer);
	    }
    
	    if (is_correct) {
	        global.quiz_answered = true;
	        global.quiz_correct = true;
	        quiz_last_wrong = false;
	        global.quiz_selected_index = selected_option;
	        adjust_money(global.quiz_reward);
	        show_debug_message("✅ Correct! You earned " + string(global.quiz_reward) + " coins!");
	        alarm[0] = 3 * room_speed;
	        return;
	    }
    
	    // Incorrect attempt; decrement and mark wrong
	    global.quiz_attempts -= 1;
	    quiz_last_wrong = true;
	    global.quiz_selected_index = selected_option;
	    if (global.quiz_attempts <= 0) {
	        global.quiz_answered = true;
	        global.quiz_correct = false;
	        if (global.quiz_difficulty == "extreme") {
	            show_debug_message("❌ Out of attempts! The correct answer was: " + global.quiz_correct_answer_text);
	        } else {
	            show_debug_message("❌ Out of attempts! The correct answer was: " + global.quiz_options[global.quiz_correct_answer]);
	        }
	        spawn_penalty_monster();
	        alarm[0] = 3 * room_speed;
	    } else {
	        show_debug_message("❌ Incorrect! Attempts left: " + string(global.quiz_attempts));
	    }
	}

	// --- Function: Spawn Penalty Monster ---
	function spawn_penalty_monster() {
	    var current_path;
	    switch(room) {
	        case rm_rank_bronze_2: current_path = pth_bronze_2; break;
	        case rm_rank_silver: current_path = pth_silver; break;
	        case rm_rank_gold: current_path = pth_gold; break;
	        case rm_rank_platinum111: current_path = pth_platinum111; break;
			case rm_rank_bronze: current_path = pth_bronze; break;
	        case rm_rank_platinum: current_path = pth_platinum; break;
	        case rm_rank_gold_2: current_path = pth_gold_2; break;
	        case rm_rank_platinum_2: current_path = pth_platinum_2; break;
			

			case rm_level_1: current_path = ch_room_path_lvl_1 break;
			case rm_level_2: current_path = ch_room_path_lvl_2 break;
			case rm_level_3: current_path = ch_room_path_lvl_3 break;
			case rm_level_4: current_path = ch_room_path_lvl_4 break;
			case rm_level_5: current_path = ch_room_path_lvl_5 break;
			case rm_level_6: current_path = ch_room_path_lvl_6 break;
			case rm_level_7: current_path = ch_room_path_lvl_7 break;
			case rm_level_8: current_path = ch_room_path_lvl_8 break;
			case rm_level_9: current_path = ch_room_path_lvl_9 break;
			case rm_level_10: current_path = ch_room_path_lvl_10 break;

			case rm_level_model: current_path = pth_bronze; break;
	        default: current_path = path1; break;
	    }

	    var path_start_x = path_get_x(current_path, 0);
	    var path_start_y = path_get_y(current_path, 0);
	    var monster_type = choose(obj_monster_4, obj_monster_boss);
	    var monster_instance = instance_create_layer(path_start_x, path_start_y, "Instances", monster_type);

	    if (monster_instance != noone) {
	        with (monster_instance) path_start(current_path, 2, path_action_stop, true);
	        show_debug_message("⚠️ Penalty monster spawned due to wrong answer!");
	    }
	}					 

	// --- Function: End Quiz ---
	function end_quiz() {
	    global.quiz_active = false;
	    quiz_target_alpha = 0;
	    // Resume enemies' movement/animation after quiz ends
	    with (obj_enemy_parent) {
	        // Restore path speed if we saved it; otherwise fall back to my_speed
	        if (variable_instance_exists(id, "saved_path_speed") && (saved_path_speed != undefined)) {
	            path_speed = saved_path_speed;
	        } else {
	            path_speed = my_speed;
	        }
	        if (variable_instance_exists(id, "saved_path_speed")) saved_path_speed = undefined;

	        // Restore animation speed if saved; otherwise use 1 as a sensible default
	        if (variable_instance_exists(id, "saved_image_speed") && (saved_image_speed != undefined)) {
	            image_speed = saved_image_speed;
	        } else {
	            image_speed = 1;
	        }
	        if (variable_instance_exists(id, "saved_image_speed")) saved_image_speed = undefined;
	    }
	    show_debug_message("Quiz ended");
	}

	// Tutorial is now disabled by default - will only show after wave starts
	// start_tutorial(); // Commented out to prevent quiz popup before game starts
// At the end of obj_quiz_manager Create Event
if (!instance_exists(obj_quiz_timer)) {
    instance_create_layer(0, 0, "Instances", obj_quiz_timer);
}

depth = -9999;