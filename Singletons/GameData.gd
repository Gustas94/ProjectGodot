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
		"slowDuration": 2.0},
	"HackerT1": { 
		"damage": 25,
		"speedDamage": 42,
		"rof": 2.7,
		"range": 450,
		"category": "AOE",
		"Price": 80,
		"slowDuration": 2.5},
	"MissleT1": {
		"damage": 200,
		"speedDamage": 50,
		"rof": 1,
		"range": 550,
		"category": "Missile",
		"Price": 100,
		"slowDuration": 3.0}} 

var enemy_data = {
	"Paper": { 
		"speed": 200,
		"hp": 70,
		"death_hp": 3,
		"reward": 12},
	"Book": {
		"speed": 160,
		"hp": 120,
		"death_hp": 5,
		"reward": 35}}
