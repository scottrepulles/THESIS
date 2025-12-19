/// @description Game Won Menu with Star System

/*
	This is here because if it is in the Draw GUI
	the buttons will draw below it.
*/

// Draw the Sprite (background)
draw_self();

// Draw the win image with correct star frame based on stars earned
// spr_win_image should have 3 frames: 0=1star, 1=2stars, 2=3stars
var star_frame = clamp(stars_earned - 1, 0, 2);
draw_sprite_ext(spr_win_image, star_frame, x, y - 13, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

// Set the Font horizontal alignment
draw_set_halign(fa_center);

// Set the font vertical alignment
draw_set_valign(fa_middle);

// Set the font
draw_set_font(ft_game_end_small);

// Use our custom function to draw the completion text with outline 
draw_text_transformed_outlined(x, y - map_value(image_xscale, 0, 1, 0, 300), completion_text, image_xscale, image_yscale, image_angle, #baaa7d, #33261E);

// Set the font
draw_set_font(ft_game_end_big);

// Use our custom function to draw the congratulations text with outline 
draw_text_transformed_outlined(x, y - map_value(image_xscale, 0, 1, 0, 200), congrats_text, image_xscale, image_yscale, image_angle, #baaa7d, #33261E);

// Optional: Draw additional info (health and stars earned)
draw_set_font(ft_game_end_small);
var info_text = "Health: " + string(current_health) + " | " + string(stars_earned) + " Star" + (stars_earned == 1 ? "" : "s") + " Earned!";
draw_text_transformed_outlined(x, y - map_value(image_xscale, 0, 1, 0, 100), info_text, image_xscale * 0.8, image_yscale * 0.8, image_angle, #baaa7d, #33261E);

// Reset text alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
