extends Node3D

@export var beatmap: Beatmap
@export var metronome: Instrument

var _tickCounter: int = 0
var _beatCounter: int = 0
var _laggingbeatCounter: int
var _laggingTickCounter: int
var _tickLength: float
var _timeSinceStart: float

func _ready() -> void:
	beatmap = Beatmap.new()
	beatmap.bpm = 100
	beatmap.division = 4

	_tickLength = 60.0 / (beatmap.bpm*beatmap.division)
	_tickCounter = 0
	_timeSinceStart = 0

func _update_tick_timer(delta: float) -> void:
	_laggingTickCounter = _tickCounter
	_laggingbeatCounter = _beatCounter
	_timeSinceStart += delta
	_tickCounter = int( _timeSinceStart / _tickLength)
	_beatCounter = int(_tickCounter / beatmap.division)

func _handle_metronome ():
	if _beatCounter != _laggingbeatCounter:
		metronome.play_note(0);

func _process(delta: float) -> void:
	_update_tick_timer(delta)
	_handle_metronome()
	# print_debug("" + str(_beatCounter) + " (" + str(_tickCounter % 4) + "/" + str(beatmap.division) + ")")
