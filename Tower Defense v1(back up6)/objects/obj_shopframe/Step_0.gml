/// @description Handle close button only

// Check close button hover
close_btn_hovered = point_distance(mouse_x, mouse_y, close_btn_x, close_btn_y) < close_btn_radius;

// Close button click
if (close_btn_hovered && mouse_check_button_pressed(mb_left)) {
    instance_destroy();
}

// Close with ESC key
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
}
