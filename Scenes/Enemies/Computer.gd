extends PathFollow2D

var speed = GameData.enemy_data["Computer"]["speed"]
var hp = GameData.enemy_data["Computer"]["hp"]
var reward = GameData.enemy_data["Computer"]["reward"]
var OriginalSpeed = GameData.enemy_data["Computer"]["speed"]
var hp_on_death = GameData.enemy_data["Computer"]["death_hp"]
var slow_effect_active = false
var slow_timer = null

signal enemy_removed

func _ready():
	set_offset(0)

func _physics_process(delta):
	move(delta)
	check_if_left_path()

func move(delta):
	set_offset(get_offset() + speed * delta)

func check_if_left_path():
	var path = get_parent() # Get the Path2D node
	var path_length = path.curve.get_baked_length()
	if get_offset() >= path_length:
		print("Enemy has left the map")
		remove_from_game(true)

func on_hit(damage, speedDamage, slowDuration):
	hp -= damage
	if not slow_effect_active:
		apply_slow_effect(speedDamage, slowDuration)
	if hp <= 0:
		get_money()
		remove_from_game()

func apply_slow_effect(speedDamage, slowDuration):
	slow_effect_active = true
	speed -= speedDamage
	slow_timer = get_tree().create_timer(slowDuration)
	slow_timer.connect("timeout", self, "reset_speed", [speedDamage])
	
func reset_speed(speedDamage):
	speed += speedDamage
	slow_effect_active = false
	slow_timer = null

func speed_back():
	speed = OriginalSpeed

func remove_from_game(left_map = false):
	emit_signal("enemy_removed")
	print("Health of paper: ", hp)
	if left_map:
		GameData.Health -= hp_on_death
	self.queue_free()

func get_money():
	GameData.Money = GameData.Money + reward
	return GameData.Money
