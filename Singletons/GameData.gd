extends Node

var Money = 150
var Health = 100

var tower_data = {
	"GunT1": { 
		"damage": 36,
		"speedDamage": 50,
		"rof": 0.8,
		"range": 350,
		"category": "Projectile",
		"Price": 50,
		"slowDuration": 2.0},  # Added slowDuration
	"DogT1": { 
		"damage": 30,
		"speedDamage": 50,
		"rof": 2.7,
		"range": 350,
		"category": "Projectile",
		"Price": 80,
		"slowDuration": 2.5},  # Added slowDuration
	"MissleT1": {
		"damage": 200,
		"speedDamage": 50,
		"rof": 1,
		"range": 550,
		"category": "Missile",
		"Price": 100,
		"slowDuration": 3.0}}  # Added slowDuration

var enemy_data = {
	"Paper": { 
		"speed": 200,
		"hp": 70,
		"reward": 12},
	"Book": {
		"speed": 160,
		"hp": 120,
		"reward": 35}}
