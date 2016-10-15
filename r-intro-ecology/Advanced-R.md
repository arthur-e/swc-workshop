# Advanced R Programming for Data Analysis

Some of the material is repurposed from [the Data Carpentry lesson on Ecology](http://www.datacarpentry.org/R-ecology-lesson/02-starting-with-data.html), which is released under an open license.

## Overview

The goal of this lesson is to orient intermediate R programmers and experienced programmers from other languages how to analyze data in R.
R is commonly used in many scientific disciplines for statistical analysis.
This workshop will focus on R as a general purpose programming language and data analysis tool, not on any specific statistical analysis.

**It's always a challenge to balance the pace of this lesson.**

- Some of you are new to R and other may have been using R for some time.
- As always, if you feel that I'm moving too fast, please interrupt me with your questions!
- If you feel that I'm covering stuff you already know, please ask me questions that extend the topic.
- I might also present an example without explanation and, instead, ask one of you to explain what is happening. **If the answer seems obvious, please don't be offended!** Look at it as an opportunity to check your own understanding by figuring out how to explain a complex idea to others.

### Dependencies

You may want to make sure you have these packages install ahead of time.

```r
install.packages(c('dplyr', 'tidyr', 'ggplot2'))
```

## Contents

<!--TODO-->

## Introduction to RStudio

**RStudio is what we would call an interactive development environment, or IDE, for the R programming language.**
It is *interactive* because we can issue it commands in the R language and the program responds with output.
It is a *development environment* because we can use its features to develop scripts or programs in R that may consist of multiple R commands.

### RStudio Layout

**Open the RStudio program if you haven't already.**

* The interactive R console (left side of screen)
* Workspace and history (tabbed in upper right)
* Files/ Plots/ Packages/ Help (tabbed in lower right)

If we open a text file that contains an R program, what would we call an *R script,* a new pane would appear that displays the contents of that R script.
**R scripts are just plain text files but they have a \*.R file extension to indicate that the contents should be interpreted as R commands.**

### Workflow in RStudio

The basis of programming is that we write down instructions for the computer to follow and then we tell the computer to follow those instructions.
We call the instructions *commands* and we tell the computer to follow the instructions by *executing* or *running* those commands.

**Generally speaking, there are two ways we can execute commands in RStudio.**
One way is to use RStudio **interactively,** as I alluded to earlier.
That is, we can test R commands in the **R console** at the bottom right and maybe save those commands into an R script to run later.
This works just fine but it can be tedious and error-prone.
A better way would be for us to compose our R script in the file pane and then run the commands as a script or line-by-line.

To execute commands from the file pane in R, use the **Run** button at the top right.

![How to execute commands from the file pane in R.](./RStudio_run.png)

## Quick Overview of R

Let's quickly review programming in R so everyone's on the same page before we dive into more advanced topics.

### Data Types

There are five (5) atomic data types in R.
We can use the `typeof()` to determine the type of a data value.

```r
# Double-precision (decimal numbers)
typeof(3.14159)

# Integers
typeof(5)
typeof(5L)

# Character strings
typeof("Hello, world!")

# Logical (Boolean)
typeof(TRUE)

# Complex numbers
typeof(2+3i)
```

### Machine Precision

When performing numerical calculations in a programming environment like R, particularly when working with important quantities like money, it's important to be aware of how the computer represents decimal numbers.
For various reasons we won't go into, computers typically only approximate decimal numbers when they're stored.
If we don't guard against this, we may see some surprising results.
Numbers that seem to be equal may actually have different underlying representations and therefore be different by a small margin of error (called machine numeric tolerance).

```r
0.1 == 0.3 / 3
```

**In general, don't use `==` to compare numbers unless they are integers. Instead, use the all `all.equal` function.**

```r
all.equal(0.1, 0.3 / 3)
```

### Variables and Assignment

```r
x <- 1/2
```

Variable names in R can contain any letters, numbers, the underscore, or the period character.
R is probably the only programming language that allows you to use the period or dot character in a variable name.
For this reason, some R experts advise against using such variable names.

```r
x2 <- 3/4
my.parameter <- 'something'
my_parameter <- 'something else'
```

Using the right assignment operator is important.
**We may be tempted to use the `=` form because it is shorter, however, there are problems with mixing these two assignment operators, so it's best to get in the habit of using the arrow form for variable assignment.**
Plus, RStudio makes it easier to type this operator with a keyboard shortcut: [Alt] + [-].

### Functions

```r
pow10 <- function (value) {
  10^value
}

pow10(1)

# Using the return() function
pow10 <- function (value) {
  return(10^value)
}

pow10(1)

# Chaining function application
pow10(log10(100))
```

### Flow of Control

Note the difference between `in` keyword and `%in%` operator.

```r
for (i in 1:10) {
  if (i %in% c(1, 3, 5, 7, 9)) {
    print(i)
  } else {
    print(0)
  }
}
```

## Project Management with RStudio

The scientific process is naturally incremental and many projects start life as random notes, some code, then a manuscript, and, eventually, everything is a bit mixed together.

[Link to "bad layout" figure.](http://swcarpentry.github.io/r-novice-gapminder/fig/bad_layout.png)

**What's wrong with organizing a project like this?**

* It is really hard to tell which version of your data is the original and which is modified.
* We may have multiple versions of our results and, here, the results are mixed together making it difficult to tell them apart at a glance.
* It is difficult to relate the correct outputs, for example, a certain graph, to the exact code that has been used to generate it.

**A good project layout, on the other hand, can make your life easier in so many ways:**

* It will help ensure the integrity of your data.
* It makes it simpler to share your code with someone else.
* It allows you to easily upload your code when submitting a manuscript for publication.
* It makes it easier to pick the project back up after a break.

[Here's one example.](http://www.datacarpentry.org/R-ecology-lesson/img/R-ecology-work_dir_structure.png)

Use the `data/` folder to store your raw data and any intermediate datasets you may create.
For the sake of **transparency and scientific provenance**, you should always keep your raw data around.
Cleaning your data should be done with scripts that do not overwrite the original data.
Therefore, the "cleaned" data should be kept in something like `data_output`.

Here's another example layout suggested by Daniel Chen.

```
project_root/
  doc/     # directory for documentation, one subdirectory for manuscript
  data/    # data for storing fixed data sets
  src/     # any source code
  bin/     # any compiled binaries or scripts
  results/ # output for tracking computational experiments performed on data
    20160701/
    20160705/
    ...
```

With version control on either the project root or the `src` directories.
The `data`, `results`, and possibly the `bin` directories should be excluded from version control.

### How RStudio Helps

RStudio has project management built- in.
We'll use this today to create a self-contained, reproducible project.

**Challenge: Create a self-contained project in RStudio.**

1. Click the "File" menu button, then "New Project".
2. Click "New Directory".
3. Click "Empty Project".
4. Type in the name of the directory to store your 5. project, e.g. "my_project".
6. Make sure that the checkbox for "Create a git repository" is selected.
7. Click the "Create Project" button.

Now, when we start R in this project directory or when we open this project in RStudio, all of our work on this project will be entirely self-contained in this directory.

### Best Practices

There is no single right way to organize a project but there are important best practices to follow.

* **Treat data as read only:** This is probably the most important goal of setting up a project. Data is typically time consuming and/or expensive to collect. Working with the data interactively (e.g., in Microsoft Excel) where they can be modified means you are never sure of where the data came from or how it has been modified since collection. **In science, we call this the problem of scientific provenance; keeping track of where our data came from and what we did to it in order to get some important result.**
* **Data cleaning:** In many cases, your initial data will be "dirty." That is, it needs significant pre-processing in order to coerce it into a format that R will find useful. This task is sometimes called "data munging." I find it useful to store these scripts in a separate folder and to create a second read-only data folder to hold the "cleaned" data sets.
* **Treat generated output as disposable:** You should be able to regenerate all of your results from your R scripts. There are many ways to do this. I find it useful to have output folders with dates for names in `YYYYMMDD` format so that I can connect outputs to new developments in my research.

### Challenge: Saving the Data to a New Directory

Using RStudio's project management pane at the lower-right, create a new folder called `data` inside your project folder.
**Then, copy the `ecology.csv` file to the new `data` directory.**

## Starting with Data Structures

Let's load in some data.

```r
surveys <- read.csv('data/ecology.csv')
```

Typically, the first thing we want to do after reading in some data is to take a quick look at it to verify its integrity.

```r
head(surveys)
tail(surveys)
```

**The default data structure in R for tabular data is referred to as a data frame.**
It has rows and columns just like a spreadsheet or a table in a database.
A data frame is a collection of vectors of identical lengths.
Each vector represents a column, and each vector can be of a different data type (e.g., characters, integers, factors).

**In R, the columns of a data frame are represented as vectors.**
Vectors in R are a sequence of values with the same data type.
We can use the `c()` function to create new vectors.

```r
x1 <- c(1, 2, 3)
x2 <- c('a', 'b', 'c')
```

We can construct data frames as a collection of vectors using the `data.frame()` function.
Note that if we try to put unlike data types in a single vector, they get coerced to the most flexible data type.

```r
df <- data.frame(
  x1 = c(TRUE, FALSE, TRUE),
  x2 = c(1, 'red', 2))
```

A data structure in R that is very similar to vectors is the `list` class.
**Unlike vectors, lists can contain elements of varying data types and even varying classes.**

```r
list(99, TRUE 'balloons')
list(1:10, c(TRUE, FALSE))
```

A data frame is like a list in that it is a collection of multiple vectors, each with a different data type.
We can confirm this with the `str()` function.

```r
str(surveys)
```

We can ask R about data structures using the `class()` function.

```r
class(list())
class(surveys)
```

**R provides several ways to access the columns of a data frame.**
It's important to understand the differences between them and what they each return.

```r
class(surveys$year) # Returns a numeric vector
class(surveys['year']) # Returns a data frame
class(surveys[['year']]) # Returns a numeric vector
class(surveys[,4]) # Returns a numeric vector
```

### Challenge: Understanding Data Frames

Based on the output of the `str()` function, answer the following questions.

1. How many rows and columns are there in the data frame?
2. How many countries have been recorded in this data frame?
3. How many continents have been recorded in this data frame?

As you can see, many of the columns consist of integers, however, the columns `country` and `continent` are of a special class called `factor`.
Before we learn more about the `data.frame` class, let's talk about factors.

## Factors

Factors...

- Are used to represent categorical data;
- Can be ordered or unordered.

**Understanding them is necessary for statistical analysis and for plotting.**
Factors are stored as integers, and have labels associated with these unique integers.
While factors look (and often behave) like character vectors, they are actually integers under the hood, and you need to be careful when treating them like strings.

Once created, factors can only contain a pre-defined set of values, known as levels.
**By default, R always sorts levels in alphabetical order.**
For instance, if you have a factor with 2 levels:

```r
sex <- factor(c('male', 'female', 'female'))
```

R assigns the `female` level the integer value 1 even through `male` appears first in the vector.
We can confirm this and the number of levels using two functions.

```r
levels(sex)
nlevels(sex)
```

**By default, factors are unordered, which makes some kinds of comparison and aggregation meaningless.**

```r
spice <- factor(c('low', 'medium', 'low', 'high'))
levels(spice)
max(spice)
```

In calling `factor()`, we can specify the labels explicitly with the `levels` keyword argument, however...

```r
spice <- factor(c('low', 'medium', 'low', 'high'),
  levels = c('low', 'medium', 'high'))
levels(spice)
```

...If we specify `ordered=TRUE` when we set the factor levels, we can now talk about the relative magnitudes of categories.

```r
spice <- factor(c('low', 'medium', 'low', 'high'),
  levels = c('low', 'medium', 'high'), ordered = TRUE)
max(spice)
```

Setting the order of the factors can be crucial in linear regression, where the reference level of a categorical predictor is the first level of a factor.
**Factors allow us to order and compare categorical data with human-readable labels instead of storing the field as ambiguous integers.**

We can created ordered factors more easily with the `ordered()` function, which can also be used to change the order of levels in an existing factor.

```r
spice <- ordered(spice, levels = c('high', 'medium', 'low'))
max(spice)
```

### Challenge: Tabulation

**What are some of the factors in the `surveys` dataset?**

**The first thing we should do after we load our data is check to see that its correct--that is, that it matches our expectation of what the data should look like.**
Tabulation is one way we can make a quick bar plot of the data, in this case, to count the number of records associated with some factor; the number associated with some category.

```r
tabulation <- table(surveys$taxa)
tabulation
barplot(tabulation)
```

- In which order are the taxa listed?
- Acknowledging that `taxa` is a factor, how could we re-order the taxa so that they are plotted in order of highest frequency to lowest frequency (from left to right)?

```r
surveys$taxa <- ordered(surveys$taxa, levels = c('Rodent', 'Bird', 'Rabbit', 'Reptile'))
barplot(table(surveys$taxa))
```

### Cross Tabulation

Cross tabulation can aid in checking the assumptions about our dataset.
Cross tabulation tallies the number of corresponding rows for each pair of unique values in two vectors.
Here, we can use it to check that the expected number of records exist for each taxa in each year.

```r
table(surveys$year, surveys$taxa)
```

**To avoid re-writing `surveys` multiple times in this function call, we can use the helper function `with`.**

```r
with(surveys, table(year, taxa))
```

The `with` function signals to R that the names of variables like `year` and `taxa` can be found among the columns of the `surveys` data frame.
Writing our cross-tabulation this way makes it easier to read at a glance.

## Data Frames

**By default, when building or importing a data frame, the columns that contain characters (i.e., text) are coerced (converted) into the factor data type.**
Depending on what you want to do with the data, you may want to keep these columns as character.
To do so, `read.csv()` and `read.table()` have an argument called `stringsAsFactors` which can be set to `FALSE`.

```r
surveys2 <- read.csv('data/ecology.csv',
  stringsAsFactors = FALSE)
str(surveys2)
```

If you want to set this behavior as the new default throughout your script, you can set it in the `options()` function.

```r
options(stringsAsFactors = FALSE)
```

If you choose to set any `options()`, make sure you do so at the very top of your R script so that it is easy for others to see that you're deviating from the default behavior of R.

**There are several questions we can answer about our data frames with built-in functions.**

```r
dim(surveys)
nrow(surveys)
ncol(surveys)
names(surveys)
rownames(surveys)
summary(surveys)
```

Most of these functions are "generic;" that is, they can be used on other types of objects besides `data.frame`.

## Sequences and Indexing

**Recall that in R, the colon character is a special function for creating sequences.**

```r
1:10
```

This is a special case of the more general `seq()` function.

```r
seq(1, 10)
seq(1, 10, by = 2)
```

**Integer sequences like these are useful for extracting data from our data frames.**
Our survey data frame has rows and columns (it has 2 dimensions), if we want to extract some specific data from it, we need to specify the "coordinates" we want from it.
Row numbers come first, followed by column numbers, **though when we provide only one number it is interpreted as denoting a column.**

```r
# First column of surveys
surveys[1]

# First element of first column
surveys[1, 1]

# First element of fifth column
surveys[1, 5]

# First three elements of the fifth column
surveys[1:3, 5]

# Third row
surveys[3, ]

# Fifth column
surveys[, 5]

# First six rows
surveys[1:6, ]
```

We can also use negative numbers to exclude parts of a data frame.

```r
# The first column removed
head(surveys[, -1])

# The second through fourth columns removed
head(surveys[, -2:-4])
```

Recall that to subset the data frame's entire columns we can use the column names.

```r
surveys['year']   # Result is a data frame
surveys[, 'year'] # Result is a vector
surveys$year      # Result is a vector
```

### Challenge

The function `nrow()` on a `data.frame` returns the number of rows. Use it, in conjunction with `seq()` to create a new `data.frame` that includes every 100th row of the `surveys` data frame starting at row 100 (100, 200, 300, ...).

-------------------------------------------------------------------------------

## Checkpoint: Data Structures in R

**Now you should be familiar with the following:**

* The different types of data in R.
* The different **data structures** that we can use to organize our data in R.
* How to ask basic questions about the structure and size of our data in R.

-------------------------------------------------------------------------------

## Subsetting and Aggregating Data

The `surveys` data frame we're using today contains the same data from our SQL lesson yesterday.
We'll learn how to use R's advanced data manipulation and aggregation features to answer a few questions about these data.

1. What was the median weight of each rodent species between 1980 and 1990?
2. What is the difference in median hindfoot length in each rodent species between 1980 and 2000?

**To answer these questions, we'll combine relatively simple tasks in R together, progressively building towards a more complex answer.**

### Subsetting Data Frames

We can get closer to the first question by subsetting our data frame.
Recall the comparison operators in R; we want to find those entries in our data frame where the `taxa` column is equal to `Rodent` and the `year` column is between 1980 and 1990.

```r
surveys$taxa == 'Rodent'
```

That's a lot of output!
In fact, there's one logical value for every row in the data frame.
This makes sense, we basically performed a calculation on the `taxa` column, comparing every value to 'Rodent'.
The result is a logical vector with `TRUE` wherever the `taxa` column takes on a value equal to 'Rodent'.

**Thus, when we subset the rows of `surveys` with this logical vector, we obtain only those rows that matched.**

```r
surveys[surveys$taxa == 'Rodent', 'taxa']
```

**Question:** Why does the conditional expression go in the first slot inside the brackets, before the comma?

#### Challenge: Subsetting

Similar to the last example, subset the `surveys` data frame to just those entries between from years between 1980 and 1990, inclusive.
**Bonus:** Combine the condition on `year` with the condition of `taxa`, so that you return just the entries between 1980 and 1990 for rodents.

## Aggregating and Analyzing Data with dplyr

**R packages** are basically sets of additional functions that let you do more stuff.
The functions we’ve been using so far, like str() or data.frame(), come built into R; packages give you access to more of them.
Before you use a package for the first time you need to install it on your machine, and then you should import it in every subsequent R session when you need it.
R packages can be installed using the `install.packages()` function.
Let's try to install the `dplyr` package, which provides advanced data querying and aggregation.

```r
install.packages('dplyr')
```

Now that we've installed the package, we can load it into our current R session with the `library()` function.

```r
library(dplyr)
```

### What is dplyr?

The package `dplyr` provides easy tools for the most common data manipulation tasks.
It is built to work directly with data frames.
As you might expect, `dplyr` is an improvement on the `plyr` package, which has been in use for some time but can be slow in some use cases.
`dplyr` addresses this by porting much of the computation to C++.
An additional feature is the ability to work directly with data stored in an external database.
The benefits of doing this are that the data can be managed natively in a relational database, queries can be conducted on that database, and only the results of the query returned.

This addresses a common problem with R in that all operations are conducted in memory and thus the amount of data you can work with is limited by available memory.
The database connections essentially remove that limitation in that you can have a database of many 100s of gigabytes, conduct queries on it directly, and pull back just what you need for analysis in R.

### Selecting and Filtering with dplyr

We're going to learn some of the most common `dplyr` functions: `select()`, `filter()`, `mutate()`, `group_by()`, and `summarize()`.

To select columns from a data frame, use `select()`.
The first argument to this function is the data frame (`surveys`), and the subsequent arguments are the columns to keep.

```r
output <- select(gapminder, year, taxa, weight)
head(output)
```

To choose rows, use `filter()`.

```r
filter(gapminder, taxa == 'Rodent')
```

### Pipes

How can we combining `select()` and `filter()` so as to do both at the same time?
There are three ways to do this, two of which we've already seen:

- Use intermediate steps; recall how we would save a subset of our data frame as a new, temporary data frame. This can clutter up our workspace with lots of objects.
- Nested functions; we saw this most recently with the `with()` function. This is handy, but can be difficult to read if too many functions are nested together.
- Pipes.

The last option, pipes, are a fairly recent addition to R.
Pipes let you take the output of one function and send it directly to the next, which is useful when you need to do many things to the same data set.
In R, the pipe operator, %>%, is available in the `magrittr` package, which is installed as part of `dplyr`.
**Let's get some practice using pipes.**

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  select(year, weight)
```

If we want to save the output of this **pipeline,** we can assign it to a new variable.

```r
rodent.surveys <- surveys %>%
  filter(taxa == 'Rodent') %>%
  select(year, weight)
```

#### Challenge: Pipes

Using pipes, subset the `surveys` data to only the rodents entries between 1980 and 1990, inclusive.
Show only the `year`, `sex`, and `weight` columns in the final result.

### Mutating Data with dplyr

Frequently you'll want to create new columns based on the values in existing columns, for example to do unit conversions, or find the ratio of values in two columns.
For this we'll use `mutate()`.
**For instance, we might want to convert weight in grams to weight in kilograms.**

```r
surveys %>%
  mutate(weight.kg = weight / 1000)
```

Woops.
This is a lot to look at.
Luckily, we can pipe the results into the `head()` function.

```r
surveys %>%
  mutate(weight.kg = weight / 1000) %>%
  head()

surveys %>%
  mutate(weight.kg = weight / 1000) %>%
  tail()
```

#### Challenge: One-Step Mutation

Mutate the `surveys` data so that there are two new columns:

1. The ratio of hindfoot length to weight;
2. The weight in ounces (1 gram is 0.035274 ounces).

### Split-Apply-Combine with dplyr

`dplyr` introduces the **split, apply, combine** workflow to our skill set.
This workflow allows us to split apart a data frame based on the levels (or unique values) of one or more columns, apply a function to those subgroups, and combine the results together.

**To split apart a data frame, we need to introduce the `group_by()` function, which identifies the groups by which we'll split the data.**
`group_by()` is often used together with `summarize()`, which collapses each group into a single-row summary of that group.
`group_by()` takes as argument the column names that contain the categorical variables for which you want to calculate the summary statistics.

```r
surveys %>%
  group_by(species_id) %>%
  summarize(median(weight))
```

**Here, we've first split apart the data by `species`, that is, into groups of entries with the same value in the `species` column. Then, we applied a function, the `median()` function, to each part. Finally, we combined together the results of each `median()` function calculation.**

Now, we're really close to answering our first question about the data!

#### Challenge: Split-Apply-Combine

Modify the last example so that it fully answers our first question: What is the median weight of each rodent species between 1980 and 1990?
**Bonus:** Remove the `NA` values before summarizing.

### More on dplyr

**When we use the `summarize()` function in `dplyr`, we can see that the output appears truncated; instead of running off the screen, we get just the first few rows and a count of how many remain to be seen.**
That's because `dplyr`, instead of a `data.frame`, has returned an instance of the `tbl_df` class.
This is a data structure that's very similar to a data frame; for our purposes the only difference is that it won't automatically show too many rows.
It also displays the data type for each column under its name.
If you want to display more data on the screen, you can add the `print()` function at the end with the argument `n` specifying the number of rows to display.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  filter(year %in% seq.int(1980, 1990)) %>%
  filter(!is.na(weight)) %>%
  group_by(species_id) %>%
  summarize(med.weight = median(weight)) %>%
  print(n = 15)
```

We can perform tabulation using the `tally()` function.
For instance, how many rodents of each species were caught between 1980 and 1990?

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  filter(year %in% seq.int(1980, 1990)) %>%
  group_by(species_id) %>%
  tally()
```

We can even bring some base R functions into our pipeline.
For instance, we can visualize the count of rodents caught in the surveys over time.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  group_by(year) %>%
  tally() %>%
  plot(type = 'l', ylab = 'Rodent Count')
```

## Cleaning Data with tidyr

The second question we asked about the `surveys` data related to how the total number of rodents caught in each species had changed from 1980 to 2000.
**This is going to be harder to answer than our previous questions because of how our data are structured.**
The `tidyr` package in R has some additional functions for data cleaning and restructuring that can be combined with the pipelines we introduced in `dplyr`.

```r
install.packages('tidyr')
```

**Following best practices, we'll build this analysis by starting with small parts that we understand.**
First, we know we're interested in rodents.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  head()
```

Next, we want to calculate how many were caught in each species in each year.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  group_by(year, species_id) %>%
  tally() %>%
  head()
```

**If we break out the count for each year into its own columns, we can then simply use mutate to subtract the count in 1980 from the median hindfoot length in 2000.**
This is what the `spread()` function does in the `tidyr` package.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  group_by(year, species_id) %>%
  tally() %>%
  spread(year, n, sep = '.') %>%
  head()
```

**It's important to note that the only reason this works here is because the intermediate tibble had only three (3) columns: `year`, `species_id`, and the count (`n`).**
We took the count and broke it out into its own column for each year, which leaves one unique field along the "left" side of our tibble.
Now we're ready to calculate the difference between the two years.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  group_by(year, species_id) %>%
  tally() %>%
  spread(year, n, sep = '.') %>%
  mutate(delta_count = year.2000 - year.1980) %>%
  select(species_id, delta_count) %>%
  print(n = 29)
```

We can use the `arrange()` function to sort the output by a particular field.
In this case, we want to look at those species with the greatest reduction in individuals caught at the top.

```r
surveys %>%
  filter(taxa == 'Rodent') %>%
  group_by(year, species_id) %>%
  tally() %>%
  spread(year, n, sep = '.') %>%
  mutate(delta_count = year.2000 - year.1980) %>%
  select(species_id, delta_count) %>%
  arrange(delta_count) %>%
  head(10)
```

-------------------------------------------------------------------------------

## Checkpoint: Data Analysis in R

**Now you should be familiar with the following:**

* How to read in a CSV as an R `data.frame`
* Factors and when to use them
* Tabulation and cross-tabulation for checking assumptions about your data
* Numeric sequences for indexing vectors and data frames
* Subsetting data frames
* The split-apply-combine workflow
* How to use `dplyr` and pipes in a data analysis workflow

Next, you'll see how to create plots of your data for checking assumptions, validating the data, and answering data analysis questions.

-------------------------------------------------------------------------------
