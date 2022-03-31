extends Node


enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}

#var observer_state : int
signal on_rod_camera
signal on_bait_camera

func _on_PhysicsObserver_on_state_change(state):
	match state:
		State.UNCASTABLE:
			pass
		State.CASTABLE:
			emit_signal("on_rod_camera")
		State.CASTING:
			pass
		State.IN_FLIGHT:
			emit_signal("on_bait_camera")
		State.DROPPED:
			pass
		State.REELING:
			pass
		State.IDLE:
			pass
		State.STRIKING:
			pass
		State.SETTING:
			pass
		State.FIGHTING:
			pass
		State.LANDED:
			pass
		State.LOST:
			pass
