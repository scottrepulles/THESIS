

// Check if monster is destroyed by damage
if (hp <= 0) {
    instance_destroy();
}

// Check if monster reached end of path
if (path_position == 1) {
    instance_destroy();
    lives--; // Make sure 'lives' is a global variable or belongs to the right object
}
