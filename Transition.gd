extends TextureRect

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func cap_screen():
	var screen_tex = get_viewport().get_texture();
	var screen_img = screen_tex.get_data();
	screen_img.flip_y();
	#screen_img.save_png("screen.png");
	var im_tex = ImageTexture.new();
	var im = Image.new()
	im.copy_from(screen_img)
	im_tex.create_from_image(im)
	texture = im_tex