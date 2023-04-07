/**
 * Create a new TextMenu.
 * @param {array<string>} _options
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 * @param {string} _selected_effects
 */
function TextMenu(_options, _default_effects = "gray", _highlight_effects = "yellow fade", _selected_effects = "lime") constructor{
	/// @ignore
	list = new TextButtonList(_options, _default_effects, _highlight_effects, _selected_effects);
	/// @ignore
	get_mouse_x = function() {
		return window_mouse_get_x();
	};
	/// @ignore
	get_mouse_y = function() {
		return window_mouse_get_y();
	};
	/// @ignore
	check_mouse_select_pressed = function() {
		return mouse_check_button_pressed(mb_left);
	};
	/// @ignore
	check_previous_pressed = function() {
		return keyboard_check_pressed(vk_up);
	};
	/// @ignore
	check_next_pressed = function() {
		return keyboard_check_pressed(vk_down);
	};
	/// @ignore
	check_select_pressed = function() {
		return keyboard_check_pressed(vk_enter);
	};
	/// @ignore
	check_other_input = function() {
		return keyboard_check_pressed(vk_anykey);
	};
	/// @ignore
	previous_mx = get_mouse_x();
	/// @ignore
	previous_my = get_mouse_y();
	/// @ignore
	using_mouse = false;
	/// @ignore
	selected_time = -1;
	/// @ignore
	selected_time_max = 25;
	/// @ignore
	is_vertical = true;

	/// @param {real} _option_selected_index
	on_option_selected = function(_option_selected_index) {
		show_debug_message("text menu on_option_selected: " + string(_option_selected_index));
	};

	/// @param {real} _option_selected_index
	on_option_selected_animation_finished = function(_option_selected_index) {
		show_debug_message("text menu on_option_selected_animation_finished invoked: " + string(_option_selected_index));
	};
}

/**
 * Gets the using_mouse state of the given text menu.
 *
 * @param {Struct.TextMenu} _text_menu
 */
function text_menu_get_using_mouse(_text_menu) {
	return _text_menu.using_mouse;
}

/**
 * Sets the using_mouse state of the given text menu. Note that this
 * setting is set in the update function.
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {bool} _using_mouse
 */
function text_menu_set_using_mouse(_text_menu, _using_mouse) {
	with (_text_menu) {
		using_mouse = _using_mouse;
		if (using_mouse) {
			text_button_list_reset_option_animations(list, text_button_list_get_highlighted_option(list));
			list.highlighted_option = -1;
		}
	}
}

/**
 * Sets the distance in pixels between options.
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _distance
 */
function text_menu_set_distance_between_option(_text_menu, _distance) {
	text_button_list_set_distance_between_options(_text_menu.list, _distance);
}

/**
 * Sets if the given text menu is vertical. If _vertical is falst the menu will display horizontal.
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {bool} _vertical
 */
function text_menu_set_is_vertical(_text_menu, _vertical) {
	_text_menu.is_vertical = _vertical;
}


// NEED TO ADD FUNCTIONS TO DETECT AND SET INPUT

/**
 * Set the function used to determine the x position of the mouse.
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _get_mouse_x function needs to return real
 */
function text_menu_set_get_mouse_x(_text_menu, _get_mouse_x) {
	_text_menu.get_mouse_x = _get_mouse_x;
}

/**
 * Set the function used to determine the y position of the mouse.
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _get_mouse_y function needs to return real
 */
function text_menu_set_get_mouse_y(_text_menu, _get_mouse_y) {
	_text_menu.get_mouse_y = _get_mouse_y;
}

/**
 * Set the function used to determine if the user pressed select with the mouse.
 * Default is check_mouse_pressed(mb_left);
 * 
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _check_mouse_select_pressed
 */
function text_menu_set_mouse_check_pressed(_text_menu, _check_mouse_select_pressed) {
	_text_menu.check_mouse_select_pressed = _check_mouse_select_pressed;
}

/**
 * Set the function used to determine if the user pressed previous.
 * Default is keyboard_check_pressed(vk_up);
 * 
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _check_previous_pressed
 */
function text_menu_set_check_previous_pressed(_text_menu, _check_previous_pressed) {
	_text_menu.check_previous_pressed = _check_previous_pressed;
}

/**
 * Set the function used to determine if the user pressed next.
 * Default is keyboard_check_pressed(vk_down);
 * 
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _check_next_pressed
 */
function text_menu_set_check_next_pressed(_text_menu, _check_next_pressed) {
	_text_menu.check_next_pressed = _check_next_pressed;
}

/**
 * Set the function used to determine if the user pressed select.
 * Default is keyboard_check_pressed(vk_enter);
 * 
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _check_select_pressed
 */
function text_menu_set_check_select_pressed(_text_menu, _check_select_pressed) {
	_text_menu.check_select_pressed = _check_select_pressed;
}

/**
 * Set the callback function invoked when the user selects an option
 * 
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _on_option_selected
 */
function text_menu_set_on_option_selected(_text_menu, _on_option_selected) {
	_text_menu.on_option_selected = _on_option_selected;
}

/**
 * Set the callback function invoked when the animation for selecting an
 * option finishes.
 * 
 * @param {Struct.TextMenu} _text_menu
 * @param {function} _on_option_selected_animation_finished
 */
function text_menu_set_on_option_selected_animation_finished(_text_menu, _on_option_selected_animation_finished) {
	_text_menu.on_option_selected_animation_finished = _on_option_selected_animation_finished;
}

/**
 * Update the given text menu. Animations are updated by the given update time in ms. Position and
 * alignment are required as well to determine button state.
 *
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {Constant.HAlign} _alignment
 * @param {real} _update_time_ms
 */
function text_menu_update(_text_menu, _list_x, _list_y, _alignment = fa_left, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (_text_menu) {
		var _current_mx = get_mouse_x();
		var _current_my = get_mouse_y();
		if (previous_mx != _current_mx || previous_my != _current_my || check_mouse_select_pressed()) using_mouse = true;
		else if (check_other_input()) using_mouse = false;
		
		var _highlighted_option_index = text_button_list_get_highlighted_option(list);
		
		if (selected_time > 0) {
			if (--selected_time <= 0) {
				on_option_selected_animation_finished(_highlighted_option_index);
				text_button_list_set_highlighted_option_selected(list, false);
				if (using_mouse) {
					if (is_vertical) text_button_list_set_highlighted_at_xy_vertical(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
					else text_button_list_set_highlighted_at_xy_horizontal(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
				}
			}
		} else if (using_mouse) {
			if (is_vertical) text_button_list_set_highlighted_at_xy_vertical(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
			else text_button_list_set_highlighted_at_xy_horizontal(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
			if (check_mouse_select_pressed()) {
				var _clicked_option_index = is_vertical ? 
					text_button_list_get_option_at_xy_vertical(list, _list_x, _list_y, _current_mx, _current_my, _alignment) 
					: 
					text_button_list_get_option_at_xy_horizontal(list, _list_x, _list_y, _current_mx, _current_my, _alignment);
				if (_highlighted_option_index == _clicked_option_index && _highlighted_option_index >= 0) {
					text_button_list_set_highlighted_option_selected(list, true);
					selected_time = selected_time_max;
					on_option_selected(_highlighted_option_index);
				}
			}
		} else {
			if (check_previous_pressed()) text_button_list_highlight_previous(list);
			if (check_next_pressed()) text_button_list_highlight_next(list);
			if (check_select_pressed() && _highlighted_option_index >= 0) {
				text_button_list_set_highlighted_option_selected(list, true);
				selected_time = selected_time_max;
				on_option_selected(_highlighted_option_index);
			}
		}

		previous_mx = _current_mx;
		previous_my = _current_my;
		
		text_button_list_update(list, _update_time_ms);
	}
}

/**
 * Draw the given text menu at the given xy, without updating state or text animations.
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_menu_draw_no_update(_text_menu, _x, _y, _alignment = fa_left) {
	with (_text_menu) {
		if (is_vertical) text_button_list_draw_vertical_no_update(list, _x, _y, _alignment);
		else text_button_list_draw_horizontal_no_update(list, _x, _y, _alignment);
	}
}

/**
 * Draw the given text menu at the given xy. Also updates menu state and text animations.
 * @param {Struct.TextMenu} _text_menu
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_menu_draw(_text_menu, _x, _y, _alignment = fa_left) {
	text_menu_update(_text_menu, _x, _y, _alignment);
	text_menu_draw_no_update(_text_menu, _x, _y, _alignment);
}
