extends TextureRect

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var did_cap = false

func _ready():
	pass

func cap_screen():
	var screen_tex = get_viewport().get_texture();
	var screen_img = screen_tex.get_data();
	screen_img.flip_y();
	var im_tex = ImageTexture.new();
	var im = Image.new()
	im.copy_from(screen_img)
	im_tex.create_from_image(im)
	texture = im_tex


func _on_HSlider_value_changed(value):
	get_material().set_shader_param("cutoff", float(value));
