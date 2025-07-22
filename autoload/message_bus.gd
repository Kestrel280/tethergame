extends Node


# Something is trying to change the level.
signal change_level_requested(map_name : String);


# Player attempting to close the game.
signal player_requested_quit();
