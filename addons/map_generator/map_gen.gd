tool
extends EditorPlugin

var generate_map_btn
var panel_button
var edited_objected = null

func _enter_tree():
	# Initalization of plugin goes here
	generate_map_btn = preload("res://addons/map_generator/Button.tscn").instance()
	generate_map_btn.connect("pressed", self, "generate_map")
	generate_map_btn.disabled = true
	panel_button = add_control_to_bottom_panel(generate_map_btn, "Generate Map")
	
func _exit_tree():
	# Clean up of plugin goes here
	# Remove from engine when plugin is deactivated
	remove_control_from_bottom_panel(panel_button)
	remove_control_from_bottom_panel(generate_map_btn)
	generate_map_btn.free()
	
func handles(object):
	print("calling handles")
	print(object)
	if (object is Node2D):
		edited_objected = object
		generate_map_btn.disabled = false
		return true
	else:
		edited_objected = null
		generate_map_btn.disabled = true
		false
	
func make_visible(visible):
	if (visible):
		make_bottom_panel_item_visible(generate_map_btn)
	else:
		hide_bottom_panel()
	
func edit(object):
	print("Editing")
	
func generate_map():
	if edited_objected:
		print("Generating map...")
		print(edited_objected)
		edited_objected.gen_points()
		edited_objected.create_or_update_path()
		
		
