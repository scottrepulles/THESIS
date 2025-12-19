var mx = mouse_x;
var my = mouse_y;

// Check Enter Map button
if (mx > 100 && mx < 250 && my > 120 && my < 170) {
    switch (current_rank) {
        case "bronze":   room_goto(rm_rank_bronze_2);   break;
        case "silver":   room_goto(rm_rank_platinum);   break;
        case "gold":     room_goto(rm_rank_gold_2);   break;
        case "platinum": room_goto(rm_rank_platinum_2);   break;
    }
}
