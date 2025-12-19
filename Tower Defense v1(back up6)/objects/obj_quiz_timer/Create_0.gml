/// obj_quiz_timer - Create Event
// Visual timer object that displays quiz countdown
// This object can be placed anywhere in the room and stays visible

// Position is set in the room editor (x, y)
// Sprite should be spr_quiz_timer (a button-like background)

// Animation/visual properties
image_speed = 0;
image_index = 0;
image_alpha = 1; // Always visible

// Timer display properties
timer_color = c_white;
timer_bg_color = c_dkgray;

// Pulsing/warning animation
pulse_scale = 1;
pulse_speed = 0;
glow_alpha = 0;
glow_size = 0;

// Get sprite dimensions for centering
sprite_center_x = sprite_get_width(sprite_index) / 2;
sprite_center_y = sprite_get_height(sprite_index) / 2;

// Display mode: "waiting", "warning", "active"
display_mode = "waiting";

// Smooth transitions
transition_progress = 0;
prev_time = 0;
current_time_display = 0;

show_debug_message("Quiz timer object created at position: " + string(x) + ", " + string(y));
