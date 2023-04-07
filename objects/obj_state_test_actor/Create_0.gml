var _idle = new StateExampleIdle();
var _up = new StateExampleMoveUp(id);
var _down = new StateExampleMoveDown(id);
var _left = new StateExampleMoveLeft(id);
var _right = new StateExampleMoveRight(id);

state_add_connections(_idle, [_up, _down, _left, _right]);
state_add_connections(_up, [_idle, _down, _left, _right]);
state_add_connections(_down, [_up, _idle, _left, _right]);
state_add_connections(_left, [_up, _down, _idle, _right]);
state_add_connections(_right, [_up, _down, _left, _idle]);

state_machine = new StateMachine(_idle);
