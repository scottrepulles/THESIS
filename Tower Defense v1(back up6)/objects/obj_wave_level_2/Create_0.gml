/// @description Wave Manager  Level 4-7

// Inherit the parent event
event_inherited();

// Choose which path to follow based on the current 
if (room == rm_rank_bronze) { 
    level_path = pth_bronze;
} else if (room == rm_rank_bronze_2) {
    level_path = pth_bronze_2;
	
} else if (room == rm_rank_silver) {
    level_path = pth_silver;
} else if (room == rm_rank_platinum) {
    level_path = pth_platinum;
	
	
} else if (room == rm_rank_gold) {
    level_path = pth_gold;
} else if (room == rm_rank_gold_2) {
    level_path = pth_gold_2;	
	
} else if (room == rm_rank_platinum_2) {
    level_path = pth_platinum_2;
	
} else if (room == rm_level_1) {
    level_path = ch_room_path_lvl_1;
	
} else if (room == rm_level_2) {
    level_path = ch_room_path_lvl_2;
	
} else if (room == rm_level_3) {
    level_path = ch_room_path_lvl_3;
	
} else if (room == rm_level_4) {
    level_path = ch_room_path_lvl_4;
	
} else if (room == rm_level_5) {
    level_path = ch_room_path_lvl_5;
	
} else if (room == rm_level_6) {
    level_path = ch_room_path_lvl_6;
	
} else if (room == rm_level_9) {
    level_path = ch_room_path_lvl_9;
	
} else if (room == rm_level_7) {
    level_path = ch_room_path_lvl_7;
	
} else if (room == rm_level_8) {
    level_path = ch_room_path_lvl_8;
	
} else if (room == rm_level_10) {
    level_path = ch_room_path_lvl_10;
} else {
    level_path = pth_bronze; // fallback/default
}

/*
	Use the following form to create a new wave: array_push(wave_array, new WaveData(_enemy_array, _wave_delay));
	...
*/

// Wave 1
array_push(wave_array, new WaveData(
	[obj_monster_1, obj_monster_1, obj_monster_1, obj_monster_3, obj_monster_3, obj_monster_3,
	obj_monster_4,obj_monster_4,obj_monster_4, obj_monster_3, obj_monster_3, obj_monster_3],
	(room_speed * 3)
));

// Wave 2
array_push(wave_array, new WaveData(
	[obj_monster_1, obj_monster_1, obj_monster_3, obj_monster_3, obj_monster_4, 
	obj_monster_1, obj_monster_4, obj_monster_4,	obj_monster_3, obj_monster_4,obj_monster_boss],
	(room_speed * 1.75)
));

// Wave 3
array_push(wave_array, new WaveData(
	[obj_monster_1, obj_monster_3, obj_monster_1, obj_monster_3, obj_monster_3, 
	obj_monster_4, obj_monster_4, obj_monster_4,	obj_monster_4, obj_monster_4, 
	obj_monster_1, obj_monster_2, obj_monster_2,	obj_monster_3, obj_monster_4, 
	obj_monster_4, obj_monster_3, obj_monster_3,	obj_monster_1, obj_monster_boss],
	(room_speed  * 1.55)
));