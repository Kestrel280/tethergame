extends PathFollow3D


func _physics_process(delta: float) -> void:
	progress_ratio = wrapf(progress_ratio + 0.001, 0.0, 1.0);
