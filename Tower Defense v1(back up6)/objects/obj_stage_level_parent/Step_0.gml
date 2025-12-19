// Stage Level Parent - Step Event

// Safety check - ensure object is properly initialized
if (!variable_instance_exists(id, "stage_number") || stage_number <= 0) {
    return;
}

// Mouse collision detection using room-defined size
var mx = mouse_x;
var my = mouse_y;

// Calculate collision bounds based on room-defined size
var left = x - (button_width / 2);
var right = x + (button_width / 2);
var top = y - (button_height / 2);
var bottom = y + (button_height / 2);

// Check if mouse is over the button
var mouse_over = point_in_rectangle(mx, my, left, top, right, bottom);

// Handle hover state
if (mouse_over && !is_hovered) {
    is_hovered = true;
    target_scale_multiplier = 1.1;
    bounce_timer = 10;
}
else if (!mouse_over && is_hovered) {
    is_hovered = false;
    target_scale_multiplier = 1.0;
}

// Handle click
if (mouse_over && mouse_check_button_pressed(mb_left)) {
    is_pressed = true;
    target_scale_multiplier = 0.9;
    bounce_timer = 5;
    
    var unlocked = is_level_unlocked();
    var stars = get_star_count();
    
    show_debug_message("Level " + string(stage_number) + " clicked - Unlocked: " + string(unlocked) + ", Stars: " + string(stars));
    
    // Check if level is unlocked (either available or completed)
    if (unlocked) {
        // Set global variables for the level
        global.current_level = stage_number;
        global.target_stars = 3; // Target 3 stars
        global.from_level_select = true; // Track that we came from level select
        
        show_debug_message("Attempting to go to Level " + string(stage_number));
        
        // Try to find and go to the level room
        var level_room = get_level_room_id();
        
        if (level_room != -1) {
            show_debug_message("Going to Level " + string(stage_number) + " room");
            room_goto(level_room);
        } else {
            // Show available room options for debugging
            show_debug_message("No room found for Level " + string(stage_number));
            show_message("Level " + string(stage_number) + " room not found!\n\n" +
                        "Make sure you have a room named:\n" +
                        "- rm_level_" + string(stage_number) + "\n" +
                        "or create a test room for now.");
        }
        
    } else {
        // Show locked message with helpful info
        show_debug_message("Level " + string(stage_number) + " is locked");
        
        if (stage_number == 1) {
            show_message("Error: Level 1 should always be unlocked!");
        } else {
            var prev_level = stage_number - 1;
            var prev_stars = (prev_level > 0 && prev_level <= array_length(current_user_levels)) ? 
                           current_user_levels[prev_level - 1] : 0;
            
            show_message("Level " + string(stage_number) + " is locked!\n\n" +
                        "Complete Level " + string(prev_level) + " with at least 1 star to unlock.\n" +
                        "Current stars on Level " + string(prev_level) + ": " + string(prev_stars));
        }
    }
}

// Handle button release
if (is_pressed && mouse_check_button_released(mb_left)) {
    is_pressed = false;
    target_scale_multiplier = is_hovered ? 1.1 : 1.0;
}

// Smooth scale animation
scale_multiplier = lerp(scale_multiplier, target_scale_multiplier, 0.2);

// Apply scale to the room-defined scale, not replacing it
image_xscale = original_xscale * scale_multiplier;
image_yscale = original_yscale * scale_multiplier;

// Update bounce timer
if (bounce_timer > 0) {
    bounce_timer--;
}
