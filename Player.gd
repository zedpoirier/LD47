extends Node2D

func setPosition(pos):
	position = pos

func setRotation(force):
	if force > 0:
		rotation += force * 0.1
	pass
