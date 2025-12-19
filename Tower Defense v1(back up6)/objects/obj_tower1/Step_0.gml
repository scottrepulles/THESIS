// Find the first enemy in range
var enemy_in_range = collision_circle(x, y, tower_range, obj_monster1, true, false);

if (enemy_in_range != noone && ready_to_fire)
{
    ready_to_fire = false;
    alarm[0] = reload_time;

    // Calculate predicted position
    var bullet_speed = 10;
    var dist_to_enemy = point_distance(x, y - 17, enemy_in_range.x, enemy_in_range.y);
    var time_to_hit = dist_to_enemy / bullet_speed;
    
    // Predict where enemy will be
    var predicted_x = enemy_in_range.x + (enemy_in_range.hspeed * time_to_hit);
    var predicted_y = enemy_in_range.y + (enemy_in_range.vspeed * time_to_hit);

    // Create bullet and aim at predicted position
    with (instance_create_layer(x, (y - 17), layer, obj_bullets))
    {
        direction = point_direction(x, y, predicted_x, predicted_y);
        target_id = enemy_in_range;
        other.predicted_x = predicted_x;
        other.predicted_y = predicted_y;
    }
}
