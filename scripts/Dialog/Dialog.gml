/**
 * Get a new dialog instance created from the given dialog filename
 *
 * @param {string} _dialog_file_name
 */
function Dialog(_dialog_file_name) constructor {
	var _file_read = file_text_open_read("dialog.txt");
	var _read_string = file_text_read_string(_file_read);
	var _dialog_json = json_parse(_read_string);
	file_text_close(_file_read);
	
	// construct step map from dialog json
	step_map = ds_map_create();
	
	for (var _i = 0; _i < array_length(_dialog_json); _i++) {
		ds_map_set(step_map, _dialog_json[_i].name, _dialog_json[_i]);
	}
	
	current_step_name = ""; // name of step in step map
	
	valid_languages = ["eng", "zho", "fre", "ger", "ita", "jpn", "kor", "pol", "por", "rus", "spa"];
	
	/**
	 * @param {struct} _new_step
	 * @param {struct} _previous_step
	 */
	on_step_change = function(_new_step, _previous_step) {
		var _new_name = variable_struct_exists(_new_step, "name") ? string(_new_step.name) : "undefined_step";
		var _previous_name = variable_struct_exists(_previous_step, "name") ? string(_previous_step.name) : "undefined_step";
		show_debug_message("dialog on step change invoked: " + _new_name + ", " + _previous_name);
	};
}

/**
 * Set on_step_change callback for given dialog.
 *
 * @param {Struct.Dialog} _dialog
 * @param {function}
 */
function dialog_set_on_step_change(_dialog, _on_step_change) {
	_dialog.on_step_change = _on_step_change;
}

/**
 * Get the name of the current step.
 *
 * @param {Struct.Dialog} _dialog
 */
function dialog_get_current_step_name(_dialog) {
	return _dialog.current_step_name;
}

/**
 * Gets if the given dialog has a current step.
 *
 * @param {Struct.Dialog} _dialog
 */
function dialog_get_is_active(_dialog) {
	return _dialog.current_step_name != "";
}

/**
 * Returns a boolean indicating if the current dialog step is an end step.
 *
 * @param {Struct.Dialog} _dialog
 * @return {bool}
 */
function dialog_get_is_at_end(_dialog) {
	with (_dialog) {
		if (!dialog_get_is_active(self)) return false;
		var _step = ds_map_find_value(step_map, current_step_name);
		// Feather disable once GM1035
		return _step.is_end;
	}
}

/**
 * Sets the given dialog to no step.
 *
 * @param {Struct.Dialog} _dialog
 */
function dialog_set_inactive(_dialog) {
	with (_dialog) {
		var _previous_step = ds_map_exists(step_map, current_step_name) ? ds_map_find_value(step_map, current_step_name) : {};
		on_step_change({}, _previous_step);
	}
	_dialog.current_step_name = "";
}

/**
 * Sets the current step of the given dialog to the step with the given name.
 * 
 * @param {Struct.Dialog} _dialog dialog instance to set step of
 * @param {string} _step_name name of the step to set dialog to
 */
function dialog_set_step(_dialog, _step_name) {
	if (!ds_map_exists(_dialog.step_map, _step_name)) return false;
	with (_dialog) {
		var _new_step = ds_map_exists(step_map, _step_name) ? ds_map_find_value(step_map, _step_name) : {};
		var _previous_step = ds_map_exists(step_map, current_step_name) ? ds_map_find_value(step_map, current_step_name) : {};
		on_step_change(_new_step, _previous_step)
		current_step_name = _step_name;	
	}
	return true;
}

/**
 * Sets the current step of the given dialog to the next step. This only works if
 * current step has no options (and therefore goes straight to its goto). Returns
 * true on sucess, fail otherwise.
 * 
 * @param {Struct.Dialog} _dialog dialog instance to set step of
 */
function dialog_set_step_next(_dialog) {
	with (_dialog) {
		if (!dialog_get_is_active(self)) return false;
		var _step = ds_map_find_value(step_map, current_step_name);
		if (array_length(_step.options) > 0) return false;
		if (dialog_get_is_at_end(self)) {
			dialog_set_inactive(self);
			return true;
		}
		dialog_set_step(_dialog, _step.goto);
		return true;
	}
}

/**
 * Sets the current step of the given dialog to goto of option of given index.
 *
 * @param {Struct.Dialog} _dialog
 * @param {real} _option_index
 */
function dialog_choose_option(_dialog, _option_index) {
	with (_dialog) {
		if (!dialog_get_is_active(self)) return false;
		var _step = ds_map_find_value(step_map, current_step_name);
		if (array_length(_step.options) <= 0) return false;
		if (dialog_get_is_at_end(self)) {
			dialog_set_inactive(self) return true;
		}
		dialog_set_step(self, _step.options[_option_index].goto);
		return true;
	}
}

/**
 * Get the text of the current dialog step. Language can be specified.
 *
 * @param {Struct.Dialog} _dialog dialog instance to get text of
 * @param {string} _lang the language of text to get
 * @return {string}
 */
function dialog_get_text(_dialog, _lang = "eng") {
	return dialog_step_get_text(_dialog, dialog_get_current_step_name(_dialog), _lang);
}

/**
 * Get the text of the given dialog step. Language can be specified.
 *
 * @param {Struct.Dialog} _dialog dialog instance to get text of
 * @param {string} _step_name name of step to get text for
 * @param {string} _lang the language of text to get
 * @return {string}
 */
function dialog_step_get_text(_dialog, _step_name, _lang = "eng") {
	with (_dialog) {
		if (!array_contains(valid_languages, _lang)) show_error("invalid language for get text", true);
		if (!ds_map_exists(step_map, _step_name)) return "";
		return ds_map_find_value(step_map, _step_name).text[$ _lang];
	}
}

/**
 * @param {string} _text
 * @param {string} _goto
 */
function DialogOption(_text, _goto) constructor {
	text = _text;
	goto = _goto;
}

/**
 * Get the options of the current step. Options are returned as an array of structs each with the text
 * of the specified language, and its goto.
 *
 * @param {Struct.Dialog} _dialog
 * @param {string} _lang the language of text to get
 * @return {Array<Struct.DialogOption>}
 */
function dialog_get_options(_dialog, _lang = "eng") {
	with (_dialog) {
		if (!array_contains(valid_languages, _lang)) show_error("invalid language for get text", true);
		var _result = array_create(0, new DialogOption("", ""));
		if (!dialog_get_is_active(self)) return _result; 
		var _name = dialog_get_current_step_name(_dialog);
		var _options = ds_map_find_value(step_map, _name).options;
		for (var _i = 0; _i < array_length(_options); _i++) {
			array_push(_result, new DialogOption(_options[_i].text[$ _lang], _options[_i].goto));
		}
		return _result;
	}
}
