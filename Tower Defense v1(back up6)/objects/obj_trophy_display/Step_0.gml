/// @description Step Event - Update Trophy Timer

// Decrease timer for trophy change display
if (variable_global_exists("last_change_timer")) {
    if (global.last_change_timer > 0) {
        global.last_change_timer--;
        
        if (global.last_change_timer <= 0) {
            global.last_trophy_change = 0;
        }
    }
}

// Optional: Refresh trophies from file every 5 seconds (300 frames at 60fps)
if (!variable_instance_exists(id, "refresh_timer")) {
    refresh_timer = 0;
}

refresh_timer++;

if (refresh_timer >= 300) { // Refresh every 5 seconds
    trophies_loaded = false; // Force reload from file
    refresh_timer = 0;
}
