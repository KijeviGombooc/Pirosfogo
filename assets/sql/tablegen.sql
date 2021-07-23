DROP TABLE IF EXISTS scores;
DROP TABLE IF EXISTS places;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS players;


CREATE TABLE players(
	player_id INTEGER PRIMARY KEY AUTOINCREMENT,
	name CHAR NOT NULL,
	img_uri CHAR
);

CREATE TABLE games(
	game_id INTEGER PRIMARY KEY AUTOINCREMENT,
	date_time CHAR NOT NULL UNIQUE
);

CREATE TABLE places(
	game_id INTEGER NOT NULL,
	player_id INTEGER,
	place_id INTEGER NOT NULL,
	
	PRIMARY KEY (game_id, place_id, player_id),
	CONSTRAINT secondary_key UNIQUE(game_id, player_id),
	CONSTRAINT third_key UNIQUE(game_id, place_id),
	FOREIGN KEY(game_id) REFERENCES games(game_id),
	FOREIGN KEY(player_id) REFERENCES players(player_id)
);

CREATE TABLE scores(
	game_id INTEGER NOT NULL,
	place_id INTEGER NOT NULL,
	row_id INTEGER NOT NULL,
	score INTEGER NOT NULL,
	
	PRIMARY KEY(game_id, place_id, row_id),
	FOREIGN KEY(game_id) REFERENCES games(game_id),
	FOREIGN KEY(game_id, place_id) REFERENCES places(game_id, place_id)
);














