// Get the current room and set appropriate path
var current_path;

switch(room) {
    case Room_ice:
        current_path = path2;
        break;
    case rm_game:
        current_path = path1;
        break;
    case rm_rank_bronze:
        current_path = pth_bronze_2;
        break;
	case rm_rank_silver:
        current_path = pth_silver;
        break;	
	case rm_rank_gold:
        current_path = pth_gold;
        break;
	case rm_rank_platinum111:
        current_path = pth_platinum111;
        break;	




    default:
        current_path = path1; // fallback path
        break;
}

// Start the path based on current room
path_start(current_path, 2, path_action_stop, true);

max_hp = 4;
hp = max_hp;
