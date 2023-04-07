//view_enabled = true
view_camera[0] = true;

width = 320;
height = 180;
var _window_multiplier = 4;

camera_set_view_size(view_camera[0], width, height);
window_set_size(width * _window_multiplier, height * _window_multiplier);
//surface_resize(application_surface, width, height);

window_center();

game_active = true;
