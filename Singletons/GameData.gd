extends Node

var Money = 150
var Health = 100
var game_paused = false

var tower_data = {
	"GunT1": { 
		"damage": 40,
		"speedDamage": 60,
		"rof": 0.9,
		"range": 350,
		"category": "Projectile",
		"Price": 60,
		"slowDuration": 1.5},
	"HackerT1": { 
		"damage": 20,
		"speedDamage": 35,
		"rof": 2.5,
		"range": 450,
		"category": "AOE",
		"Price": 90,
		"slowDuration": 2.0},
	"MissleT1": {
		"damage": 180,
		"speedDamage": 40,
		"rof": 1.2,
		"range": 500,
		"category": "Missile",
		"Price": 120,
		"slowDuration": 2.5}}

var enemy_data = {
	"Paper": { 
		"speed": 240,
		"hp": 90,
		"death_hp": 4,
		"reward": 15,
		"scaling": 0.1},
	"PDF": { 
		"speed": 140,
		"hp": 220,
		"death_hp": 12,
		"reward": 60,
		"scaling": 0.1},
	"Word": { 
		"speed": 140,
		"hp": 220,
		"death_hp": 12,
		"reward": 60,
		"scaling": 0.1},
	"Winrar": { 
		"speed": 140,
		"hp": 220,
		"death_hp": 12,
		"reward": 60,
		"scaling": 0.1},
	"Book": {
		"speed": 190,
		"hp": 150,
		"death_hp": 7,
		"reward": 40,
		"scaling": 0.1}}
