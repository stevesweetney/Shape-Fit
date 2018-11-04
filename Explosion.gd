extends Particles2D

func _ready():
	$LifeTimer.wait_time = lifetime * 1.01
	$LifeTimer.connect("timeout", self, "_on_timeout")
	
func start():
	emitting = true
	$LifeTimer.start()
func _on_timeout():
	queue_free()
