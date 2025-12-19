// Outer glow layers
var glow_layers = 10;
var max_glow_radius = tower_range + 30;

for (var i = glow_layers; i >= 1; i--)
{
    var layer_ratio = i / glow_layers;
    var current_radius = tower_range + (layer_ratio * 30); // Extends 30 pixels beyond
    var glow_alpha = 0.3 * (1 - layer_ratio) * (1 - layer_ratio); // Smooth fade
    
    // Neon blue with cyan tint
    draw_set_colour(make_colour_rgb(0, 180 + (75 * layer_ratio), 255));
    draw_set_alpha(glow_alpha);
    draw_circle(x, y, current_radius, true);
}

// Main range circle
draw_set_colour(make_colour_rgb(100, 200, 255));
draw_set_alpha(0.4);
draw_circle(x, y, tower_range, true);

// Inner filled circle (subtle)
draw_set_colour(make_colour_rgb(150, 230, 255));
draw_set_alpha(0.1);
draw_circle(x, y, tower_range, false);

// Reset and draw tower
draw_set_alpha(1);
draw_set_colour(c_white);
draw_self();
