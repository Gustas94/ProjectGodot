extends Node2D



var map_node

var build_mode = false
var build_valid = false
var build_location
var build_type
var current_wave = 0
var enemies_in_wave = 0
var wave_data
var wave_time = 3
var enemies_remaining = 0
signal wave_complete
signal wave_ended
var game_speed = 1
var wave_in_progress = false
var wave_paused = false
var starting_wave = false
var pause_cooldown = false
var wave_timer
##
## seclection functions
##
func _ready():
	map_node = get_node("Map1")
	connect("wave_ended", self, "start_next_wave")
	for index in get_tree().get_nodes_in_group("build_buttons"):
		index.connect("pressed", self, "initiate_build_mode", [index.get_name()])
	connect("wave_complete", self, "start_next_wave")
	start_next_wave()
	show_money()
	show_wave()


func _process(_delta):
	show_money()
	show_health()
	show_wave()
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##
## Wave functions
##
func start_next_wave():
	if starting_wave or wave_paused:
		return

	starting_wave = true
	wave_in_progress = true
	$WaveTimer.start(wave_time)
	yield($WaveTimer, "timeout")
	var wave_data = retrieve_wave_data()
	spawn_enemies(wave_data)
	print(current_wave)
	starting_wave = false
	
func check_next_wave():
	if not wave_paused and not wave_in_progress and enemies_remaining <= 0:
		start_next_wave()
	
func retrieve_wave_data():
	current_wave += 1
	wave_data = []
	var enemy_types = ["PDF", "Paper", "Book","Word","Winrar"]

	# Modify these values to control the difficulty scaling
	var base_enemies = 2
	var additional_enemies_per_wave = 1

	var total_enemies = base_enemies + additional_enemies_per_wave * (current_wave - 1)

	for _i in range(total_enemies):
		var random_enemy = enemy_types[randi() % enemy_types.size()]
		var spawn_delay = rand_range(0.8, 1.6)  # Adjust spawn delay range as desired
		wave_data.append([random_enemy, spawn_delay])

	return wave_data

		
func spawn_enemies(wave_data):
	wave_in_progress = true
	var spawn_index = 0
	while spawn_index < wave_data.size():
		if GameData.game_paused:
			yield(get_tree().create_timer(0.1), "timeout")
			continue
		var i = wave_data[spawn_index]
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
		new_enemy.hp = int(new_enemy.hp * (1 + current_wave * GameData.enemy_data[i[0]]["scaling"]))
		new_enemy.speed = int(new_enemy.speed * (1 + current_wave * GameData.enemy_data[i[0]]["scaling"]))
		map_node.get_node("Path").add_child(new_enemy, true)
		new_enemy.connect("enemy_removed", self, "enemy_removed")
		enemies_remaining += 1
		yield(get_tree().create_timer(i[1]), "timeout")
		spawn_index += 1
		if GameData.game_paused:
			yield(get_tree().create_timer(0.1), "timeout")
			continue
	wave_in_progress = false
	check_next_wave()
	
func enemy_removed():
	enemies_remaining -= 1
	print("Enemy removed. Remaining:", enemies_remaining)
	if enemies_remaining <= 0 and not wave_in_progress and not wave_paused:
		emit_signal("wave_ended")
##
## build functions
##
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	get_node("UserInterface").set_tower_preview(build_type, get_global_mouse_position())


func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExculusion").world_to_map(mouse_position)
	
	if map_node.get_node("TowerExculusion").get_cellv(current_tile):
		get_node("UserInterface").update_tower_preview(mouse_position, "ad54ff3c")
		build_valid = true
		build_location = mouse_position
	else:
		get_node("UserInterface").update_tower_preview(mouse_position, "adff4545")
		build_valid = false


func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UserInterface/TowerPreview").free()


func verify_and_build():
	if build_valid:
		## test to see if player has enough money
		var Price = GameData.tower_data[build_type]["Price"]
		if GameData.Money >= Price:
			var new_tower = load("res://Scenes/Towers/" + build_type + ".tscn").instance()
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.category = GameData.tower_data[build_type]["category"]
			map_node.get_node("Towers").add_child(new_tower, true)
			GameData.Money -= Price
		
##Money function
func show_money():
	$UserInterface/HUD/InfoMenu/Money_counter.text = str("Cash: ", GameData.Money)
	
func show_health():
	$UserInterface/HUD/InfoMenu/Health_counter.text = str("Health: ", GameData.Health)

func show_wave():
	$UserInterface/HUD/InfoMenu/Wave_counter.text = str("Wave: ", current_wave)

func _on_Pause_pressed():
	if not pause_cooldown:
		toggle_pause()
	
func toggle_pause():
	GameData.game_paused = not GameData.game_paused
	wave_paused = GameData.game_paused
	if GameData.game_paused:
		$UserInterface/HUD/InfoMenu/Pause.text = "Resume"
		pause_enemies(true)
		pause_towers(true)
	else:
		$UserInterface/HUD/InfoMenu/Pause.text = "Pause"
		pause_enemies(false)
		pause_towers(false)
		check_next_wave()

func pause_enemies(pause):
	for enemy in map_node.get_node("Path").get_children():
		enemy.set_process(!pause)
		enemy.set_physics_process(!pause)
		
func pause_towers(pause):
	for tower in map_node.get_node("Towers").get_children():
		tower.set_process(!pause)
		tower.set_physics_process(!pause)
		
		
func _on_Speed5x_pressed():
	toggle_speed_up()
	

func toggle_speed_up():
	if game_speed == 1:
		game_speed = 5
		$UserInterface/HUD/InfoMenu/Speed5x.text = "Speed x1"
	else:
		game_speed = 1
		$UserInterface/HUD/InfoMenu/Speed5x.text = "Speed x5"
	Engine.time_scale = game_speed
