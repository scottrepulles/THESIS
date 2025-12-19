// ===== obj_leaderboard DRAW EVENT =====

if (room != rm_leaderboard) {
    exit;
}

var _x = ui.x;
var _y = ui.y;
var _w = ui.width;
var _h = ui.height;

// ============================================
// BACKGROUND WITH GRADIENT
// ============================================
if (ui.show_background) {
    draw_set_alpha(ui.bg_alpha);
    draw_set_color(ui.bg_color);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
    
    draw_set_alpha(0.2);
    draw_rectangle_color(_x, _y, _x + _w, _y + 250, 
        ui.accent_color, ui.accent_color, ui.bg_color, ui.bg_color, false);
    
    draw_set_alpha(1);
}

// Border with glow effect
if (ui.show_border) {
    draw_set_alpha(0.3);
    draw_set_color(ui.accent_color);
    draw_rectangle(_x - 2, _y - 2, _x + _w + 2, _y + _h + 2, true);
    
    draw_set_alpha(1);
    draw_set_color(ui.border_color);
    draw_rectangle(_x, _y, _x + _w, _y + _h, true);
    draw_rectangle(_x + 1, _y + 1, _x + _w - 1, _y + _h - 1, true);
}

// ============================================
// TITLE - FIXED POSITION
// ============================================
draw_set_font(ui.font_title);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _title_y = _y + 15;

// Title shadow
if (ui.show_shadows) {
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_text_transformed(_x + _w/2 + 3, _title_y + 3, "🏆 LEADERBOARD 🏆", 1.5, 1.5, 0);
}

// Title - LARGER
draw_set_alpha(1);
draw_set_color(ui.header_color);
draw_text_transformed(_x + _w/2, _title_y, "🏆 LEADERBOARD 🏆", 1.5, 1.5, 0);

// Subtitle - LARGER
draw_set_font(ui.font_body);
draw_set_color(ui.text_color);
draw_set_alpha(0.7);
draw_text_transformed(_x + _w/2, _title_y + 50, "Top " + string(ui.max_entries) + " Players", 1.2, 1.2, 0);
draw_set_alpha(1);

// ============================================
// REFRESH BUTTON - CLEAN SPACING
// ============================================
var _btn = refresh_button;
var _btn_x = _btn.x + (_btn.width/2) * (1 - _btn.scale);
var _btn_y = _btn.y + (_btn.height/2) * (1 - _btn.scale);
var _btn_w = _btn.width * _btn.scale;
var _btn_h = _btn.height * _btn.scale;

// Button shadow
if (ui.show_shadows) {
    draw_set_alpha(0.4);
    draw_set_color(c_black);
    draw_roundrect(_btn_x + 3, _btn_y + 3, _btn_x + _btn_w + 3, _btn_y + _btn_h + 3, false);
}

// Button background
draw_set_alpha(1);
draw_set_color(_btn.is_hovered ? _btn.hover_color : _btn.color);
draw_roundrect(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, false);

// Button border
draw_set_color(ui.border_color);
draw_roundrect(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, true);

// Button text - LARGER
draw_set_font(ui.font_button);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_btn.text_color);

if (is_loading) {
    var _center_x = _btn_x + _btn_w/2;
    var _center_y = _btn_y + _btn_h/2;
    
    var _old_transform = matrix_get(matrix_world);
    var _transform = matrix_build(_center_x, _center_y, 0, 0, 0, _btn.rotation, 1, 1, 1);
    matrix_set(matrix_world, _transform);
    
    draw_text_transformed(0, 0, "🔄", 1.3, 1.3, 0);
    matrix_set(matrix_world, _old_transform);
    
    draw_text_transformed(_center_x + 30, _center_y, "Loading...", 1.1, 1.1, 0);
} else {
    draw_text_transformed(_btn_x + _btn_w/2, _btn_y + _btn_h/2, _btn.text, 1.1, 1.1, 0);
}

// ============================================
// BACK BUTTON - CLEAN SPACING
// ============================================
var _back = back_button;
var _back_x = _back.x + (_back.width/2) * (1 - _back.scale);
var _back_y = _back.y + (_back.height/2) * (1 - _back.scale);
var _back_w = _back.width * _back.scale;
var _back_h = _back.height * _back.scale;

if (ui.show_shadows) {
    draw_set_alpha(0.4);
    draw_set_color(c_black);
    draw_roundrect(_back_x + 3, _back_y + 3, _back_x + _back_w + 3, _back_y + _back_h + 3, false);
}

draw_set_alpha(1);
draw_set_color(_back.is_hovered ? _back.hover_color : _back.color);
draw_roundrect(_back_x, _back_y, _back_x + _back_w, _back_y + _back_h, false);

draw_set_color(ui.border_color);
draw_roundrect(_back_x, _back_y, _back_x + _back_w, _back_y + _back_h, true);

draw_set_color(_back.text_color);
draw_text_transformed(_back_x + _back_w/2, _back_y + _back_h/2, _back.text, 1.1, 1.1, 0);

// ============================================
// LOADING / ERROR STATE
// ============================================
if (is_loading && array_length(leaderboard_data) == 0) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _dots = string_repeat(".", floor((current_time / 500) mod 4));
    draw_text_transformed(_x + _w/2, _y + _h/2, "Loading" + _dots, 1.3, 1.3, 0);
    
    var _loader_size = 30;
    var _loader_angle = (current_time / 10) mod 360;
    draw_set_color(ui.accent_color);
    draw_circle(_x + _w/2, _y + _h/2 - 60, _loader_size, true);
    
    var _arc_x = _x + _w/2 + lengthdir_x(_loader_size, _loader_angle);
    var _arc_y = _y + _h/2 - 60 + lengthdir_y(_loader_size, _loader_angle);
    draw_circle(_arc_x, _arc_y, 5, false);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    return;
}

if (error_message != "") {
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_x + _w/2, _y + _h/2, "⚠️ " + error_message, 1.2, 1.2, 0);
    draw_text_transformed(_x + _w/2, _y + _h/2 + 40, "Click REFRESH to try again", 1.1, 1.1, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    return;
}

// ============================================
// TABLE HEADER - CLEAN SPACING
// ============================================
var _header_y = _y + ui.title_height;
var _table_start_y = _header_y + ui.header_height;

// Header background
draw_set_alpha(0.3);
draw_set_color(ui.accent_color);
draw_rectangle(_x + ui.padding, _header_y, _x + _w - ui.padding, _header_y + ui.header_height, false);
draw_set_alpha(1);

// Header separator
draw_set_color(ui.accent_color);
draw_line_width(_x + ui.padding, _header_y + ui.header_height - 2, 
               _x + _w - ui.padding, _header_y + ui.header_height - 2, 3);

draw_set_font(ui.font_header);
draw_set_color(ui.accent_color);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// FIXED COLUMN POSITIONS - NO OVERLAP
var _col_rank_x = _x + ui.padding + 30;
var _col_name_x = _x + ui.padding + 150;
var _col_trophy_x = _x + _w - ui.padding - 200;

// Headers - LARGER TEXT
draw_text_transformed(_col_rank_x, _header_y + 30, "RANK", 1.3, 1.3, 0);
draw_text_transformed(_col_name_x, _header_y + 30, "PLAYER", 1.3, 1.3, 0);
draw_set_halign(fa_right);
draw_text_transformed(_col_trophy_x + 180, _header_y + 30, "SCORE", 1.3, 1.3, 0);

// ============================================
// LEADERBOARD ENTRIES - FIXED SPACING
// ============================================
draw_set_font(ui.font_body);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var _entry_y = _table_start_y - ui.scroll_offset;

for (var i = 0; i < array_length(leaderboard_data); i++) {
    var _entry = leaderboard_data[i];
    var _rank = i + 1;
    var _row_y = _entry_y + (i * ui.row_height);
    
    // Skip if outside visible area
    if (_row_y + ui.row_height < _table_start_y || _row_y > _y + _h - ui.footer_height) {
        continue;
    }
    
    var _fade = min(ui.entry_fade[i], 1);
    var _is_current_player = (_entry.player_name == current_player_name && current_player_name != "");
    
    // Row background with clean spacing
    if (i mod 2 == 0 || _is_current_player) {
        draw_set_alpha(0.5 * _fade);
        
        if (_is_current_player) {
            var _pulse = 0.5 + sin(current_time / 500) * 0.2;
            draw_set_alpha(_pulse * _fade);
            draw_set_color(ui.highlight_color);
        } else {
            draw_set_color(ui.alt_row_color);
        }
        
        draw_roundrect(_x + ui.padding + 10, _row_y + 5, 
                      _x + _w - ui.padding - 10, _row_y + ui.row_height - 5, false);
        draw_set_alpha(_fade);
    }
    
    var _text_color = get_rank_color(_rank);
    
    if (_is_current_player) {
        draw_set_color(ui.highlight_color);
    } else {
        draw_set_color(_text_color);
    }
    
    draw_set_alpha(_fade);
    
    // RANK - LARGER with proper spacing
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _rank_text = get_rank_medal(_rank);
    draw_text_transformed(_col_rank_x, _row_y + ui.row_height/2, _rank_text, 1.4, 1.4, 0);
    
    // PLAYER NAME - LARGER with shadow
    draw_set_halign(fa_left);
    
    if (ui.show_shadows) {
        draw_set_alpha(0.3 * _fade);
        draw_set_color(c_black);
        draw_text_transformed(_col_name_x + 2, _row_y + ui.row_height/2 + 2, _entry.player_name, 1.2, 1.2, 0);
    }
    
    draw_set_alpha(_fade);
    draw_set_color(_is_current_player ? ui.highlight_color : _text_color);
    
    var _display_name = _entry.player_name;
    if (string_length(_display_name) > 20) {
        _display_name = string_copy(_display_name, 1, 17) + "...";
    }
    draw_text_transformed(_col_name_x, _row_y + ui.row_height/2, _display_name, 1.2, 1.2, 0);
    
    // TROPHY SCORE - LARGER with shine effect
    draw_set_halign(fa_right);
    
    if (_rank <= 3) {
        var _shine = abs(sin(trophy_shine_time + i));
        draw_set_alpha(_shine * 0.3 * _fade);
        draw_set_color(c_white);
        draw_text_transformed(_col_trophy_x + 182, _row_y + ui.row_height/2, string(_entry.trophy), 1.3, 1.3, 0);
    }
    
    draw_set_alpha(_fade);
    draw_set_color(_text_color);
    draw_text_transformed(_col_trophy_x + 180, _row_y + ui.row_height/2, string(_entry.trophy) + " 🏆", 1.3, 1.3, 0);
    
    draw_set_alpha(1);
}

// ============================================
// STATISTICS FOOTER - FIXED SPACING
// ============================================
var _footer_y = _y + _h - ui.footer_height;

// Footer background
draw_set_alpha(0.3);
draw_set_color(ui.accent_color);
draw_rectangle(_x, _footer_y, _x + _w, _y + _h, false);
draw_set_alpha(1);

// Footer separator line
draw_set_color(ui.accent_color);
draw_line_width(_x + ui.padding, _footer_y, _x + _w - ui.padding, _footer_y, 3);

draw_set_font(ui.font_body);
draw_set_color(ui.text_color);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// Statistics with proper spacing - LARGER TEXT
var _stats_y1 = _footer_y + 30;
var _stats_y2 = _footer_y + 60;
var _col1 = _x + ui.padding + 40;
var _col2 = _x + ui.width/2;

// Row 1: Total Players and Average
draw_set_color(ui.accent_color);
draw_text_transformed(_col1, _stats_y1, "👥 Players:", 1.2, 1.2, 0);
draw_set_color(ui.text_color);
draw_text_transformed(_col1 + 120, _stats_y1, string(stats.total_players), 1.2, 1.2, 0);

draw_set_color(ui.accent_color);
draw_text_transformed(_col2, _stats_y1, "📊 Average:", 1.2, 1.2, 0);
draw_set_color(ui.text_color);
draw_text_transformed(_col2 + 130, _stats_y1, string(floor(stats.average_score)), 1.2, 1.2, 0);

// Row 2: Highest Score
draw_set_color(ui.gold_color);
draw_text_transformed(_col1, _stats_y2, "⭐ Top Score:", 1.2, 1.2, 0);
draw_set_color(ui.text_color);
draw_text_transformed(_col1 + 140, _stats_y2, string(stats.highest_score), 1.2, 1.2, 0);

// Current player rank - centered and larger
if (player_rank != -1) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _rank_y = _footer_y + 95;
    
    // Highlight box
    draw_set_alpha(0.5);
    draw_set_color(ui.highlight_color);
    draw_roundrect(_x + _w/2 - 180, _rank_y - 18, _x + _w/2 + 180, _rank_y + 18, false);
    
    draw_set_alpha(1);
    draw_set_color(ui.highlight_color);
    draw_text_transformed(_x + _w/2, _rank_y, "YOUR RANK: #" + string(player_rank) + " 🎯", 1.3, 1.3, 0);
}

// ============================================
// PARTICLES
// ============================================
for (var i = 0; i < array_length(particles); i++) {
    var _p = particles[i];
    var _alpha = _p.life / _p.max_life;
    
    draw_set_alpha(_alpha);
    draw_set_color(_p.color);
    draw_circle(_p.x, _p.y, _p.size, false);
}

// ============================================
// NO DATA MESSAGE
// ============================================
if (array_length(leaderboard_data) == 0 && !is_loading && error_message == "") {
    draw_set_alpha(1);
    draw_set_color(ui.text_color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_text_transformed(_x + _w/2, _y + _h/2 - 40, "📭 No data available", 1.3, 1.3, 0);
    draw_set_alpha(0.6);
    draw_text_transformed(_x + _w/2, _y + _h/2 + 20, "Click REFRESH to load leaderboard", 1.1, 1.1, 0);
}

// ============================================
// HOVER TOOLTIPS - LARGER
// ============================================
draw_set_alpha(1);

if (refresh_button.is_hovered && !is_loading) {
    draw_set_color(c_black);
    draw_set_alpha(0.9);
    var _tooltip_x = refresh_button.x + refresh_button.width/2;
    var _tooltip_y = refresh_button.y - 40;
    draw_roundrect(_tooltip_x - 80, _tooltip_y - 20, _tooltip_x + 80, _tooltip_y + 10, false);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_tooltip_x, _tooltip_y - 5, "Update Leaderboard", 1.1, 1.1, 0);
}

if (back_button.is_hovered) {
    draw_set_color(c_black);
    draw_set_alpha(0.9);
    var _tooltip_x = back_button.x + back_button.width/2;
    var _tooltip_y = back_button.y - 40;
    draw_roundrect(_tooltip_x - 70, _tooltip_y - 20, _tooltip_x + 70, _tooltip_y + 10, false);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_tooltip_x, _tooltip_y - 5, "Return to Menu", 1.1, 1.1, 0);
}

// ============================================
// DECORATIVE ELEMENTS
// ============================================
draw_set_color(ui.accent_color);
draw_set_alpha(0.3);

// Top left corner
draw_line_width(_x, _y, _x + 60, _y, 4);
draw_line_width(_x, _y, _x, _y + 60, 4);

// Top right corner
draw_line_width(_x + _w, _y, _x + _w - 60, _y, 4);
draw_line_width(_x + _w, _y, _x + _w, _y + 60, 4);

// Bottom left corner
draw_line_width(_x, _y + _h, _x + 60, _y + _h, 4);
draw_line_width(_x, _y + _h, _x, _y + _h - 60, 4);

// Bottom right corner
draw_line_width(_x + _w, _y + _h, _x + _w - 60, _y + _h, 4);
draw_line_width(_x + _w, _y + _h, _x + _w, _y + _h - 60, 4);

// ============================================
// RESET DRAW SETTINGS
// ============================================
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
