/// @description Initialize shop frame

depth = -100;

// Shop position and size
shop_x = room_width / 2;
shop_y = room_height / 2;

// Grid layout configuration
grid_cols = 2;
grid_rows = 2;
box_spacing = 20;
box_width = sprite_get_width(spr_box);
box_height = sprite_get_height(spr_box);

// Calculate frame dimensions
frame_width = sprite_get_width(spr_shopframe);
frame_height = sprite_get_height(spr_shopframe);

// Calculate grid start position (centered in frame)
grid_start_x = shop_x - ((grid_cols * box_width + (grid_cols - 1) * box_spacing) / 2);
grid_start_y = shop_y - ((grid_rows * box_height + (grid_rows - 1) * box_spacing) / 2);

// Close button properties
close_btn_x = shop_x + frame_width/2 - 30;
close_btn_y = shop_y - frame_height/2 + 30;
close_btn_radius = 15;
close_btn_hovered = false;

// Array to track created boxes
boxes = [];

//// Create tower skin boxes
//scr_create_tower_boxes(id);
