# Advanced R Programming for Data Analysis

Some of the material is repurposed from [the Data Carpentry lesson on Ecology](http://www.datacarpentry.org/R-ecology-lesson/02-starting-with-data.html), which is released under an open license.

## Overview

The goal of this lesson is to orient intermediate R programmers and experienced programmers from other languages how to analyze data in R.
R is commonly used in many scientific disciplines for statistical analysis.
This workshop will focus on R as a general purpose programming language and data analysis tool, not on any specific statistical analysis.

## Contents

1. Introduction to RStudio
  - RStudio Layout
  - Workflow
2. Quick Overview of R
  - Mathematical Operations in R
  - Data Types
  - Machine Precision
  - Variables and Assignment
  - Functions
  - Flow of Control
3. Project Management with R Studio
  - How RStudio Helps
  - Best Practices
4. Starting with Data Structures
  - Reading in a CSV as a Data Frame
  - Factors
  - Tabulation
  - Cross-Tabulation
5. Data Frames
6. Sequences and Indexing
7. Subsetting and Aggregating Data
  - Subsetting Data Frames
  - `aggregate()`
  - Function Application
  - The `plyr` Package
6. Analyzing data with `dplyr`
  - `select()` and `filter()`
  - Pipes
  - Mutating Data
  - Split-Apply-Combine with `dplyr`
7. Cleaning Data with `tidyr`

### The Data

In this workshop, we will be using a subset of [the Gapminder dataset](http://www.gapminder.org/).
This is world-wide statistical data collected and curated to allow for a "fact based worldview."
These data includes things like employment rates, birth rates, death rates, percent of GDP that's from agriculture and more.
There are currently 519 variables overall, each as a time series.

You can see some examples of Gapminder's visualizations [in this TED video](http://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen).
In this workshop, we'll focus just on **life expectancy at birth** and **per-capita GDP** by country, continent, and total population.

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

### Mathematical Operations in R

```r
# Order of operations
3 + 5 * 2

# Parentheses help
(3 + 5) * 2

# Scientific notation
2/1000000
5e3

# Built-ins: Natural logarithm
log(1)

# Built-ins: Base-10 logarithm
log10(1)

# Getting help
?exp
??exponential

# Comparison operators
1 == 1
1 != 2
!TRUE
1 < 2
2 >= 1
```

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
We may be tempted to use the `=` form because it is shorter, however, we should be aware of the important differences between these two operators.

```r
# Argument assignment; no side effects
mean(x = 1:10)
x

# Variable assignment; side effects!
mean(x <- 1:10)
x
```

The above example may have you thinking that the `=` form is better to use in all cases.
However, the following example shows a situation in which the `=` form is incorrectly interpreted as a keyword argument assignment.

```r
df <- data.frame(foo = rnorm(10, 1000, 100))
within(df, bar = log10(foo)) # Breaks
within(df, bar <- log10(foo)) # Works
```

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
**Then, copy the `gapminder-FiveYearData.csv` file to the new `data` directory.**

<!--TODO Advanced lesson: version control.

"We also set up our project to integrate with Git, putting it under version control..."-->

## Starting with Data Structures

Let's load in some data.

```r
gapminder <- read.csv('data/gapminder-FiveYearData.csv')
```

Typically, the first thing we want to do after reading in some data is to take a quick look at it to verify its integrity.

```r
head(gapminder)
tail(gapminder)
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
str(gapminder)
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
By default, R always sorts levels in alphabetical order.
For instance, if you have a factor with 2 levels:

```r
times <- factor(c('night', 'day', 'night', 'day'))
```

R assigns the `day` level the integer value 1 even through `night` appears first in the vector.
We can confirm this and the number of levels using two functions.

```r
levels(times)
nlevels(times)
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

### Converting Factors

If you need to convert a factor to a character vector, you use the `as.character()` function.
**However, if the levels of the factor appear as numbers, such as concentration levels, then conversion to a numeric vector can be tricky.**
One method is to convert factors to characters and then numbers.
Another method is to use the `levels()` function. Compare:

```r
f <- factor(c(1, 5, 10, 2))
as.numeric(f)
as.numeric(as.character(f))
as.numeric(levels(f))[f]
```

Notice that in the `levels()` approach, three important steps occur:

- We obtain all the factor levels using `levels(f)`;
- We convert these levels to numeric values using as.numeric`(levels(f))`;
- We then access these numeric values using the underlying integers of the vector `f` inside the square brackets.

### Challenge: Tabulation

The function `table()` tabulates and cross-tabulates observations.
Tabulation can be used to create a quick bar plot of your data.
In this case, we can quickly plot the number of observations in each continent in the data.
Answer the following questions after tabulating and plotting the continents in the Gapminder data.

```r
tabulation <- table(gapminder$continent)
tabulation
barplot(tabulation)
```

- In which order are the continents listed?
- How can you re-order the continents so that they are plotted in order of highest frequency to lowest frequency (from left to right)?

### Cross Tabulation

Cross tabulation can aid in checking the assumptions about our dataset.
Cross tabulation tallies the number of corresponding rows for each pair of unique values in two vectors.
Here, we can use it to check that the expected number of records exist for each continent in each year.
Because each country appears only once a year, these numbers correspond to the number of countries recorded for that continent in that year.

```r
table(gapminder$year, gapminder$continent)
```

To avoid re-writing `gapminder` multiple times in this function call, we can use the helper function `with`.

```r
with(gapminder, table(year, continent))
```

The `with` function signals to R that the names of variables like `year` and `continent` can be found among the columns of the `gapminder` data frame.
Writing our cross-tabulation this way makes it easier to read at a glance.

## Data Frames

By default, when building or importing a data frame, the columns that contain characters (i.e., text) are coerced (converted) into the factor data type.
Depending on what you want to do with the data, you may want to keep these columns as character.
To do so, `read.csv()` and `read.table()` have an argument called `stringsAsFactors` which can be set to `FALSE`.

```r
gapminder2 <- read.csv('data/gapminder-FiveYearData.csv', stringsAsFactors = FALSE)
str(gapminder2)
```

If you want to set this behavior as the new default throughout your script, you can set it in the `options()` function.

```r
options(stringsAsFactors = FALSE)
```

If you choose to set any `options()`, make sure you do so at the very top of your R script so that it is easy for others to see that you're deviating from the default behavior of R.

There are several questions we can answer about our data frames with built-in functions.

```r
dim(gapminder)
nrow(gapminder)
ncol(gapminder)
names(gapminder)
rownames(gapminder)
summary(gapminder)
```

Most of these functions are "generic;" that is, they can be used on other types of objects besides `data.frame`.

## Sequences and Indexing

Recall that in R, the colon character is a special function for creating sequences.

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
Row numbers come first, followed by column numbers.

```r
# First column of gapminder
gapminder[1]

# First element of first column
gapminder[1, 1]

# First element of fifth column
gapminder[1, 5]

# First three elements of the fifth column
gapminder[1:3, 5]

# Third row
gapminder[3, ]

# Fifth column
gapminder[, 5]

# First six rows
gapminder[1:6, ]
```

We can also use negative number to exclude parts of a data frame.

```r
# The first column removed
head(gapminder[, -1])

# The second through fourth columns removed
head(gapminder[, -2:-4])
```

Recall that to subset the data frame's entire columns we can use the column names.

```r
gapminder['year']   # Result is a data frame
gapminder[, 'year'] # Result is a vector
gapminder$year      # Result is a vector
```

### Challenge

The function `nrow()` on a `data.frame` returns the number of rows. Use it, in conjunction with `seq()` to create a new `data.frame` that includes every 10th row of the `gapminder` data frame starting at row 10 (10, 20, 30, ...).

-------------------------------------------------------------------------------

## Checkpoint: Data Structures in R

**Now you should be familiar with the following:**

* The different types of data in R.
* The different **data structures** that we can use to organize our data in R.
* How to ask basic questions about the structure and size of our data in R.

-------------------------------------------------------------------------------

## Subsetting and Aggregating Data

The Gapminder data contain surveys of each country's per-capita GDP and life expectancy every five years.
Let's learn how to use R's advanced data manipulation and aggregation features to answer a few questions about the Gapminder data.

1. Which countries had a life expectancy lower than 30 years of age in 1952?
2. What was the mean per-capita GDP between 2002 and 2007 for each country?
3. What is the range in life expectancy for each continent?

These are problems of aggregation, fundamentally,
**To answer these questions, we'll combine relatively simple tasks in R together, progressively building towards a more complex answer.**

### Subsetting Data Frames

To answer our first question, we need to learn about subsetting data frames.
Recall our comparison operators; we want to find those entries of the `lifeExp` column that are less than 30.

```r
gapminder$lifeExp < 30
```

That's a lot of output!
In fact, there's one logical value for every row in the data frame.
This makes sense; we basically performed a calculation on the `lifeExp` column, comparing every value in that column to 30.
The result is a logical vector with `TRUE` wherever the `lifeExp` value is less than 30 and `FALSE` elsewhere.

**Thus, when we subset the rows of `gapminder` with this logical vector, we obtain only those rows that matched.**
Finally, we specified we just wanted the `country` column in this result.

```r
gapminder[gapminder$lifeExp < 30, 'country']
```

This is the best way to subset data frames when we're writing a reusable R script.
However, when we're using R interactively as part of **exploratory data analysis,** it may be easier to use the `subset()` function.

```r
subset(gapminder, lifeExp < 30, select = 'country')
```

Note that, unlike our bracket notation, the `subset()` function returns a data frame for an input data frame.
`subset()` can be easier to use, especially when we have multiple conditionals.
For instance, if we want to find the countries where life expectancy was lower than 30 years of age in 1952, not just in any year...

```r
subset(gapminder, lifeExp < 30 & year == 1952, select = 'country')
```

### The aggregate() Function

To answer the other questions we asked, we need to be able to summarize values in one column for each of the unique values in another column.
That is, we need to **aggregate** our data, and there's a built-in function in R to do just this.

```r
?aggregate
```

**Note that the `by` argument in `aggregate()` takes a list of unique values "as long as the variables in the data frame x."**
This means we can call `aggregate()` on two separate vectors, even if we don't have a data frame, as long as those vectors are the same length.
Recall that we wanted to know the mean per-capita GDP between 2002 and 2007 for each country.
Thus, we need to start by subsetting the `gapminder` data frame to just those years.

```r
gm.subset <- gapminder[gapminder$year %in% c(2002, 2007),]
```

Now we can provide the column the be aggregated, `gdpPercap`, and the column with the unique group values, `country`, to the `aggregate()` function.

```r
aggregate(gm.subset$gdpPercap, by = list(gm.subset$country), FUN = mean)
```

### Function Application

Another way we can aggregate data in R is with function application.
R has several built in functions like `sapply()`, `tapply()`, and `apply()` that apply a function over a list, vector, or data frame.

Of these functions, `sapply()` is the simplest.
We can use it, for instance, with the `class()` function to check the data type of every column in our data frame.
Because a data frame is really a list of vectors, `sapply()` applies the `class()` function to each vector.

```r
sapply(gapminder, class)
```

With the more general `apply()` function, we can aggregate across the rows or columns of a data frame.
We have to tell `apply()` which we're aggregating over, however: rows or columns.

```r
?apply
```

This is the `MARGIN` argument of `apply()`.
Recall that when indexing data frames, we specify the row index before the column index.
Thus, the number 1 is the margin for row application and the number 2 is for column application.
For instance, we can reproduce the `sapply()` example with `apply()` like so.

```r
apply(gapminder, 2, class)
```

We can also calculate summary statistics over multiple numeric columns, such as the last two columns of `gapminder`.

```r
apply(gapminder[,5:6], 2, mean)
```

**However, this kind of aggregation isn't very meaningful for this dataset. We probably don't care about the mean life expectancy or per-capita GDP across a period of over 50 years.**
Instead, we'd like to summarize columns within predefined groups, like countries or continents.
This is where `tapply()` comes in.

```r
?tapply()
```

We can see that, like `aggregate()`, we can specify the groups to aggregate within.
Let's reproduce our result from `aggregate()` starting with the subset data, `gm.subset`.

```r
tapply(gm.subset$gdpPercap, gm.subset$country, FUN = mean)
```

Note that this output is formatted differently.
This is because, unlike `aggregate()` which returns a vector, `tapply()` simplifies the data by default and returns an instance of the `array` class, a more general kind of vector.

In addition to the built-in functions like `mean()`, we can provide any custom function to `tapply()`.
For instance, we can use it to answer Question 3; to find out how much life expectancy varies across each continent in 2007.
Here, we use the `with()` function to subset our data before calling `tapply()`.

```r
with(gapminder[gapminder$year == 2007,], tapply(lifeExp,
  INDEX = continent, FUN = function (values) {
    max(values) - min(values)
    }))
```

### The plyr Package

The aggregation techniques we've seen so far are all built into base R.
We can explore some alternative techniques that are available in third-party libraries developed by the R community.
**R packages** are basically sets of additional functions that let you do more stuff.
The functions we’ve been using so far, like str() or data.frame(), come built into R; packages give you access to more of them.
Before you use a package for the first time you need to install it on your machine, and then you should import it in every subsequent R session when you need it.
R packages can be installed using the `install.packages()` function.
Let's try to install the `plyr` package, which provides advanced data querying and aggregation.

```r
install.packages('plyr')
```

Now that we've installed the package, we can load it into our current R session with the `library()` function.

```r
library(plyr)
```

The `plyr` package has a number of useful functions including `summarize()`, which can be used to summarize our `gapminder` data frame multiple times.

```r
summarize(gapminder,
  min.life.expectancy = min(lifeExp),
  max.life.expectancy = max(lifeExp),
  mean.population = mean(pop))
```

**Unlike the `aggregate()` and `tapply()` functions, `summarize()` allows us to calculate multiple aggregates at once. However, it is unable to distinguish among subgroups.**
To aggregate within groups, we can combine `summarize()` with the `ddply()` function.

```r
?ddply
```

`ddply()` introduces the **split, apply, combine** workflow to our skill set.
This workflow allows us to split apart a data frame based on the levels (or unique values) of one or more columns, apply a function to those subgroups, and combine the results together.
For instance, we can answer Question 3 with this workflow as follows.

```r
ddply(gapminder[gapminder$year == 2007,], 'continent', summarize,
  life.exp.range = max(lifeExp) - min(lifeExp))
```

R executes this code in this order:

- First, the `gapminder` data frame is subset so that only those records from 2007 are retained.
- Next, `ddply()` is called, and it begins by splitting the subset data frame into multiple groups based on the unique values (factor levels) of the `continent` column.
- Then, `summarize()` is called on each of those subgroups; `summarize()` calculates all of the subsequent arguments to the `ddply()` function, here, calculating the range in life expectancy.
- Finally, `ddply()` takes all the results of the `summarize()` function and combines them together into a data frame.

Just as we saw with `summarize()` when it was called alone, we can calculate multiple aggregates at once in this way.

## Analyzing Data with dplyr

Because the R programming language is open source, the developer community moves quickly and a number of different tools are available for a wide variety of tasks.
We've just seen three ways of summarizing our `gapminder` data frame that we can use to find the range in 2007 life expectancies across the continents.

```r
# Outputs a data frame
with(gapminder[gapminder$year == 2007,],
  aggregate(lifeExp, by = list(continent), FUN = function (values) {
    max(values) - min(values)
    }))

# Outputs a vector/ array
with(gapminder[gapminder$year == 2007,],
  tapply(lifeExp, INDEX = continent, FUN = function (values) {
    max(values) - min(values)
    }))

# Outputs a data frame
library(plyr)
ddply(gapminder[gapminder$year == 2007,], 'continent', summarize,
  life.exp.range = max(lifeExp) - min(lifeExp))
```

Now, we'll take a look at another R package that can help us streamline our workflows for querying, subsetting, and summarizing our datasets.
`dplyr` is an R package for making data manipulation easier.

```r
install.packages('dplyr')
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
Recall that we saw the `summarize()` function in the `plyr` package.
The `summarize()` function in `dplyr` does the same thing but is faster.

To select columns from a data frame, use `select()`.
The first argument to this function is the data frame (`gapminder`), and the subsequent arguments are the columns to keep.

```r
output <- select(gapminder, country, pop)
head(output)
```

To choose rows, use `filter()`.

```r
filter(gapminder, country == 'Australia')
```

### Pipes

But what if you wanted to select and filter at the same time?
There are three ways to do this, two of which we've already seen:

- Use intermediate steps; recall how we would save a subset of our data frame as a new, temporary data frame. This can clutter up our workspace with lots of objects.
- Nested functions; we saw this most recently with the `with()` function. This is handy, but can be difficult to read if too many functions are nested together.
- Pipes.

The last option, pipes, are a fairly recent addition to R.
Pipes let you take the output of one function and send it directly to the next, which is useful when you need to do many things to the same data set.
In R, the pipe operator, %>%, is available in the `magrittr` package, which is installed as part of `dplyr`.
**Let's get some practice using pipes.**

```r
gapminder %>%
  filter(continent == 'Oceania') %>%
  select(country, year, pop)
```

If we want to save the output of this **pipeline,** we can assign it to a new variable.

```r
oceania <- gapminder %>%
  filter(continent == 'Oceania') %>%
  select(country, year, pop)
```

### Challenge: Pipes

Using pipes, subset the `gapminder` data to the United States and retain the year, population, and life expectancy columns.

### Mutating Data with dplyr

Frequently you'll want to create new columns based on the values in existing columns, for example to do unit conversions, or find the ratio of values in two columns.
For this we'll use `mutate()`.
**For instance, we can convert per-capita GDP to total GDP as follows.**

```r
gapminder %>%
  mutate(gdp = gdpPercap * pop)
```

Woops.
This is a lot to look at.
Luckily, we can pipe the results into the `head()` function.

```r
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  head()
```

### Challenge: One-Step Mutation

Mutate the gapminder data so that there are two new columns, the base-10 logarithm of population and the base-10 logarithm of per-capita GDP.
Note there are two ways to do this in `dplyr`.

### Split-Apply-Combine with dplyr

We saw how the split, apply, combine workflow can be used with the `plyr` package.
In `dplyr`, to do the same, we need to introduce the `group_by` function.
`group_by()` is often used together with `summarize()`, which collapses each group into a single-row summary of that group.
`group_by()` takes as argument the column names that contain the categorical variables for which you want to calculate the summary statistics.
For instance, to view the maximum life expectancy by country in 2007:

```r
gapminder %>%
  group_by(country) %>%
  summarize(max(lifeExp))
```

We can see that the output appears truncated; instead of running off the screen, we get just the first few rows and a count of how many remain to be seen.
That's because `dplyr`, instead of a `data.frame`, has returned an instance of the `tbl_df` class.
This is a data structure that's very similar to a data frame; for our purposes the only difference is that it won't automatically show too many rows.
It also displays the data type for each column under its name.
If you want to display more data on the screen, you can add the `print()` function at the end with the argument `n` specifying the number of rows to display.

```r
gapminder %>%
  group_by(country) %>%
  summarize(max(lifeExp)) %>%
  print(n = 15)
```

We can perform tabulation using the `tally()` function.
How many countries are found in each continent in 2007?

```r
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  tally()
```

We can even bring some base R functions into our pipeline.
For instance, we can investigate a possible correlation between mean per-capita GDP and mean life expectancy over the past 50 years.

```r
gapminder %>%
  group_by(country) %>%
  summarize(y = mean(lifeExp), x = mean(gdpPercap)) %>%
  select(x, y) %>%
  plot(main = 'Life Expectancy vs. Per-Capita GDP',
    xlab = 'Mean Per-Capita GDP', ylab = 'Mean Life Expectancy')
```

Let's try taking the base-10 logarithm of mean per-capita GDP.

```r
gapminder %>%
  group_by(country) %>%
  mutate(log.gdpPercap = log10(gdpPercap)) %>%
  summarize(y = mean(lifeExp), x = mean(log.gdpPercap)) %>%
  select(x, y) %>%
  plot(main = 'Life Expectancy vs. Per-Capita GDP',
    xlab = 'Mean Log10 Per-Capita GDP', ylab = 'Mean Life Expectancy')
```

## Cleaning Data with tidyr

There's one more question I want to answer about the gapminder data using pipes.
How much did life expectancy change in each African country in the 40-year period between 1952 and 1992?
**This is going to be harder to answer than our previous questions because of how our data are structured.**
We can't use `summarize()` here because there is no way to distinguish between the years when we're aggregating values in a given column.
We could assume that life expectancy increased in all cases and simply subtract the minimum value from the maximum value but our assumption may not hold; there might be some places where life expectancy, for whatever reason, decreased.

The `tidyr` package in R has some additional functions for data cleaning and restructuring that can be combined with the pipelines we introduced in `dplyr`.

```r
install.packages('tidyr')
```

Following best practices, we'll build this analysis by starting with small parts that we understand.
We know that we want to filter the data to the African continent and to the years 1952 and 1992.

```r
gapminder %>%
  filter(continent == 'Africa') %>%
  filter(year %in% c(1952, 1992)) %>%
  head()
```

**If we break out the value of life expectancy for each year into its own columns, we can then simply use mutate to subtract the life expectancy in 1952 from the life expectancy in 1992.**
This is what the `spread()` function does in the `tidyr` package.

```r
library(tidyr)
gapminder %>%
  filter(continent == 'Africa') %>%
  filter(year %in% c(1952, 1992)) %>%
  spread(year, lifeExp, sep = '.') %>%
  head()
```

From this output, it looks like we now have separate columns but the rows need to be collapsed into one entry per country.
We could do this with `summarize()` but there is an easier way.
It turns out that `spread()` is pretty smart about this, we just need to ensure that the only variables in our data frame are the "key" and "value" variables and any non-unique grouping variable, like `country`.
So, we `select()` these variables before we `spread()`.

```r
gapminder %>%
  filter(continent == 'Africa') %>%
  filter(year %in% c(1952, 1992)) %>%
  select(country, year, lifeExp) %>%
  spread(year, lifeExp, sep = '.') %>%
  head()
```

Now we're ready to calculate the difference between the two years.

```r
gapminder %>%
  filter(continent == 'Africa') %>%
  filter(year %in% c(1952, 1992)) %>%
  select(country, year, lifeExp) %>%
  spread(year, lifeExp, sep = '.') %>%
  mutate(life.exp.change = year.1992 - year.1952) %>%
  head()
```

We can use the `arrange()` function to sort the output by a particular field.
In this case, we want to look at those countries with the lowest gain in life expectancy at the top.

```r
gapminder %>%
  filter(continent == 'Africa') %>%
  filter(year %in% c(1952, 1992)) %>%
  select(country, year, lifeExp) %>%
  spread(year, lifeExp, sep = '.') %>%
  mutate(life.exp.change = year.1992 - year.1952) %>%
  arrange(life.exp.change) %>%
  head()
```

## Applications

### Batch Plot Creation

```r
gapminder <- read.csv('gapminder-FiveYearData.csv')

# Quantize remaining variables
variables <- c('pop', 'lifeExp', 'gdpPercap')

labels <- c(
  'pop' = 'Population',
  'lifeExp' = 'Life Expectancy',
  'gdpPercap' = 'Per-Capita GDP')

plot.histogram <- function (var) {
  hist(gapminder[,var], main = paste('Histogram of', labels[var]),
    xlab = labels[var])
}

for (variable in variables) {
  png(file=paste0('~/Desktop/histogram_', variable, '.png'), width=670, height=655)
  plot.histogram(variable)
  dev.off()
}
```

## Conclusion and Summary

### Other Resources

* [Quick-R](http://www.statmethods.net/): "An easily accessible reference...for both current R users, and experienced users of other statistical packages...who would like to transition to R."
* [RStudio Cheat Sheets](https://www.rstudio.com/resources/cheatsheets/): A list of informational graphics that help remind you how to use some advanced features in RStudio.
* [The R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf): A humorous and informative guide to some of the more advanced features and confounding behavior.
* [Writing (Fast) Loops in R](http://faculty.washington.edu/kenrice/sisg/SISG-08-05.pdf)
* [dplyr Cheat Sheet](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
* A longer introduction to `plyr` and `dplyr` [using the same Gapminder data](http://stat545.com/block009_dplyr-intro.html).
* More on using `dplyr` [to analyze the Gapminder data](http://stat545.com/block010_dplyr-end-single-table.html).
