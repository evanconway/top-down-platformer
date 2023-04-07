/**
 * Create a conversation instance from the given dialog file name.
 *
 * @param {string} _dialog_file_name
 * @param {real} _width
 * @param {real} _height
 */
function Conversation(_dialog_file_name, _width, _height) constructor {
	dialog = new Dialog(_dialog_file_name);
	width = _width;
	height = _height;
	
	language = "eng";
	
	// set when changing steps
	current_step_tag_decorated_text = new TagDecoratedText("$");
	current_step_options_menu = new TextMenu([]);
	
	/// @param {struct} _dialog_step
	get_text_effect_default = function(_dialog_step) {
		return "";
	};
	/// @param {struct} _dialog_step
	get_option_effect_default = function(_dialog_step) {
		return "gray";
	};
	/// @param {struct} _dialog_step
	get_option_effect_highlighted = function(_dialog_step) {
		return "yellow fade";
	};
	/// @param {struct} _dialog_step
	get_option_effect_selected = function(_dialog_step) {
		return "wave lime";
	};
	
	// input handling
	check_next_pressed = function() {
		return keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down);
	};
	
	check_previous_pressed = function() {
		return keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up);
	}
	
	check_select_pressed = function() {
		return keyboard_check_pressed(vk_enter);
	};
	
	check_mouse_select_pressed = function() {
		return mouse_check_button_pressed(mb_left);
	};
	
	distance_between_options = 30;
	
	/// @param {struct} _new_step
	/// @param {struct} _previous_step
	var _f = function(_new_step, _previous_step) {
		// using name to determine if dialog is active. on step change is called before dialog state actually changes
		// if new step is not valid it will an empty object
		if (!variable_struct_exists(_new_step, "name")) return;
		
		var _text = variable_struct_exists(_new_step, "name") ? dialog_step_get_text(dialog, _new_step.name, language) : "";
		current_step_tag_decorated_text = new TagDecoratedText(_text, get_text_effect_default(_new_step), width, height);
		tag_decorated_text_reset(current_step_tag_decorated_text);
		
		var _map_options = function(_option) {
			return _option.text[$ language];
		};
		
		var _option_effect_default = get_option_effect_default(_new_step);
		var _option_effect_highlighted = get_option_effect_highlighted(_new_step);
		var _option_effect_selected = get_option_effect_selected(_new_step);
		var _options = array_map(_new_step.options, _map_options);
		
		// ensure new menu has same mouse state
		var _previous_using_mouse = text_menu_get_using_mouse(current_step_options_menu);
		current_step_options_menu = new TextMenu(_options, _option_effect_default, _option_effect_highlighted, _option_effect_selected);
		text_menu_set_using_mouse(current_step_options_menu, _previous_using_mouse);
		
		/// @param {real} _option_selected_index
		var _on_option_selected = function(_option_selected_index) {
			dialog_choose_option(dialog, _option_selected_index);
		};
		
		text_menu_set_on_option_selected_animation_finished(current_step_options_menu, _on_option_selected);
		text_menu_set_check_next_pressed(current_step_options_menu, check_next_pressed);
		text_menu_set_check_previous_pressed(current_step_options_menu, check_previous_pressed);
		text_menu_set_check_select_pressed(current_step_options_menu, check_select_pressed);
		text_menu_set_mouse_check_pressed(current_step_options_menu, check_mouse_select_pressed);
	};
	
	dialog_set_on_step_change(dialog, _f);
}

/**
 * Set distance in pixels between text body and options of given conversation instance.
 *
 * @param {Struct.Conversation} _conversation
 */
function conversation_set_distance_between_options(_conversation, _new_distance) {
	_conversation.distance_between_options = _new_distance;
}

/**
 * @param {Struct.Conversation} _conversation
 */
function conversation_get_is_active(_conversation) {
	return dialog_get_is_active(_conversation.dialog);
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {string} _step_name
 */
function conversation_start(_conversation, _step_name) {
	with (_conversation) {
		dialog_set_step(dialog, _step_name);
	}
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 * @param {real} _update_time_ms
 */
function conversation_update(_conversation, _x, _y, _alignment = fa_left, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	with (_conversation) {
		if (!dialog_get_is_active(dialog)) return;
		
		if (tag_decorated_text_get_finished(current_step_tag_decorated_text)) {
			text_menu_update(current_step_options_menu, _x, _y + tag_decorated_text_get_height(current_step_tag_decorated_text) + distance_between_options, _alignment);
			if (array_length(dialog_get_options(dialog)) > 0) {
				// Recall that because of the callbacks established above, the text menu can change the dialog state by itself.
				//text_menu_update(current_step_options_menu, _x, _y + tag_decorated_text_get_height(current_step_tag_decorated_text), _alignment);
			} else if (check_select_pressed() || check_mouse_select_pressed()) dialog_set_step_next(dialog);
		} else if (check_select_pressed() || check_mouse_select_pressed()) tag_decorated_text_advance(current_step_tag_decorated_text);
		
		tag_decorated_text_update(current_step_tag_decorated_text, _update_time_ms);
	}
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {real} _x
 * @param {real} _y
 */
function conversation_draw(_conversation, _x, _y, _alignment = fa_left) {
	with (_conversation) {
		if (!dialog_get_is_active(dialog)) return;
		tag_decorated_text_draw_no_update(current_step_tag_decorated_text, _x, _y, _alignment);
		var _options_y = _y + tag_decorated_text_get_height(current_step_tag_decorated_text) + distance_between_options;
		if (array_length(dialog_get_options(dialog)) > 0 && tag_decorated_text_get_finished(current_step_tag_decorated_text)) {
			text_menu_draw_no_update(current_step_options_menu, _x, _options_y, _alignment)
		}
	}
}

/**
 * @param {Struct.Conversation} _conversation
 * @param {real} _x
 * @param {real} _y
 * @param {Constant.HAlign} _alignment
 * @param {real} _update_time_ms
 */
function conversation_update_and_draw(_conversation, _x, _y, _alignment = fa_left, _update_time_ms = 1000 / game_get_speed(gamespeed_fps)) {
	conversation_update(_conversation, _x, _y, _alignment, _update_time_ms);
	conversation_draw(_conversation, _x, _y, _alignment);
}
