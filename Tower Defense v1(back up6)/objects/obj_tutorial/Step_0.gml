

// Handle popup first
if (popup_active) {
    popup_alpha = lerp(popup_alpha, 1, 0.2);
    popup_scale = lerp(popup_scale, 1, 0.15);
    
    if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_escape)) {
        popup_active = false;
        popup_alpha = 0;
        popup_scale = 0.5;
    }
    return;
}

popup_alpha = 0;
popup_scale = 0.5;

// Calculate scroll limits first
var frame_top = y - frame_height/2;
var inner_top = frame_top + box_padding + 70;
var inner_height = frame_height - box_padding * 2 - 140;

max_scroll = 0;
min_scroll = -(total_height - inner_height + 40);

// Handle touch/swipe for scrolling
if (!dragging) {
    if (mouse_check_button_pressed(mb_left)) {
        // Check if click is within the scrollable area (not on a card)
        var frame_left = x - frame_width/2;
        var inner_left = frame_left + box_padding;
        var inner_width = frame_width - box_padding * 2;
        var inner_top_calc = frame_top + box_padding + 70;
        
        if (mouse_x >= inner_left && mouse_x <= inner_left + inner_width &&
            mouse_y >= inner_top_calc && mouse_y <= inner_top_calc + inner_height) {
            
            // Check if not clicking on a card
            var clicking_card = false;
            var start_y = inner_top_calc + 15 + scroll_y;
            var box_width = ((inner_width - box_spacing_x - 40) / 2);
            
            for (var i = 0; i < max_steps; i++) {
                var row = floor(i / boxes_per_row);
                var col = i % boxes_per_row;
                
                var box_x_offset = (col == 0) ? -(box_width/2 + box_spacing_x/2 + 10) : (box_width/2 + box_spacing_x/2 + 10);
                var box_y = start_y + box_y_positions[i];
                
                var box_x1 = x + box_x_offset - box_width/2;
                var box_x2 = x + box_x_offset + box_width/2;
                var box_y1 = box_y;
                var box_y2 = box_y + box_heights[i];
                
                if (mouse_x >= box_x1 && mouse_x <= box_x2 && mouse_y >= box_y1 && mouse_y <= box_y2) {
                    clicking_card = true;
                    break;
                }
            }
            
            if (!clicking_card) {
                is_touching = true;
                touch_start_y = mouse_y;
                last_touch_y = mouse_y;
                touch_start_scroll = scroll_y;
                touch_velocity = 0;
                inertia_active = false;
            }
        }
    }
    
    // Handle touch dragging
    if (is_touching && mouse_check_button(mb_left)) {
        var delta_y = mouse_y - last_touch_y;
        scroll_y += delta_y;
        touch_velocity = delta_y;
        last_touch_y = mouse_y;
        
        // Clamp during drag
        scroll_y = clamp(scroll_y, min_scroll, max_scroll);
    }
    
    // Release touch
    if (is_touching && !mouse_check_button(mb_left)) {
        is_touching = false;
        // Start inertia if there's velocity
        if (abs(touch_velocity) > 1) {
            inertia_active = true;
        }
    }
    
    // Apply inertia
    if (inertia_active && !is_touching) {
        scroll_y += touch_velocity;
        touch_velocity *= inertia_friction;
        
        // Stop inertia when velocity is low
        if (abs(touch_velocity) < 0.5) {
            inertia_active = false;
            touch_velocity = 0;
        }
        
        // Clamp during inertia
        scroll_y = clamp(scroll_y, min_scroll, max_scroll);
        
        // Stop inertia if we hit boundaries
        if (scroll_y <= min_scroll || scroll_y >= max_scroll) {
            inertia_active = false;
            touch_velocity = 0;
        }
    }
    
    // Mouse wheel scrolling
    if (mouse_wheel_up()) {
        scroll_y += scroll_speed;
        inertia_active = false;
        touch_velocity = 0;
    }
    if (mouse_wheel_down()) {
        scroll_y -= scroll_speed;
        inertia_active = false;
        touch_velocity = 0;
    }

    // Scroll with arrow keys
    if (keyboard_check(vk_down)) {
        scroll_y -= 5;
        inertia_active = false;
        touch_velocity = 0;
    }
    if (keyboard_check(vk_up)) {
        scroll_y += 5;
        inertia_active = false;
        touch_velocity = 0;
    }

    // Clamp scrolling
    scroll_y = clamp(scroll_y, min_scroll, max_scroll);
}

// Close tutorial
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
}

// Reset hover and swap target
hovered_box = -1;
swap_target = -1;

// Check for hover, drag, and clicks
var frame_left = x - frame_width/2;
var frame_top = y - frame_height/2;
var inner_left = frame_left + box_padding;
var inner_width = frame_width - box_padding * 2;
var inner_top_calc = frame_top + box_padding + 70;
var inner_height = frame_height - box_padding * 2 - 140;

var start_y = inner_top_calc + 15 + scroll_y;
var box_width = ((inner_width - box_spacing_x - 40) / 2);

// Check if we're starting a drag
if (mouse_check_button_pressed(mb_right) && !dragging) {
    for (var i = 0; i < max_steps; i++) {
        var row = floor(i / boxes_per_row);
        var col = i % boxes_per_row;
        
        var box_x_offset = (col == 0) ? -(box_width/2 + box_spacing_x/2 + 10) : (box_width/2 + box_spacing_x/2 + 10);
        var box_y = start_y + box_y_positions[i];
        
        var box_x1 = x + box_x_offset - box_width/2;
        var box_x2 = x + box_x_offset + box_width/2;
        var box_y1 = box_y;
        var box_y2 = box_y + box_heights[i];
        
        if (mouse_x >= box_x1 && mouse_x <= box_x2 && mouse_y >= box_y1 && mouse_y <= box_y2) {
            if (box_y1 >= inner_top_calc && box_y2 <= inner_top_calc + inner_height) {
                dragging = true;
                dragged_index = i;
                drag_start_x = mouse_x;
                drag_start_y = mouse_y;
                drag_offset_x = mouse_x - (x + box_x_offset);
                drag_offset_y = mouse_y - box_y;
                break;
            }
        }
    }
}

// Handle dragging
if (dragging) {
    if (mouse_check_button(mb_right)) {
        // Find swap target
        for (var i = 0; i < max_steps; i++) {
            if (i == dragged_index) continue;
            
            var row = floor(i / boxes_per_row);
            var col = i % boxes_per_row;
            
            var box_x_offset = (col == 0) ? -(box_width/2 + box_spacing_x/2 + 10) : (box_width/2 + box_spacing_x/2 + 10);
            var box_y = start_y + box_y_positions[i];
            
            var box_x1 = x + box_x_offset - box_width/2;
            var box_x2 = x + box_x_offset + box_width/2;
            var box_y1 = box_y;
            var box_y2 = box_y + box_heights[i];
            
            if (mouse_x >= box_x1 && mouse_x <= box_x2 && mouse_y >= box_y1 && mouse_y <= box_y2) {
                swap_target = i;
                break;
            }
        }
    } else {
        // Released mouse - perform swap
        if (swap_target != -1 && swap_target != dragged_index) {
            // Swap sprites
            var temp_sprite = tutorial_steps[dragged_index];
            tutorial_steps[dragged_index] = tutorial_steps[swap_target];
            tutorial_steps[swap_target] = temp_sprite;
            
            // Swap titles
            var temp_title = tutorial_titles[dragged_index];
            tutorial_titles[dragged_index] = tutorial_titles[swap_target];
            tutorial_titles[swap_target] = temp_title;
            
            // Swap descriptions
            var temp_desc = tutorial_descriptions[dragged_index];
            tutorial_descriptions[dragged_index] = tutorial_descriptions[swap_target];
            tutorial_descriptions[swap_target] = temp_desc;
            
            // Swap heights
            var temp_height = box_heights[dragged_index];
            box_heights[dragged_index] = box_heights[swap_target];
            box_heights[swap_target] = temp_height;
        }
        
        dragging = false;
        dragged_index = -1;
        swap_target = -1;
    }
}

// Normal hover detection (only if not dragging and not touching)
if (!dragging && !is_touching) {
    for (var i = 0; i < max_steps; i++) {
        var row = floor(i / boxes_per_row);
        var col = i % boxes_per_row;
        
        var box_x_offset = (col == 0) ? -(box_width/2 + box_spacing_x/2 + 10) : (box_width/2 + box_spacing_x/2 + 10);
        var box_y = start_y + box_y_positions[i];
        
        var box_x1 = x + box_x_offset - box_width/2;
        var box_x2 = x + box_x_offset + box_width/2;
        var box_y1 = box_y;
        var box_y2 = box_y + box_heights[i];
        
        if (mouse_x >= box_x1 && mouse_x <= box_x2 && mouse_y >= box_y1 && mouse_y <= box_y2) {
            if (box_y1 >= inner_top_calc && box_y2 <= inner_top_calc + inner_height) {
                hovered_box = i;
                
                // Left click opens popup
                if (mouse_check_button_pressed(mb_left)) {
                    popup_active = true;
                    popup_sprite = tutorial_steps[i];
                    popup_title = tutorial_titles[i];
                    popup_description = tutorial_descriptions[i];
                    popup_index = i;
                }
            }
        }
    }
}
