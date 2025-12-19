/// @description Draw shop frame and UI

// Draw shop frame background
draw_sprite(spr_shopframe, 0, shop_x, shop_y);

// Draw title
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(-1);
draw_text(shop_x, shop_y - frame_height/2 + 20, "TOWER SKINS SHOP");

// Draw player coins (static display)
draw_set_halign(fa_left);
draw_set_color(c_yellow);
draw_text(shop_x - frame_width/2 + 20, shop_y - frame_height/2 + 50, "Coins: " + string(global.player_coins));

// Draw close button
if (close_btn_hovered) {
    draw_set_color(c_maroon);
} else {
    draw_set_color(c_red);
}
draw_circle(close_btn_x, close_btn_y, close_btn_radius, false);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(close_btn_x, close_btn_y, "X");

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
