/// @description Update trophy display with animation
/// @function scr_update_trophy_display(trophy_change)
/// @param trophy_change Amount of trophies added/removed

function scr_update_trophy_display(trophy_change) {
    
    // Store the change for display
    global.last_trophy_change = trophy_change;
    global.last_change_timer = global.change_display_duration;
    
    // Force trophy display to reload from file
    if (instance_exists(obj_trophy_display)) {
        obj_trophy_display.trophies_loaded = false;
    }
    
    show_debug_message("Trophy display updated: " + string(trophy_change) + " trophies");
}
