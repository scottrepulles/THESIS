

current_step = 0;
max_steps = 8;

// Tutorial steps array
tutorial_steps = [
    spr_tutorial_1towerbase,
    spr_tutorial_2hud,
    spr_tutorial_3blank,
    spr_tutorial_4build,
    spr_tutorial_5upgrade,
    spr_tutorial_7countdown,
    spr_tutorial_8quiz,
    spr_tutorial_9done
];

// Titles for each step
tutorial_titles = [
    "Tower Base",
    "HUD Overview",
    "Game Area",
    "Building Towers",
    "Upgrading Towers",
    "Countdown Timer",
    "Quiz Challenge",
    "Completion"
];

// Descriptions for each step
tutorial_descriptions = [
    "Place your tower on the base to defend against enemies",
    "Monitor your resources and score at the top of screen",
    "This is where the action happens during gameplay",
    "Click to build towers in strategic locations",
    "Upgrade your towers to increase power and range",
    "Complete objectives before time runs out",
    "Answer quiz questions correctly to earn bonuses",
    "Congratulations! You're ready to play the game!"
];

// Scrolling variables
scroll_y = 0;
scroll_speed = 25;
max_scroll = 0;
min_scroll = 0;

// Box dimensions
box_padding = 50;
box_min_height = 300;
box_spacing_x = 30;
box_spacing_y = 40;
boxes_per_row = 2;

// Get sprite dimensions
frame_width = sprite_width;
frame_height = sprite_height;

// Initialize total_height variable
total_height = 0;

// Calculate dynamic box heights based on content
box_heights = array_create(max_steps, 0);
box_y_positions = array_create(max_steps, 0);

// Calculate each box height
var frame_left = x - frame_width/2;
var inner_left = frame_left + box_padding;
var inner_width = frame_width - box_padding * 2;
var box_width = ((inner_width - box_spacing_x - 40) / 2);

for (var i = 0; i < max_steps; i++) {
    var title_bar_height = 32;
    var title_bottom_padding = 18;
    
    var spr_w = sprite_get_width(tutorial_steps[i]);
    var spr_h = sprite_get_height(tutorial_steps[i]);
    var sprite_area_width = box_width - 40;
    var scale_x = sprite_area_width / spr_w;
    var sprite_display_height = (spr_h * scale_x * 0.7);
    
    var sprite_bottom_padding = 25;
    var desc_width = sprite_area_width - 30;
    var line_height = 18;
    var desc_height = string_height_ext(tutorial_descriptions[i], line_height, desc_width);
    var desc_box_padding = 16;
    var hint_height = 22;
    var bottom_padding = 18;
    
    var total_box_height = title_bar_height + 
                          title_bottom_padding + 
                          sprite_display_height + 
                          sprite_bottom_padding + 
                          desc_height + 
                          (desc_box_padding * 2) + 
                          hint_height + 
                          bottom_padding;
    
    box_heights[i] = max(total_box_height, box_min_height);
}

// Calculate Y positions for each box
total_height = 0;
for (var i = 0; i < max_steps; i++) {
    var row = floor(i / boxes_per_row);
    var col = i % boxes_per_row;
    
    if (col == 0) {
        if (row > 0) {
            var prev_left_idx = (row-1) * boxes_per_row;
            var prev_right_idx = prev_left_idx + 1;
            
            var prev_row_max_height = box_heights[prev_left_idx];
            if (prev_right_idx < max_steps) {
                prev_row_max_height = max(box_heights[prev_left_idx], box_heights[prev_right_idx]);
            }
            
            total_height += prev_row_max_height + box_spacing_y;
        }
        box_y_positions[i] = total_height;
    } else {
        box_y_positions[i] = box_y_positions[i - 1];
    }
}

var last_row = floor((max_steps - 1) / boxes_per_row);
var last_left_idx = last_row * boxes_per_row;
var last_right_idx = last_left_idx + 1;

var last_row_max_height = box_heights[last_left_idx];
if (last_right_idx < max_steps) {
    last_row_max_height = max(box_heights[last_left_idx], box_heights[last_right_idx]);
}
total_height += last_row_max_height;

// Popup variables
popup_active = false;
popup_sprite = -1;
popup_title = "";
popup_description = "";
popup_alpha = 0;
popup_scale = 0.5;
popup_index = -1;

// Hover state
hovered_box = -1;

// Drag and swap variables
dragging = false;
dragged_index = -1;
drag_start_x = 0;
drag_start_y = 0;
drag_offset_x = 0;
drag_offset_y = 0;
swap_target = -1;

// Swipe/touch variables
touch_start_y = 0;
touch_start_scroll = 0;
is_touching = false;
touch_velocity = 0;
last_touch_y = 0;
inertia_active = false;
inertia_friction = 0.92;


depth = -1000; 
