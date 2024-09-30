extends CanvasLayer

onready var right := $Control/HBoxRight
onready var top := $Control/HBoxTop

onready var keys := [$Control/HBoxRight/C, $Control/HBoxRight/X]
onready var buttons := [$Control/HBoxRight/C/Control/Button, $Control/HBoxRight/X/Control/Button]

onready var game_hide := [$Control/HBoxRight/C/Control/Key, $Control/HBoxRight/X/Control/Key]
onready var game_show := [$Control/HBoxTop/Z, $Control/HBoxRight/C/Control/Sprite, $Control/HBoxRight/X/Control/Sprite]

onready var btns := $Control/HBoxLeft/DPad/Buttons.get_children()
onready var actions := InputMap.get_actions()

func _ready():
	connect("visibility_changed", self, "vis")

	yield(get_tree(), "idle_frame")
	visible = (OS.has_touchscreen_ui_hint() and OS.get_name() == "HTML5") or OS.get_name() == "Android"
	vis()

func vis():
	pass
#	if is_instance_valid(UI.keys_node):
#		UI.keys_node.visible = !visible

func show_keys(arg_arrows := true, arg_c := true, arg_x := true, arg_pause := false, arg_passby := false):
	right.visible = arg_arrows
	keys[0].visible = arg_c
	keys[1].visible = arg_x
	top.visible = arg_pause

func set_game(arg := false):
	var i = "" if arg else "ui_"
	set_actions(i + "up", i + "down", i + "left", i + "right")
	buttons[0].action = "grab" if arg else "ui_cancel"
	buttons[1].action = "jump" if arg else "ui_accept"
	
	for h in game_hide:
		h.visible = !arg
	for s in game_show:
		s.visible = arg
	
	for a in actions:
		Input.action_release(a)
	
	for f in buttons:
		f.passby_press = arg

func set_actions(_up, _down, _left, _right):
	for i in 4:
		btns[i].action = [_right, _down, _left, _up][i]
		btns[i].passby_press = !("ui_" in _up)
