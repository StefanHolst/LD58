extends Node
@onready var player: PlayerBody = $"../player"
@onready var boat_mode: AudioStreamPlayer = $boat_mode
@onready var player_mode: AudioStreamPlayer = $player_mode

func _process(delta: float) -> void:
	if player.active:
		boat_mode.volume_linear = 0.0
		player_mode.volume_linear = 1.0
	else:
		boat_mode.volume_linear = 1.0
		player_mode.volume_linear = 0.0
