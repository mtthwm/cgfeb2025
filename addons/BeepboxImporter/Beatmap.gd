extends Resource
class_name Beatmap

@export var bpm: int
@export var division: int
@export var notes: Array[Array]

enum NoteOpts {
    PITCH,
    TICK,
    LENGTH,
}

func _init() -> void:
    bpm = 100
    division = 4
    notes = []