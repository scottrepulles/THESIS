draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Background panel
draw_set_color(make_color_rgb(24,24,28));
draw_rectangle(center_x - 220, center_y - 170, center_x + 220, center_y + 220, false);
draw_set_color(c_white);
draw_rectangle(center_x - 220, center_y - 170, center_x + 220, center_y + 220, true);

// Title
var title = current_mode == "login" ? "LOGIN" : "CREATE ACCOUNT";
draw_set_color(c_white);
draw_text(center_x, center_y - 140, title);

// Username field
draw_set_halign(fa_left);
draw_set_color(c_white);
draw_text(center_x - textbox_width/2, center_y - 100, "Username:");

var username_color = active_field == "username" ? c_yellow : c_white;
draw_set_color(username_color);
draw_rectangle(center_x - textbox_width/2, center_y - 80, 
               center_x + textbox_width/2, center_y - 50, true);
draw_set_color(c_white);
draw_text(center_x - textbox_width/2 + 5, center_y - 65, username_input);

// Password field
draw_text(center_x - textbox_width/2, center_y - 50, "Password:");

var password_color = active_field == "password" ? c_yellow : c_white;
draw_set_color(password_color);
draw_rectangle(center_x - textbox_width/2, center_y - 30, 
               center_x + textbox_width/2, center_y, true);
draw_set_color(c_white);
// Draw asterisks for password
var password_display = "";
for (var i = 0; i < string_length(password_input); i++) {
    password_display += "*";
}
draw_text(center_x - textbox_width/2 + 5, center_y - 15, password_display);

// Confirm password field (only in register mode)
if (current_mode == "register") {
    draw_text(center_x - textbox_width/2, center_y, "Confirm Password:");
    
    var confirm_color = active_field == "confirm" ? c_yellow : c_white;
    draw_set_color(confirm_color);
    draw_rectangle(center_x - textbox_width/2, center_y + 20, 
                   center_x + textbox_width/2, center_y + 50, true);
    draw_set_color(c_white);
    // Draw asterisks for confirm password
    var confirm_display = "";
    for (var i = 0; i < string_length(confirm_password_input); i++) {
        confirm_display += "*";
    }
    draw_text(center_x - textbox_width/2 + 5, center_y + 35, confirm_display);
}

// Main button (Login/Register)
var main_button_y = current_mode == "login" ? center_y + 30 : center_y + 70;
var main_button_text = current_mode == "login" ? "LOGIN" : "CREATE ACCOUNT";

// Highlight button if selected
var main_button_bg_color = active_field == "main_button" ? make_color_rgb(30,180,120) : make_color_rgb(22,140,100);
draw_set_color(main_button_bg_color);
draw_rectangle(center_x - button_width/2, main_button_y, 
               center_x + button_width/2, main_button_y + button_height, false);

var main_button_border_color = active_field == "main_button" ? c_yellow : c_white;
draw_set_color(main_button_border_color);
draw_rectangle(center_x - button_width/2, main_button_y, 
               center_x + button_width/2, main_button_y + button_height, true);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(center_x, main_button_y + button_height/2, main_button_text);

// Switch mode button
var switch_button_y = current_mode == "login" ? center_y + 80 : center_y + 120;
var switch_button_text = current_mode == "login" ? "CREATE NEW ACCOUNT" : "BACK TO LOGIN";

// Highlight button if selected
var switch_button_bg_color = active_field == "switch_button" ? make_color_rgb(60,100,220) : make_color_rgb(40,70,180);
draw_set_color(switch_button_bg_color);
draw_rectangle(center_x - button_width/2, switch_button_y, 
               center_x + button_width/2, switch_button_y + button_height, false);

var switch_button_border_color = active_field == "switch_button" ? c_yellow : c_white;
draw_set_color(switch_button_border_color);
draw_rectangle(center_x - button_width/2, switch_button_y, 
               center_x + button_width/2, switch_button_y + button_height, true);

draw_set_color(c_white);
draw_text(center_x, switch_button_y + button_height/2, switch_button_text);

// Message
if (message != "") {
    draw_set_color(message_color);
    var message_y = current_mode == "login" ? center_y + 140 : center_y + 180;
    draw_text(center_x, message_y, message);
}

// Instructions
draw_set_color(c_gray);
draw_set_halign(fa_center);
var instruction_y = current_mode == "login" ? center_y + 160 : center_y + 200;
draw_text(center_x, instruction_y, "TAB: Navigate  |  ENTER: Submit  |  CLICK: Focus");
