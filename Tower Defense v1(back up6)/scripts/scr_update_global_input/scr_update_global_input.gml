/// @description Update global input variables
/// Call this once per frame in a controller object

function scr_update_global_input() {
    // Update mouse click states
    global.mouse_clicked = mouse_check_button_pressed(mb_left);
    global.mouse_released = mouse_check_button_released(mb_left);
    
    // Update mouse positions
    global.mouse_x_gui = mouse_x;
    global.mouse_y_gui = mouse_y;
}
