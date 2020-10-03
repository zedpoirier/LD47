extends Node2D

signal generate
var screenWidth
var screenHeight
var plateaud = false

func _ready():
	screenWidth = get_viewport_rect().size.x
	screenHeight = get_viewport_rect().size.y
	generatePath()

func generatePath():
	plateaud = !plateaud
	var botHeight = rand_range(0.6, 0.9) #godot has y down as positive
	var topHeight = rand_range(0.2, 0.65)
	$Path.curve.clear_points()
	if plateaud:
		$Path.curve.add_point(Vector2(0.0, screenHeight * botHeight))
		$Path.curve.add_point(Vector2(screenWidth, screenHeight * botHeight))
	else:
		$Path.curve.add_point(Vector2(0.0, screenHeight * botHeight))
		$Path.curve.add_point(Vector2(screenWidth, screenHeight * topHeight))
	matchPolygon()

func matchPolygon():
	var points = PoolVector2Array()
	points.append($Path.curve.get_point_position(0))
	points.append($Path.curve.get_point_position(1))
	points.append(Vector2(screenWidth, screenHeight))
	points.append(Vector2(0, screenHeight))
	$Background.set_polygon(points)
	$Foreground.set_polygon(points)

func isPlateaud():
	return plateaud
