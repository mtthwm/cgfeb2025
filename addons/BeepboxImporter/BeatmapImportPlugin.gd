# import_plugin.gd
@tool
extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_preset_count():
    return Presets.size()

func _get_preset_name(preset_index):
    match preset_index:
        Presets.DEFAULT:
            return "Default"
        _:
            return "Unknown"

func _get_import_order() -> int:
    return ResourceImporter.ImportOrder.IMPORT_ORDER_DEFAULT

func _get_import_options(path, preset_index):
    match preset_index:
        Presets.DEFAULT:
            return [{
                "name": "channel_index",
                "default_value": 0
                },
                {
                "name": "allowed_pitches",
                "default_value": [48,50,52,54,55]
                }
            ]
        _:
            return []

func _get_importer_name():
    return "beatmap.beepbox"

func _get_visible_name():
    return "Beatmap"

func _get_recognized_extensions():
    return ["bj"]

func _get_save_extension():
    return "tres"

func _get_priority():
    return 2

func _get_resource_type():
    return "Beatmap"

func _get_option_visibility(path, option_name, options):
    return true

func _get_allowed_pitch(pitch: int, allowed_pitches) -> int:
    for i in range(len(allowed_pitches)):
        if allowed_pitches[i] == pitch:
            return i
    return -1

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
    var file = FileAccess.open(source_file, FileAccess.READ)
    if file == null:
        return FileAccess.get_open_error()

    var json_txt = file.get_as_text()
    var json = JSON.new()
    var error = json.parse(json_txt)

    if error == OK:
        var beatmap = Beatmap.new()
        beatmap.bpm = json.data["beatsPerMinute"]
        beatmap.division = json.data["ticksPerBeat"]

        var patterns = json.data["channels"][options.channel_index]["patterns"]
        var sequence = json.data["channels"][options.channel_index]["sequence"]
        var tickOffset = 0

        for index_string in sequence:
            var index = int(index_string) - 1
            var pattern = patterns[index]
            for bb_note in pattern["notes"]:
                var note = Note.new()
                note.pitch = _get_allowed_pitch(bb_note["pitches"][0], options.allowed_pitches)
                note.tick = bb_note["points"][0]["tick"] + tickOffset
                note.length = bb_note["points"][1]["tick"] - bb_note["points"][0]["tick"]
                beatmap.notes.append(note)
            tickOffset += beatmap.division*json.data["beatsPerBar"]

        var err = ResourceSaver.save(beatmap, "%s.%s" % [save_path, _get_save_extension()])
        print_debug(err)
        return err
    else:
        print_debug("JSON PARSE ERROR IN %s" % source_file)