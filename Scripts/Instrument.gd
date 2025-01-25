extends Node3D
class_name Instrument

@export_group("InstrumentResource")
@export var indicators: Array[AnimationPlayer]
@export var audioPlayers: Array[AudioStreamPlayer3D]

@export_group("Strings")
@export var indicatorAnimationName: String = "MusicIndicator"
@export var inputActionPrefix: String = "Note"

var _actions: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(indicators)):
		_actions.append(inputActionPrefix+str(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(_actions)):
		if Input.is_action_just_pressed(_actions[i]):
			play_note(i)

func play_note (index: int):
	_play_audio(index)
	_show_indicator(index)

func _play_audio (index: int):
	audioPlayers[index].play()
		
func _show_indicator (index: int):
	indicators[index].play(indicatorAnimationName)
