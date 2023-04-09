extends Control

"""
This library allows to use a virtual joystick and to access its normalized
vector from the "get_direction" function.
"""

@export var background_texture: Texture2D = load("res://libs/joystick/textures/backgrounds/allaxis_outline.png")
@export var foreground_texture: Texture2D = load("res://libs/joystick/textures/foregrounds/handle_outline.png")
@export var listen_keyboard_event: bool
@export var mouse_detection_area_offset: float

@onready var _foreground_node: TextureRect = get_node("Foreground")
@onready var _background_node: TextureRect = get_node("Background")

var _radius: float
var _foreground_pivot: Vector2

func get_direction() -> Vector2:
	return (_foreground_node.get_position() + _foreground_pivot).normalized() * Vector2(1, -1)

func get_direction3D() -> Vector3:
	var dir = (_foreground_node.get_position() + _foreground_pivot).normalized()
	return Vector3(dir.x, dir.y, 0) * Vector3(1, -1, 0)

func _ready():
	_background_node.set_texture(background_texture)
	_foreground_node.set_texture(foreground_texture)
	
	_radius = _background_node.get_rect().size.x / 2
	_foreground_pivot = Vector2(_radius, _radius) / 2
	
	_background_node.set_anchors_preset(Control.PRESET_CENTER)
	_foreground_node.set_anchors_preset(Control.PRESET_CENTER)

func _process(_delta):
	_process_joystick_position()


func _process_joystick_position() -> void:
	var new_position = Vector2.ZERO
	
	if (mouse_detection_area_offset == 0 || \
	(get_local_mouse_position()).length() < _radius + mouse_detection_area_offset):
			new_position = get_local_mouse_position()
	
	if (listen_keyboard_event):
		var position_based_on_keyboard = Vector2.ZERO
		
		if Input.is_action_pressed("ui_up"):
			position_based_on_keyboard += Vector2(0, -_radius)
		if Input.is_action_pressed("ui_right"):
			position_based_on_keyboard += Vector2(_radius, 0)
		if Input.is_action_pressed("ui_down"):
			position_based_on_keyboard += Vector2(0, _radius)
		if Input.is_action_pressed("ui_left"):
			position_based_on_keyboard += Vector2(-_radius, 0)
		
		if (position_based_on_keyboard != Vector2.ZERO):
			new_position = position_based_on_keyboard

	_foreground_node.set_position(new_position.limit_length(_radius) - _foreground_pivot)
