# Databases and SQL

## Background

There are three common options for storing data:

- Text files
- Spreadsheets
- Databases

Text files are the easiest to create and work well with version control.
We even saw how we could organize and search them in the Unix shell but we had to build the tools for even moderately complex analyses ourselves.
Spreadsheets are good for doing analysis but they don't handle large or complex datasets well.
**Databases, however, include powerful tools for search and analysis and are capable of handling large, complex datasets.**

- **A relational database is a way to store and manipulate information.**
- Databases are arranged as tables.
- Each table has columns (also known as fields) that describe the data, and rows (also known as records) which contain the data.

When we are using a spreadsheet, we put formulas into cells to calculate new values based on old ones.
When we are using a database, we send commands (usually called queries) to a database manager: a program that manipulates the database for us.
**This is analogous to what we saw with the Unix shell.**
Here, the database manager reads the user's command, retrieves and manipulates data from the database according to what the user asked for, and returns it for display.

**Why would we use a relational database?**

* It separates our data from our analysis. Recall how this builds on best practices: treating the data as read-only; treating our results as disposable and generating them from scripts. This way, there is no risk of accidentally changing data when analyzing it.
* Databases are fast for large amounts of data; much faster than many programming environments including R.
* We improve the quality control of data entry through the use of data type checking and constraints. Everyone who reads from the database gets the same information. When the database is updated, everyone has access to those updates immediately.
* Furthermore, the concepts of relational database queries are core to understanding more advanced features in R and high-performance computing environments for working with big datasets.

## The Data

The data we will be using is a time-series for a small mammal community in southern Arizona.
This is part of a project studying the effects of rodents and ants on the plant community that has been running for almost 40 years.
The rodents are sampled on a series of 24 plots, with different experimental manipulations controlling which rodents are allowed to access which plots.

## Getting Started

    $ sqlite3 survey.sqlite

**We'll first change some settings in SQLite3 to improve the display of our data.**

    sqlite> .mode column
    sqlite> .header on

**What do we call the word "sqlite" and with the greater-than symbol at the beginning of each line?**
This is the "prompt" in SQLite3, which performs the same role as the dollar sign in the Unix shell.

Let's check to see what tables are in the database.

    sqlite> .tables

- The `plots` table has a row for each of the 24 plots.
- The `species` table has a row for each kind of species encountered in the dataset.
- The `surveys` table is the longest; it has a row for each survey that is conducted.

### Our First Query

Let's write a query to find out which species are represented in the survey data.

    sqlite> SELECT genus, species FROM species;

**What happened? Let's go to the whiteboard for this.**

- The word `SELECT` here is the most common command we see in SQL. It tells the database manager we want to retrieve some rows.
- The word `FROM` tells the database manager which table we want to retrieve those rows from. It's followed by the name of that table, which here is `species`.
- The words `genus` and `species` are the names of two of the columns in the `species` table. Column names follow the `SELECT` statement, indicating that those are the only columns we want to see in the output.
- The words `SELECT` and `FROM` are capitalized here by convention; it's not required to capitalize them but it helps make your code more readable which is very important.

**Throughout today's lesson I will be typing SQL commands in all capitals and the names of columns in lowercase to help you distinguish them from the names of tables and columns in the data. I encourage you to try to do the same but you can type these commands however you want; they'll work just the same.**

    sqlite> select genus, species from species;

**Finally, the semicolon.**
The semicolon is very import in SQL.
It tells the database manager that the command we're typing is finished.
More than once today, you might find yourself typing a command like so...

    sqlite> SELECT genus, species FROM species;

**And you hit Enter (or Return), forgetting the semicolon!**
When that happens, you're going to see `...>` instead of the usual SQLite3 prompt.
That's okay!
SQLite3 is telling you that it's waiting for more commands.
**If you're finished with your command and you intended to type a semicolon, just type one now and hit Enter (or Return).**
SQLite3 doesn't care how many lines your command uses.

### The SELECT Statement

**Let's get more familiar with the SELECT command.**
We can re-order the columns in the output simply by swapping their order in our query.

    sqlite> SELECT species, genus FROM species;

One thing that's neat about SQL, compared to other languages like R or Python, is that SQL is **declarative.**
**That means that in SQL, we tell the computer what we want to happen, not how to do it.**

For example, with the `SELECT` command, I tell the computer what columns I want to see from the `surveys` table, **I don't tell it how to retrieve or display the data, only what I want to see.**

As a shortcut, we can select all of the columns from a table using the wildcard:

    sqlite> SELECT * FROM species;

### Challenge: Selecting a Column

**Write a query to select the `plot_type` column from the `plots` table.**

## Removing Duplicates

Let's answer some real questions about this dataset.
**For starters, what kind of animals (what taxa) were collected in these surveys?**

    sqlite> SELECT taxa FROM species;

**What's the problem with this result?**

    sqlite> SELECT DISTINCT taxa FROM species;

Here, the results are returned in the order in which they appear in the table.
**It's important to realize that the database manager doesn't return rows in a predictable order.**
We'll see later on how we need to factor that into our construction of more complex queries.
For now, you should know if we want to specify the order of rows in the output, we need to use the `ORDER BY` clause.
**For instance, if we want to sort the results alphabetically by taxa, we would write:**

    sqlite> SELECT DISTINCT taxa FROM species ORDER BY taxa;

For descending order, we add `DESC` after the column name.

    sqlite> SELECT DISTINCT taxa FROM species ORDER BY taxa DESC;

By default, the output is in ascending order.
That means there is an implicit `ASC` key after each column name in the `ORDER BY` clause.

    sqlite> SELECT DISTINCT taxa FROM species ORDER BY taxa ASC;

We can order by multiple columns.
**For instance, we can sort the species list first by taxa and then by genus name within each taxonomical group.**

    sqlite> SELECT DISTINCT taxa, genus FROM species ORDER BY taxa, genus;

**Note that we don't actually have to display a column to order by it.**

    sqlite> SELECT DISTINCT genus FROM species ORDER BY taxa, genus;

Let's answer another question: **In what years were surveys conducted?**

    sqlite> SELECT DISTINCT year FROM surveys;

We can use the keyword `DISTINCT` with two columns in order to return all unique pairs.

    sqlite> SELECT DISTINCT year, species_id FROM surveys;

## Calculating New Values

In addition to selecting columns that already exist in our table, we can calculate values in a new column as part of our queries.
**Let's say, for instance, that we want to look at the animal weights on different days in units of kilograms instead of grams.**

    SELECT year, month, day, weight / 1000.0
      FROM surveys;

When we run the query, the expression `weight / 1000.0` is evaluated for each row and appended to that row, in a new column.
**Why did I write one-thousand as `1000.0` instead of `1000`?**

    SELECT year, month, day, weight / 1000
      FROM surveys;

Expressions can use any fields, any arithmetic operators `(+, -, *, and /)` and a variety of built-in functions.
**For example, we could round the values to make them easier to read.**

    SELECT plot_id, species_id, sex, weight, round(weight / 1000.0, 2)
      FROM surveys;

### Challenge: Changing the Units

Write a query that returns the `year`, `month`, `day`, `species_id` and `weight` in milligrams.
Remember that the units stored in the database are grams.

## Filtering

**One of the most powerful features of a database is the ability to filter data, i.e., to select only those records that match certain criteria.**
For example, let's say we only want data for the species *Dipodomys merriami*, which has a species code of `DM`.
We need to add a `WHERE` clause to our query:

    SELECT * FROM surveys
     WHERE species_id = 'DM';

**The database manager executes this query in two stages.**

- First, it checks at each row in the `surveys` table to see which ones satisfy the `WHERE` clause.
- It then uses the column names following the `SELECT` keyword to determine which columns to display.

This processing order means that we can filter records using WHERE based on values in columns that aren't then displayed.
Here, we select all the weight measurements since 2000.

    SELECT species_id, weight FROM surveys
     WHERE year >= 2000;

If we want to combine the last two queries, we can use the keywords `AND` and `OR`.

    SELECT * FROM surveys
     WHERE (year >= 2000) AND (species_id = 'DM');

**Note that while the parentheses are not needed here, they make our queries much easier to read. Also, when we use `AND` and `OR` together they do become necessary to ensure that the database manager combines the conditional statements in the way we intended.**

### Challenge: Filtering

Write a query that returns the `day`, `month`, `year`, `species_id`, and `weight` (in kilograms) for individuals caught in Plot 1 that weigh more than 75 grams.

## Building More Complex Queries

**Let's say we want to select the records for all *Diopodomys* species.**
We could write the query this way...

    SELECT * FROM surveys
     WHERE (year >= 2000) AND (species_id = 'DO' OR species_id = 'DM' OR species_id = 'DS');

However, this is pretty tedious, and tedium is what we're trying to avoid by using computers!

    SELECT * FROM surveys
     WHERE (year >= 2000) AND (species_id IN ('DM', 'DO', 'DS'));

**In this case, because all the species IDs start with the same letter, we can also filter by partial matches using the wildcard character.**
When we use partial matching, we have to use the `LIKE` keyword.

    SELECT * FROM surveys
     WHERE (year >= 2000) AND (species_id LIKE 'D%');

**As we begin to build more complex queries, it's best to...**

- Start with something simple;
- Then add more clauses one by one;
- Testing their effects as we go along.

For complex queries, this is a good strategy, to make sure you are getting what you want.
Sometimes it might help to take a subset of the data that you can easily see in a temporary database to practice your queries on before working on a larger or more complicated database.

**When the queries become more complex, it can be useful to add comments.**
In SQL, comments are started by `--`, and end at the end of the line.

    -- Get post-2000 data on Dipodomys' species
    SELECT * FROM surveys
     WHERE year >= 2000
    -- All of Dipodomys' species IDs and no others begin with the letter D
       AND (species_id LIKE 'D%');

### Challenge: Putting it All Together

Let's try to combine what we've learned so far in a single query.
Using the `surveys` table write a query to display the three date fields, `species_id`, and `weight` in kilograms (rounded to two decimal places) for individuals captured in 1999, ordered alphabetically by the `species_id`.

    SELECT year, month, day, species_id, round(weight / 1000.0, 2)
      FROM surveys
     WHERE year = 1999
     ORDER BY species_id;

**It's important we understand the order in which the database manager executes these statements.**

1. Filtering rows according to `WHERE`;
2. Sorting results according to `ORDER BY`;
3. Displaying requested columns or expressions.

## Missing Data

Real-world data are never complete--there are always holes.
**Databases represent these holes using a special value called `NULL`.**
`NULL` is not zero, `NULL` is not False, and `NULL` is not the emptry string; it is a one-of-a-king value that means "nothing here."
Dealing with `NULL` requires a few special tricks and some careful thinking.

To start, let's look at the first 10 rows in the `surveys` table.
**We can use the `LIMIT` keyword to limit our results to the given number of rows.**

    SELECT *
      FROM surveys LIMIT 10;

It appears that the record with `record_id` equal to 7 is missing a `hindfoot_length` or, rather, the hindfoot length is `NULL`.
`NULL` doesn't behave like other values.
**How might we try to find other records like this where the `hindfoot_length` column is null?**

    SELECT * FROM surveys WHERE hindfoot_length = NULL;
    SELECT * FROM surveys WHERE hindfoot_length != NULL;
    SELECT 2 = 2;
    SELECT 2 = 3;
    SELECT 2 = NULL;
    SELECT NULL = NULL;

It turns out, we need a special test for `NULL`.

    SELECT *
      FROM surveys
     WHERE year = 1977 AND hindfoot_length IS NULL;

    SELECT *
      FROM surveys
     WHERE year = 1977 AND hindfoot_length IS NOT NULL;

`NULL` can make trouble for some of queries.
Suppose we want to see all the records in 1977 but exclude those of a certain species.

    SELECT *
      FROM surveys
     WHERE year = 1977 AND species_id NOT LIKE 'D%';

**What we don't get in this query are all those records where `species_id` is `NULL`.**
To get those records, we need to add another condition.

    SELECT *
      FROM surveys
     WHERE year = 1977 AND (species_id NOT LIKE 'D%' OR species_id IS NULL);

Similarly, what is wrong with the following query?

    SELECT * FROM surveys WHERE species_id IN ('OX', NULL);

## Aggregation

**Aggregation allows us to combine results by grouping records based on value and calculating combined values in groups.**
Let's go to the surveys table and find out how many individuals there are.
Using the wildcard simply counts the number of records (rows).

    SELECT count(*) FROM surveys;

We can also calculate the total weight of all those individuals!

    SELECT count(*), sum(weight)
      FROM surveys;

There are other aggregation functions that allow us to compute summary statistics.

    SELECT min(weight), max(weight), avg(weight)
      FROM surveys;

These numbers may be useful for validating or exploring our data; for instance, is the maximum weight 99 a real weight here?
It's also kind of neat to think about the total weight or biomass that has entered this survey.
But these numbers aren't very meaningful scientifically because they span so many survey years and so many dissimilar species.
**If we want to aggregate within groups, such as within years or within species, we can add a `GROUP BY` clause to our query.**

    SELECT species_id, count(species_id)
      FROM surveys
     GROUP BY species_id;

`GROUP BY` tells SQL what field or fields we want to use to aggregate the data.
**If we want to group by multiple fields, we give `GROUP BY` a comma-separated list.**

    SELECT species_id, sex, count(species_id)
      FROM surveys
     GROUP BY species_id, sex;

### Challenge: Aggregation

Write queries that return:

- How many individuals of each species were counted in each year?
- What is the average weight of each species in each year?

Can you modify the above queries combining them into one?

### Care in Aggregation

Let's say we want to find out the average weight of species `OT` in each year and we write a query like this.

    SELECT species_id, year, sex, avg(weight)
      FROM surveys
     WHERE species_id = 'OT'
     GROUP BY year;

**We absent-mindedly included the `sex` column, maybe because we were typing quickly and we also wanted to group within the sexes, but we forgot to include the `sex` column in the `GROUP BY` clause.**

- What does the `sex` column mean in the context of this query?
- Why is it populated?

When the `GROUP BY` clause is processed by the database manager, it groups the records that correspond to the groups we defined.
Then, the database manager has to figure out what values should appear in each column for each group.
In the `SELECT` clause we specified:

- `species_id`: This is easy because of our `WHERE` clause: there is only one value to choose from.
- `year`: This is also easy, because we grouped by this column; there should be one unique value in this column for each output row.
- `avg(weight)`: Here, the database manager takes the mean of each group of weights for each year.

**The problem is that the database manager wasn't told how to aggregate the `sex` field.**
When SQLite is asked to aggregate a field but isn't told how to do so, it choose an actual value that appears in the input set of values more or less at random.
For instance, if we see an `M` in the `sex` field in 1978, this could be because only males were capture in this year, because the first value in the set of `sex` values was `M`, or for entirely different reason.

**It's very important for you to know that this is non-standard behavior and will not work in all database management systems.**
If you use PostgreSQL, for instance, you will get an error.
PostgreSQL will not process this query, it will give you an error to the effect that the `sex` column is not included in an aggregation function nor in a `GROUP BY` clause.
**Personally, I like getting this error message because, in such a case, I have done something wrong. It's meaningless to interpret a non-aggregated column like `sex` when other columns have been aggregated.**

    SELECT species_id, year, sex, avg(weight)
      FROM surveys
     WHERE species_id = 'OT'
     GROUP BY year;

### Filtering on Aggregates

**We've seen how we can use a `WHERE` clause to filter records based on some criteria.**
**What if we wanted to filter aggregated records?**
For instance, we might want to find those species that appear in the surveys more than 10 times.

    SELECT species_id, count(species_id) AS total
      FROM surveys
     WHERE total > 10
     GROUP BY species_id;

**Why doesn't this work?**
Recall the order of database operations.

**We need to introduce the `HAVING` clause for this kind of aggregation.**

    SELECT species_id, count(species_id) AS total
      FROM surveys
     GROUP BY species_id
    HAVING total > 10;

We can, however, use the `ORDER BY` clause in the same way we've been using it.

    SELECT species_id, count(species_id) AS total
      FROM surveys
     GROUP BY species_id
    HAVING total > 10
     ORDER BY total DESC;

### Challenge: Filtering on Aggregates

Write a query that returns, from the `species` table, the number of genera (`genus`) in each `taxa`, only for the `taxa` with more than 10 genera.

## Saving Queries

We've learned how to do some interesting analyses inside our database.
It's not uncommon that we would want to run the same analysis more than once, for monitoring or reporting purposes, as two examples.
SQL databases come with a powerful tool to help us save our queries for later re-use.
**Views are a form of query that is saved in the database, and can be used to look at, filter, and even update information.**
We can think of Views as Tables; they are also called Table Views.
We can read, aggregate, and filter information from several tables using a single View.

For example, let's say we wanted to look at the all the data from the northern hemisphere's summer of 2000.

    SELECT *
      FROM surveys
     WHERE year = 2000 AND (month > 4 AND month < 10);

To save the results of this query as a view:

    CREATE VIEW summer_2000 AS
    SELECT *
      FROM surveys
     WHERE year = 2000 AND (month > 4 AND month < 10);

Now, we can retrieve the results of that query anytime as:

    SELECT * FROM summer_2000;

If we want to get rid of the View, for whatever reason, we can:

    DROP VIEW summer_2000;

## Combining Data

**Take a look at your handout.**
What are some of the disadvantages of the "combined" format?

- We have redundant information in the table; a given `genus` will always have the same `taxa` and, generally, a given `species` will have the same `genus` and `taxa`. For large tables, this could require a lot more disk space.
- Moreover, if we realize that the `plot_type` of a group of surveys on a particular date is wrong, we have to change multiple records in the database. What's worse, we may have to guess which records to change, since other plot types may have been used on that same date.
- Let's say `record_id` 4 was the only record with a Rodent Exclosure. If there was something wrong with the record other than the `plot_type` and we decided to delete it, then the fact that we had ever used a Rodent Exclosure, or that Rodent Exclosure was a valid `plot_type`, is also gone from our database; that is, we lose more information than just the measurement itself.

**Relational layouts solve these problems. Take a look at the relational layout on the backside of your handout.**
One apparent disadvantage of a relational layout is that sometimes we will want to see information from multiple tables displayed together.

To combine data from two or more tables, relational databases like SQLite  use a `JOIN` clause, which comes after the `FROM` clause.
We also need to tell the database management system which columns provide the link between the two tables using the word `ON`.

    SELECT *
      FROM surveys
      JOIN species
        ON surveys.species_id = species.species_id
     LIMIT 5;

`ON` is like `WHERE`; it filters things out according to a test condition.
We use the `table.colname` format to distinguish the columns in each table.

    SELECT species.genus, species.species, surveys.sex
      FROM surveys
      JOIN species
        ON surveys.species_id = species.species_id
     LIMIT 5;

**With this join, every value of the `species_id` field from one table is compared to every value in the `species_id` field of the other table. Only those records where the value matches are returned.**
This is called a "many-to-many" mapping.
Because there is only 1 record in the `species` table for each unique value of `species_id`, the result of joining this table to `surveys` is a table with the same number of rows as the `surveys` table (35,549 rows).
If there were 2 records in the `species` table for each `species_id` in the `surveys` table, we'd have twice as many rows.

### Challenge: Joins and Aggregation

Write a query that returns the genus, the average weight, and the average hindfoot length for every genus.

### Aggregation and the Order of Operations

Let's examine the answer to the challenge question above.

    SELECT species.genus, avg(surveys.weight), avg(surveys.hindfoot_length)
      FROM surveys
      JOIN species
        ON surveys.species_id = species.species_id
     GROUP BY species.genus;

**It's important that we understand how this query is processed by the database.**
We know that the `WHERE` clause is one of the first things the database manager evaluates.
However, we've included a `JOIN` statement here.
**Are we able to filter on joined columns?**
Let's modify the previous query so that we're aggregating across genera for a single taxa.

    SELECT species.genus, avg(surveys.weight), avg(surveys.hindfoot_length)
      FROM surveys
      JOIN species
        ON surveys.species_id = species.species_id
     WHERE species.taxa = 'Rodent'
     GROUP BY species.genus;

Since this worked, we can conclude that the database manager evaluates the `JOIN` before it evaluates the `WHERE` clause.
Thus, the order of operations in this query is:

- `JOIN` the tables together `ON` the matching columns;
- Filter entries according to the `WHERE` condition;
- `SELECT` the specified columns in the table and its joined tables;
- Finally, `GROUP` the results `BY` the unique values of a specified column.

### Different Kinds of Joins

There are multiple ways of joining two (or more) tables together with `JOIN`.
[See this graphic](https://commons.wikimedia.org/wiki/File:SQL_Joins.svg) for an illustration of what's possible with SQL `JOIN`.

### Aliases

**As queries get more complex, table and column names can get long and unwieldy. Just as we saw with column names, we can use aliases to assign new names to tables.**

We can alias table names, as in this example.

    SELECT s.species_id, pl.plot_type
      FROM surveys AS s
      JOIN plots AS pl
        ON s.plot_id = pl.plot_id
     LIMIT 5;

## Connecting to SQL in R

```r
install.packages('RSQLite')
```

**Because the database manager provides all sorts of services for managing and protecting the integrity of our data, we don't open the database like a regular file. Instead, we open a connection to the database and use this connection to issue commands to the database manager.**

```r
library(RSQLite)
conn <- dbConnect(SQLite(), dbname='/Users/arthur/Desktop/survey.sqlite')
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
species <- dbGetQuery(conn, 'SELECT * FROM species')
head(species)
```

**Note that the result of our query is, specifically, a `data.frame`.**

```r
class(species)
```

Let's make another query.
When we have a data frame in R we can get quick summary statistics with the `summary()` function.

```r
surveys <- dbGetQuery(conn, 'SELECT * FROM surveys')
summary(surveys)
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

## Conclusion and Summary

### Other Resources

* On correct aggregation: [Do you use GROUP BY correctly?](https://www.psce.com/blog/2012/05/15/mysql-mistakes-do-you-use-group-by-correctly/)
* The best book on SQL is [SQL: Visual Quickstart Guide (by Chris Fehily, 3rd Edition)](http://www.fehily.com/books/sql_vqs_3.html)
