// Draw self (the background frame)
draw_self();

// Calculate the inner area bounds
var frame_left = x - frame_width/2.03;
var frame_top = y - frame_height/2;
var frame_right = x + frame_width/2;
var frame_bottom = y + frame_height/2;

// Header section
var header_height = 30;
var footer_height = 60;

var inner_left = frame_left + box_padding;
var inner_top = frame_top + box_padding + header_height;
var inner_width = frame_width - box_padding * 2;
var inner_height = frame_height - box_padding * 2 - header_height - footer_height;
var inner_right = inner_left + inner_width;
var inner_bottom = inner_top + inner_height;

// Draw header background
draw_set_alpha(0.3);
draw_set_color(c_black);
draw_rectangle(frame_left, frame_top, frame_right, inner_top - 10, false);
draw_set_alpha(1);


// Draw separator line
draw_set_color(c_yellow);
draw_rectangle(inner_left, inner_top - 5, inner_right, inner_top - 3, false);

// Enable scissor clipping
gpu_set_scissor(inner_left, inner_top, inner_width, inner_height);

// Starting Y position with scroll
var start_y = inner_top + 15 + scroll_y;

// Calculate box width
var box_width = ((inner_width - box_spacing_x - 40) / 2);

// Draw each tutorial step with dynamic height
for (var i = 0; i < max_steps; i++) {
    // Skip drawing the dragged item in its original position
    if (dragging && i == dragged_index) continue;
    
    var row = floor(i / boxes_per_row);
    var col = i % boxes_per_row;
    
    var box_x_offset = (col == 0) ? -(box_width/2 + box_spacing_x/2 + 10) : (box_width/2 + box_spacing_x/2 + 10);
    var box_y = start_y + box_y_positions[i];
    var box_height = box_heights[i];
    
    var box_x1 = x + box_x_offset - box_width/2;
    var box_x2 = x + box_x_offset + box_width/2;
    var box_y1 = box_y;
    var box_y2 = box_y + box_height;
    
    var is_hovering = (hovered_box == i);
    var is_swap_target = (swap_target == i);
    
    // Only draw if visible
    if (box_y2 > inner_top - box_height && box_y1 < inner_bottom + box_height) {
        
        // Draw shadow
        if (!is_hovering && !is_swap_target) {
            draw_set_alpha(0.3);
            draw_set_color(c_black);
            draw_roundrect(box_x1 + 4, box_y1 + 4, box_x2 + 4, box_y2 + 4, false);
            draw_set_alpha(1);
        }
        
        // Draw swap target highlight
        if (is_swap_target) {
            draw_set_alpha(0.5);
            draw_set_color(c_lime);
            draw_roundrect(box_x1 - 3, box_y1 - 3, box_x2 + 3, box_y2 + 3, false);
            draw_set_alpha(1);
        }
        
        // Draw box background
        if (is_hovering || is_swap_target) {
            draw_set_color(merge_color(c_dkgray, c_gray, 0.5));
        } else {
            draw_set_color(c_dkgray);
        }
        draw_roundrect(box_x1, box_y1, box_x2, box_y2, false);
        
        // Draw border
        if (is_swap_target) {
            draw_set_color(c_lime);
        } else if (is_hovering) {
            draw_set_color(c_yellow);
        } else {
            draw_set_color(c_white);
        }
        draw_roundrect(box_x1, box_y1, box_x2, box_y2, true);
        draw_set_alpha(0.6);
        draw_roundrect(box_x1 + 2, box_y1 + 2, box_x2 - 2, box_y2 - 2, true);
        draw_set_alpha(1);
        
        var title_x = x + box_x_offset;
        
        // TITLE SECTION
        var title_bar_height = 32;
        
        // Title background bar
        draw_set_color(merge_color(c_black, c_dkgray, 0.5));
        draw_rectangle(box_x1, box_y1, box_x2, box_y1 + title_bar_height, false);
        
        // Title text
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(title_x, box_y1 + title_bar_height/2, tutorial_titles[i]);
        
        // Separator line after title
        draw_set_color(is_hovering || is_swap_target ? c_yellow : c_white);
        draw_set_alpha(0.5);
        draw_rectangle(box_x1 + 10, box_y1 + title_bar_height, box_x2 - 10, box_y1 + title_bar_height + 2, false);
        draw_set_alpha(1);
        
        var current_y = box_y1 + title_bar_height;
        
        // Padding after title
        current_y += 18;
        
        // Draw inner content background (below title)
        draw_set_color(merge_color(c_black, c_dkgray, 0.3));
        draw_roundrect(box_x1 + 6, box_y1 + title_bar_height + 5, box_x2 - 6, box_y2 - 6, false);
        
        // SPRITE SECTION
        var sprite_y_start = current_y;
        
        // Get sprite dimensions
        var spr_w = sprite_get_width(tutorial_steps[i]);
        var spr_h = sprite_get_height(tutorial_steps[i]);
        var sprite_area_width = box_width - 40;
        
        // Calculate scale
        var scale_x = sprite_area_width / spr_w;
        var scale_y = scale_x; // Keep aspect ratio
        var scale = scale_y * 0.7;
        
        if (is_hovering) {
            scale *= 1.05;
        }
        
        var sprite_display_height = spr_h * scale;
        var sprite_center_y = sprite_y_start + sprite_display_height/2;
        
        // Draw sprite border if hovering
        if (is_hovering || is_swap_target) {
            draw_set_color(is_swap_target ? c_lime : c_yellow);
            var border_w = (spr_w * scale / 2) + 5;
            var border_h = (spr_h * scale / 2) + 5;
            draw_rectangle(title_x - border_w, sprite_center_y - border_h, 
                         title_x + border_w, sprite_center_y + border_h, true);
        }
        
        // Draw sprite
        draw_sprite_ext(tutorial_steps[i], 0, title_x, sprite_center_y, scale, scale, 0, c_white, 1);
        
        current_y += sprite_display_height;
        
        // Padding after sprite
        current_y += 25;
        
        // DESCRIPTION SECTION - FIXED SPACING
        var desc_y_start = current_y;
        var desc_width = sprite_area_width - 30; // Side padding
        var line_height = 18; // Good line spacing
        var desc_height = string_height_ext(tutorial_descriptions[i], line_height, desc_width);
        var desc_top_padding = 8;
        var desc_bottom_padding = 8;
        
        // Description background box
        var desc_box_y1 = desc_y_start - desc_top_padding;
        var desc_box_y2 = desc_y_start + desc_height + desc_bottom_padding;
        
        draw_set_color(merge_color(c_black, c_dkgray, 0.7));
        draw_roundrect(box_x1 + 15, desc_box_y1, box_x2 - 15, desc_box_y2, false);
        
        // Description border
        draw_set_color(is_hovering || is_swap_target ? c_yellow : c_white);
        draw_set_alpha(0.3);
        draw_roundrect(box_x1 + 15, desc_box_y1, box_x2 - 15, desc_box_y2, true);
        draw_set_alpha(1);
        
        // Draw description text with proper spacing
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_text_ext(title_x, desc_y_start, tutorial_descriptions[i], line_height, desc_width);
        
        current_y = desc_box_y2;
        
        // Padding after description
        current_y += 10;
        
        // HOVER HINT SECTION (at bottom with padding)
        if (is_hovering && !dragging) {
            var hint_y = box_y2 - 12;
            
            // Background for hint
            draw_set_color(c_lime);
            draw_set_alpha(0.8 + sin(current_time / 200) * 0.2);
            draw_rectangle(box_x1 + 20, hint_y - 18, box_x2 - 20, hint_y - 2, false);
            
            // Hint text
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(title_x, hint_y - 10, "Left: View | Right: Drag", 0.65, 0.65, 0);
            
            draw_set_alpha(1);
        }
        
        // Swap target indicator
        if (is_swap_target) {
            draw_set_color(c_lime);
            draw_set_alpha(0.8 + sin(current_time / 150) * 0.2);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_transformed(title_x, box_y1 - 15, "▼ DROP HERE ▼", 0.8, 0.8, 0);
            draw_set_alpha(1);
        }
        
        // Reset alignment
        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
    }
}

// Draw dragged item on top (outside scissor)
if (dragging && dragged_index != -1) {
    // Temporarily disable scissor to draw dragged item
    gpu_set_scissor(-1, -1, -1, -1);
    
    var drag_x = mouse_x - drag_offset_x;
    var drag_y = mouse_y - drag_offset_y;
    var drag_height = box_heights[dragged_index];
    
    var drag_x1 = drag_x - box_width/2;
    var drag_x2 = drag_x + box_width/2;
    var drag_y1 = drag_y;
    var drag_y2 = drag_y + drag_height;
    
    // Large shadow for depth
    draw_set_alpha(0.6);
    draw_set_color(c_black);
    draw_roundrect(drag_x1 + 8, drag_y1 + 8, drag_x2 + 8, drag_y2 + 8, false);
    draw_set_alpha(0.85);
    
    // Box with glow effect
    draw_set_color(merge_color(c_gray, c_aqua, 0.3));
    draw_roundrect(drag_x1, drag_y1, drag_x2, drag_y2, false);
    
    // Animated glow border
    var glow_intensity = 0.7 + sin(current_time / 100) * 0.3;
    draw_set_alpha(glow_intensity);
    draw_set_color(c_aqua);
    for (var g = 0; g < 3; g++) {
        draw_roundrect(drag_x1 - g, drag_y1 - g, drag_x2 + g, drag_y2 + g, true);
    }
    draw_set_alpha(0.85);
    
    // Title bar
    var title_bar_height = 32;
    draw_set_color(merge_color(c_black, c_aqua, 0.3));
    draw_rectangle(drag_x1, drag_y1, drag_x2, drag_y1 + title_bar_height, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_aqua);
    draw_text(drag_x, drag_y1 + title_bar_height/2, tutorial_titles[dragged_index]);
    
    // Title separator
    draw_set_alpha(0.5);
    draw_rectangle(drag_x1 + 10, drag_y1 + title_bar_height, drag_x2 - 10, drag_y1 + title_bar_height + 2, false);
    draw_set_alpha(0.85);
    
    // Content background
    draw_set_color(merge_color(c_black, c_dkgray, 0.4));
    draw_roundrect(drag_x1 + 6, drag_y1 + title_bar_height + 5, drag_x2 - 6, drag_y2 - 6, false);
    
    // Sprite (simplified for dragging)
    var current_y = drag_y1 + title_bar_height + 18;
    var spr_w = sprite_get_width(tutorial_steps[dragged_index]);
    var spr_h = sprite_get_height(tutorial_steps[dragged_index]);
    var sprite_area_width = box_width - 40;
    var scale = (sprite_area_width / spr_w) * 0.7;
    var sprite_display_height = spr_h * scale;
    var sprite_center_y = current_y + sprite_display_height/2;
    
    draw_sprite_ext(tutorial_steps[dragged_index], 0, drag_x, sprite_center_y, scale, scale, 0, c_white, 0.85);
    
    // "Dragging" indicator
    draw_set_alpha(0.9);
    draw_set_color(c_aqua);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text_transformed(drag_x, drag_y2 + 20, "⬍ DRAGGING ⬍", 0.7, 0.7, 0);
    
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // Re-enable scissor
    gpu_set_scissor(inner_left, inner_top, inner_width, inner_height);
}

// Disable scissor for footer
gpu_set_scissor(-1, -1, -1, -1);

// Draw separator line
draw_set_color(c_yellow);
draw_rectangle(inner_left, inner_bottom + 3, inner_right, inner_bottom + 5, false);

// Draw footer background
draw_set_alpha(0.3);
draw_set_color(c_black);
draw_rectangle(frame_left, inner_bottom + 10, frame_right, frame_bottom, false);
draw_set_alpha(1);

// Draw scroll indicator
if (total_height > inner_height) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var scroll_progress = abs(scroll_y) / abs(min_scroll);
    scroll_progress = clamp(scroll_progress, 0, 1);
    
    draw_set_color(c_white);
    draw_text_transformed(x, inner_bottom + 18, "Scroll: " + string(floor(scroll_progress * 100)) + "%", 0.75, 0.75, 0);
    
    // Scroll bar
    var bar_width = inner_width - 100;
    var bar_x1 = x - bar_width/2;
    var bar_x2 = x + bar_width/2;
    var bar_y = inner_bottom + 32;
    
    draw_set_color(c_dkgray);
    draw_rectangle(bar_x1, bar_y, bar_x2, bar_y + 6, false);
    
    draw_set_color(c_lime);
    draw_rectangle(bar_x1, bar_y, bar_x1 + (bar_width * scroll_progress), bar_y + 6, false);
    
    draw_set_color(c_white);
    draw_rectangle(bar_x1, bar_y, bar_x2, bar_y + 6, true);
}

// Footer instructions
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(x, frame_bottom - 40, "Mouse Wheel / Arrow Keys / Swipe: Scroll", 0.75, 0.75, 0);
draw_set_color(c_lime);
draw_text_transformed(x, frame_bottom - 25, "Left Click: View Details | Right Click + Drag: Swap Cards", 0.75, 0.75, 0);
draw_set_color(c_yellow);
draw_text_transformed(x, frame_bottom - 10, "Press ESC to Close", 0.8, 0.8, 0);


draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw popup
if (popup_active && popup_alpha > 0) {
    draw_set_alpha(popup_alpha * 0.85);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    var popup_w = frame_width * 0.85;
    var popup_h = frame_height * 0.85;
    var popup_x1 = x - popup_w/2;
    var popup_x2 = x + popup_w/2;
    var popup_y1 = y - popup_h/2;
    var popup_y2 = y + popup_h/2;
    
    draw_set_alpha(popup_alpha * 0.5);
    draw_set_color(c_black);
    draw_roundrect(popup_x1 + 8, popup_y1 + 8, popup_x2 + 8, popup_y2 + 8, false);
    draw_set_alpha(popup_alpha);
    
    draw_set_color(merge_color(c_dkgray, c_gray, 0.3));
    draw_roundrect(popup_x1, popup_y1, popup_x2, popup_y2, false);
    
    draw_set_color(c_black);
    draw_set_alpha(popup_alpha * 0.3);
    draw_roundrect(popup_x1 + 20, popup_y1 + 70, popup_x2 - 20, popup_y2 - 80, false);
    draw_set_alpha(popup_alpha);
    
    draw_set_color(c_yellow);
    draw_roundrect(popup_x1, popup_y1, popup_x2, popup_y2, true);
    draw_roundrect(popup_x1 + 3, popup_y1 + 3, popup_x2 - 3, popup_y2 - 3, true);
    
    // Title sevar box_paddiction with padding
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text_transformed(x, popup_y1 + 35, popup_title, 2.2, 2.2, 0);
    
    var title_width = string_width(popup_title) * 2.2;
    draw_rectangle(x - title_width/2, popup_y1 + 55, x + title_width/2, popup_y1 + 58, false);
    
    // Sprite section
    var spr_w = sprite_get_width(popup_sprite);
    var spr_h = sprite_get_height(popup_sprite);
    var available_w = popup_w - 120;
    var available_h = popup_h - 260;
    var scale_x = available_w / spr_w;
    var scale_y = available_h / spr_h;
    var final_scale = min(scale_x, scale_y) * popup_scale * 0.9;
    
    draw_set_color(c_white);
    var sprite_border_w = (spr_w * final_scale / 2) + 10;
    var sprite_border_h = (spr_h * final_scale / 2) + 10;
    var sprite_y = popup_y1 + 90 + available_h/2;
    draw_rectangle(x - sprite_border_w, sprite_y - sprite_border_h, 
                  x + sprite_border_w, sprite_y + sprite_border_h, true);
    
    draw_sprite_ext(popup_sprite, 0, x, sprite_y, final_scale, final_scale, 0, c_white, popup_alpha);
    
    // Description section with proper spacing
    var desc_y_pos = popup_y2 - 65;
    var popup_desc_line_height = 20;
    var popup_desc_height = string_height_ext(popup_description, popup_desc_line_height, popup_w - 120);
    
    draw_set_color(c_dkgray);
    draw_set_alpha(popup_alpha * 0.9);
    draw_roundrect(popup_x1 + 40, desc_y_pos - popup_desc_height/2 - 10, 
                   popup_x2 - 40, desc_y_pos + popup_desc_height/2 + 10, false);
    draw_set_alpha(popup_alpha);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_ext(x, desc_y_pos, popup_description, popup_desc_line_height, popup_w - 120);
    
    // Close instruction with spacing
    draw_set_alpha(popup_alpha * (0.7 + sin(current_time / 300) * 0.3));
    draw_set_color(c_lime);
    draw_text_transformed(x, popup_y2 - 20, "CLICK ANYWHERE TO CLOSE", 0.95, 0.95, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
}
