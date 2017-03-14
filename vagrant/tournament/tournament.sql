-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

CREATE DATABASE tournament;
CREATE TABLE players (name TEXT, id SERIAL PRIMARY KEY);
CREATE TABLE matches (id SERIAL PRIMARY KEY, winner INTEGER REFERENCES players(id),
											loser INTEGER REFERENCES players(id));

CREATE VIEW count_win AS SELECT players.id AS id, COUNT(players.id) AS win FROM players, matches WHERE players.id = matches.winner GROUP BY players.id ORDER BY win DESC;

CREATE VIEW null_win AS SELECT players.id AS id, players.name AS name, count_win.win as win FROM players LEFT JOIN count_win ON count_win.id = players.id ORDER BY win DESC;

CREATE VIEW null_win_zero AS SELECT id, CASE WHEN win IS NULL THEN 0 ELSE win END FROM null_win;

CREATE VIEW final_win AS SELECT null_win.id AS id, null_win.name AS name, null_win_zero.win AS win FROM null_win, null_win_zero WHERE null_win.id = null_win_zero.id ORDER BY win DESC;

CREATE VIEW count_match AS SELECT players.id AS id, COUNT(players.id) AS num FROM players, matches WHERE players.id = matches.winner OR players.id = matches.loser GROUP BY players.id;

CREATE VIEW null_match AS SELECT players.id AS id, count_match.num as num FROM players LEFT JOIN count_match ON count_match.id = players.id;

CREATE VIEW null_match_zero AS SELECT id, CASE WHEN num IS NULL THEN 0 ELSE num END FROM null_match;

CREATE VIEW final_match AS SELECT null_match.id AS id, null_match_zero.num AS num FROM null_match, null_match_zero WHERE null_match.id = null_match_zero.id;

CREATE VIEW player_standings AS SELECT final_win.id AS id, final_win.name AS name, final_win.win AS win, final_match.num AS num FROM final_win LEFT JOIN final_match ON final_win.id = final_match.id;
