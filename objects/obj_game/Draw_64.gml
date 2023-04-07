with (obj_player) {
	draw_set_alpha(1);
	draw_set_color(c_lime);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text(0, 0, "(" + string(x) + "," + string(y) + ")");
}

if (!game_active) {
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(display_get_gui_width() / 2, display_get_gui_height() /2 , "game over\npress R to restart");
}