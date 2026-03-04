CREATE DATABASE RMAD;
USE RMAD;
CREATE TABLE teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(50),
    coach VARCHAR(50),
    stadium VARCHAR(50)
);
CREATE TABLE players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    player_name VARCHAR(50),
    position VARCHAR(30),
    age INT,
    JER_NO INT,
    team_id INT
);
CREATE TABLE matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    opponent VARCHAR(50),
    match_date DATE,
    goals_scored INT,
    goals_conceded INT,
    stadium VARCHAR(50)
);
INSERT INTO teams VALUES ('001','Real Madrid', 'Xabi', 'Santiago Bernabeu');
INSERT INTO players VALUES ('001','Jude Bellingham', 'Midfielder', 21, 5, '001'), ('002','Vinicius Jr', 'Forward', 24, 7,'001'), ('003','Mbappe', 'Forward', 23, 9, '001'), ('004','Toni Kroos', 'Midfielder', 34, 8, '001'), ('005','Luka Modric', 'Midfielder', 40, 10, '001'), ('006','Thibaut Courtois', 'Goalkeeper', 32, 1, '001');
INSERT INTO matches VALUES ('001','Barcelona', '2024-04-21', 2, 1, 'Santiago Bernabeu'), ('002','Atletico Madrid', '2024-02-11', 3, 1, 'Wanda Metropolitano'), ('003','Bayern Munich', '2024-05-08', 2, 1, 'Allianz Arena'), ('004','Manchester City', '2024-04-17', 6, 4, 'Etihad Stadium');
SELECT player_name, age FROM players WHERE age > (SELECT AVG(age) FROM players);
SELECT * FROM matches WHERE goals_scored > (SELECT AVG(goals_scored) FROM matches);
SELECT player_name, position FROM players WHERE team_id = (
    SELECT team_id 
    FROM teams 
    WHERE team_name = 'Real Madrid'
);
CREATE VIEW real_madrid_players AS SELECT p.player_name, p.position, p.age, t.team_name, t.coach FROM players p JOIN teams t ON p.team_id = t.team_id;
SELECT * FROM real_madrid_players;
CREATE VIEW match_summary AS SELECT opponent, match_date,
       goals_scored, goals_conceded,
       (goals_scored - goals_conceded) AS goal_difference
FROM matches;
SELECT * FROM match_summary;
CREATE VIEW senior_players AS SELECT player_name, position, age FROM players WHERE age > 30;
SELECT * FROM senior_players;
SELECT p.player_name, p.position, t.team_name, t.coach FROM players p INNER JOIN teams t ON p.team_id = t.team_id;
SELECT t.team_name, p.player_name, p.position FROM teams t LEFT JOIN players p ON t.team_id = p.team_id;
SELECT t.team_name, p.player_name, p.position FROM teams t RIGHT JOIN players p ON t.team_id = p.team_id;
SELECT p.player_name, p.age, t.team_name FROM players p JOIN teams t ON p.team_id = t.team_id WHERE p.position = 'Midfielder';