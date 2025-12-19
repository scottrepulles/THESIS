// Login function
if (username_input == "" || password_input == "") {
    message = "Please fill in all fields!";
    message_color = c_red;
    return;
}

if (validate_login(username_input, password_input)) {
    message = "Login successful! Welcome " + username_input + "!";
    message_color = c_green;
    
    // Store the logged-in username globally
    global.current_user = username_input;
    
    // Wait a moment then go to landing room
    alarm[1] = 60; // 1 second delay
    
} else {
    message = "Invalid username or password!";
    message_color = c_red;
}
