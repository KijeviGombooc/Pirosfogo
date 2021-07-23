INSERT INTO players(name) VALUES("dummy 1");
INSERT INTO players(name) VALUES("dummy 2");
INSERT INTO players(name) VALUES("dummy 3");
INSERT INTO players(name) VALUES("dummy 4");
INSERT INTO games(date_time) VALUES("000");

INSERT INTO places(game_id, player_id, place) VALUES(1, 4, 1);
INSERT INTO places(game_id, player_id, place) VALUES(1, 3, 2);
INSERT INTO places(game_id, player_id, place) VALUES(1, 1, 3);
INSERT INTO places(game_id, player_id, place) VALUES(1, 2, 4);

INSERT INTO scores(row_id, place_id, score) VALUES(1, 1, 2);
INSERT INTO scores(row_id, place_id, score) VALUES(1, 2, 1);
INSERT INTO scores(row_id, place_id, score) VALUES(1, 3, 3);
INSERT INTO scores(row_id, place_id, score) VALUES(1, 4, 2);

INSERT INTO scores(row_id, place_id, score) VALUES(2, 1, 4);
INSERT INTO scores(row_id, place_id, score) VALUES(2, 2, 1);
INSERT INTO scores(row_id, place_id, score) VALUES(2, 3, 3);
INSERT INTO scores(row_id, place_id, score) VALUES(2, 4, 0);

INSERT INTO scores(row_id, place_id, score) VALUES(3, 1, 1);
INSERT INTO scores(row_id, place_id, score) VALUES(3, 2, 0);
INSERT INTO scores(row_id, place_id, score) VALUES(3, 3, 1);
INSERT INTO scores(row_id, place_id, score) VALUES(3, 4, 6);

INSERT INTO scores(row_id, place_id, score) VALUES(4, 1, 3);
INSERT INTO scores(row_id, place_id, score) VALUES(4, 2, 3);
INSERT INTO scores(row_id, place_id, score) VALUES(4, 3, 1);
INSERT INTO scores(row_id, place_id, score) VALUES(4, 4, 1);