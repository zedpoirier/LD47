extends Node2D

export var boulderForce = 0.0
export var gravity = 0.1
export var sisyphorce = 1.0
export var pathStartOffset = 0.1
var level = 1.0
var state = "menu"

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_ESCAPE:
				get_tree().quit()
			elif !event.echo:
				if event.scancode == KEY_LEFT:
					boulderForce -= sisyphorce
				else:
					boulderForce += sisyphorce

func _process(delta):
	# setup boulderForce contraints
	boulderForce = min(boulderForce, 3.0)
	if $Mountain.isPlateaud() or $Mountain/Path/Follow.unit_offset < 0.05:
		boulderForce = max(boulderForce, -2.0)
	if $Mountain/Path/Follow.unit_offset > 0.95:
		$Mountain/Path/Follow.unit_offset = 0.0
		gravity += 0.1
		$Mountain.generatePath()
	# apply boulderForce to offset and move player
	$Mountain/Path/Follow.offset += boulderForce
	$Player.setPosition($Mountain/Path/Follow.position)
	$Player.setRotation(boulderForce)
	# control particle dust effect
	if boulderForce < 0:
		$Dust.emitting = true
		$Dust.transform = Transform2D($Player.transform)
		$Dust.translate(Vector2(5.0, 20.0))
	else:
		$Dust.emitting = false

func _on_GravityTimer_timeout():
	if boulderForce - gravity > 0:
		boulderForce -= gravity
