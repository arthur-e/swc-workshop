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

## Sorting and Removing Duplicates

Let's answer some real questions about this dataset.
**For starters, what kind of animals (what taxa) were collected in these surveys?**

    sqlite> SELECT taxa FROM species;

**What's the problem with this result?**

    sqlite> SELECT DISTINCT taxa FROM species;

We can use this insight to answer another question.
**In what years were surveys conducted?**

    sqlite> SELECT DISTINCT year FROM surveys;

We can use the keyword `DISTINCT` with two columns in order to return all unique pairs.

    sqlite SELECT DISTINCT year, species_id FROM surveys;
