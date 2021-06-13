USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- Number of rows in movie table
SELECT count(*) FROM movie;
--  7997

--  Number of rows in genre table
SELECT count(*) FROM genre;
-- 14662

--  Number of rows in director_mapping table
SELECT count(*) FROM director_mapping;
-- 3867

--  Number of rows in role_mapping table
SELECT count(*) FROM role_mapping;
-- 15615

--  Number of rows in names table
SELECT count(*) FROM names;
-- 25735

--  Number of rows in ratings table
SELECT count(*) FROM ratings;
-- 7997

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	DISTINCT(CASE
    WHEN year IS NULL THEN 'year'
	WHEN date_published IS NULL THEN 'date_published'
    WHEN duration IS NULL THEN 'duration'
    WHEN country IS NULL THEN 'country'
    WHEN worlwide_gross_income IS NULL THEN 'worlwide_gross_income'
    WHEN languages IS NULL THEN 'language'
    WHEN production_company IS NULL THEN 'production_company'
    ELSE 'None'
    END) AS Null_Column
FROM movie;

-- worlwide_gross_income, production_company, country and language have null values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT year,
	count(id) as number_of_movies
FROM movie
GROUP BY year ;

SELECT month(date_published) as month_num,
	count(id) as number_of_movies
FROM movie
GROUP BY month(date_published)
ORDER BY month(date_published);

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT count(id) FROM movie
WHERE (country like '%USA%' or country like '%India%') and year = 2019; 
-- 1059 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT(genre) FROM genre;
/* Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery, Others */

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre 
FROM genre 
INNER JOIN movie 
ON id = movie_id
GROUP BY genre
ORDER BY count(id) DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH genre_det AS
(
SELECT movie_id, count(genre) as genre_count
FROM genre 
GROUP BY movie_id
HAVING count(genre) = 1
)
SELECT count(*) FROM genre_det;
-- 3289

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
	round(avg(duration),2) AS avg_duartion
FROM movie
INNER JOIN genre
ON id = movie_id
GROUP BY genre;

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT genre,
	count(movie_id) AS movie_count,
    RANK() OVER(ORDER BY count(movie_id)) AS genre_rank
FROM genre
where genre = 'Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT min(avg_rating) AS min_avg_rating,
	max(avg_rating) AS max_avg_rating,
    min(total_votes) AS min_total_votes, 
    max(total_votes) AS max_total_votes,
    min(median_rating) AS min_median_rating,
    max(median_rating) AS max_median_rating
FROM ratings;
    
/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rankings AS (
SELECT title,
	avg_rating,
    DENSE_RANK() OVER(ORDER BY avg_rating DESC) as movie_rank
FROM movie
INNER JOIN ratings
ON id=movie_id
)
SELECT * FROM rankings WHERE movie_rank <= 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
	count(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY count(movie_id) DESC;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH prod_rankings AS(
SELECT production_company,
	count(id) AS movie_count,
    RANK() OVER(ORDER BY count(id) DESC) AS prod_company_rank
FROM movie 
INNER JOIN ratings
ON id=movie_id
WHERE avg_rating > 8 and production_company IS NOT NULL
GROUP BY production_company
)
SELECT * FROM prod_rankings WHERE prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT genre,
	count(movie_id) as movie_count
FROM genre
INNER JOIN ratings USING(movie_id)
INNER JOIN movie
	ON id = movie_id
WHERE year = 2017 AND 
	month(date_published) = 3 AND
    country like '%USA%' AND
    total_votes > 1000
GROUP BY genre;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT title, 
	avg_rating,
		genre
FROM movie
INNER JOIN ratings 
	ON id = movie_id
	INNER JOIN genre
		USING(movie_id)
	WHERE avg_rating > 8 AND
    title like 'The%';

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT count(id) AS movie_count
FROM movie
WHERE id in (SELECT movie_id FROM ratings WHERE median_rating = 8) AND
	date_published BETWEEN '2018-04-01' AND '2019-04-01';
 
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
	CASE 
    WHEN languages like '%German%' THEN 'German'
    WHEN languages like '%Italian%' THEN 'Italian'
    ELSE 'None' 
    END AS langs,	
	sum(total_votes) as total_votes
FROM movie
INNER JOIN ratings
ON id = movie_id
WHERE languages LIKE '%German%' OR
	languages LIKE '%Italian%'
GROUP BY langs;
    
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
	sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	sum(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    sum(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    sum(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genre AS (
SELECT genre
FROM genre 
INNER JOIN ratings USING(movie_id)
WHERE avg_rating>8
GROUP BY genre
ORDER BY count(movie_id) DESC
LIMIT 3
),
director_rankings AS (
SELECT name AS director_name,
	count(movie_id) AS movie_count,
    DENSE_RANK() OVER(ORDER BY count(movie_id) DESC) AS director_rank
FROM director_mapping
INNER JOIN names
	ON name_id = id
		INNER JOIN genre USING(movie_id)
        INNER JOIN ratings USINg(movie_id)
        WHERE genre in (SELECT * FROM top_genre) AND
			avg_rating > 8
GROUP BY director_name
)
SELECT director_name, movie_count FROM director_rankings WHERE director_rank <= 3;
        
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name as actor_name,
	count(movie_id) as movie_count
FROM names
INNER JOIN role_mapping 
ON id = name_id
INNER JOIN ratings USING(movie_id)
WHERE median_rating >=8 
GROUP BY actor_name
ORDER BY count(movie_id) DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH top_prod AS(
SELECT production_company,
	sum(total_votes) as vote_count,
    DENSE_RANK() OVER(ORDER BY sum(total_votes) DESC) as prod_comp_rank
FROM movie
INNER JOIN ratings
ON id = movie_id
GROUP BY production_company
)
SELECT * FROM top_prod WHERE prod_comp_rank <= 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name AS actor_name,
	sum(rt.total_votes) AS total_votes,
    count(r.movie_id) AS movie_count,
    round(sum(rt.total_votes*rt.avg_rating)/sum(rt.total_votes),2) AS actor_avg_rating,
    RANk() OVER(ORDER BY sum(rt.total_votes*rt.avg_rating)/sum(rt.total_votes) DESC, sum(rt.total_votes) DESC) AS actor_rank
FROM role_mapping as r
	INNER JOIN names as n
		ON r.name_id = n.id
		INNER JOIN movie as m
			ON r.movie_id = m.id
			INNER JOIN ratings as rt
				ON r.movie_id = rt.movie_id
WHERE m.country like '%India%' AND
	r.category = 'actor'
GROUP BY n.name
HAVING movie_count>=5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT n.name AS actress_name,
	sum(rt.total_votes) AS total_votes,
    count(r.movie_id) AS movie_count,
    round(sum(rt.total_votes*rt.avg_rating)/sum(rt.total_votes),2) AS actress_avg_rating,
    RANK() OVER(ORDER BY sum(rt.total_votes*rt.avg_rating)/sum(rt.total_votes) DESC, sum(rt.total_votes) DESC) AS actress_rank
FROM role_mapping as r
	INNER JOIN names as n
		ON r.name_id = n.id
		INNER JOIN movie as m
			ON r.movie_id = m.id
			INNER JOIN ratings as rt
				ON r.movie_id = rt.movie_id
WHERE m.country like '%India%' AND
	r.category = 'actress' AND
    m.languages like '%Hindi%'
GROUP BY n.name
HAVING movie_count>=3;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH movie_ctg AS (
SELECT r.movie_id,
	CASE
		WHEN r.avg_rating > 8 THEN 'Superhit movies'
		WHEN r.avg_rating BETWEEN 7 and 8 THEN 'Hit movies'
		WHEN r.avg_rating BETWEEN 5 and 7 THEN 'One-time-watch movies'
		ELSE 'Flop movies'
		END AS Category
FROM ratings as r
	INNER JOIN genre as g
		ON r.movie_id= g.movie_id
WHERE g.genre = 'Thriller'
)
SELECT Category,
	count(movie_id) as movie_count
FROM movie_ctg
GROUP BY Category;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH averages AS (
SELECT genre,
	ROUND(avg(duration),2) AS avg_duration
FROM genre
INNER JOIN movie
ON id = movie_id
GROUP BY genre
)    
SELECT *,
    SUM(avg_duration) OVER w AS running_total_duration, 
    AVG(avg_duration) OVER w AS moving_avg_duration
FROM averages
WINDOW w AS (ORDER BY avg_duration ROWS UNBOUNDED PRECEDING);

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genre AS(
SELECT genre
FROM genre 
GROUP BY genre
ORDER bY count(movie_id) DESC
LIMIT 3
),
output AS(
SELECT genre,
	year,
    title AS movie_name,
    worlwide_gross_income AS worldwide_gross_income,
    RANK() OVER(PARTITION BY genre, year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM movie
INNER JOIN genre
ON id = movie_id
WHERE genre in (SELECT * FROM top_genre)
)
SELECT * FROM output WHERE movie_rank<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
	count(id) AS movie_count,
    DENSE_RANK() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie
WHERE id in (SELECT movie_id FROM ratings where median_rating >=8) AND
	production_company IS NOT NULL AND
    languages like '%,%'
GROUP BY production_company
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actress AS(
SELECT n.name AS actress_name,
	sum(rt.total_votes) AS total_votes,
    count(r.movie_id) AS movie_count,
    round(avg(rt.avg_rating),2) AS actress_avg_rating,
    DENSE_RANK() OVER(ORDER BY count(r.movie_id) DESC) AS actress_rank
FROM role_mapping r
INNER JOIN names n 
	ON r.name_id = n.id
    INNER JOIN ratings rt
		ON r.movie_id = rt.movie_id
WHERE rt.avg_rating > 8 AND
	r.movie_id in (SELECT movie_id FROM genre WHERE genre='Drama') AND
    r.category = 'actress'
GROUP BY n.name
) 
SELECT * FROM top_actress where actress_rank <=3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH date_det AS
(
SELECT name_id, 
	movie_id,
    date_published,
    duration,
	LAG(date_published,1) OVER (PARTITION BY name_id ORDER BY name_id,date_published) AS prev_date_published
FROM movie
INNER JOIN director_mapping
ON id = movie_id
GROUP BY name_id,movie_id
)

SELECT d.name_id AS director_id,
	n.name AS director_name,
    count(d.movie_id) AS number_of_movies,
    SUM(CASE 
    WHEN d.prev_date_published IS NULL THEN 0
    ELSE DATEDIFF(d.date_published,d.prev_date_published) 
    END) AS avg_inter_movie_days,
    avg(r.avg_rating) AS avg_rating,
    sum(r.total_votes) AS total_votes,
    min(r.avg_rating) AS min_rating,
    max(r.avg_rating) AS max_rating,
    sum(d.duration) AS total_duration
FROM date_det d
INNER JOIN names n
	ON d.name_id = n.id
	INNER JOIN ratings r
		ON d.movie_id = r.movie_id
GROUP BY d.name_id
ORDER BY count(d.movie_id) DESC
LIMIT 9;