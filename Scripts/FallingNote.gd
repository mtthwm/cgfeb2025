extends Node3D
class_name FallingNote

@export var fallDirection: Vector3 = Vector3.DOWN
@export var spreadDirection: Vector3 = Vector3.RIGHT
@export var mesh: MeshInstance3D
@export var extraSpacing: float = 0.05

@export var height: float
@export var speed: float
@export var horizontalOffset: float

func _ready() -> void:
	mesh.scale.y = height - extraSpacing
	mesh.position.y = height/2
	position += spreadDirection*horizontalOffset

func _physics_process(delta: float) -> void:
	position += fallDirection*speed*delta