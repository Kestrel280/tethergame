extends Node


# Something is trying to change the level.
signal change_level_requested(map_name : String);


# Attempting to close the game.
signal quit_requested();


# Attempting to return to main menu.
signal quit_to_menu_requested();
