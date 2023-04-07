if (keyboard_check_pressed(vk_up)) {
	surface_size_mult = clamp(surface_size_mult + 1, 1, 1000);
}

if (keyboard_check_pressed(vk_down)) {
	surface_size_mult = clamp(surface_size_mult - 1, 1, 1000);
}

surface_resize(application_surface, width * surface_size_mult, height * surface_size_mult);
