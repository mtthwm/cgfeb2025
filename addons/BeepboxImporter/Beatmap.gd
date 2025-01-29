extends Resource
class_name Beatmap

@export var bpm: int
@export var division: int
var notes: Array[Note]

func _init() -> void:
    bpm = 100
    division = 4
    notes = []