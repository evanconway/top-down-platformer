var _x = 20;
var _y = 20;

if (conversation_get_is_active(conversation)) conversation_update_and_draw(conversation, _x, _y,);
else {
	if (keyboard_check_pressed(ord("1"))) conversation_start(conversation, "greet_tutorial_person");
	if (keyboard_check_pressed(ord("2"))) conversation_start(conversation, "ends_in_choice");
	if (keyboard_check_pressed(ord("3"))) conversation_start(conversation, "basic_conversation");
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	draw_text(_x, _y, "Dialog is not active.\nPress 1: greet_tutorial_person\nPress 2: ends_in_choice\nPress 3: basic_conversation");
}
