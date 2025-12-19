// Show trophies and current rank
draw_set_color(c_white);
draw_text(50, 30, "Trophies: " + string(global.player_trophies));
draw_text(50, 60, "Rank: " + string(current_rank));

// Draw Enter Map button

draw_text(180, 140, "Enter Rank");
// Draw Enter Map button
draw_set_color(c_white);
draw_rectangle(100, 120, 250, 170, true);

