/**
 * Create a new text button list instance.
 * @param {array<string>} _options
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 * @param {string} _selected_effects
 */
function TextButtonList(_options, _default_effects = "", _highlight_effects = "yellow fade", _selected_effects = "blink:0.6,1,50") constructor {
	/// @ignore
	options = [];
	
	for (var _i = 0; _i < array_length(_options); _i++) {
		array_push(options, new TextButton(_options[_i], _default_effects, _highlight_effects, _selected_effects));
	}
	
	/// @ignore
	width = 0;
	for (var _i = 0; _i < array_length(_options); _i++) {
		width += text_button_get_width(options[_i]);
	}
	
	/// @ignore
	height = 0;
	for (var _i = 0; _i < array_length(_options); _i++) {
		height += text_button_get_height(options[_i]);
	}
	
	/// @ignore
	highlighted_option = 0;
	
	/// @ignore
	highlighted_option_selected = false;
	/// @ignore
	reset_highlight_animation_on_change = true;
	/// @ignore
	reset_selected_animation_on_change = true;
	/// @ignore
	reset_default_animation_on_change = false;
	/// @ignore
	distance_between_options = 15;
}

/**
 * Sets the distance in pixels between options in the given text_button list.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _distance
 */
function text_button_list_set_distance_between_options(_text_button_list, _distance) {
	_text_button_list.distance_between_options = _distance;
}

/**
 * Sets the animation reset settings for default, highlight, and selected effects.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {bool} _reset_default
 * @param {bool} _reset_highlight
 * @param {bool} _reset_selected
 */
function text_button_list_set_animation_reset_options(_text_button_list, _reset_default, _reset_highlight, _reset_selected) {
	_text_button_list.reset_default_animation_on_change = _reset_default;
	_text_button_list.reset_highlight_animation_on_change = _reset_highlight;
	_text_button_list.reset_selected_animation_on_change = _reset_selected;
}

/**
 * Reset animation state of option at given index.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _option_index
 */
function text_button_list_reset_option_animations(_text_button_list, _option_index) {
	with (_text_button_list) {
		if (!reset_highlight_animation_on_change && !reset_selected_animation_on_change && !reset_default_animation_on_change) return;
		if (_option_index < 0 || _option_index >= array_length(options)) return;
		if (highlighted_option == _option_index && highlighted_option_selected && reset_selected_animation_on_change) {
			text_button_reset_animations_selected(options[_option_index]);
		} else if (highlighted_option == _option_index && reset_highlight_animation_on_change) {
			text_button_reset_animations_highlighted(options[_option_index]);
		} else if (reset_default_animation_on_change) {
			text_button_reset_animations_default(options[_option_index]);
		}
	}
}

/**
 * Resets the animations of the two given option indexes. But only if they differ.
 * This is mostly a utility function for resetting animations of newly changed
 * highlighted/selected option indexes.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _a
 * @param {real} _b
 */
function text_button_list_reset_two_animations(_text_button_list, _a, _b) {
	if (_a == _b) return;
	text_button_list_reset_option_animations(_text_button_list, _a);
	text_button_list_reset_option_animations(_text_button_list, _b);
}

/**
 * Return index of the highlighted option of the given text button list.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_get_highlighted_option(_text_button_list) {
	return _text_button_list.highlighted_option;
}

/**
 * Set the highlighted option of given text button list to given selected state.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {bool} _selected
 */
function text_button_list_set_highlighted_option_selected(_text_button_list, _selected) {
	with (_text_button_list) {
		highlighted_option_selected = _selected;
		text_button_list_reset_option_animations(self, highlighted_option);
	}
}

/**
 * Get width of given text button list.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_get_width(_text_button_list) {
	return _text_button_list.width;
}

/**
 * Get height of given text button list.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_get_height(_text_button_list) {
	return _text_button_list.height;
}

/**
 * Set highlighted option to previous option.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_highlight_previous(_text_button_list) {
	with (_text_button_list) {
		var _prev_highlighted = highlighted_option;
		highlighted_option--;
		highlighted_option = clamp(highlighted_option, 0, array_length(options) - 1);
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
	}
}

/**
 * Set highlighted option to next option.
 * @param {Struct.TextButtonList} _text_button_list
 */
function text_button_list_highlight_next(_text_button_list) {
	with (_text_button_list) {
		var _prev_highlighted = highlighted_option;
		highlighted_option++;
		highlighted_option = clamp(highlighted_option, 0, array_length(options) - 1);
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
	}
}

/**
 * Returns an array of vertical xy positions of buttons in the given text button list at given position and alignment.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_get_button_positions_vertical(_text_button_list, _x, _y, _alignment) {
	var _result = array_create(array_length(_text_button_list.options), [0]);
	with (_text_button_list) {
		for (var _i = 0; _i < array_length(_result); _i++) {
			if (_alignment == fa_left) _result[_i] = [_x, _y];
			if (_alignment == fa_right) _result[_i] = [_x - text_button_get_width(options[_i]), _y];
			if (_alignment == fa_center) _result[_i] = [_x - floor(text_button_get_width(options[_i]) / 2), _y];
			_y += (text_button_get_height(options[_i]) + distance_between_options);
		}
	}
	return _result;
}

/**
 * Returns an array of horizontal xy positions of buttons in the given text button list at given position and alignment.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_get_button_positions_horizontal(_text_button_list, _x, _y, _alignment) {
	var _result = array_create(array_length(_text_button_list.options), [0]);
	with (_text_button_list) {
		var _width_of_list = (array_length(options) - 1) * distance_between_options;
		for (var _i = 0; _i < array_length(options); _i++) {
			_width_of_list += text_button_get_width(options[_i]);
		}
		
		// modify starting _x based on alignment
		if (_alignment == fa_right) _x -= _width_of_list;
		if (_alignment == fa_center) _x -= floor(_width_of_list / 2);
		
		for (var _i = 0; _i < array_length(options); _i++) {
			_result[_i] = [_x, _y];
			_x += (text_button_get_width(options[_i]) + distance_between_options);
		}
	}
	return _result;
}

/**
 * Returns the index of the option in the given text button list that's at the given xy in vertical orientation.
 * Returns -1 if no option as at given xy.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_get_option_at_xy_vertical(_text_button_list, _list_x, _list_y, _x, _y, _alignment = fa_left) {
	var _positions = text_button_list_get_button_positions_vertical(_text_button_list, _list_x, _list_y, _alignment);
	for (var _i = 0; _i < array_length(_positions); _i++) {
		var _button_x = _positions[_i][0];
		var _button_y = _positions[_i][1];
		if (text_button_is_point_on(_text_button_list.options[_i], _button_x, _button_y, _x, _y)) return _i;
	}
	return -1;
}

/**
 * Returns the index of the option in the given text button list that's at the given xy in horizontal orientation.
 * Returns -1 if no option as at given xy.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_get_option_at_xy_horizontal(_text_button_list, _list_x, _list_y, _x, _y, _alignment = fa_left) {
	var _positions = text_button_list_get_button_positions_horizontal(_text_button_list, _list_x, _list_y, _alignment);
	for (var _i = 0; _i < array_length(_positions); _i++) {
		var _button_x = _positions[_i][0];
		var _button_y = _positions[_i][1];
		if (text_button_is_point_on(_text_button_list.options[_i], _button_x, _button_y, _x, _y)) return _i;
	}
	return -1;
}

/**
 * Sets the highlighted option to the option at the given xy, if the given text button list is at the given list xy vertically.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_set_highlighted_at_xy_vertical(_text_button_list, _list_x, _list_y, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		var _new_highlight = text_button_list_get_option_at_xy_vertical(self, _list_x, _list_y, _x, _y, _alignment);
		if (_new_highlight == highlighted_option) return;
		var _prev_highlighted = highlighted_option;
		highlighted_option = _new_highlight;
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
	}
}

/**
 * Sets the highlighted option to the option at the given xy, if the given text button list is at the given list xy horizontally.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _list_x
 * @param {real} _list_y
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_set_highlighted_at_xy_horizontal(_text_button_list, _list_x, _list_y, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		var _new_highlight = text_button_list_get_option_at_xy_horizontal(self, _list_x, _list_y, _x, _y, _alignment);
		if (_new_highlight == highlighted_option) return;
		var _prev_highlighted = highlighted_option;
		highlighted_option = _new_highlight;
		text_button_list_reset_two_animations(self, _prev_highlighted, highlighted_option);
	}
}

/**
 * Update button animations of given text button list by given time in ms.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _update_time_ms
 */
function text_button_list_update(_text_button_list, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (_text_button_list) {
		for (var _i = 0; _i < array_length(options); _i++) {
			text_button_update(options[_i], _update_time_ms);
		}
	}
}

/**
 * Draw given text button list in vertical orientation, but without updating any animations.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_draw_vertical_no_update(_text_button_list, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		var _positions = text_button_list_get_button_positions_vertical(self, _x, _y, _alignment);
		for (var _i = 0; _i < array_length(options); _i++) {
			var _highlighted = highlighted_option == _i;
			var _selected = highlighted_option == _i && highlighted_option_selected;
			text_button_draw_no_update(options[_i], _positions[_i][0], _positions[_i][1], _highlighted, _selected);
		}
	}
}

/**
 * Draw given text button list in vertical orientation.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_draw_vertical(_text_button_list, _x, _y, _alignment = fa_left) {
	text_button_list_update(_text_button_list);
	text_button_list_draw_vertical_no_update(_text_button_list, _x, _y, _alignment);
}

/**
 * Draw given text button list in horizontal orientation, but without updating any animations.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_draw_horizontal_no_update(_text_button_list, _x, _y, _alignment = fa_left) {
	with (_text_button_list) {
		var _positions = text_button_list_get_button_positions_horizontal(self, _x, _y, _alignment);
		for (var _i = 0; _i < array_length(options); _i++) {
			var _highlighted = highlighted_option == _i;
			var _selected = highlighted_option == _i && highlighted_option_selected;
			text_button_draw_no_update(options[_i], _positions[_i][0], _positions[_i][1], _highlighted, _selected);
		}
	}
}

/**
 * Draw given text button list in horizontal orientation.
 * @param {Struct.TextButtonList} _text_button_list
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 */
function text_button_list_draw_horizontal(_text_button_list, _x, _y, _alignment = fa_left) {
	text_button_list_update(_text_button_list);
	text_button_list_draw_horizontal_no_update(_text_button_list, _x, _y, _alignment);
}
