// Deselect all buttons
with(obj_button_beginner) is_selected = false;
with(obj_button_intermidiate) is_selected = false;
with(obj_button_expert) is_selected = false;
with(obj_button_history) is_selected = false;
with(obj_button_sql) is_selected = false;
// Select this button
is_selected = true;

// Update the board content
if (instance_exists(obj_board3)) {
    obj_board3.set_lesson_content("beginner");
}
