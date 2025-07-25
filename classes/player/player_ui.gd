extends Tether_Ui


@export var player : Player;


func _physics_process(dt : float):
	var real_velocity = player.get_real_velocity();
	var xy_speed : float = Vector2(real_velocity.x, real_velocity.z).length();
	$Center_Screen/Kinetics_Console/Speed_Label.set_value(xy_speed);
	$Center_Screen/Kinetics_Console/Energy_Label.set_value(real_velocity.length_squared() / 2 + player.position.y * ProjectSettings.get_setting("physics/3d/default_gravity"));
