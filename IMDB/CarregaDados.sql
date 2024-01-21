mysql.exe --local-infile=1 -u root -p

SET GLOBAL local_infile = true;

LOAD DATA LOCAL INFILE '/Users/rodrr/Documents/Projects/SQL/IMDB/data/imdb_top_1000_v2.csv' INTO TABLE `project`.`imdb` CHARACTER SET UTF8
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;