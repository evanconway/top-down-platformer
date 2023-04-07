/**
 * Create a new text button instance.
 * @param {string} _string
 * @param {string} _default_effects
 * @param {string} _highlight_effects
 */
function TextButton(_string, _default_effects = "", _highlight_effects = "yellow fade", _selected_effects = "blink:0.6,1,50") constructor {
	/// @ignore
	tds = new TagDecoratedText(_string, _default_effects);
	/// @ignore
	tds_highlighted = new TagDecoratedText(_string, _highlight_effects);
	/// @ignore
	tds_selected = new TagDecoratedText(_string, _selected_effects);
}

/**
 * Return the width of the given text button.
 * @param {Struct.TextButton} _text_button
 */
function text_button_get_width(_text_button) {
	return tag_decorated_text_get_width(_text_button.tds);
};
	
/**
 * Return the height of the given text button.
 * @param {Struct.TextButton} _text_button
 */
function text_button_get_height(_text_button) {
	return tag_decorated_text_get_height(_text_button.tds);
};
	
/**
 * Reset animation state of default effects.
 * @param {Struct.TextButton} _text_button
 */
function text_button_reset_animations_default(_text_button) {
	tag_decorated_text_reset_animations(_text_button.tds);
};
	
/**
 * Reset animation state of highlighted effects.
 * @param {Struct.TextButton} _text_button
 */
function text_button_reset_animations_highlighted(_text_button) {
	tag_decorated_text_reset_animations(_text_button.tds_highlighted);
};
	
/**
 * Reset animation state of selected effects.
 * @param {Struct.TextButton} _text_button
 */
function text_button_reset_animations_selected(_text_button) {
	tag_decorated_text_reset_animations(_text_button.tds_selected);
}
	
/**
 * Returns boolean indicating if given xy is on given text button at given button xy.
 * @param {Struct.TextButton} _text_button
 * @param {real} _button_x
 * @param {real} _button_y
 * @param {real} _point_x
 * @param {real} _point_y
 */
function text_button_is_point_on(_text_button, _button_x, _button_y, _point_x, _point_y) {
	with (_text_button) {
		var _far_x = _button_x + tag_decorated_text_get_width(tds);
		var _far_y = _button_y + tag_decorated_text_get_height(tds);
		return _point_x >= _button_x && _point_x <= _far_x && _point_y >= _button_y && _point_y <= _far_y;
	}
};
	
/**
 * Update the given text button by the given time in ms. This updates any animations the text
 * may have.
 * @param {Struct.TextButton} _text_button
 * @param {real} _update_time_ms
 */
function text_button_update(_text_button, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (_text_button) {
		tag_decorated_text_update(tds);
		tag_decorated_text_update(tds_highlighted);
		tag_decorated_text_update(tds_selected);
	}
}

/**
 * Draw given text button at given xy without updating animations.
 * @param {Struct.TextButton} _text_button
 * @param {real} _x
 * @param {real} _y
 * @param {bool} _highlighted
 */
function text_button_draw_no_update(_text_button, _x, _y, _highlighted = false, _selected = false) {
	// offsets to account for different size of highlight and selected
	with (_text_button) {
		if (_selected) {
			var _offset_x = floor((tag_decorated_text_get_width(tds) - tag_decorated_text_get_width(tds_selected)) / 2);
			var _offset_y = floor((tag_decorated_text_get_height(tds) - tag_decorated_text_get_height(tds_selected)) / 2);
			tag_decorated_text_draw_no_update(tds_selected, _x + _offset_x, _y + _offset_y);
		} else if (_highlighted) {
			var _offset_x = floor((tag_decorated_text_get_width(tds) - tag_decorated_text_get_width(tds_highlighted)) / 2);
			var _offset_y = floor((tag_decorated_text_get_height(tds) - tag_decorated_text_get_height(tds_highlighted)) / 2);
			tag_decorated_text_draw_no_update(tds_highlighted, _x + _offset_x, _y + _offset_y);
		} else {
			tag_decorated_text_draw_no_update(tds, _x, _y);
		}
	}
}

/**
 * Draw given text button at given xy.
 * @param {Struct.TextButton} _text_button
 * @param {real} _x
 * @param {real} _y
 * @param {bool} _highlighted
 */
function text_button_draw(_text_button, _x, _y, _highlighted = false, _selected = false) {
	text_button_update(_text_button);
	text_button_draw_no_update(_text_button, _x, _y, _highlighted, _selected);
};
