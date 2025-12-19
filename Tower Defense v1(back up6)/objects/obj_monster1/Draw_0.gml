


var xx1 = x - 5;
var yy1 = bbox_top - 5;
var xx2 = x + 5;
var yy2 = bbox_top - 3;

var amount = (hp/max_hp) * 100; // (current_health/ max_health) * 10

draw_self();

draw_healthbar(xx1, yy1, xx2, yy2, amount, c_black, c_red, c_green, 0, true, false);