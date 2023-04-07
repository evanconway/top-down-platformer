/*
Two maps for managing boxes. The boxes_map is a mapping of box names to arrays of box objects with that name.
The boxes_name_group_map is a mapping of box group names to box names. This helps us do two things. First it
helps us ensure that all boxes with the same name are assigned to the same group. Secondly it helps us
get all boxes of the same group.
*/
global.boxes_map = ds_map_create();
global.boxes_group_name_map = ds_map_create();

/**
 * @param {real} _x X position of this box.
 * @param {real} _y Y position of this box.
 * @param {real} _width Boxes width.
 * @param {real} _height Boxes height.
 * @param {string, real} _name Name of the box. Boxes with the same name are collision checked together.
 * @param {string, real} _group Group of the box. Boxes with same group can be collision checked together.
 */
function Boxes(_x, _y, _width, _height, _name, _group) constructor {
	position_x = _x;
	position_y = _y;
	
	if (_width < 1 || _height < 1) show_error("box width and height must be greater than or equal to 1", true);
	
	width = floor(_width);
	height = floor(_height);
	name = _name;
	group = _group;
}

/**
 * @param {string} _box_name name of the box to get
 */
function boxes_get_by_name(_box_name) {
	if (!ds_map_exists(global.boxes_map, _box_name)) show_error("unknown box name referenced: " + _box_name, true);
	return ds_map_find_value(global.boxes_map, _box_name);
}

function boxes_place(_x, _y, _width, _height, _name = "box", _group = "default") {
	if (!ds_map_exists(global.boxes_map, _name)) {
		ds_map_set(global.boxes_map, _name, []);
		ds_map_set(global.boxes_group_name_map, _group, [_name]);
	}
	var _box_arr = ds_map_find_value(global.boxes_map, _name);
	array_push(_box_arr, new Boxes(_x, _y, _width, _height, _name, _group));
	var _name_arr = ds_map_find_value(global.boxes_group_name_map, _group);
	if (!array_contains(_name_arr, _name)) array_push(_name_arr, _name);
}

function boxes_draw(_name, _color = c_fuchsia) {
	var _box_arr = boxes_get_by_name(_name);
	draw_set_color(_color);
	draw_set_alpha(1);
	for (var _i = 0; _i < array_length(_box_arr); _i++) {
		var _x = _box_arr[_i].position_x;
		var _y = _box_arr[_i].position_y;
		var _width = _box_arr[_i].width - 1;
		var _height = _box_arr[_i].height - 1;
		
		/*
		We draw rectangles 1 pixel in width to draw the boxes, this ensures
		that boxes look correct in the draw or gui layer. GameMaker does
		not normally respect line thickness in regards to resolution in the
		gui layer.
		*/
		draw_rectangle(_x, _y, _x, _y + _height, false);
		draw_rectangle(_x + _width, _y, _x + _width, _y + _height, false);
		draw_rectangle(_x + 1, _y, _x + _width - 1, _y, false);
		draw_rectangle(_x + 1, _y + _height, _x + _width - 1, _y + _height, false);
	}
}

/**
 * @param {string} _name
 * @param {string} _name_colliding
 */
function boxes_get_name_collides_name(_name, _name_colliding) {
	var _arr_checking = boxes_get_by_name(_name);
	var _arr_colliding = boxes_get_by_name(_name_colliding);
	
	if (keyboard_check_pressed(vk_space)) {
		show_debug_message("debug");
	}
	
	for (var _i = 0; _i < array_length(_arr_checking); _i++) {
		var _box_checking = _arr_checking[_i];
		for (var _k = 0; _k < array_length(_arr_colliding); _k++) {
			var _box_colliding = _arr_colliding[_k];
			var _bbox_check_left = _box_checking.position_x;
			var _bbox_collide_left = _box_colliding.position_x;
			var _bbox_check_right = _box_checking.position_x + _box_checking.width - 1;
			var _bbox_collide_right = _box_colliding.position_x + _box_colliding.width - 1;
			var _bbox_check_bottom = _box_checking.position_y + _box_checking.height - 1;
			var _bbox_collide_bottom = _box_colliding.position_y + _box_colliding.height - 1;
			var _bbox_check_top = _box_checking.position_y;
			var _bbox_collide_top = _box_colliding.position_y;
			
			if (_bbox_check_left <= _bbox_collide_right &&
				_bbox_check_right >= _bbox_collide_left &&
				_bbox_check_top <= _bbox_collide_bottom &&
				_bbox_check_bottom >= _bbox_collide_top
			) {
				return true;
			}
		}
	}
	return false;
}

function boxes_clear_all() {
	ds_map_clear(global.boxes_map);
	ds_map_clear(global.boxes_group_name_map);
}
