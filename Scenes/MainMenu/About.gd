extends Node2D



func _ready():
	get_node("Next").connect("pressed", self, "on_next_pressed")
	get_node("Back").connect("pressed", self, "on_back_pressed")


func on_next_pressed():
	get_node("Intro!").visible = false
	get_node("Tower explentaion2").visible = true

func on_back_pressed():
	queue_free()
