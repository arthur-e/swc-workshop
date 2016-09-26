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
- The word `FROM` tells the database manager which table we want to retrieve those rows from. It's followed by the name of that table, which here is `surveys`.
- The words `genus` and `species` are the names of two of the columns in the `surveys` table. Column names follow the `SELECT` statement, indicating that those are the only columns we want to see in the output.
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
    -- There are 3 Dipodomys species in the area
       AND species_id IN ('DM', 'DO', 'DS');

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
