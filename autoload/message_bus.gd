extends Node


# Something (Player) is trying to change the level.
signal change_level_requested(map_name : String);


# Something (Player) is attempting to close the game.
signal quit_requested();


# Something (Player) is attempting to return to main menu.
signal quit_to_menu_requested();


# Something (Player) tried to pause.
signal pause_requested();
