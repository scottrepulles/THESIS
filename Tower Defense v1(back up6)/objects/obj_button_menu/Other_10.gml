/// @description Menu Button

// Play the button press sound effect
audio_play_sound(snd_button_click, 0, false);

// Check if we're in a rank room
var room_name = room_get_name(room);
var is_rank_room = false;

// Check if current room is any of the rank rooms
if (room == rm_rank_bronze || room == rm_rank_bronze_2 ||
    room == rm_rank_silver ||
    room == rm_rank_gold || room == rm_rank_gold_2 ||
    room == rm_rank_platinum || room == rm_rank_platinum_2) {
    is_rank_room = true;
}

// Go to appropriate room based on where we are
if (is_rank_room) {
    room_goto(rm_picking_mode);
    show_debug_message("Returning to picking mode from rank room");
} else {
    room_goto(rm_level);
    show_debug_message("Returning to level select");
}
