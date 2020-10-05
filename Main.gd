extends Node2D

export var boulderForce = 0.0
export var gravity = 0.1
export var sisyphorce = 1.0
export var pathStartOffset = 0.1

var plateaud = true
var startOffset = 0.3153
var v1s = 0.352
var v1e = 0.4012
var v2s = 0.455
var v2e = 0.514
var v3s = 0.615
var loopDestOffset = 0.75
var loopTriggerOffset = 0.85

func _ready():
	$Path/Follow.unit_offset = startOffset
	$Player.setPosition($Path/Follow.global_position)
	print($Player.transform.get_origin())

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
	checkProgress()
	# setup boulderForce contraints
	boulderForce = min(boulderForce, 3.0)
	# apply boulderForce to offset and move player
	$Path/Follow.offset += boulderForce
	$Player.setPosition($Path/Follow.position)
	$Player.setRotation(boulderForce)
	# control particle dust effect
	if boulderForce < 0:
		$Dust.emitting = true
		$Dust.transform = Transform2D($Player.transform)
		$Dust.translate(Vector2(5.0, 20.0))
	else:
		$Dust.emitting = false

func checkProgress():
	if $Path/Follow.unit_offset < 0.01:
		$EndScreen/Control/Label.visible = true
		$EndScreen/Control/Label2.visible = true
		return
	elif $Path/Follow.unit_offset > loopTriggerOffset:
		$Path/Follow.unit_offset = loopDestOffset
		$Player.setPosition($Path/Follow.position)
	elif $Path/Follow.unit_offset > v3s:
		plateaud = false
	elif $Path/Follow.unit_offset > v2e:
		plateaud = true
	elif $Path/Follow.unit_offset > v2s:
		plateaud = false
	elif $Path/Follow.unit_offset > v1e:
		plateaud = true
	elif $Path/Follow.unit_offset > v1s:
		plateaud = false
	
func _on_GravityTimer_timeout():
	if !plateaud:
		boulderForce -= gravity * 2.0
	else:
		if boulderForce - gravity > 0:
			boulderForce -= gravity


func _on_Timer_timeout():
	get_tree().quit()
