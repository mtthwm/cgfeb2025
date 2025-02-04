extends Node3D

@export var beatmap: Beatmap
@export var metronome: Instrument
@export var fallingNoteOrigin: Vector3
@export var fallingNotePrefab: PackedScene
@export var fallingNoteScale: float = 0.25
@export var fallingNoteHorizontalSpacing = 1.5;

var _tickCounter: int = 0
var _beatCounter: int = 0
var _laggingbeatCounter: int
var _laggingTickCounter: int
var _tickLength: float
var _timeSinceStart: float

var _note_index: int

func _ready() -> void:
	_tickLength = 60.0 / (beatmap.bpm*beatmap.division)
	_tickCounter = 0
	_timeSinceStart = 0

	_note_index = 0
	print_debug(beatmap.bpm)

func _update_tick_timer(delta: float) -> void:
	_laggingTickCounter = _tickCounter
	_laggingbeatCounter = _beatCounter
	_timeSinceStart += delta
	_tickCounter = int( _timeSinceStart / _tickLength)
	_beatCounter = int(_tickCounter / beatmap.division)

func _handle_metronome ():
	if _beatCounter != _laggingbeatCounter:
		metronome.play_note(0);

func _create_falling_note(note: Array):
	var noteObject = fallingNotePrefab.instantiate() as FallingNote
	noteObject.position = fallingNoteOrigin;
	noteObject.height = note[Beatmap.NoteOpts.LENGTH]*fallingNoteScale
	noteObject.speed = (beatmap.bpm/60.0)*beatmap.division*fallingNoteScale
	noteObject.horizontalOffset = note[Beatmap.NoteOpts.PITCH]*fallingNoteHorizontalSpacing
	add_child(noteObject)

func _handle_falling_notes ():
	if _note_index >= len(beatmap.notes):
		return
	var current_note = beatmap.notes[_note_index]
	if _tickCounter == current_note[Beatmap.NoteOpts.TICK]:
		_note_index += 1
		_create_falling_note(current_note)

func _physics_process(delta: float) -> void:
	_update_tick_timer(delta)
	_handle_metronome()
	_handle_falling_notes()
	# print_debug("" + str(_beatCounter) + " (" + str(_tickCounter % 4) + "/" + str(beatmap.division) + ")")
