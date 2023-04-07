/**
 * Create a new state. This function should never be used. Instead it should be 
 * inherited to create states actually used by the game.
 */
function State() constructor {
	connections = [];
	
	/// @return {bool}
	can_end = function() {};
	/// @return {bool}
	can_start = function() {};
	/// @return {bool}
	on_end = function() {};
	/// @return {bool}
	on_start = function() {};
	
	/// @param {real}
	update = function(_update_time_ms) {};
}

/**
 * @param {Struct.State} _starting_state
 */
function StateMachine(_starting_state) constructor {
	current_state = _starting_state;
	
	change = function() {
		if (!current_state.can_end()) return;
		for (var _i = 0; _i < array_length(current_state.connections); _i++) {
			var _s = current_state.connections[_i];
			if (_s.can_start()) {
				_i = array_length(current_state.connections);
				current_state.on_end();
				_s.on_start();
				current_state = _s;
			}
		}
	}
	
	/// @param {real} _update_time_ms
	update = function(_update_time_ms = game_get_speed(gamespeed_fps)) {
		change();
		current_state.update(_update_time_ms);
		change();
	}
}

/**
 * @param {Struct.State} _state
 * @param {Array<Struct.State>} _states_connecting_to
 */
function state_add_connections(_state, _states_connecting_to) {
	for (var _i = 0; _i < array_length(_states_connecting_to); _i++) {
		array_push(_state.connections, _states_connecting_to[_i]);
	}
}
