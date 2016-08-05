# Databases and SQL

## Goal and Objectives

We'll again use the Gapminder dataset we saw in the R introduction lesson.
Now that we're more familiar with this dataset, we might ask some specific questions about the data.

* What is the average life expectancy since 2000 of each of the top 10 countries ordered by per capita GDP?
* What is the average life expectancy since 2000 across each continent?

**In order to answer the questions described above, we'll need to do the following basic data operations:**

* Select subsets of the data (rows and columns)
* Group subsets of data
* Do math and other calculations
* Combine data across spreadsheets

In addition, we don't want to do this manually!
Instead of searching for the right pieces of data ourselves, or clicking between spreadsheets, or manually sorting columns, we want to make the computer do the work.
In particular, we want to use a tool where it's easy to repeat our analysis in case our data changes. We also want to do all this searching without actually modifying our source data.
Putting our data into a database and using SQL will help us achieve these goals.

## Background

There are three common options for storing data:

* Text files
* Spreadsheets
* Databases

Text files are the easiest to create and work well with version control.
Spreadsheets and spreadsheet programs like Microsoft Excel are good for doing analysis but they don't handle large or complex datasets well.
**Databases, however, include powerful tools for search and analysis and are capable of handling large, complex datasets.**

**As with the previous lessons, I'm going to provide some brief background material and then we'll dive right into hands-on exercises.**

### Relational Databases

**The type of database we'll be working with today is called a relational database.**
Databases are arranged as tables.
**Just as in a spreadsheet,** each table has columns (also known as fields) that describe the data, and rows (also known as records) which contain the data.

To interact with the data in our database, we send commands to a database manager, which is a program that manipulates the database for us.
Here, the database manager reads the user's command, retrieves and manipulates data from the database according to what the user asked for, and returns it for display.

**Why would we use a relational database?**

* It separates our data from our analysis. Recall how this builds on best practices: treating the data as read-only; treating our results as disposable and generating them from scripts. This way, there is no risk of accidentally changing data when analyzing it.
* Databases are fast for large amounts of data; much faster than many programming environments including R.
* We improve the quality control of data entry through the use of data type checking and constraints.
* Furthermore, the concepts of relation database queries are core to understanding more advanced features in R and high-performance computing environments for working with big datasets.

### SQL

**When working with databases, the commands we type are usually called queries. The language we type them in is called Structured Query Language or S-Q-L, which can also be pronounced as "sequel."**
It's correct however you say it.

**The name Structured Query Language is a bit of a misnomer, as is the term "query," because with SQL we can do more than just query our data.**
We can add data to the database, transform existing data, combine data from different tables in powerful ways, and delete data, as necessary.

**The database manager we'll be using today is called SQLite3.**
There are many different relational database managers out there but they all speak SQL.
**While they do speak slightly different flavors or "dialects" of SQL, what you'll be learning today will help you work with any one of them.**

## Getting Started with SQLite Manager

Our database manager is SQLite and we'll be using a software application that wraps SQLite, what we'll call a **client** for SQLite.
That client is called SQLite Manager and it is available as a plug-in for Mozilla Firefox.
**Go ahead and open SQLite Manager from Firefox.**

### Creating and Populating a New Database

1. At the top menu, select **Database** -> **New Database.**
2. We'll call our new database **gapminder.**
3. SQLite3 manages databases that are stored as single files on a computer's file system. So, after we click **OK** we'll be prompted to save the database as a file. **Save it to your Desktop as `gapminder.sqlite`.**
4. Start the import **Database** -> **Import.**
5. Select the file to import: `gap-every-five-years.csv`
6. Give the table a name that matches the table's contents. I like to choose a plural noun that describes the data represented by the rows. We'll call it **surveys.**
7. Here the first row has column headings, so **check the 'First row contains column names' box**
8. Use the defaults of **Fields separated by: comma** and **Fields enclosed by: double quotes.**
9. After you click **OK** at the bottom, you're asked if you want to modify this table. Click **OK.**
10. Modify the table's fields according to the table below.
11. **After manually setting the data types,** click **OK.**

Column Name | Data Type
----------- | ---------
country     | TEXT
year        | INTEGER
lifeExp     | FLOAT
pop         | INTEGER
gdpPercap   | FLOAT

### Challenge: Importing the Countries Table

Import the table `countries.csv` as a new a table called `countries`.

## Basic Queries

**In this lesson, we have two tables rather than the one combined table we saw in the R lesson.**
Let's examine the difference between these two layouts.
This is what we get when we combine these two tables.
**Because the combined table is wider, we refer to this as "wide format" data. What are the advantages of wide format data?**
We now have all the data in a single table and as a single text file, when outside of the database.
We can also see at a glance all of the variables at once.
**What are the disadvantages of wide format data compared to the "narrow" format we have in our database?**

* **It's redundant:** the values for the `color` and `continent` fields are reproduced needlessly for the same value of `country`.
* **It is tedious to change:** If we updating this information, say, changing the `color` associated with Afghanistan, we would have to change that value in every row for that country.
* **It could lead to inconsistencies:** As we're updating or adding new rows to a table, we might mistype a value that should be the same as in another row in the table. This could lead, for instance, to one row of Albania being assigned a different `continent` than the others, based on a mispelling or mistaken entry.

**So, here, rather than repeating the continent information along with the country in the surveys table, we have a separate table that contains that information.**
Then we can put that information back together whenever we need to by matching `country` in the `surveys` table to `country` in the `countries` table.
We'll discuss how to join the data in the `countries` table to the data in the `surveys` table later, and then you'll see that the advantages of the wide format outweighany disadvantages.

**Let's start with some basic SQL queries to answer fundamental questions about our data.**
Click on the "Execute SQL" tab.

Let's say we want to find the years associated with our surveys.
In SQL, we use the `SELECT` command to tell the database we want to select columns from a table.
In the text box, type the following:

```sql
SELECT country FROM surveys;
```

Here, we've also told SQL `FROM` which table to select the `country` column.
And what are the results?
We see the `country` column from our table, just like we asked for.
**One of the things that fundamentally distinguishes SQL from a programming language like R is that SQL is declarative.**
This means that, in SQL, rather than telling the computer *how* to accomplish a task, we describe *what* the computer should do (e.g., "Iterate through this data structure and grab this value in each iteration...").
Let's try another query.

```sql
SELECT country, pop FROM surveys;
```

Here, we see two columns: `country` and `pop`.
Let me highlight a couple of key things.

* SQL only returns the columns we've asked for and it returns them in the order in which we specified them.
* The semicolon is very import in SQL. It tells the database manager that the command we're typing is finished. The SQLite Manager client will forgive us for forgetting the semicolon but other clients will not, so it's a good habit to add it to the end of every query.
* The words `SELECT` and `FROM` are capitalized here by convention; it's not required to capitalize them but it helps make your code more readable which is very important.

**Throughout today's lesson I will be typing SQL commands in all capitals and the names of columns in lowercase to help you distinguish them from the names of tables and columns in the data. I encourage you to try to do the same but you can type these commands however you want; they'll work just the same.**

What if we want to see all the columns of the `surveys` table?
Do we have to type each column name?

```sql
SELECT * FROM surveys;
```

Let's go back to our query on the `country` column.
With that query, SQLite returned the value of `country` for each row in the table.
**What if we want to see only the unique values of a column?**

```sql
SELECT DISTINCT country FROM surveys;
```

**We see from this behavior that, by default, SQL returns all the rows of the column.**

```sql
SELECT ALL country FROM surveys;
```

What happens if we use `DISTINCT` with two or more columns?

```sql
SELECT DISTINCT country, year FROM surveys
```

SQLite returns every unique pair of values between the two columns.

**What else is this good for? Identifying (and ultimately removing) duplicates!**

In addition to querying values stored in the database, we can use SQL to calculate new or derived values.

```sql
SELECT country, year, pop/1000.0 FROM surveys;
```

Note that our third column is the original value divided by 1000; it is now population in thousands of people.
**Why did I explicitly include the decimal point and a trailing zero? Try removing it.**

```sql
SELECT country, year, pop/1000 FROM surveys;
```

Expressions can use any fields, any arithmetic operators, and a variety of built-in functions, like `round()`.

```sql
SELECT country, year, round(gdpPercap, 2) FROM surveys;
```

We can choose a better name for this column too.

```sql
SELECT country, year, round(gdpPercap, 2) AS gdp_per_capita FROM surveys;
```

### Challenge: First Query

Write a query that returns the `country`, `year`, population in millions of people rounded to two decimal places, and life expectancy rounded to one decimal place.
Then, rename the derived columns so they are more readable.

## Filtering Data

We can write SQL queries that filter the data in our tables, selecting only those records that match certain criteria.
For instance, let's say we only want data for the country of Iceland.

```sql
SELECT * FROM surveys WHERE country="Iceland";
```

**The `WHERE` clause in this query specifies a condition which each record must match in order for it to be included in the results.**
Since the `year` column is just an integer, if we want to get only the data since the year 2000, we can write a condition that tests for `year` greater-than-or-equal-to 2000.

```sql
SELECT * FROM surveys WHERE year >= 2000;
```

**How does this work? The database manager executes this query in two stages.**
First, it checks the entries of the `surveys` table to see which ones match the `WHERE` clause.
Then, it returns only the columns from those entries specified in the `SELECT` clause.
**This processing order means that we can even filter records on columns that don't appear in the results.**

How could we combine the last two queries?

```sql
SELECT * FROM surveys WHERE country="Iceland" AND year >= 2000;
```

As we continue to add conditions, we might want to add parentheses to make our query more readable.
For instance, if we wanted to get data for three countries instead of just for Iceland...

```sql
SELECT * FROM surveys WHERE (country = "Iceland") OR (country = "Madagascar") OR (country = "Dominican Republic");
```

We can invert queries with the `NOT` keyword.

```sql
SELECT * FROM surveys WHERE NOT country = "Iceland";
```

**We can also filter by partial matches.**
If we want to see all of the countries whose names begin with the word "United" we could use the `LIKE` keyword.

```sql
SELECT * FROM surveys WHERE country LIKE "United%";
```

Here, the percent sign (`%`) is a wildcard symbol.
It specifies that any number of characters, or no characters, can take its place.
Here, its use at the end of the word "United" indicates that matching country names must begin with "United" but can otherwise have anything coming after it.

If we want to see all of the countries that have "Guinea" in their name we could write a query as follows.

```sql
SELECT * FROM surveys WHERE country LIKE "%Guinea%";
```

**Note that the country of Guinea is also returned; the wildcards can match nothing.**

### Challenge: Effective Filtering

Write a query that returns the country, year, life expectancy and population in thousands of people for any record with a life expectancy greater than 70.
* How many records are there? **(493)**
* How many records are there if you change lifeExp to 75? **(173)**

Write a query that returns the country, year, life expectancy and population in thousands of people for any record with a life expectancy greater than 70 and before 1990.
* How many records are there? **(216)**
* How many records are there if you just look at the year 1952? **(5)**
* How many records are there if you just look at the year 2007? **(83)**

## Building Complex Queries

Now, let's combine what we've seen so far to get data for three countries from the year 2000 on.
This time, we'll introduce the `IN` keyword to make the query more readable.

```sql
SELECT *
  FROM surveys
 WHERE (year >= 2000)
   AND (country IN ("Iceland", "Madagascar", "Dominican Republic"));
```

**We built this query by starting with more simple queries, testing each one as we went along. This is a practice to get familiar with.**
It's exactly how expert software engineers produce complex programs, too.
Sometimes it might help to take a subset of the data that you can easily see in a temporary database to practice your queries on before working on a larger or more complicated database.

### Sorting

It's important to understand that **the records in a database table aren't actually stored in any particular order.**
When we execute a query, we get the results in what is essentially random order from our perspective.
We can sort the results of our queries using the `ORDER BY` clause.
In this example, notice that I'm selecting records from the `countries` table instead of the the `surveys` table.

```sql
SELECT * FROM countries ORDER BY country ASC;
```

The keyword `ASC` indicates we want the rows in ascending order.
This is the default, so we could have omitted this keyword.
To get the rows in descending order, we use the keyword `DESC`.

```sql
SELECT * FROM countries ORDER BY country DESC;
```

We can also sort on several fields at once.
Multiple sorting is typically only effective if there are multiple categorical fields--fields that have multiple rows with the same values.
For instance, to order the names of countries within continents...

```sql
SELECT * FROM countries ORDER BY continent ASC, country ASC;
```

Note that we don't actually have to display a column to sort by it.
For instance, let’s say we want to look at countries with population higher than a million and order the countries by their population, but we only want to see `gdpPercap`.

```sql
SELECT country, gdpPercap FROM surveys WHERE (pop > 1000000) ORDER BY pop ASC;
```

**To understand why this works, we need to understand more about how SQL queries are processed by the database management system.**
When SQLite3, or another other database management system, receives the above SQL query...

1. It first filters the rows according to the `WHERE` clause. It applies this condition to each row, one-by-one, keeping the rows that fit the conditional statement.
2. Second, it sorts the results according to the `ORDER BY` clause.
3. Finally, it displays the requested columns and any calculations you've requested on them.

**When we're writing a query, the order of the clauses must be:** `SELECT`, `FROM`, `WHERE`, and then `ORDER BY`.

### Challenge

Using the `surveys` table, write a query to display `country`, `year`, `lifeExp` (life expectancy), and population in millions (rounded to two decimal places) for the year 2007, ordered by life expectancy with highest life expectancy at the top.

## Aggregation and Joins

The features we've seen so far are not too dissimilar from what we could do with a spreadsheet program.
**One of the more powerful features of SQL that distinguishes it from a spreadsheet is aggregation.**
This allows us to combine results by grouping records based on their values and calculating totals or averages.

Let's go to the `surveys` table and find out how many entries there are.

```sql
SELECT count(*)
  FROM surveys;
```

The `count()` function counts the number of rows that appear in the result.
Here, we don't need to supply any particular column name if we just want to count the number of rows that appear; thus, the wildcard is the shortest way to write this query.

We can find out the overall population; here, the number of people who have been on Earth since 1952.

```sql
SELECT count(*), sum(pop)
  FROM surveys;
```

Let's output this value in millions of people, rounded to three decimal places.

```sql
SELECT round(sum(pop)/1000000.0, 3)
  FROM surveys;
```

There are many other aggregation functions available in SQL.

* `avg()``
* `first()`
* `last()`
* `max()`
* `min()`
* `sum()`

Let's use one query to output the average population, the minimum and maximum population.

```sql
SELECT avg(pop), min(pop), max(pop)
  FROM surveys;
```

**This isn't very meaningful, however, aggregating across countries.**
We can use a `GROUP BY` clause to aggregate within groups.

```sql
SELECT country, avg(pop), min(pop), max(pop)
  FROM surveys
 GROUP BY country;
```

What happens if we add the `year` column to this query?

```sql
SELECT country, year, avg(pop), min(pop), max(pop)
  FROM surveys
 GROUP BY country;
```

**The `year` columns' values seem like they're randomly picked. In fact, that's pretty much the case.**
We've aggregated by country so the data are summarized across years; there is no longer a meaning to `year` in the results of this query.
We shouldn't have been allowed to include the `year` column in this query.

**Actually, this is non-standard behavior for SQLite and MySQL, another database management system. Any other database management system would not have allowed us to run this query; it would have thrown an error instead.**
Even though SQLite and MySQL allow this, we should avoid this behavior because it leads to meaningless columns in the output.
When using `GROUP BY`, every field in our `SELECT` statement should either by in the `GROUP BY` statement or should be called with an aggregation function.

### Ordering Aggregates

We can also order the aggregated rows in the output.

```sql
SELECT continent, count(*)
  FROM countries
 GROUP BY continent
 ORDER BY count(continent);
```

Note that this is the same as:

```sql
SELECT continent, count(*) AS total
  FROM countries
 GROUP BY continent
 ORDER BY total;
```

#### Challenge: Aggregation

Let's go back to the `surveys` table.
Write queries that return:

* How many countries were counted in each year?
* Average `gdpPercap` of each country?

### Joins

To combine data from two tables we can use a `JOIN` clause, which comes after the `FROM` clause.
We also need to tell the computer which columns provide the link between the two tables using the word `ON`.
**The intent here is to combine the data in the `countries` table with the data in the `surveys` table.**
What we want is to join the data with the same country name.

```sql
SELECT *
  FROM surveys
  JOIN countries
    ON surveys.country = countries.country;
```

`ON` is like `WHERE`; it filters things out according to a test condition.
We use the `table.colname` format to distinguish the columns in each table.

```sql
SELECT countries.continent, surveys.country, surveys.lifeExp
 FROM surveys
 JOIN countries
   ON surveys.country = countries.country;
```

#### Challenge: Joins and Aggregation

Write a query that returns the continent, the average life expectancy and the maximum population for each continent.
**Bonus:** Do this just for the year 1952 then for the year 2007.

### Aggregation and the Order of Operations

Let's examine the answer to the challenge question above.

```sql
SELECT countries.continent,
       avg(surveys.lifeExp), max(surveys.pop)
  FROM surveys
  JOIN countries
    ON surveys.country = countries.country
 WHERE surveys.year = 1952
 GROUP BY countries.continent;
```

**It's important that we understand how this query is processed by the database.**
We know that the `WHERE` clause is one of the first things the database manager evaluates.
However, we've included a `JOIN` statement here.
Are we able to filter on joined columns?
Let's modify the previous query so that we're aggregating across countries for a single continent in each year.

```sql
SELECT surveys.year, avg(surveys.lifeExp)
  FROM surveys
  JOIN countries
    ON surveys.country = countries.country
 WHERE countries.continent = 'Americas'
 GROUP BY surveys.year;
```

Since this worked, we can conclude that the database manager evaluates the `JOIN` before it evaluates the `WHERE` clause.
Thus, the order of operations in this query is:

- `JOIN` the tables together `ON` the matching columns;
- Filter entries according to the `WHERE` condition;
- `SELECT` the specified columns `FROM` the table and its joined tables;
- Finally, `GROUP` the results `BY` the unique values of a specified column.

### Different Kinds of Joins

There are multiple ways of joining two (or more) tables together with `JOIN`.
[See this graphic](https://commons.wikimedia.org/wiki/File:SQL_Joins.svg) for an illustration of what's possible with SQL `JOIN`.

### Aliases

**As queries get more complex, table and column names can get long and unwieldy. Just as we saw with column names, we can use aliases to assign new names to tables.**

We can alias table names, as in this example.

```sql
SELECT s.year, s.country
  FROM surveys AS s
  JOIN countries AS co
    ON s.country = co.country;
```

### Filtering on Aggregates

We've now seen how a `WHERE` clause can be used to filter the results according to some criteria.
**Yet the `GROUP BY` clause is executed after the `WHERE` clause is executed. Instead of `WHERE`, we can filter aggregated results with a `HAVING` clause.**
For instance, we can find those countries with the highest life expectancy at any time with the following country.

```sql
SELECT country, max(lifeExp) AS max_life_exp
  FROM surveys
 GROUP BY country
HAVING max_life_exp > 80;
```

**Note that while the `WHERE` clause comes before the `GROUP BY` clause, the `HAVING` clause comes after. One way to think about this is: the data are filtered (`WHERE`), some columns are retrieved (`SELECT`), then summarized in groups (`GROUP BY`); finally, we only select some of these groups (`HAVING`).**

## Saving Queries

It is not uncommon to repeat the same operation more than once, for example for monitoring or reporting purposes.
SQL comes with a very powerful mechanism to do this: views.
**Views are a form of query that is saved in the database, and can be used to look at, filter, and even update information.**
One way to think of views is as a table, that can read, aggregate, and filter information from several places before showing it to you.

To create a View in SQLite Manager: at the top menu, click **View** then **Create View.**
**A better way to create a View is using SQL.**

```sql
CREATE VIEW maximum_life_expectancies AS
SELECT country, max(lifeExp) AS max_life_exp
  FROM surveys
 GROUP BY country
 ORDER BY max_life_exp;
```

Having done this, we can now access the results of this query with a much shorter query:

```sql
SELECT *
  FROM maximum_life_expectancies;
```

In SQLite Manager, we can remind ourselves of how we wrote this query by looking at the tree view on the left, expanding the **Views** tree, right-clicking on the view **maximum_life_expectancies**, and clicking **"Modify View"** in the menu.

**When we save a View, the results of the query are not saved; the query is re-run each time we select from that view.**
If the query takes a long time to run, we might want to store the output as a table.
We can store the result of our query as a table using a `CREATE TABLE` clause.

```sql
CREATE TABLE new_table AS
SELECT *
  FROM maximum_life_expectancies;
```

SQLite doesn't support doing this with the `INTO` keyword but other databases, such as PostgreSQL, allow this usage:

```sql
-- Not for SQLite
SELECT *
  INTO new_table
  FROM maximum_life_expectancies;
```

Unless the query takes a long time to run, we are better off staying with a View because it doesn't storing the table on the hard drive.
To get rid of a view or table:

```sql
DROP VIEW maximum_life_expectancies;
DROP TABLE new_table;
```

**We can export the results of our query** by clicking **Actions** -> **Save Result (CSV) to File.**

## Combining Queries

What if we need to combine the results of two queries?
For instance, what if we knew there was a systematic error in the population estimates prior to 1967?

```sql
SELECT country, year, pop + 1000
  FROM surveys
 WHERE year < 1967
```

How do we combine the records from these years with the records from later years?
We only want to apply the population adjustment to the records from before 1967.

```sql
SELECT country, year, pop + 1000 AS pop
  FROM surveys
 WHERE year < 1967
UNION
SELECT country, year, pop
  FROM surveys
 WHERE year >= 1967
```

Some things to note:

* We can use `UNION` multiple times to combine, row-wise, as many queries as we want.
* Every query we combine in this way must have the same columns in the output.

## Connecting to SQL in R

```r
install.packages('RSQLite')
```

**Because the database manager provides all sorts of services for managing and protecting the integrity of our data, we don't open the database like a regular file. Instead, we open a connection to the database and use this connection to issue commands to the database manager.**

```r
library(RSQLite)
conn <- dbConnect(SQLite(), dbname='/Users/arthur/Desktop/gapminder.sqlite')
```

I've specified the file path to the SQLite database on my machine.
It may be different on your machine.
On Windows machines, the path to your Desktop may be:

```
C:\Users\<username>\Desktop
```

**Now, `conn` is a variable in R that represents our connection to the database.**
First, let's take a look at what tables are available in this database.

```r
tables <- dbListTables(conn)
tables
```

Note that the result is an R character vector.

```r
class(tables)
```

Now, we can issue SQL commands to the database from the R environment.
The advantage of doing this in R is that, just like in the last example, the results of our queries will be in the form of R data types.
We can then take everything we've learned about data analysis in R and apply it to the data stored in our database.

```r
countries <- dbGetQuery(conn, 'SELECT * FROM countries')
head(countries)
```

**Note that the result of our query is, specifically, a `data.frame`.**

```r
class(countries)
```

Let's make another query.
When we have a data frame in R we can get quick summary statistics with the `summary()` function.

```r
surveys <- dbGetQuery(conn, 'SELECT * FROM surveys')
summary(surveys)
```

### Challenge: Reproducing our Aggregation in R

Let's see if we can do that same aggregation we were trying before with this dataset.

```r
output <- dbGetQuery(conn, 'SELECT country, avg(gdpPercap) AS mean_gdp_per_capita, max(lifeExp) - min(lifeExp) AS life_exp_change FROM surveys GROUP BY country;')
head(output)
```

### Disconnecting from the Database

It's important to realize that the data frame representation of our SQL table is just a copy of the data from the database.
We can safely make any changes we want to the data frame without affecting our data in the database.
Moreover, once we have pulled our data from the database and have no need for running further queries, we should close our connection to the database.
We should do this before running any analysis on our data.

```r
dbDisconnect(conn)
rm(conn)
```

## Advanced Challenges

Recall the questions we asked at the beginning.

* What is the average life expectancy since 2000 of each of the top 10 countries ordered by per capita GDP?
* What is the average life expectancy since 2000 across each continent?

### Challenge: Life Expectancy, Top 10 Countries by GDP

**What is the average life expectancy since 2000 of each of the top 10 countries ordered by average per capita GDP?**

```sql
SELECT country, avg(lifeExp), avg(gdpPercap) AS avg_percap_gdp
  FROM surveys
 WHERE year >= 2000
 GROUP BY country
 ORDER BY avg_percap_gdp DESC
 LIMIT 10;
```

Here, I've introducted the `LIMIT` clause, which isn't required to answer this question but can make the results easier to read.
What happens if we `ORDER BY gdpPercap` instead of the above?
Why is this distinction important?

### Challenge: Average Life Expectancy across Continents

**What is the average life expectancy since 2000 across each continent?**

```sql
SELECT c.continent, avg(s.lifeExp)
  FROM surveys AS s
  JOIN countries AS c ON s.country = c.country
 WHERE s.year >= 2000
 GROUP BY continent
```

## Conclusion and Summary

### Other Resources

* On correct aggregation: [Do you use GROUP BY correctly?](https://www.psce.com/blog/2012/05/15/mysql-mistakes-do-you-use-group-by-correctly/)
* The best book on SQL is [SQL: Visual Quickstart Guide (by Chris Fehily, 3rd Edition)](http://www.fehily.com/books/sql_vqs_3.html)
