// ===== obj_leaderboard CREATE EVENT =====

// ============================================
// ROOM CHECK - Only work in rm_leaderboard
// ============================================
if (room != rm_leaderboard) {
    instance_destroy();
    exit;
}

// ============================================
// CONFIGURATION
// ============================================
global.supabase_url = "https://nwzgdpzsyqlidamamzip.supabase.co";
global.supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53emdkcHpzeXFsaWRhbWFtemlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2MDQ3MzAsImV4cCI6MjA3MzE4MDczMH0.6Nf8bMFsJtvx2QBbK3NFQ7utPr50pDFY-KPyyzjAEps";

// ============================================
// STATE VARIABLES
// ============================================
request_id = -1;
leaderboard_data = [];
is_loading = false;
error_message = "";
last_fetch_time = 0;
auto_refresh_enabled = false;
refresh_interval = 300;

// ============================================
// UI CONFIGURATION - FIXED SPACING
// ============================================
ui = {
    // Position and Size - Larger and Centered
    x: room_width/2 - 500,
    y: room_height/2 - 400,
    width: 1000,
    height: 800,
    
    // Colors - Modern Gaming Theme
    bg_color: #0d1117,
    bg_alpha: 0.95,
    header_color: #58a6ff,
    text_color: #c9d1d9,
    alt_row_color: #161b22,
    highlight_color: #ffa657,
    border_color: #30363d,
    accent_color: #58a6ff,
    gold_color: #FFD700,
    silver_color: #C0C0C0,
    bronze_color: #CD7F32,
    
    // Fonts - Will be larger
    font_title: -1,
    font_header: -1,
    font_body: -1,
    font_button: -1,
    
    // Spacing - FIXED FOR NO OVERLAPS
    padding: 40,
    row_height: 60,  // Increased from 50
    header_height: 70,  // Increased from 60
    title_height: 100,  // Increased from 80
    footer_height: 120,  // New - dedicated footer space
    
    // Display options
    show_background: true,
    show_border: true,
    show_rank_medals: true,
    show_shadows: true,
    max_entries: 10,
    
    // Animation
    scroll_offset: 0,
    target_scroll: 0,
    scroll_speed: 0.2,
    entry_fade: []
};

// Initialize fade animation for entries
for (var i = 0; i < ui.max_entries; i++) {
    ui.entry_fade[i] = 0;
}

// ============================================
// REFRESH BUTTON - REPOSITIONED
// ============================================
refresh_button = {
    x: ui.x + ui.width - 180,
    y: ui.y + 25,
    width: 160,
    height: 50,
    text: "🔄 REFRESH",
    color: #238636,
    hover_color: #2ea043,
    text_color: c_white,
    is_hovered: false,
    is_pressed: false,
    
    // Animation
    scale: 1,
    target_scale: 1,
    rotation: 0,
    pulse_time: 0
};

// ============================================
// BACK BUTTON - REPOSITIONED
// ============================================
back_button = {
    x: ui.x + 20,
    y: ui.y + 25,
    width: 160,
    height: 50,
    text: "← BACK",
    color: #21262d,
    hover_color: #30363d,
    text_color: c_white,
    is_hovered: false,
    is_pressed: false,
    
    // Animation
    scale: 1,
    target_scale: 1
};

// Player highlight
current_player_name = "";
player_rank = -1;

// ============================================
// STATISTICS
// ============================================
stats = {
    total_players: 0,
    highest_score: 0,
    average_score: 0,
    lowest_score: 0
};

// ============================================
// PARTICLES/EFFECTS
// ============================================
particles = [];
trophy_shine_time = 0;

// ============================================
// FUNCTIONS
// ============================================

/// @function fetch_leaderboard()
function fetch_leaderboard() {
    if (room != rm_leaderboard) {
        show_debug_message("⚠️ Not in leaderboard room, skipping fetch");
        return false;
    }
    
    is_loading = true;
    error_message = "";
    
    // Reset entry fade
    for (var i = 0; i < ui.max_entries; i++) {
        ui.entry_fade[i] = 0;
    }
    
    var _url = global.supabase_url + "/rest/v1/leaderboard?select=player_name,trophy&order=trophy.desc&limit=" + string(ui.max_entries);
    
    var _headers = ds_map_create();
    ds_map_add(_headers, "apikey", global.supabase_key);
    ds_map_add(_headers, "Authorization", "Bearer " + global.supabase_key);
    
    request_id = http_request(_url, "GET", _headers, "");
    
    ds_map_destroy(_headers);
    
    show_debug_message("🔄 Fetching leaderboard... Request ID: " + string(request_id));
    return true;
}

/// @function add_score(_name, _trophy)
function add_score(_name, _trophy) {
    if (_name == "" || string_length(_name) == 0) {
        show_debug_message("⚠️ Error: Player name cannot be empty");
        return false;
    }
    
    is_loading = true;
    error_message = "";
    
    var _url = global.supabase_url + "/rest/v1/leaderboard";
    
    var _headers = ds_map_create();
    ds_map_add(_headers, "apikey", global.supabase_key);
    ds_map_add(_headers, "Authorization", "Bearer " + global.supabase_key);
    ds_map_add(_headers, "Content-Type", "application/json");
    ds_map_add(_headers, "Prefer", "return=representation");
    
    var _body = json_stringify({
        player_name: _name,
        trophy: _trophy
    });
    
    request_id = http_request(_url, "POST", _headers, _body);
    
    ds_map_destroy(_headers);
    
    show_debug_message("📤 Submitting score: " + _name + " - " + string(_trophy));
    
    return true;
}

/// @function search_player(_name)
function search_player(_name) {
    if (_name == "") return;
    
    current_player_name = _name;
    player_rank = -1;
    
    for (var i = 0; i < array_length(leaderboard_data); i++) {
        if (leaderboard_data[i].player_name == _name) {
            player_rank = i + 1;
            show_debug_message("🔍 Found " + _name + " at rank #" + string(player_rank));
            break;
        }
    }
}

/// @function calculate_statistics()
function calculate_statistics() {
    stats.total_players = array_length(leaderboard_data);
    
    if (stats.total_players > 0) {
        stats.highest_score = leaderboard_data[0].trophy;
        stats.lowest_score = leaderboard_data[stats.total_players - 1].trophy;
        
        var _total = 0;
        for (var i = 0; i < stats.total_players; i++) {
            _total += leaderboard_data[i].trophy;
        }
        stats.average_score = _total / stats.total_players;
    } else {
        stats.highest_score = 0;
        stats.lowest_score = 0;
        stats.average_score = 0;
    }
}

/// @function refresh()
function refresh() {
    fetch_leaderboard();
}

/// @function get_rank_medal(_rank)
function get_rank_medal(_rank) {
    switch(_rank) {
        case 1: return "👑";
        case 2: return "🥈";
        case 3: return "🥉";
        default: return "#" + string(_rank);
    }
}

/// @function get_rank_color(_rank)
function get_rank_color(_rank) {
    switch(_rank) {
        case 1: return ui.gold_color;
        case 2: return ui.silver_color;
        case 3: return ui.bronze_color;
        default: return ui.text_color;
    }
}

/// @function create_particle(_x, _y)
function create_particle(_x, _y) {
    var _particle = {
        x: _x,
        y: _y,
        vx: random_range(-2, 2),
        vy: random_range(-3, -1),
        life: 60,
        max_life: 60,
        size: random_range(2, 4),
        color: choose(ui.gold_color, ui.accent_color, ui.highlight_color)
    };
    array_push(particles, _particle);
}

// ============================================
// INITIAL FETCH
// ============================================
fetch_leaderboard();
