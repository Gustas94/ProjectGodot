extends Node2D

var type
var category
var enemy_array = []
var built = false
var enemy
var ready = true
var checkPR = 0

func _ready():
	checkPR = 0
	if built:
		checkPR = 1
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]	
	
func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
		if ready:
			fire()
	else: 
		enemy = null
		
func turn():
	get_node("Turret").look_at(enemy.position)

func select_enemy():
	var enemy_progress_array = []
	for index in enemy_array:
		enemy_progress_array.append(index.get_offset())
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
	
func fire():
	ready = false
	if category == "Projectile":
		fire_gun()
	if category == "Missile":
		fire_missile()
	var damage = GameData.tower_data[type]["damage"]
	var speed_damage = GameData.tower_data[type]["speedDamage"]
	var slow_duration = GameData.tower_data[type]["slowDuration"]
	enemy.on_hit(damage, speed_damage, slow_duration)  # Call on_hit on the enemy instance directly
	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true
	
func fire_gun():
	get_node("AnimationPlayer").play("Fire")
func fire_missile():
	pass
	
func remove_enemy(enemy):
	enemy_array.erase(enemy)

func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_Range_body_exited(body):
	if checkPR == 1:
		enemy.speed_back()
	enemy_array.erase(body.get_parent())
