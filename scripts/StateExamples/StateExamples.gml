/*
	can_end = function() {};
	can_start = function() {};
	on_end = function() {};
	on_start = function() {};
	
	update = function(_update_time_ms) {};
*/

function StateExampleIdle(): State() constructor {
	connections = [];
	
	/// @return {bool}
	can_end = function() {
		return true;
	};
	/// @return {bool}
	can_start = function() {
		return true;
	};
}

/**
 * @param {Id.Instance} _obj
 * @ignore
 */
function StateExampleMoveRight(_obj): State() constructor {
	object = _obj;
	can_end = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x + 1, y, obj_state_test_wall);
			return !keyboard_check(vk_right) || _against_wall;
		}
	};
	
	can_start = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x + 1, y, obj_state_test_wall);
			return keyboard_check(vk_right) && !_against_wall;
		}
	};
	
	update = function() {
		with (object) {
			var _moved = 0;
			while (!place_meeting(x + 1, y, obj_state_test_wall) && _moved < 2) {
				x += 1;
				_moved++;
			}
		}
	};
}

/**
 * @param {Id.Instance} _obj
 * @ignore
 */
function StateExampleMoveLeft(_obj): State() constructor {
	object = _obj;
	can_end = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x - 1, y, obj_state_test_wall);
			return !keyboard_check(vk_left) || _against_wall;
		}
	};
	
	can_start = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x - 1, y, obj_state_test_wall);
			return keyboard_check(vk_left) && !_against_wall;
		}
	};
	
	update = function() {
		with (object) {
			var _moved = 0;
			while (!place_meeting(x - 1, y, obj_state_test_wall) && _moved < 2) {
				x -= 1;
				_moved++;
			}
		}
	};
}

/**
 * @param {Id.Instance} _obj
 * @ignore
 */
function StateExampleMoveUp(_obj): State() constructor {
	object = _obj;
	can_end = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x, y - 1, obj_state_test_wall);
			return !keyboard_check(vk_up) || _against_wall;
		}
	};
	
	can_start = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x, y - 1, obj_state_test_wall);
			return keyboard_check(vk_up) && !_against_wall;
		}
	};
	
	update = function() {
		with (object) {
			var _moved = 0;
			while (!place_meeting(x, y - 1, obj_state_test_wall) && _moved < 2) {
				y -= 1;
				_moved++;
			}
		}
	};
}

/**
 * @param {Id.Instance} _obj
 * @ignore
 */
function StateExampleMoveDown(_obj): State() constructor {
	object = _obj;
	can_end = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x, y + 1, obj_state_test_wall);
			return !keyboard_check(vk_down) || _against_wall;
		}
	};
	
	can_start = function() {
		with (object) {
			var _against_wall = !place_meeting(x, y, obj_state_test_wall) && place_meeting(x, y + 1, obj_state_test_wall);
			return keyboard_check(vk_down) && !_against_wall;
		}
	};
	
	update = function() {
		with (object) {
			var _moved = 0;
			while (!place_meeting(x, y + 1, obj_state_test_wall) && _moved < 2) {
				y += 1;
				_moved++;
			}
		}
	};
}
