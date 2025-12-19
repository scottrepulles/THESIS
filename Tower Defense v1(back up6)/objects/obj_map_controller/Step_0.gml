// Decide rank based on trophies
if (global.player_trophies < 500) {
    current_rank = "bronze";
} else if (global.player_trophies < 1000) {
    current_rank = "silver";
} else if (global.player_trophies < 2000) {
    current_rank = "gold";
} else {
    current_rank = "platinum";
}
