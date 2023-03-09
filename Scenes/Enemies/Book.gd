extends PathFollow2D

var speed = GameData.enemy_data["Book"]["speed"]
var hp = GameData.enemy_data["Book"]["hp"]
var reward = GameData.enemy_data["Book"]["reward"]

func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_offset(get_offset() + speed * delta)

func on_hit(damage):
	hp -= damage
	if hp <= 0:
		get_money()
		on_destroy()
		
func on_destroy():
	self.queue_free()

func get_money():
	GameData.Money = GameData.Money + reward
	return GameData.Money
