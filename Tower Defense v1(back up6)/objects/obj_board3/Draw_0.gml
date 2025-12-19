// Draw the board sprite
draw_self();

// Only draw content when visible
if (alpha_flash > 0) {
    draw_set_alpha(alpha_flash);
    
    // No margins - use full sprite area, centered content
    var padding = 40; // Internal padding for content only
    
    // Calculate positions - no margins, just padding for content
    var board_top = y - sprite_height/2 + padding;
    var board_bottom = y + sprite_height/2 - padding;
    var board_left = x - sprite_width/2 + padding;
    var board_right = x + sprite_width/2 - padding;
    var board_width = sprite_width - (padding * 2);
    var board_height = sprite_height - (padding * 2);
    var content_width = board_width - 60; // Use more horizontal space - increased from 80
    
    // FONT SIZE SETTINGS
    var title_font_scale = 1.2;          // Title scale
    var content_font_scale = 1; // Content is HALF of title (0.6)
    var bold_multiplier = 1.3;          // Bold text multiplier
    
    // Animated glow effect for borders
    var glow_intensity = 0.5 + sin(current_time / 500) * 0.3;
    var pulse_scale = 1 + sin(current_time / 800) * 0.02;
    
    // Draw outer glow/shadow for depth at sprite edges
    draw_set_color(c_black);
    for (var i = 5; i > 0; i--) {
        draw_set_alpha(alpha_flash * 0.1 * (i / 5));
        draw_rectangle(
            x - sprite_width/2 - i * 2, 
            y - sprite_height/2 - i * 2, 
            x + sprite_width/2 + i * 2, 
            y + sprite_height/2 + i * 2, 
            true
        );
    }
    
    // Animated corner particles/sparkles at sprite edges
    var sparkle_count = 8;
    for (var i = 0; i < sparkle_count; i++) {
        var sparkle_time = current_time / 1000 + i * (pi * 2 / sparkle_count);
        var sparkle_alpha = (sin(sparkle_time * 2) + 1) / 2;
        var sparkle_size = 2 + sin(sparkle_time * 3) * 1;
        
        draw_set_color(c_yellow);
        draw_set_alpha(alpha_flash * sparkle_alpha * 0.6);
        
        // Sparkles at sprite corners
        draw_circle(x - sprite_width/2 + 15 + cos(sparkle_time) * 5, y - sprite_height/2 + 15 + sin(sparkle_time) * 5, sparkle_size, false);
        draw_circle(x + sprite_width/2 - 15 + cos(sparkle_time + pi) * 5, y - sprite_height/2 + 15 + sin(sparkle_time + pi) * 5, sparkle_size, false);
    }
    
    // Title section positioning - centered
    var title_y = board_top + 40;
    var title_bg_height = 45;
    
    // Animated title background with gradient and glow
    for (var i = 0; i < 3; i++) {
        draw_set_color(c_black);
        draw_set_alpha(alpha_flash * 0.25 * (3 - i) / 3);
        draw_rectangle(
            board_left + 20 - i, 
            title_y - 12 - i, 
            board_right - 20 + i, 
            title_y + title_bg_height - 12 + i, 
            false
        );
    }
    
    // Gradient overlay for title background
    draw_set_color(c_dkgray);
    draw_set_alpha(alpha_flash * 0.3);
    draw_rectangle(board_left + 20, title_y - 12, board_right - 20, title_y + 5, false);
    
    // Animated border glow for title
    draw_set_color(c_yellow);
    draw_set_alpha(alpha_flash * glow_intensity * 0.8);
    draw_line_width(board_left + 20, title_y - 12, board_right - 20, title_y - 12, 2);
    draw_line_width(board_left + 20, title_y + title_bg_height - 12, board_right - 20, title_y + title_bg_height - 12, 2);
    
    // Title border with corner highlights
    draw_set_color(c_yellow);
    draw_set_alpha(alpha_flash * 0.9);
    draw_rectangle(board_left + 20, title_y - 12, board_right - 20, title_y + title_bg_height - 12, true);
    
    // Animated underline with gradient
    var underline_offset = sin(current_time / 600) * 2;
    for (var i = 0; i < 3; i++) {
        draw_set_color(c_yellow);
        draw_set_alpha(alpha_flash * (0.8 - i * 0.2));
        draw_line_width(
            board_left + 20, 
            title_y + title_bg_height - 10 + i + underline_offset, 
            board_right - 20, 
            title_y + title_bg_height - 10 + i + underline_offset, 
            3 - i
        );
    }
    
    // Title text with multiple shadow layers for depth - centered
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Outer glow for title
    for (var i = 0; i < 4; i++) {
        var glow_offset = 4 - i;
        draw_set_color(c_black);
        draw_set_alpha(alpha_flash * 0.2 * (i / 4));
        draw_text_transformed(x + glow_offset, title_y + 14 + glow_offset, lesson_title, title_font_scale, title_font_scale, 0);
        draw_text_transformed(x - glow_offset, title_y + 14 + glow_offset, lesson_title, title_font_scale, title_font_scale, 0);
        draw_text_transformed(x + glow_offset, title_y + 14 - glow_offset, lesson_title, title_font_scale, title_font_scale, 0);
        draw_text_transformed(x - glow_offset, title_y + 14 - glow_offset, lesson_title, title_font_scale, title_font_scale, 0);
    }
    
    // Title shadow for depth
    draw_set_color(c_black);
    draw_set_alpha(alpha_flash * 0.7);
    draw_text_transformed(x + 3, title_y + 15, lesson_title, title_font_scale, title_font_scale, 0);
    
    // Title main text with subtle animation - centered at x
    var title_wave = sin(current_time / 400) * 0.5;
    draw_set_color(c_yellow);
    draw_set_alpha(alpha_flash);
    draw_text_transformed(x, title_y + 12 + title_wave, lesson_title, title_font_scale * pulse_scale, title_font_scale * pulse_scale, 0);
    
    // Title highlight/shine effect
    draw_set_color(c_white);
    draw_set_alpha(alpha_flash * 0.4 * glow_intensity);
    draw_text_transformed(x, title_y + 11, lesson_title, title_font_scale * pulse_scale, title_font_scale * pulse_scale, 0);
    
    // Decorative animated lines under title
    var line_wave1 = sin(current_time / 500) * 3;
    var line_wave2 = cos(current_time / 500) * 3;
    
    draw_set_color(c_yellow);
    draw_set_alpha(alpha_flash * 0.6);
    draw_line_width(board_left + 40 + line_wave1, title_y + 48, board_right - 40 + line_wave2, title_y + 48, 2);
    
    draw_set_color(c_white);
    draw_set_alpha(alpha_flash * 0.3);
    draw_line_width(board_left + 40 - line_wave1, title_y + 51, board_right - 40 - line_wave2, title_y + 51, 1);
    
    // Decorative side ornaments (symmetrical)
    var ornament_spacing = 20;
    for (var i = 0; i < 3; i++) {
        var ornament_alpha = 0.4 + sin(current_time / 600 + i * 0.5) * 0.2;
        draw_set_color(c_yellow);
        draw_set_alpha(alpha_flash * ornament_alpha);
        
        // Left ornaments
        draw_circle(board_left + 35, title_y + 18 + i * 8, 2, false);
        // Right ornaments
        draw_circle(board_right - 35, title_y + 18 + i * 8, 2, false);
    }
    
    // Content section with FULL LINE WIDTH and EMPHASIZED LINE SPACING
    var content_y = title_y + 70;
    var line_height = -1; // NO LIMIT - use -1 to allow full line before wrapping
    var newline_spacing = 25; // EMPHASIZED spacing between different lines
    var paragraph_spacing = 40; // Extra spacing for empty paragraph breaks
    var content_area_height = board_bottom - content_y - 20;
    var text_left_margin = 20; // Reduced left margin to use more space
    
    // Process text and calculate content height with formatting support
    var text_lines = string_split(lesson_text, "\n");
    var total_height = 0;
    var prev_was_empty = false;
    
    for (var i = 0; i < array_length(text_lines); i++) {
        var current_line = text_lines[i];
        
        // Remove formatting tags for measurement
        var clean_line = string_replace_all(current_line, "[center]", "");
        clean_line = string_replace_all(clean_line, "[/center]", "");
        clean_line = string_replace_all(clean_line, "[bold]", "");
        clean_line = string_replace_all(clean_line, "[/bold]", "");
        
        var is_empty = (string_length(string_trim(clean_line)) == 0);
        
        if (is_empty && !prev_was_empty) {
            // Add paragraph spacing for empty lines
            total_height += paragraph_spacing;
        } else if (!is_empty) {
            // Check if bold for scale calculation
            var is_bold = string_pos("[bold]", current_line) > 0;
            var text_scale = content_font_scale * (is_bold ? bold_multiplier : 1.0);
            
            // Calculate the height of this line with wrapping - NO LINE HEIGHT LIMIT
            var line_str_height = string_height_ext(clean_line, line_height, content_width) * text_scale;
            total_height += line_str_height + newline_spacing; // Add EMPHASIZED newline spacing after EACH line
        }
        
        prev_was_empty = is_empty;
    }
    
    content_height = total_height;
    
    // Calculate max scroll
    max_scroll = max(0, content_height - content_area_height);
    
    // Set up clipping for scrollable area
    var clip_x = board_left + 10;
    var clip_y = content_y - 10;
    var clip_w = board_right - board_left - 20;
    var clip_h = content_area_height + 20;
    
    // Draw content background with animated border
    draw_set_color(c_black);
    draw_set_alpha(alpha_flash * 0.3);
    draw_rectangle(clip_x, clip_y, clip_x + clip_w, clip_y + clip_h, false);
    
    // Content area border with glow
    draw_set_color(c_dkgray);
    draw_set_alpha(alpha_flash * 0.5);
    draw_rectangle(clip_x, clip_y, clip_x + clip_w, clip_y + clip_h, true);
    
    draw_set_color(c_yellow);
    draw_set_alpha(alpha_flash * glow_intensity * 0.3);
    draw_rectangle(clip_x + 1, clip_y + 1, clip_x + clip_w - 1, clip_y + clip_h - 1, true);
    
    // Enable surface for scrollable content
    draw_set_alpha(alpha_flash);
    
    // Create surface for scrollable content if it doesn't exist
    if (!surface_exists(content_surface)) {
        content_surface = surface_create(clip_w, clip_h);
    }
    
    // Verify surface size matches current clip dimensions
    if (surface_get_width(content_surface) != clip_w || surface_get_height(content_surface) != clip_h) {
        surface_free(content_surface);
        content_surface = surface_create(clip_w, clip_h);
    }
    
    // Draw content to surface with FULL LINE WIDTH USAGE
    surface_set_target(content_surface);
    draw_clear_alpha(c_black, 0);
    
    draw_set_alpha(1);
    draw_set_valign(fa_top);
    
    var draw_y = 10 - scroll_y;
    var prev_was_empty = false;
    
    for (var i = 0; i < array_length(text_lines); i++) {
        var current_line = text_lines[i];
        
        // Check for formatting tags
        var is_centered = string_pos("[center]", current_line) > 0;
        var is_bold = string_pos("[bold]", current_line) > 0;
        
        // Remove formatting tags
        var clean_line = string_replace_all(current_line, "[center]", "");
        clean_line = string_replace_all(clean_line, "[/center]", "");
        clean_line = string_replace_all(clean_line, "[bold]", "");
        clean_line = string_replace_all(clean_line, "[/bold]", "");
        
        var is_empty = (string_length(string_trim(clean_line)) == 0);
        
        if (is_empty && !prev_was_empty) {
            // Add EMPHASIZED paragraph spacing for empty lines
            draw_y += paragraph_spacing;
        } else if (!is_empty) {
            // Set alignment based on formatting
            if (is_centered) {
                draw_set_halign(fa_center);
                var draw_x = clip_w / 2;
            } else {
                draw_set_halign(fa_left);
                var draw_x = text_left_margin;
            }
            
            // Determine scale for text - HALF OF TITLE SIZE
            var text_scale = content_font_scale * (is_bold ? bold_multiplier : 1.0);
            
            // Draw text shadow for depth
            draw_set_color(c_black);
            for (var sx = -1; sx <= 1; sx++) {
                for (var sy = -1; sy <= 1; sy++) {
                    if (sx != 0 || sy != 0) {
                        draw_text_ext_transformed(draw_x + sx, draw_y + sy, clean_line, line_height, content_width, text_scale, text_scale, 0);
                    }
                }
            }
            
            // Main text - NO LINE HEIGHT LIMIT allows full line usage
            draw_set_color(c_white);
            draw_text_ext_transformed(draw_x, draw_y, clean_line, line_height, content_width, text_scale, text_scale, 0);
            
            // Subtle text highlight (stronger for bold)
            draw_set_color(c_yellow);
            draw_set_alpha(is_bold ? 0.2 : 0.1);
            draw_text_ext_transformed(draw_x, draw_y - 1, clean_line, line_height, content_width, text_scale, text_scale, 0);
            draw_set_alpha(1);
            
            // Calculate line height and advance with EMPHASIZED NEWLINE SPACING
            var line_str_height = string_height_ext(clean_line, line_height, content_width) * text_scale;
            draw_y += line_str_height + newline_spacing; // Add EMPHASIZED spacing after EVERY new line
        }
        
        prev_was_empty = is_empty;
    }
    
    surface_reset_target();
    
    // Draw the surface
    draw_set_alpha(alpha_flash);
    draw_surface(content_surface, clip_x, clip_y);
    
    // Fade effect at top and bottom of content area
    var fade_height = 30;
    
    // Top fade
    for (var i = 0; i < fade_height; i++) {
        draw_set_color(c_black);
        draw_set_alpha(alpha_flash * (fade_height - i) / fade_height * 0.3);
        draw_line(clip_x, clip_y + i, clip_x + clip_w, clip_y + i);
    }
    
    // Bottom fade
    for (var i = 0; i < fade_height; i++) {
        draw_set_color(c_black);
        draw_set_alpha(alpha_flash * i / fade_height * 0.3);
        draw_line(clip_x, clip_y + clip_h - fade_height + i, clip_x + clip_w, clip_y + clip_h - fade_height + i);
    }
    
    // Draw enhanced scrollbar if content is scrollable
    if (max_scroll > 0) {
        var scrollbar_x = board_right - 15;
        var scrollbar_y = content_y;
        var scrollbar_height = content_area_height;
        var scrollbar_width = 10;
        
        // Scrollbar background with gradient
        draw_set_color(c_black);
        draw_set_alpha(alpha_flash * 0.4);
        draw_roundrect(scrollbar_x - 1, scrollbar_y, scrollbar_x + scrollbar_width + 1, scrollbar_y + scrollbar_height, false);
        
        draw_set_color(c_dkgray);
        draw_set_alpha(alpha_flash * 0.3);
        draw_roundrect(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_width, scrollbar_y + scrollbar_height, false);
        
        // Scrollbar border
        draw_set_color(c_gray);
        draw_set_alpha(alpha_flash * 0.5);
        draw_roundrect(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_width, scrollbar_y + scrollbar_height, true);
        
        // Scrollbar handle
        var handle_height = max(30, (content_area_height / content_height) * scrollbar_height);
        var handle_y = scrollbar_y + (scroll_y / max_scroll) * (scrollbar_height - handle_height);
        
        // Handle shadow
        draw_set_color(c_black);
        draw_set_alpha(alpha_flash * 0.5);
        draw_roundrect(scrollbar_x + 1, handle_y + 2, scrollbar_x + scrollbar_width + 1, handle_y + handle_height + 2, false);
        
        // Handle color changes based on interaction state
        var handle_color = c_yellow;
        var handle_alpha = 0.8;
        
        if (scrollbar_dragging) {
            handle_color = c_orange;
            handle_alpha = 1.0;
        } else if (scrollbar_hover) {
            handle_color = c_white;
            handle_alpha = 0.9;
        } else if (content_dragging) {
            handle_color = c_lime;
            handle_alpha = 0.9;
        }
        
        // Handle gradient
        draw_set_color(handle_color);
        draw_set_alpha(alpha_flash * handle_alpha);
        draw_roundrect(scrollbar_x, handle_y, scrollbar_x + scrollbar_width, handle_y + handle_height, false);
        
        // Handle highlight
        draw_set_color(c_white);
        draw_set_alpha(alpha_flash * 0.4);
        draw_roundrect(scrollbar_x + 1, handle_y + 1, scrollbar_x + scrollbar_width - 1, handle_y + handle_height / 3, false);
        
        // Handle border
        draw_set_color(scrollbar_dragging ? c_white : c_orange);
        draw_set_alpha(alpha_flash * 0.9);
        draw_roundrect(scrollbar_x, handle_y, scrollbar_x + scrollbar_width, handle_y + handle_height, true);
        
        // Animated grip lines on handle
        var grip_count = 3;
        var grip_spacing = handle_height / (grip_count + 1);
        for (var i = 1; i <= grip_count; i++) {
            draw_set_color(c_white);
            draw_set_alpha(alpha_flash * 0.6);
            var grip_y = handle_y + grip_spacing * i;
            draw_line(scrollbar_x + 2, grip_y, scrollbar_x + scrollbar_width - 2, grip_y);
        }
        
        // --- MODIFIED SECTION ---
        // Scroll indicator text with animation - centered at x
        // Only show if an evaluation object is NOT visible
        if ((is_mouse_over || scrollbar_dragging || content_dragging) && !instance_exists(current_evaluation_instance)) {
            var indicator_y = board_bottom + 20;
            var indicator_bounce = sin(current_time / 300) * 3;
            
            // Indicator background
            draw_set_color(c_black);
            draw_set_alpha(alpha_flash * 0.5);
            draw_roundrect(x - 100, indicator_y - 15 + indicator_bounce, x + 100, indicator_y + 15 + indicator_bounce, false);
            
            // Indicator border
            var indicator_border_color = content_dragging ? c_lime : c_yellow;
            draw_set_color(indicator_border_color);
            draw_set_alpha(alpha_flash * 0.7);
            draw_roundrect(x - 100, indicator_y - 15 + indicator_bounce, x + 100, indicator_y + 15 + indicator_bounce, true);
            
            // Indicator text - centered
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_black);
            draw_set_alpha(alpha_flash * 0.8);
            
            var indicator_text = content_dragging ? "↕ Swiping ↕" : "▲ Scroll for more ▼";
            draw_text(x + 1, indicator_y + 1 + indicator_bounce, indicator_text);
            
            draw_set_color(content_dragging ? c_lime : c_yellow);
            draw_set_alpha(alpha_flash);
            draw_text(x, indicator_y + indicator_bounce, indicator_text);
        }
        // --- END MODIFICATION ---
    }
    
    // Enhanced corner accents at sprite edges - no margins
    draw_set_color(c_yellow);
    var accent_size = 20;
    var accent_glow = sin(current_time / 400) * 0.3 + 0.7;
    
    // Corner glow effect at sprite boundaries
    for (var i = 3; i > 0; i--) {
        draw_set_alpha(alpha_flash * accent_glow * 0.15 * i);
        var glow_size = accent_size + (4 - i) * 3;
        
        // Top-left
        draw_line_width(x - sprite_width/2 + 10, y - sprite_height/2 + 10, x - sprite_width/2 + 10 + glow_size, y - sprite_height/2 + 10, 2 + i);
        draw_line_width(x - sprite_width/2 + 10, y - sprite_height/2 + 10, x - sprite_width/2 + 10, y - sprite_height/2 + 10 + glow_size, 2 + i);
        
        // Top-right
        draw_line_width(x + sprite_width/2 - 10, y - sprite_height/2 + 10, x + sprite_width/2 - 10 - glow_size, y - sprite_height/2 + 10, 2 + i);
                draw_line_width(x + sprite_width/2 - 10, y - sprite_height/2 + 10, x + sprite_width/2 - 10, y - sprite_height/2 + 10 + glow_size, 2 + i);
        
        // Bottom-left
        draw_line_width(x - sprite_width/2 + 10, y + sprite_height/2 - 10, x - sprite_width/2 + 10 + glow_size, y + sprite_height/2 - 10, 2 + i);
        draw_line_width(x - sprite_width/2 + 10, y + sprite_height/2 - 10, x - sprite_width/2 + 10, y + sprite_height/2 - 10 - glow_size, 2 + i);
        
        // Bottom-right
        draw_line_width(x + sprite_width/2 - 10, y + sprite_height/2 - 10, x + sprite_width/2 - 10 - glow_size, y + sprite_height/2 - 10, 2 + i);
        draw_line_width(x + sprite_width/2 - 10, y + sprite_height/2 - 10, x + sprite_width/2 - 10, y + sprite_height/2 - 10 - glow_size, 2 + i);
    }
    
    // Main corner accent lines at sprite edges
    draw_set_alpha(alpha_flash * accent_glow);
    draw_set_color(c_yellow);
    
    // Top-left corner
    draw_line_width(x - sprite_width/2 + 10, y - sprite_height/2 + 10, x - sprite_width/2 + 10 + accent_size, y - sprite_height/2 + 10, 3);
    draw_line_width(x - sprite_width/2 + 10, y - sprite_height/2 + 10, x - sprite_width/2 + 10, y - sprite_height/2 + 10 + accent_size, 3);
    
    // Top-right corner
    draw_line_width(x + sprite_width/2 - 10, y - sprite_height/2 + 10, x + sprite_width/2 - 10 - accent_size, y - sprite_height/2 + 10, 3);
    draw_line_width(x + sprite_width/2 - 10, y - sprite_height/2 + 10, x + sprite_width/2 - 10, y - sprite_height/2 + 10 + accent_size, 3);
    
    // Bottom-left corner
    draw_line_width(x - sprite_width/2 + 10, y + sprite_height/2 - 10, x - sprite_width/2 + 10 + accent_size, y + sprite_height/2 - 10, 3);
    draw_line_width(x - sprite_width/2 + 10, y + sprite_height/2 - 10, x - sprite_width/2 + 10, y + sprite_height/2 - 10 - accent_size, 3);
    
    // Bottom-right corner
    draw_line_width(x + sprite_width/2 - 10, y + sprite_height/2 - 10, x + sprite_width/2 - 10 - accent_size, y + sprite_height/2 - 10, 3);
    draw_line_width(x + sprite_width/2 - 10, y + sprite_height/2 - 10, x + sprite_width/2 - 10, y + sprite_height/2 - 10 - accent_size, 3);
    
    // Corner highlights
    draw_set_color(c_white);
    draw_set_alpha(alpha_flash * accent_glow * 0.7);
    
    // Top-left
    draw_circle(x - sprite_width/2 + 10, y - sprite_height/2 + 10, 4, false);
    // Top-right
    draw_circle(x + sprite_width/2 - 10, y - sprite_height/2 + 10, 4, false);
    // Bottom-left
    draw_circle(x - sprite_width/2 + 10, y + sprite_height/2 - 10, 4, false);
    // Bottom-right
    draw_circle(x + sprite_width/2 - 10, y + sprite_height/2 - 10, 4, false);
    
    // Animated border particles along sprite edges
    var particle_count = 12;
    var total_perimeter = (sprite_width + sprite_height) * 2;
    
    for (var i = 0; i < particle_count; i++) {
        var particle_progress = (current_time / 3000 + i / particle_count) % 1;
        var particle_alpha = sin(particle_progress * pi) * 0.7;
        
        draw_set_color(c_yellow);
        draw_set_alpha(alpha_flash * particle_alpha);
        
        // Calculate position along sprite border
        var particle_pos = particle_progress * total_perimeter;
        var px, py;
        
        if (particle_pos < sprite_width) {
            // Top edge
            px = x - sprite_width/2 + particle_pos;
            py = y - sprite_height/2;
        } else if (particle_pos < sprite_width + sprite_height) {
            // Right edge
            px = x + sprite_width/2;
            py = y - sprite_height/2 + (particle_pos - sprite_width);
        } else if (particle_pos < sprite_width * 2 + sprite_height) {
            // Bottom edge
            px = x + sprite_width/2 - (particle_pos - sprite_width - sprite_height);
            py = y + sprite_height/2;
        } else {
            // Left edge
            px = x - sprite_width/2;
            py = y + sprite_height/2 - (particle_pos - sprite_width * 2 - sprite_height);
        }
        
        draw_circle(px, py, 3, false);
        
        // Particle trail
        draw_set_alpha(alpha_flash * particle_alpha * 0.5);
        draw_circle(px, py, 5, false);
    }
    
    // Holographic scan line effect across full sprite
    var scan_line_y = (current_time / 20) % (sprite_height + 100);
    draw_set_color(c_aqua);
    draw_set_alpha(alpha_flash * 0.1);
    draw_line_width(x - sprite_width/2, y - sprite_height/2 + scan_line_y, x + sprite_width/2, y - sprite_height/2 + scan_line_y, 2);
    draw_set_alpha(alpha_flash * 0.05);
    draw_line_width(x - sprite_width/2, y - sprite_height/2 + scan_line_y - 5, x + sprite_width/2, y - sprite_height/2 + scan_line_y - 5, 4);
    
    // --- MODIFIED SECTION ---
    // Visual feedback for swipe/drag action
    // Only show if an evaluation object is NOT visible
    if (content_dragging && !instance_exists(current_evaluation_instance)) {
        // Draw swipe indicator arrows
        var swipe_alpha = 0.3 + sin(current_time / 200) * 0.2;
        draw_set_color(c_lime);
        draw_set_alpha(alpha_flash * swipe_alpha);
        
        // Draw animated up/down arrows on the sides
        var arrow_offset = sin(current_time / 300) * 5;
        var arrow_x_left = clip_x + 5;
        var arrow_x_right = clip_x + clip_w - 5;
        var arrow_y_center = clip_y + clip_h / 2;
        
        // Left side arrows
        draw_triangle(arrow_x_left, arrow_y_center - 20 - arrow_offset, 
                      arrow_x_left - 5, arrow_y_center - 10 - arrow_offset, 
                      arrow_x_left + 5, arrow_y_center - 10 - arrow_offset, false);
        draw_triangle(arrow_x_left, arrow_y_center + 20 + arrow_offset, 
                      arrow_x_left - 5, arrow_y_center + 10 + arrow_offset, 
                      arrow_x_left + 5, arrow_y_center + 10 + arrow_offset, false);
        
        // Right side arrows
        draw_triangle(arrow_x_right, arrow_y_center - 20 - arrow_offset, 
                      arrow_x_right - 5, arrow_y_center - 10 - arrow_offset, 
                      arrow_x_right + 5, arrow_y_center - 10 - arrow_offset, false);
        draw_triangle(arrow_x_right, arrow_y_center + 20 + arrow_offset, 
                      arrow_x_right - 5, arrow_y_center + 10 + arrow_offset, 
                      arrow_x_right + 5, arrow_y_center + 10 + arrow_offset, false);
    }
    // --- END MODIFICATION ---
    
    // Reset drawing settings
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}