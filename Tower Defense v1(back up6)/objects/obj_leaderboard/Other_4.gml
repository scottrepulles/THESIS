// ===== obj_leaderboard ROOM START EVENT =====

if (room != rm_leaderboard) {
    instance_destroy();
    exit;
}

// Reset state
is_loading = false;
error_message = "";
last_fetch_time = 0;

// Reset animations
for (var i = 0; i < ui.max_entries; i++) {
    ui.entry_fade[i] = 0;
}

// Fetch fresh data when entering room
fetch_leaderboard();

show_debug_message("📍 Leaderboard room entered - fetching data");
