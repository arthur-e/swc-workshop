# Databases and SQL

## Goal and Objectives

<!--TODO

In order to answer the questions described above, we’ll need to do the following basic data operations:

    select subsets of the data (rows and columns)
    group subsets of data
    do math and other calculations
    combine data across spreadsheets

In addition, we don’t want to do this manually! Instead of searching for the right pieces of data ourselves, or clicking between spreadsheets, or manually sorting columns, we want to make the computer do the work.

In particular, we want to use a tool where it’s easy to repeat our analysis in case our data changes. We also want to do all this searching without actually modifying our source data.

Putting our data into a database and using SQL will help us achieve these goals.

-->

## Background

There are three common options for storing data:

* Text files
* Spreadsheets
* Databases

Text files are the easiest to create and work well with version control.
Spreadsheets and spreadsheet programs like Microsoft Excel are good for doing analysis but they don't handle large or complex datasets well.
**Databases, however, include powerful tools for search and analysis and are capable of handling large, complex datasets.**

<!--TODO Short description of today's data-->

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
3. SQLite3 manages databases that are stored as single files on a computer's file system. So, after we click **OK** we'll be prompted to save the database as a file. **Save it to your Desktop.**
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

**The `WHERE` keyword in this query specifies a condition which each record must match in order for it to be included in the results.**
Since the `year` column is just an integer, if we want to get only the data since the year 2000, we can write a condition that tests for `year` greater-than-or-equal-to 2000.

```sql
SELECT * FROM surveys WHERE year >= 2000;
```

How could we combine the last two queries?

```sql
SELECT * FROM surveys WHERE country="Iceland" AND year >= 2000;
```

As we continue to add conditions, we might want to add parentheses to make our query more readable.
For instance, if we wanted to get data for three countries instead of just for Iceland...

```sql
SELECT * FROM surveys WHERE (country = "Iceland") OR (country = "Madagascar") OR (country = "Dominican Republic");
```

### Challenge: Effective Filtering

Write a query that returns the country, year, life expectancy and population in thousands of people for any record with a life expectancy greater than 70.
* How many records are there? **(493)**
* How many records are there if you change lifeExp to 75? **(173)**

Write a query that returns the country, year, life expectancy and population in thousands of people for any record with a life expectancy greater than 70 and before 1990.
* How many records are there? **(216)**
* How many records are there if you just look at the year 1952? **(5)**
* How many records are there if you just look at the year 2007? **(83)**
