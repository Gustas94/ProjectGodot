extends PathFollow2D

var speed = GameData.enemy_data["Book"]["speed"]
var hp = GameData.enemy_data["Book"]["hp"]
var reward = GameData.enemy_data["Book"]["reward"]
var OriginalSpeed = GameData.enemy_data["Book"]["speed"]
var slow_effect_active = false
var slow_timer = null

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
		on_left_map()

func on_hit(damage, speedDamage, slowDuration):
	hp -= damage
	if not slow_effect_active:
		apply_slow_effect(speedDamage, slowDuration)
	if hp <= 0:
		get_money()
		on_destroy()

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

func on_destroy():
	emit_signal("enemy_removed")
	print("Health of book: ", hp)
	self.queue_free()

func get_money():
	GameData.Money = GameData.Money + reward
	return GameData.Money

func on_left_map():
	GameData.Health = GameData.Health - 5
	emit_signal("enemy_removed")
	self.queue_free()
