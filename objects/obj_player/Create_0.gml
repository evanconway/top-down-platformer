jump_offset = 0;
jump_offset_max = 8;

/**
 * @param {Id.Instance} _player_instance
 * @param {Struct.SmoothMove} _move
 * @param {function} _move_function
 */
function StatePlayerMove(_player_instance, _move, _move_function): State() constructor {
	player = _player_instance;
	move = _move;
	move_function = _move_function;
	update = function() {
		move_function(move, player);
	};
	can_start = function() {
		return true;
	};
	can_end = function() {
		return true;
	};
}

/**
 * @param {Id.Instance} _player_instance
 * @param {Struct.SmoothMove} _move
 * @param {function} _move_function
 */
function StatePlayerJump(_player_instance, _move, _move_function): State() constructor {
	player = _player_instance;
	move = _move;
	move_function = _move_function;
	
	jump_time = 0;
	
	can_start = function() {
		return keyboard_check_pressed(vk_space);
	};
	
	can_end = function() {
		return jump_time >= pi;
	};
	
	on_start = function() {
		jump_time = 0;
		player.jump_offset = 0;
	};
	
	on_end = function() {
		jump_time = 0;
		player.jump_offset = 0;
	};
	
	update = function() {
		move_function(move, player);
		jump_time += pi/60;
		player.jump_offset = sin(jump_time) * player.jump_offset_max;
	};
}

var _move = new SmoothMove(x, y);
/// @param {Struct.SmoothMove} _move
/// @param {Id.Instance} _instance
var _instance_move = function(_move, _instance) {
	var _up = keyboard_check(vk_up);
	var _dn = keyboard_check(vk_down);
	var _lf = keyboard_check(vk_left);
	var _rt = keyboard_check(vk_right);
	var _angle = -1;
	if (_up && !_rt &&! _dn && !_lf) _angle = 0;
	if (_up && _rt &&! _dn && !_lf) _angle = pi/4;
	if (!_up && _rt &&! _dn && !_lf) _angle = pi/2;
	if (!_up && _rt && _dn && !_lf) _angle = 3*pi/4;
	if (!_up && !_rt && _dn && !_lf) _angle = pi;
	if (!_up && !_rt && _dn && _lf) _angle = 5*pi/4;
	if (!_up && !_rt && !_dn && _lf) _angle = 3*pi/2;
	if (_up && !_rt && !_dn && _lf) _angle = 7*pi/4;
	
	if (_angle >= 0) {
		smooth_move_vector(_move, _angle, 1);
		_instance.x = smooth_move_get_x(_move);
		_instance.y = smooth_move_get_y(_move);
	}
};

var _state_move = new StatePlayerMove(id, _move, _instance_move);
var _state_jump = new StatePlayerJump(id, _move, _instance_move);

state_add_connections(_state_jump, [_state_move]);
state_add_connections(_state_move, [_state_jump]);

state_machine = new StateMachine(_state_move);

update = function() {
	state_machine.update();
};

draw = function() {
	if (jump_offset != 0) {
		draw_set_alpha(0.7);
		draw_set_color(c_black);
		draw_circle(x + 5, y + 5, 5, false);
	}
	draw_set_alpha(1);
	draw_sprite(spr_player, 0, x, y - jump_offset);
};
