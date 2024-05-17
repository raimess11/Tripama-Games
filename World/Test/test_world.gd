extends Node2D


@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D

func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
