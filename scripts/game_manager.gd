extends Node

var score = 0
@onready var score_label = $ScoreLabel

func add_point():
	score += 1
	print("Score: ", score)
	score_label.text = "GOT " + str(score) + " COINS"
