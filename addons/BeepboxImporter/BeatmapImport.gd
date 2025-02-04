@tool
extends EditorPlugin


var import_plugin


func _enter_tree():
	import_plugin = preload("BeatmapImportPlugin.gd").new()
	add_import_plugin(import_plugin)
	add_custom_type("Beatmap", "Resource", preload("Beatmap.gd"), preload("res://icon.svg"))


func _exit_tree():
	remove_import_plugin(import_plugin)
	remove_custom_type("Beatmap")
	import_plugin = null