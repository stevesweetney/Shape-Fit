extends Node

var best_score

func save_game():
    var save_game = File.new();
    save_game.open("user://savegame.save", File.WRITE);
    var content = to_json({'best_score': best_score});
    save_game.store_string(content);
    save_game.close()
	
func load_game():
    var file = File.new()
    if not file.file_exists("user://savegame.save"):
        self.best_score = 0
        return # Error save file does not exist
    file.open("user://savegame.save", File.READ);
    var content = parse_json(file.get_line())
    self.best_score = content["best_score"];