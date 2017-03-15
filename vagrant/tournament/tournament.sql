-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;
CREATE TABLE players (id SERIAL PRIMARY KEY, name TEXT);
CREATE TABLE matches (id SERIAL PRIMARY KEY, winner INTEGER REFERENCES players(id),
											loser INTEGER REFERENCES players(id));

-- join players table and matches table and count each player's total wins,
-- if no match played, the player will not shown in the table after query
CREATE VIEW count_win AS
	SELECT players.id AS id, COUNT(players.id) AS win
	FROM players, matches
	WHERE players.id = matches.winner
	GROUP BY players.id
	ORDER BY win DESC;

-- left join players table and count_win view, if the player has not played,
-- he/she will shown in the table after query but the win column will be null
CREATE VIEW null_win AS
	SELECT players.id AS id, players.name AS name, count_win.win AS win
	FROM players
		LEFT JOIN count_win
	ON count_win.id = players.id
	ORDER BY win DESC;

-- if the value in win column in null_win view is null, change it to 0
CREATE VIEW null_win_zero AS
	SELECT id,
		CASE WHEN win IS NULL THEN 0
		ELSE win END
	FROM null_win;

-- join null_win view and null_win_zero view, the table after query contains
-- players' ids, players' names and players' total wins, players with higher
-- number of wins are on top
CREATE VIEW final_win AS
	SELECT null_win.id AS id, null_win.name AS name, null_win_zero.win AS win
	FROM null_win, null_win_zero
	WHERE null_win.id = null_win_zero.id
	ORDER BY win DESC;

-- join players table and matches table and count the number of matches each
-- player has played, if no match played, the player will not shown in the
-- table after query
CREATE VIEW count_match AS
	SELECT players.id AS id, COUNT(players.id) AS num
	FROM players, matches
	WHERE players.id = matches.winner
		OR players.id = matches.loser
	GROUP BY players.id;

-- left join players table and count_match view, if the player has not played,
-- he/she will shown in the table after query but the num column will be null
CREATE VIEW null_match AS
	SELECT players.id AS id, count_match.num as num
	FROM players
		LEFT JOIN count_match
		ON count_match.id = players.id;

-- if the value in num column in null_match view is null, change it to 0
CREATE VIEW null_match_zero AS
	SELECT id,
		CASE WHEN num IS NULL THEN 0
		ELSE num END
	FROM null_match;

-- join null_match view and null_match_zero view, the table after query contains
-- players' ids, and players' total matches played
CREATE VIEW final_match AS
	SELECT null_match.id AS id, null_match_zero.num AS num
	FROM null_match, null_match_zero
	WHERE null_match.id = null_match_zero.id;

-- left join final_win view and final match view, the table after query contains
-- players' ids, players' names, players' total wins and players' total matches
-- played,  players with higher number of wins are on top, sort is derived from
-- final_win view
CREATE VIEW player_standings AS
	SELECT final_win.id AS id, final_win.name AS name, final_win.win AS win,
		final_match.num AS num
	FROM final_win
		LEFT JOIN final_match
		ON final_win.id = final_match.id;
