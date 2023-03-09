extends Node

func _ready():
	get_node("MainMenu/MarginContainer/VBox/Story").connect("pressed", self, "on_Story_pressed")
	get_node("MainMenu/MarginContainer/VBox/Quit").connect("pressed", self, "on_Quit_pressed")
	get_node("MainMenu/MarginContainer/VBox/About").connect("pressed", self, "on_About_pressed")
	get_node("MainMenu/MarginContainer/VBox/Infinite").connect("pressed", self, "on_Infinite_pressed")
	
func on_Story_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	add_child(game_scene)

func on_About_pressed():
	#get_node("MainMenu").queue_free()
	var About_scene = load("res://Scenes/MainMenu/About.tscn").instance()
	add_child(About_scene)

func on_Infinite_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	add_child(game_scene)


func on_Quit_pressed():
	get_tree().quit()
