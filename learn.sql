-- Query for Question 1 
SELECT primaryTitle FROM title
WHERE tconst IN (
    SELECT  tconst FROM directors
   WHERE ARRAY_LENGTH(directors,1) >2
)
AND (titleType = 'movie');


--Query for Question 2 
select k.acname from (select d.acname,max(ct) from (select c.acname,c.dname,count(dname) as ct
from (select a.nconst as aid,a.primaryname as acname,a.tconst,b.nconst as did,b.primaryname as dname 
from (select principal.nconst, principal.tconst, names.primaryname
from title,principal,names
where principal.nconst=names.nconst
and title.tconst=principal.tconst
and principal.category='actor'
and title.titletype='movie') as a,
(select principal.nconst, principal.tconst, names.primaryname
from title,principal,names
where principal.nconst=names.nconst
and title.tconst=principal.tconst
and principal.category='director'
and title.titletype='movie') as b 
where a.tconst=b.tconst) as c
group by c.acname,c.dname
) as d
group by d.acname
order by max desc) as k,
(select c.acname,c.dname,count(dname) as ct
from (select a.nconst as aid,a.primaryname as acname,a.tconst,b.nconst as did,b.primaryname as dname 
from (select principal.nconst, principal.tconst, names.primaryname
from title,principal,names
where principal.nconst=names.nconst
and title.tconst=principal.tconst
and principal.category='actor'
and title.titletype='movie') as a,
(select principal.nconst, principal.tconst, names.primaryname
from title,principal,names
where principal.nconst=names.nconst
and title.tconst=principal.tconst
and principal.category='director'
and title.titletype='movie') as b 
where a.tconst=b.tconst) as c
group by c.acname,c.dname
) as j
where k.acname=j.acname and k.max=j.ct and j.dname='Zack Snyder'

--Query for Question 3 
SELECT primaryTitle FROM title
WHERE ARRAY_LENGTH(awards ,1)<2 ;

--Query for Question 4
select c.acname,c.dname,count(c.tconst)
from (select a.nconst as aid,a.primaryname as acname,a.tconst,b.nconst as did,b.primaryname as dname 
from (select principal.nconst, principal.tconst, names.primaryname
from title,principal,names
where principal.nconst=names.nconst
and title.tconst=principal.tconst
and principal.category='actor'
and title.titletype='movie') as a,
(select principal.nconst, principal.tconst, names.primaryname
from title,principal,names
where principal.nconst=names.nconst
and title.tconst=principal.tconst
and principal.category='director'
and title.titletype='movie') as b 
where a.tconst=b.tconst) as c,ratings
where ratings.tconst=c.tconst and ratings.averagerating>7
group by c.acname,c.dname
having count(c.tconst)<=2


--Query for Question 5
SELECT primaryTitle FROM title
WHERE endYear-startYear = (SELECT max(endYear-startYear) FROM title)


--Query for Question 6 
SELECT primaryName from names
WHERE nconst in 
(
    SELECT principal.nconst from principal,title
    WHERE title.tconst=principal.tconst
	and principal.category='director'
    AND title.titleType='movie' AND title.startYear=2020
    ORDER BY title.runtimeMinutes limit 2
)
and nconst not in (
    SELECT principal.nconst from principal,title
    WHERE title.tconst=principal.tconst
	and principal.category='director'
    AND title.titleType='movie' AND title.startYear=2020
    ORDER BY title.runtimeMinutes limit 1
)

--Query for Question 7 

SELECT tite.primaryTitle,ratings.averageRating
FROM title INNER JOIN ratings on title.tconst =ratings.tconst
WHERE title.titleType ='movie' AND title.isAdult = 'yes'
ORDER BY ratings.averageRating limit 1 ;

SELECT tite.primaryTitle,ratings.averageRating
FROM title INNER JOIN ratings on title.tconst =ratings.tconst
WHERE title.titleType ='tvSeries' AND title.isAdult = 'yes'
ORDER BY ratings.averageRating limit 1

--Query for Question 8

select primaryname from names 
where nconst in 
(select n.nconst from (select s.nconst, avg(s.averagerating) from (select * from (SELECT P.tconst ,P.nconst ,P.category ,T.titleType
FROM  principal as P 
INNER JOIN title T on T.tconst = P.tconst
WHERE P.category = 'director' and T.titletype='movie')
as e INNER JOIN ratings on e.tconst=ratings.tconst) as s 
group by s.nconst
order by avg desc
limit 5) as n );

--Query for Question 9
SELECT title.primaryTitle 
FROM title INNER JOIN titleakas ON title.tconst=title.titleId
WHERE title.titleType = 'tvSeries'
HAVING COUNT(titleakas.productionCompany)>2
AND COUNT(titleakas.region)>3

--Query for Question 10
SELECT names.primaryName,awards.Year
FROM names INNER JOIN awards ON names.nconst=awards.nconst
WHERE awards.name= 'Oscar'
ORDER BY awards.Year

--Query for Question 11
select names.primaryname from (select s.nconst,(0.7*(0.8*avg(case when job is null then s.averagerating else 0 end)+
0.2*avg(case when job is not null then s.averagerating else 0 end))+
0.3*count(tconst)) as score,count(tconst) as exp
from (select p.job,p.nconst,p.category,r.averagerating,p.tconst from principal p , ratings r,title
where p.tconst=r.tconst and (p.job like '%assistant director' or (p.category='director' and p.job is null))
and title.tconst=p.tconst and title.titletype='movie'
order by p.nconst) as s
group by nconst
order by score desc limit 1) as king,names
where king.nconst=names.nconst


--Query for Question 12 
SELECT title.primaryTitle,directors.directors,MAX(title.Boxoffice - title.Budget)
FROM title INNER JOIN directors WHERE title.tconst = directors.tconst
GROUP BY genere

--Query for Question 13 
SELECT primaryName FROM names
WHERE nconst in (SELECT DISTINCT principal.nconst
FROM principal INNER JOIN title ON principal.tconst = title.tconst
WHERE principal.category = 'actor'
GROUP BY principal.nconst 
HAVING SUM(CASE WHEN title.titleType = 'movie' THEN 1 ELSE 0 END)>=2
AND SUM(CASE WHEN title.titleType = 'tvSeries' THEN 1 ELSE 0 END)>=2)


--Query for Question 14
select primarytitle,k.startyear,k.min from (select min(runtimeminutes),startyear from title
where title.titletype='tvEpisode' and runtimeminutes is not null
group by startyear) as k,title
where title.startyear=k.startyear and title.runtimeminutes=k.min and title.titletype='tvEpisode'
order by k.startyear,k.min

--Query for Question 15 
select s.primarytitle,s.genre,s.rowranking from (select title.tconst,primarytitle,unnest(title.genres) as genre,row_number() 
									 over (partition by unnest(title.genres) order by ratings.averagerating desc) as rowranking
                          from title,ratings
                          where titletype='movie'
                          and ratings.tconst=title.tconst
						  order by title.tconst) as s
						  where s.rowranking<4
						  order by s.genre,s.rowranking asc


--Query for Question 16
SELECT primaryTitle FROM title
WHERE  'Switzerland'= ANY(filmingLocation)
AND (titleType = 'movie' OR titleType = 'tvSeries');

--Query for Question 17 

SELECT titleakas.title 
FROM title INNER JOIN titleakas
ON titleakas.titleId=title.tconst
AND title.startYear = 1995
AND title.isAdult = 'yes'
AND titleakas.region = 'US'


--Query for Question 18 
select distinct(names.primaryname,k.category,k.max) from names,
(select max(names.birthyear),principal.category from principal,names 
where names.nconst=principal.nconst
group by principal.category) as k,principal 
where principal.nconst=names.nconst and names.birthyear=k.max and k.category=principal.category

--Query for Question 19 
SELECT primaryName from names
WHERE nconst IN 
(
    SELECT nconst FROM principal
    WHERE category like 'composer'
    GROUP BY nconst
    HAVING COUNT(*)>5
);


--Query for Question 20
--Where movie name is Justice league
SELECT primaryName FROM names
WHERE nconst in
(
    SELECT nconst FROM principal
    WHERE category ='actor'
    GROUP BY nconst 
    HAVING  COUNT(tconst)  = (
    SELECT COUNT(tconst) FROM principal
    WHERE tconst =  'tt0974015'
)
);
