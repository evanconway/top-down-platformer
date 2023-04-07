draw_set_color(c_lime);
draw_text(0, 0, "(" + string(x) + "," + string(y) + ")");

if (place_meeting(x, y, obj_movement_test_wall)) {
	draw_text(0, 18, "collide");
}
