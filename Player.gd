extends Node2D

func setPosition(pos):
	position = Vector2(pos.x, pos.y - 25)

func setRotation(force):
	rotation += force * 0.1
