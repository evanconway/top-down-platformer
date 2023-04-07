if (game_active) {
		with (obj_player) {
		update();
		if (!place_meeting(x, y, obj_platform) && obj_player.jump_offset <= 0) {
			other.game_active = false;
		}
	}
}


if (keyboard_check_pressed(ord("R"))) game_restart();