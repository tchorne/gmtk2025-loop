extends Area2D

func trigger_hit():
	for area in get_overlapping_areas():
		if area.has_method("get_statue"):
			var statue := area.get_statue() as Statue
			statue.lock_until_combo_ended()
			statue.add_knockback(Vector2.UP * 500 + Vector2.RIGHT * 100)
			statue.take_damage(1)
			statue.split()
