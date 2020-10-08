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

var lastBestScore = 0
var currentScore = 0
var loopScoreOffset = 0
var playerStartY = 0

func _ready():
	$Path/Follow.unit_offset = startOffset
	$Player.setPosition($Path/Follow.global_position)
	playerStartY = $Player.position.y
	print($Player.transform.get_origin())

func _input(event):
	if !event.is_echo(): # is the input the same the last check?
		if event is InputEventMIDI:
			pass
		if event is InputEventMouseButton:
			if event.pressed:
					boulderForce += sisyphorce
		if event is InputEventKey:
			if event.pressed:
				if event.scancode == KEY_ESCAPE:
					get_tree().quit()
				elif !event.echo:
					boulderForce += sisyphorce

func _process(_delta):
	checkProgress()
	scoreUpdate()
	# setup boulderForce contraints
	boulderForce = min(boulderForce, 3.0)
	# apply boulderForce to offset and move player
	$Path/Follow.offset += boulderForce
	$Player.setPosition($Path/Follow.position)
	$Player.setRotation(boulderForce)
	
	dust(); # control particle dust effect

func dust():
	if boulderForce < 0:
		$Dust.emitting = true
		$Dust.transform = Transform2D($Player.transform)
		$Dust.translate(Vector2(5.0, 20.0))
	else:
		$Dust.emitting = false

func scoreUpdate():
	$Score.position = $Player.position
	currentScore = (playerStartY - $Player.position.y) * 0.1 + loopScoreOffset
	if currentScore > lastBestScore:
		$Score/Control/Value.text = str(stepify(currentScore, 1)) + "m"
		lastBestScore = currentScore
	pass

func checkProgress():
	if $Path/Follow.unit_offset < 0.01:
		$EndScreen/Control/WinText.visible = true
		return
	elif $Path/Follow.unit_offset > loopTriggerOffset:
		var a = (playerStartY - $Player.position.y) * 0.1
		$Path/Follow.unit_offset = loopDestOffset
		$Player.setPosition($Path/Follow.position)
		var b = (playerStartY - $Player.position.y) * 0.1
		loopScoreOffset += a - b
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
	elif $Path/Follow.unit_offset > 0.01:
		plateaud = true
	
func _on_GravityTimer_timeout():
	if !plateaud:
		boulderForce -= gravity * 2.0
	else:
		if boulderForce - gravity > 0:
			boulderForce -= gravity
