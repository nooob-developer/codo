extends Control

@onready var editor: TextEdit = $Panel/TextEdit

func _ready():
	var highlighter = load("res://assets/syntax/syntaxhighlight.tres")
	editor.syntax_highlighter = highlighter
