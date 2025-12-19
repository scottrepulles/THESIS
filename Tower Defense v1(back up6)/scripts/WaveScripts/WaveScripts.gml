/// WaveScript Functions

/*
    These are functions used with the obj_wave_manager object to 
    create, start, and manage waves. With the exception of the constructor
    they all access instance variables in obj_wave_manager using with() 
    to ensure that an instance of obj_wave_manager exists.
*/

/// @description This function is a constructor that creates a struct that contains data for a wave
/// @param {array} _enemy_array 
/// @param {int} _wave_delay 
/// @returns {struct} 
function WaveData(_enemy_array, _wave_delay) constructor 
{
    // enemy_array should be an array of GameMaker Objects
    enemy_array = _enemy_array;
    
    // wave_delay should be the amount of time in frames you want to wait before spawning a new enemy
    wave_delay = _wave_delay;
}

/// @description Start the next wave
function start_next_wave()
{
    global.waves_have_started = true;
    
    global.quiz_next_time = irandom_range(room_speed * 20, room_speed * 40);
    global.quiz_warning_active = false;
    global.quiz_warning_timer = 0;

    // Uses with() to access the instance of obj_wave_manager.
    // with() only works if an instance of the object exists.
    with (obj_wave_manager)
    {
        // Check if this is the first wave before incrementing
        var is_first_wave = (wave == 1);
        
        // Tutorial now runs BEFORE waves on START click; do not start here
        // (Wave starts only after tutorial completion)
        
        // Prevent out-of-bounds error if no more waves
        if (wave - 1 < 0 || wave - 1 >= array_length(wave_array)) {
            show_debug_message("No more waves or invalid wave index!");
            waves_over = true; // Optionally set a flag to indicate all waves are done
            exit; // Stops the script to prevent the crash
        }

        // Assign the next wave struct to the current_wave_struct.
        current_wave_struct = wave_array[wave - 1];
        
        // This variable marks the current position in the enemy array
        // and will be increased each time an enemy is spawned
        position = 0;
        
        // This variable tells whether a wave is currently running
        wave_running = true;    
        
        // Spawn the first enemy in the wave
        event_perform(ev_alarm, 0);
    }
    
    // Create the wave start banner sequence
    layer_sequence_create("Sequences", 0, 0, seq_wave_start_banner);
}

/// @description Returns true if the wave is currently running, otherwise returns false
/// @returns bool
function wave_is_running()
{

    // Uses with() to access the instance of obj_wave_manager.
    // with() only works if an instance of the object exists.
    with (obj_wave_manager)
    {
        // Return the boolean value stored in the wave_running variable of obj_wave_manager.
        // return will end the function
        return wave_running;
    }
    
    // If we make it here, then there is no instance of obj_wave_manager to check,
    // so we will return false instead.
    return false;
}

/// @description Returns true if the waves are over, otherwise returns false
/// @returns bool
function waves_are_over()
{
    
    // Uses with() to access the instance of obj_wave_manager.
    // with() only works if an instance of the object exists.
    with (obj_wave_manager)
    {
        // Return the boolean value stored in the waves_over variable of obj_wave_manager.
        // return will end the function
        return waves_over;
    }
    
    // If we make it here, then there is no instance of obj_wave_manager to check,
    // so we will return false instead.
    return false;    
}

/// @description Returns the current wave number
/// @returns number
function return_wave_number()
{
    
    // Uses with() to access the instance of obj_wave_manager.
    // with() only works if an instance of the object exists.
    with (obj_wave_manager)
    {
        // Return the number stored in the wave variable of obj_wave_manager.
        // return will end the function
        return wave;
    }    
    
    // If we make it here, then there is no instance of obj_wave_manager to check,
    // so we will return -1 instead.
    return -1;
}