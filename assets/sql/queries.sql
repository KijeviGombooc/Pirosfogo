/* get all players from given game in turning order */
SELECT player_id FROM places, games
WHERE games.game_id = places.game_id
AND date_time = "000"
ORDER BY place_id
;

/* get all scores from given game from given player in round order */
SELECT score FROM scores, places
WHERE game_id = 1
AND scores.place_id = places.place_id
AND player_id = 2
ORDER BY row_id;
