extends Control

# Terminal toggle with fade in/out animation
var terminal_instance: Control = null
var tween: Tween = null

func _on_terminal_pressed() -> void:
	if terminal_instance == null:
		var packed = load("res://scene/componnent/terminal.tscn")
		terminal_instance = packed.instantiate()
		add_child(terminal_instance)

		terminal_instance.modulate.a = 0.0
		terminal_instance.visible = true

		tween = create_tween()
		tween.tween_property(terminal_instance, "modulate:a", 1.0, 0.2)
	else:
		if terminal_instance.visible and terminal_instance.modulate.a > 0.5:
			tween = create_tween()
			tween.tween_property(terminal_instance, "modulate:a", 0.0, 0.2)
			await tween.finished
			terminal_instance.visible = false
		else:
			terminal_instance.visible = true
			tween = create_tween()
			tween.tween_property(terminal_instance, "modulate:a", 1.0, 0.2)


@onready var text_edit: TextEdit = $"../TextEdit"
@onready var open_dialog: FileDialog = $"../Dialogs/OpenFileDialog"
@onready var save_dialog: FileDialog = $"../Dialogs/SaveFileDialog"

func _ready():
	# Connect file dialogs to their callbacks
	open_dialog.file_selected.connect(_on_open_file_selected)
	save_dialog.file_selected.connect(_on_save_file_selected)

func _on_openfile_pressed() -> void:
	open_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_dialog.popup_centered()

func _on_open_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		text_edit.text = file.get_as_text()
		file.close()

func _on_savefile_pressed() -> void:
	save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dialog.popup_centered()

func _on_save_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(text_edit.text)
		file.close()

func _on_newfile_pressed() -> void:
	text_edit.text = ""
