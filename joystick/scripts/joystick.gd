extends Node2D

"""
This library allows to use a virtual joystick and to access its normalized
vector from the "get_direction" function.
"""

export(Texture) var background_texture
export(Texture) var frontground_texture

var _radius :float
var _frontground_node: Sprite
var _background_node: Sprite


func get_direction() -> Vector2:
	return _frontground_node.get_position().normalized() * Vector2(1, -1)


func _ready():
	_background_node = get_node("Background")
	_frontground_node = get_node("Frontground")
	
	_background_node.set_texture(background_texture)
	_frontground_node.set_texture(frontground_texture)
	_init_radius()
	


func _process(_delta):
	_process_joystick_position()


func _init_radius() -> void:
	_radius = _background_node.get_rect().size.x / 2


func _process_joystick_position() -> void:
	_frontground_node.set_position(get_local_mouse_position() \
		.limit_length(_radius)) 
