extends Node2D

export var boulderForce = 0.0
export var gravity = 1.0
export var sisyphorce = 1.0
export var pathStartOffset = 0.1
var level = 1.0
var state = "menu"

func _input(event):
	if event is InputEventKey and event.is_pressed():
		boulderForce += sisyphorce

func _process(delta):
	checkInput()
	if state == "menu":
		menuMode()
	elif state == "game":
		gameMode()

func checkInput():
	pass

func menuMode():
	# play anims and stuff in the menu
	pass
	
func gameMode():
	# setup boulderForce contraints
	boulderForce = min(boulderForce, 3.0)
	if $Mountain/Path/Follow.unit_offset < 0.05:
		boulderForce = max(boulderForce, -2.0)
	if $Mountain/Path/Follow.unit_offset > 0.95:
		$Mountain/Path/Follow.unit_offset = 0.0
		gravity += 0.1
		$Mountain.generatePath()
	if $Mountain.isPlateaud():
		boulderForce = max(boulderForce, 0.0)
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
	
func startGame():
	# reset and start new game
	state = "game"
	pass

func _on_GravityTimer_timeout():
	boulderForce -= gravity


func _on_Button_pressed():
	$Menu.hide()
	startGame()
	pass # Replace with function body.
