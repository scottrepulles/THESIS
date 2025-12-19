/// obj_tutorial_manager - Create Event
// Tutorial state variables

// --- Initialize tutorial variables safely ---

global.tutorial_index = 0;
global.show_tutorial = false;
global.selected_choice = -1;
global.tutorial_feedback = ""; // message shown after answering
global.tutorial_waiting_continue = false; // true after feedback, click to proceed

// Completion state and next button label
global.tutorial_complete = false;
global.next_btn_label = "NEXT";

global.tutorial_visible = false;
global.tutorial_message = "";
global.tutorial_timer = 0;
global.tutorial_active = false;
global.tutorial_paused = false;
global.tutorial_step = 0;
global.tutorial_can_continue = false;
global.tutorial_text = "";
game_paused = false; // Do not force pause here; tutorial controls its own state

// Add click cooldown to prevent rapid clicking issues
click_cooldown = 0;

// Auto-advance timer for feedback display
advance_timer = 5;

// --- Ensure NPC exists ---
if (!instance_exists(obj_npc)) {
    var npc_x = 200;
    var npc_y = room_height - 200;
    instance_create_layer(npc_x, npc_y, "SequenceInstance", obj_npc);
}

// 🧠 SQL Defender Beginner Tutorial Steps
global.tutorial_steps = [
    {
        title: "Welcome to SQL Defender!",
        question: "What is SQL injection?",
        choices: [
            "A) A way to improve database performance",
            "B) A security vulnerability that allows attackers to manipulate database queries",
            "C) A method to backup databases",
            "D) A programming language"
        ],
        correct: 1,
        explanation: "SQL injection is a code injection technique that exploits security vulnerabilities in database layer of applications."
    },
    {
        title: "Understanding Input Validation",
        question: "Which of these is the BEST way to prevent SQL injection?",
        choices: [
            "A) Using string concatenation for queries",
            "B) Using prepared statements with parameterized queries",
            "C) Only allowing admin users to access the database",
            "D) Encrypting the database"
        ],
        correct: 1,
        explanation: "Prepared statements with parameterized queries separate SQL code from data, making injection impossible."
    },
    {
        title: "Recognizing Threats",
        question: "Which input looks like a SQL injection attempt?",
        choices: [
            "A) john@example.com",
            "B) ' OR '1'='1",
            "C) Password123!",
            "D) 555-1234"
        ],
        correct: 1,
        explanation: "' OR '1'='1 is a classic SQL injection payload that attempts to bypass authentication by making the WHERE clause always true."
    },
    {
        title: "SQL Injection Impact",
        question: "What can an attacker do with a successful SQL injection attack?",
        choices: [
            "A) Only read data from the database",
            "B) Steal, modify, or delete data; bypass authentication; execute admin operations",
            "C) Only slow down the website",
            "D) Change the website's colors"
        ],
        correct: 1,
        explanation: "SQL injection can give attackers full control over the database, allowing them to steal sensitive data, modify records, delete information, and even take over user accounts."
    },
    {
        title: "Defense Strategies",
        question: "Which is NOT an effective defense against SQL injection?",
        choices: [
            "A) Input validation and sanitization",
            "B) Using an ORM (Object-Relational Mapping)",
            "C) Making error messages more detailed",
            "D) Principle of least privilege for database accounts"
        ],
        correct: 2,
        explanation: "Detailed error messages can actually help attackers by revealing database structure. All other options are legitimate defenses."
    }
];

// Store the total number of tutorial steps
tutorial_total_steps = array_length(global.tutorial_steps);

// --- UI variables ---
text_alpha = 0;
text_target_alpha = 1; // Start with tutorial visible
box_width = 700;
box_height = 160;

// Initialize box position variables (these will be calculated properly in Step)
global.tutorial_box_w = 840;
global.tutorial_box_h = 560;
global.tutorial_box_x = 0;
global.tutorial_box_y = 0;
global.tutorial_option_y = 0;
global.tutorial_option_x = 0;
global.tutorial_option_w = 0;
global.tutorial_option_h = 40;
global.feedback_y = 0;
global.next_btn_w = 100;
global.next_btn_h = 36;
global.next_btn_x = 0;
global.next_btn_y = 0;

// Debug confirmation
show_debug_message("SQL Defender Tutorial Manager started!");
show_debug_message("Tutorial active: " + string(global.tutorial_active));
show_debug_message("Tutorial visible: " + string(global.tutorial_visible));
show_debug_message("Tutorial steps loaded: " + string(tutorial_total_steps));
show_debug_message("NPC exists: " + string(instance_exists(obj_npc)));
