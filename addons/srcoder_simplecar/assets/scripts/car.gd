extends VehicleBody3D
class_name car

var health : int = 100
var boost : int = 100

#@export_category("Car Settings")
## max steer in radians for the front wheels- defaults to 0.45
var max_steer : float = .2
## the maximum torque that the engine will sent to the rear wheels- defaults to 300
var max_torque : float = 600.0
## the maximum amount of braking force applied to the wheel. Default is 1.0
var max_brake_force : float = 2.0
## the maximum rear wheel rpm. The actual engine torque is scaled in a linear vector to ensure the rear wheels will never go beyond this given rpm.
## The default value is 600rpm
var max_wheel_rpm : float = 3000.0
## How sticky are the front wheels. Default is 5. 0 is frictionless._add_constant_central_force
var front_wheel_grip : float = 30.0
## How sticky are the rear wheel. Default is 5. Try lower value for a more drift experience
var rear_wheel_grip : float = 20.0


#local member variables
var player_acceleration : float = 0.0
var player_braking : float = 0.0
var _playersteer : float = 0.0

var player_input : Vector2 = Vector2.ZERO
var player_drift : bool = false
var player_boost : bool = false

#an exporetd array of driving wheels so we can limit rom of each wheel when we process input
@onready var backwheels : Array[VehicleWheel3D] = [$WheelBackLeft,$WheelBackRight]
@onready var frontwheels : Array[VehicleWheel3D] = [$WheelFrontLeft,$WheelFrontRight]

var on : bool = true

func _ready() -> void:
	#set wheel friction slip
	for wheel in frontwheels:
		wheel.wheel_friction_slip = front_wheel_grip
	for wheel in backwheels:
		wheel.wheel_friction_slip = rear_wheel_grip

func _physics_process(delta: float) -> void:
	previouspeed = linear_velocity
	if(!Input.is_action_pressed("drift")):
		var global_velocity: Vector3 = linear_velocity
		var local_velocity = global_basis.inverse() * global_velocity
		apply_force(global_basis.x * local_velocity.x * -80)
	
	for wheel in backwheels:
		wheel.wheel_friction_slip = rear_wheel_grip if !Input.is_action_pressed("drift") else 0
	get_input(delta)
	#now process steering and braking
	steering = _playersteer
	brake = player_braking
	#cos we want to limit rpm- control each driving wheel individually
	for wheel in frontwheels:
		#linearly reduce engine force based on the wheels current rpm and the player input
		var actual_force : float = player_acceleration * ((-max_torque/max_wheel_rpm) * abs(wheel.get_rpm()) + max_torque) 
		wheel.engine_force = actual_force * (1 if (!player_boost||boost <= 0) else 3)
	if(player_boost && boost >= 0):
		boost -= delta

func get_input(delta : float):
	if(!on):
		return
	
	#steer first
	_playersteer = player_input.x * max_steer
	
	#for n in frontwheels:
		#n.rotation.y = lerp(n.rotation.y, _playersteer, .2)
	#now acceleration and/or braking
	if player_input.y > 0.01:
		#accelerating
		player_acceleration = player_input.y
		player_braking = 0.0
	elif player_input.y < -0.01:
		#we are trying to brake or reverse
		if going_forward():
			#brake
			player_braking = -player_input.y * max_brake_force
			player_acceleration = 0.0
		else:
			#reverse
			player_braking = 0.0
			player_acceleration = player_input.y/2
	else:
		player_acceleration = 0.0
		player_braking = 0.0

## helper function to see if we are moving forward
func going_forward() -> bool:
	var relative_speed : float = basis.z.dot(linear_velocity.normalized())
	if relative_speed > 0.01:
		return true
	else:
		return false

var previouspeed : Vector3
func collisionentered(body):
	if(body is car):
		if(linear_velocity <= body.linear_velocity):
			health -= (linear_velocity.length() - body.linear_velocity.length())
	else:
		health -= (previouspeed.length() - linear_velocity.length())
