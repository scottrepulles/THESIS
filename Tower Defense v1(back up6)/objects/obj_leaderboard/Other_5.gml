// ===== obj_leaderboard ROOM END EVENT =====

show_debug_message("📍 Leaving leaderboard room - cleaning up");

// Clean up particles
particles = [];

// Stop any pending requests
request_id = -1;
is_loading = false;
