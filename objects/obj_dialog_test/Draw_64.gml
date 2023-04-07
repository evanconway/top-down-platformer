if (keyboard_check_pressed(ord("1"))) dialog_set_step(dialog, "greet_tutorial_person");
if (keyboard_check_pressed(ord("2"))) dialog_set_step(dialog, "ends_in_choice");
if (keyboard_check_pressed(ord("3"))) dialog_set_step(dialog, "basic_conversation");

var _text = dialog_get_text(dialog);

draw_set_color(c_white);
draw_set_alpha(1);

var _x = 20;
var _y = 20;

if (dialog_get_is_active(dialog)) {
	draw_text_ext(_x, _y, dialog_get_text(dialog), 0, 100);
	_x += 120;

	var _options = dialog_get_options(dialog);

	for (var _i = 0; _i < array_length(_options); _i++) {
		draw_text(_x, _y, _options[_i].text + string(selected_option == _i ? "<" : ""));
		_y += 20;
	}

	if (array_length(_options) > 0) {
		if (keyboard_check_pressed(vk_enter)) {
			dialog_choose_option(dialog, selected_option);
			selected_option = 0;
		} else if (keyboard_check_pressed(vk_up)) selected_option = clamp(selected_option - 1, 0, array_length(_options) - 1);
		else if (keyboard_check_pressed(vk_down)) selected_option = clamp(selected_option + 1, 0, array_length(_options) - 1);
	} else if (keyboard_check_pressed(vk_enter)) {
		dialog_set_step_next(dialog);
	}
} else {
	draw_text(_x, _y, "Dialog is not active.\nPress 1: greet_tutorial_person\nPress 2: ends_in_choice\nPress 3: basic_conversation");
}
