#Qual é a média das avaliações (IMDB_Rating) de todos os filmes na tabela?
SELECT ROUND(AVG(IMDB_Rating),2) AS Media_Avaliacoes
FROM project.imdb;

#Qual é a média da duração de todos os filmes na tabela? E o qual oalor Máximo e Mínimo:
SELECT ROUND(AVG(Runtime),2) AS Media_Duracao, MAX(Runtime) AS Maior_Duracao, MIN(Runtime) AS Menor_Duracao
FROM project.imdb;

#Quantos filmes foram lançados em cada ano ano?
SELECT Released_Year, COUNT(*) AS Quantidade
FROM project.imdb
GROUP BY Released_Year
ORDER BY Released_Year DESC;

#Qual foi o Total de bilheteria, Média de bilheteria e a Média de votos de cada gênero?
SELECT Genre, ROUND(SUM(Gross),2) AS Total_Bilheteria, ROUND(AVG(Gross),2) AS Media_Bilheteria, ROUND(AVG(No_of_Votes),2) AS Media_Votos
FROM project.imdb
GROUP BY Genre
ORDER BY Total_Bilheteria DESC;

#Quais filmes tiveram metascore acima de 80 e o gênero contém 'Drama'?
SELECT Series_Title, Genre, Meta_Score
FROM project.imdb
WHERE Meta_Score > 80
AND Genre LIKE '%Drama%';
 
#Quais são os 5 diretores com a maior média de avaliações?
WITH Top_Directors AS(
	SELECT Director, Round(AVG(IMDB_Rating),2) AS Media_Avaliacoes,
	ROW_NUMBER() OVER (ORDER BY AVG(IMDB_Rating) DESC) AS RankingDiretores
    FROM project.imdb
	GROUP BY Director
    )
SELECT RankingDiretores, Director, Media_Avaliacoes
FROM Top_Directors
WHERE RankingDiretores <=5; 

#Qual é a média de avaliação dos filmes por certificado?
SELECT Certificate, Round(AVG(IMDB_Rating),2) as Media_Avaliacoes
FROM project.imdb
GROUP BY Certificate
ORDER BY Media_avaliacoes DESC;

#Quais são os 10 filmes com a maior bilheteria?
WITH Top_Filmes AS(
	SELECT Series_Title, Gross,
	ROW_NUMBER() OVER (ORDER BY GROSS DESC) AS RankingFilmes
	FROM project.imdb
)
SELECT RankingFilmes, Series_Title, Gross
FROM Top_Filmes
WHERE RankingFilmes <=10;

#Quantos filmes têm uma avaliação maior que 8 e uma pontuação de meta superior a 80?
SELECT COUNT(*)
FROM project.imdb
WHERE IMDB_Rating > 8 AND Meta_Score > 80;

#Quais os nomes deles:
SELECT Series_Title, IMDB_Rating, Meta_Score
FROM project.imdb
WHERE IMDB_Rating > 8 AND Meta_Score > 80
ORDER BY Series_Title;

#Quais filmes lançados depois de 2010 tiveram bilheteria acima de 100.000.000? 
SELECT Series_Title, Gross, Released_Year
FROM project.imdb
WHERE Released_Year > 2010 AND Gross > 100000000
ORDER BY Gross DESC;

#Qual é a média de avaliação para cada gênero (Genre)?
SELECT Genre, Round(AVG(IMDB_Rating),2) as Media_Avaliacoes
FROM project.imdb
GROUP BY Genre
ORDER BY Media_avaliacoes DESC;

#Quais são os diretores que têm filmes em mais de um gênero?
SELECT Director, COUNT(DISTINCT Genre) AS Quantidade_Generos
FROM project.imdb
GROUP BY Director
HAVING Quantidade_Generos >=2
ORDER BY Quantidade_Generos DESC;

#Como as avaliações médias dos filmes mudaram ao longo dos anos para filmes cujo gênero contém 'Ação'?
SELECT Genre, Released_Year, 
ROUND(AVG(IMDB_Rating) OVER (PARTITION BY(Genre) ORDER BY (Released_Year)),2) AS Media_Avaliacoes
FROM project.imdb
WHERE Genre LIKE '%Action%';

#Como se comportam a pontuação no IMDB e a pontuação no Metascore ao longo do tempo de acordo com a Certificação?
SELECT Released_Year, Certificate, 
ROUND(AVG(IMDB_Rating) OVER (PARTITION BY Certificate ORDER BY Released_Year),2) AS Media_Avaliacoes,
ROUND(AVG(Meta_Score) OVER (PARTITION BY Certificate ORDER BY Released_Year),2) AS Media_Metascore
FROM project.imdb
ORDER BY Released_Year;

#Quais filmes tiveram atores com Henry no nome?
SELECT Series_Title
FROM(
	SELECT Series_Title, CONCAT(Star1, ',', Star2, ',', Star3, ',', Star4) as All_Actors
	FROM project.imdb
    ) AS Sub_Query
WHERE All_Actors LIKE '%Henry%';

#Classificação dos filmes por ano de acordo com a avaliação (IMDB_Rating).
SELECT Released_Year, Series_Title, IMDB_Rating,
RANK() OVER (PARTITION BY Released_Year ORDER BY IMDB_Rating DESC) as Classificacao
FROM project.imdb
ORDER BY Released_Year;

#Comparação entre a avaliação (IMDB_Rating) de cada filme e a média de avaliação dos filmes lançados no mesmo ano.
SELECT Series_Title, Released_Year, IMDB_Rating, 
ROUND(AVG(IMDB_Rating) OVER (PARTITION BY Released_Year ORDER BY Released_Year),2) AS Media_Avaliacoes_Ano
FROM project.imdb
GROUP BY Series_Title, IMDB_Rating, Released_Year;

#Comparação entre a bilheteria (Gross) de cada e a media de bilheterias no mesmo ano.
SELECT Series_Title, Released_Year, Gross,
ROUND(AVG(Gross) OVER (PARTITION BY Released_Year ORDER BY Released_Year),2) AS Media_Bilheteria_Ano
FROM project.imdb
GROUP BY Series_Title, Released_Year, Gross;

#Classificação dos gêneros com base no total de número de votos
SELECT Genre, SUM(No_of_Votes) AS Total_Votos,
ROW_NUMBER() OVER (ORDER BY SUM(No_of_Votes) DESC) AS Classificacao
FROM project.imdb
GROUP BY Genre

