var _vel = 1;
if (keyboard_check_pressed(vk_right)) box_x += _vel;
if (keyboard_check_pressed(vk_left)) box_x -= _vel;
if (keyboard_check_pressed(vk_down)) box_y += _vel;
if (keyboard_check_pressed(vk_up)) box_y -= _vel;

boxes_place(8, 8, 4, 4, "wall");
boxes_draw("wall", c_lime);
boxes_place(box_x, box_y, 4, 4, "player");
boxes_place(box_x + 4, box_y, 3, 3, "player");
boxes_draw("player");
if (boxes_get_name_collides_name("player", "wall")) {
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(0, 0, "!");
}
boxes_clear_all();
