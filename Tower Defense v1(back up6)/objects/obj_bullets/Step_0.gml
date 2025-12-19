// Check if target still exists
if (instance_exists(target_id))
{
    // Gradually turn towards target
    var target_dir = point_direction(x, y, target_id.x, target_id.y);
    var turn_speed = 0; // Adjust this value (higher = more responsive)
    
    direction += angle_difference(target_dir, direction) * turn_speed * (1/60);
    
    // Check for collision
    if (place_meeting(x, y, target_id))
    {
        target_id.hp -= damage; // Assuming enemy has hp variable
        instance_destroy();
    }
}
else
{
    // Target destroyed, continue in straight line or destroy bullet
    // Optional: destroy bullet after some time
}
