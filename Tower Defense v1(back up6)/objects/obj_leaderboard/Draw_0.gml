/// obj_leaderboard - Draw
var cx = x;
var cy = y;
var w = sprite_get_width(sprite_index);
var h = sprite_get_height(sprite_index);

// Title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(cx, cy - h/2 + 20, "LEADERBOARD");

// Status
if (!loaded) {
    draw_set_color(c_yellow);
    var _status = "Loading...";
    if (error != "") { _status = error; }
    draw_text(cx, cy - h/2 + 60, _status);
    exit;
}

// Columns
var table_top = cy - h/2 + 120;
var col_rank_x = cx - w/2 + 80;
var col_name_x = cx - w/2 + 240;
var col_score_x = cx + w/2 - 120;

draw_set_halign(fa_left);
draw_set_color(c_cadetblue);
draw_text(col_rank_x, table_top - 30, "RANK");
draw_text(col_name_x, table_top - 30, "NAME");
draw_text(col_score_x, table_top - 30, "HIGHEST SCORE");

// Rows (top 10)
var row_h = 48;
for (var i = 0; i < min(10, array_length(entries)); i++) {
    var yy = table_top + i * row_h;

    // Highlight top 3
    var col = c_white;
    if (i == 0) { col = c_yellow; }
    else if (i == 1) { col = c_silver; }
    else if (i == 2) { col = c_orange; }
    draw_set_color(col);

    var nm = entries[i][0];
    var sc = entries[i][1];

    draw_text(col_rank_x, yy, string(i + 1));
    draw_text(col_name_x, yy, nm);
    draw_set_halign(fa_right);
    draw_text(col_score_x, yy, string(sc));
    draw_set_halign(fa_left);
}