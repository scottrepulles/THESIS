// Flash effect when content changes
if (is_flashing) {
    if (alpha_flash < 1) {
        alpha_flash += flash_speed;
        if (alpha_flash >= 1) {
            alpha_flash = 1;
            is_flashing = false;
        }
    }
}

// Apply to sprite alpha
image_alpha = alpha_flash;

// Define margins
var sprite_margin = 20;
var side_margin = 80;
var bottom_margin = 50; // Fixed bottom margin for all cases

// Check if mouse is over the content area
var board_left = x - sprite_width/2 + sprite_margin + side_margin;
var board_right = x + sprite_width/2 - sprite_margin - side_margin;
var board_top = y - sprite_height/2 + sprite_margin;
var board_bottom = y + sprite_height/2 - sprite_margin - bottom_margin;

is_mouse_over = (mouse_x >= board_left && mouse_x <= board_right && 
                 mouse_y >= board_top && mouse_y <= board_bottom);

// Calculate scrollbar dimensions (needed for interaction)
var padding = 40;
var title_y = board_top + 40;
var title_bg_height = 45;
var content_y = title_y + 70;
var content_area_height = board_bottom - content_y - 20;
var scrollbar_x = board_right - 15;
var scrollbar_y = content_y;
var scrollbar_height = content_area_height;
var scrollbar_width = 10;

// Calculate handle dimensions
if (max_scroll > 0) {
    var handle_height = max(30, (content_area_height / content_height) * scrollbar_height);
    var handle_y = scrollbar_y + (scroll_y / max_scroll) * (scrollbar_height - handle_height);
    
    // Check if mouse is over scrollbar handle
    scrollbar_hover = (mouse_x >= scrollbar_x && mouse_x <= scrollbar_x + scrollbar_width &&
                       mouse_y >= handle_y && mouse_y <= handle_y + handle_height);
    
    // Start dragging scrollbar
    if (scrollbar_hover && mouse_check_button_pressed(mb_left)) {
        scrollbar_dragging = true;
        scrollbar_drag_offset = mouse_y - handle_y;
    }
    
    // Handle scrollbar dragging
    if (scrollbar_dragging) {
        if (mouse_check_button(mb_left)) {
            // Calculate new scroll position based on mouse position
            var new_handle_y = mouse_y - scrollbar_drag_offset;
            var handle_range = scrollbar_height - handle_height;
            var handle_position = clamp(new_handle_y - scrollbar_y, 0, handle_range);
            
            // Convert handle position to scroll_y
            if (handle_range > 0) {
                scroll_y = (handle_position / handle_range) * max_scroll;
            }
        } else {
            // Stop dragging when mouse button is released
            scrollbar_dragging = false;
        }
    }
} else {
    scrollbar_hover = false;
    scrollbar_dragging = false;
}

// Swipe/drag scrolling on content area
if (is_mouse_over && !scrollbar_dragging) {
    // Start content dragging
    if (mouse_check_button_pressed(mb_left)) {
        if (!variable_instance_exists(id, "content_dragging")) {
            content_dragging = false;
            drag_start_y = 0;
            drag_start_scroll = 0;
            drag_velocity = 0;
            drag_last_y = 0;
        }
        
        content_dragging = true;
        drag_start_y = mouse_y;
        drag_start_scroll = scroll_y;
        drag_velocity = 0;
        drag_last_y = mouse_y;
    }
}

// Handle content dragging/swiping
if (variable_instance_exists(id, "content_dragging") && content_dragging) {
    if (mouse_check_button(mb_left)) {
        // Calculate drag distance
        var drag_distance = drag_start_y - mouse_y;
        scroll_y = drag_start_scroll + drag_distance;
        
        // Calculate velocity for momentum
        drag_velocity = mouse_y - drag_last_y;
        drag_last_y = mouse_y;
        
        // Clamp scroll position
        scroll_y = clamp(scroll_y, 0, max_scroll);
    } else {
        // Released - apply momentum
        content_dragging = false;
        
        // Apply velocity with friction
        if (abs(drag_velocity) > 0.5) {
            scroll_y -= drag_velocity * 2; // Momentum multiplier
        }
    }
}

// Apply momentum/inertia when not dragging
if (variable_instance_exists(id, "drag_velocity") && !content_dragging && !scrollbar_dragging) {
    if (abs(drag_velocity) > 0.1) {
        scroll_y -= drag_velocity;
        drag_velocity *= 0.92; // Friction/deceleration
        
        // Clamp scroll position
        scroll_y = clamp(scroll_y, 0, max_scroll);
    } else {
        drag_velocity = 0;
    }
}

// Handle scrolling with mouse wheel (only when not dragging)
if (is_mouse_over && !scrollbar_dragging && (!variable_instance_exists(id, "content_dragging") || !content_dragging)) {
    if (mouse_wheel_up()) {
        scroll_y -= scroll_speed;
        if (variable_instance_exists(id, "drag_velocity")) {
            drag_velocity = 0; // Reset momentum
        }
    }
    if (mouse_wheel_down()) {
        scroll_y += scroll_speed;
        if (variable_instance_exists(id, "drag_velocity")) {
            drag_velocity = 0; // Reset momentum
        }
    }
    
    // Clamp scroll position
    scroll_y = clamp(scroll_y, 0, max_scroll);
}

// Elastic bounce at boundaries
if (scroll_y < 0) {
    scroll_y = lerp(scroll_y, 0, 0.2);
    if (variable_instance_exists(id, "drag_velocity")) {
        drag_velocity *= 0.5;
    }
} else if (scroll_y > max_scroll) {
    scroll_y = lerp(scroll_y, max_scroll, 0.2);
    if (variable_instance_exists(id, "drag_velocity")) {
        drag_velocity *= 0.5;
    }
}


// --- MANAGE EVALUATION OBJECT VISIBILITY ---

// Check if this lesson *has* an evaluation object
if (evaluation_object_to_spawn != noone) {
    
    // Check if we are scrolled to the bottom. 
    // We use a 5px buffer to make it easier to hit the bottom.
    var is_at_bottom = (scroll_y >= max_scroll - 5);
    
    if (is_at_bottom) {
        // If we are at the bottom and the object doesn't exist, create it.
        if (!instance_exists(current_evaluation_instance)) {
            // Define spawn position (same as before)
            var spawn_x = x; 
            var spawn_y = y + (sprite_height / 2) - 60; 
            
            // --- THIS LINE IS MODIFIED ---
            // Create the instance at a depth IN FRONT of the board (depth - 1)
            current_evaluation_instance = instance_create_depth(spawn_x, spawn_y, depth - 1, evaluation_object_to_spawn);
            // --- END MODIFICATION ---
        }
    } else {
        // If we are NOT at the bottom, and the object *does* exist, destroy it.
        if (instance_exists(current_evaluation_instance)) {
            instance_destroy(current_evaluation_instance);
            current_evaluation_instance = noone;
        }
    }
}
else {
    // This lesson has no evaluation object, so make sure none is visible
    if (instance_exists(current_evaluation_instance)) {
        instance_destroy(current_evaluation_instance);
        current_evaluation_instance = noone;
    }
}