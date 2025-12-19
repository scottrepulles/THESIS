/// @description Wave Start Button

// Check if we're in the tutorial room
if (room == rm_tutorial) {
    // Tutorial-specific logic
    global.show_tutorial = true;
    global.tutorial_index = 0;
    global.tutorial_visible = true; // ensure popup shows and fades in
    global.tutorial_active = true;
    global.menu_lock = true;

    // Ensure tutorial manager exists to handle Q&A
    if (!instance_exists(obj_tutorial_manager)) {
        instance_create_layer(0, 0, "Instances", obj_tutorial_manager);
    }

    // Do NOT start waves yet; wait until tutorial completes
}
else {
    // Normal gameplay logic (not in tutorial room)
    // Start the next wave using our custom function
    start_next_wave();
}

// Common actions for both cases
// Destroy this button
instance_destroy(id);

// Play the button press sound effect
audio_play_sound(snd_button_click, 0, false);
