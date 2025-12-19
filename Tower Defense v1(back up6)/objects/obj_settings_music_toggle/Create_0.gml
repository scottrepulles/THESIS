// Position (set by obj_bg_settings, but provide defaults)
if (x == 0 && y == 0) {
    x = room_width / 2 + 200;
    y = room_height / 2 - 120;
}

// Button properties
width = 140;
height = 50;
hover = false;
scale = 1;
target_scale = 1;

// Colors
color_on = make_color_rgb(76, 175, 80);  // Green
color_off = make_color_rgb(244, 67, 54); // Red

// Depth
depth = -10;


// Enable mouse events
image_xscale = 1;
image_yscale = 1;
