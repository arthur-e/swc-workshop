# Advanced R Programming for Data Analysis

Some of the material is repurposed from [the Data Carpentry lesson on Ecology](http://www.datacarpentry.org/R-ecology-lesson/02-starting-with-data.html), which is released under an open license.

## Overview

The goal of this lesson is to orient intermediate R programmers and experienced programmers from other languages how to analyze data in R.
R is commonly used in many scientific disciplines for statistical analysis.
This workshop will focus on R as a general purpose programming language and data analysis tool, not on any specific statistical analysis.

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

One way that we can use RStudio is in the interactive way I alluded to earlier.
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

Here's an example layout suggested by Daniel Chen.

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

## Data Structures

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

**In R, the columns of a data frame are represented as vectors.**
Vectors in R are a sequence of values with the same data type.
We can use the `c()` function to create new vectors.

```r
x1 <- c(1, 2, 3)
x2 <- c('a', 'b', 'c')
```

We can construct data frames as a collection of vectors.
Note that if we try to put unlike data types in a single vector, they get coerced to the most flexible data type.

```r
df <- data.frame(
  x1 = c(TRUE, FALSE, TRUE),
  x2 = c(1, 'red', 2))
```

We can confirm that our `gapminder` data frame is a collection of vectors with a consistent data type by examining the structure with the `str()` function.

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

### Challenge: Cross-Tabulation

The function `table()` tabulates and cross-tabulates observations.
Tabulation can be used to create a quick bar plot of your data.
In this case, we can quickly plot the number of countries in each continent in the data.
Answer the following questions after tabulating and plotting the continents in the Gapminder data.

```r
tabulation <- table(gapminder$continent)
tabulation
barplot(tabulation)
```

- In which order are the continents listed?
- How can you re-order the continents so that they are plotted in order of highest frequency to lowest frequency (from left to right)?

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
* [R Cookbook](http://www.cookbook-r.com/): Code samples for a number of "common tasks and problems in analyzing data."
* [The R Inferno](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf): A humorous and informative guide to some of the more advanced features and confounding behavior.
* [Rtips](http://pj.freefaculty.org/R/Rtips.html)
* [R Reference Card](https://cran.r-project.org/doc/contrib/Short-refcard.pdf)
* [Writing (Fast) Loops in R](http://faculty.washington.edu/kenrice/sisg/SISG-08-05.pdf)
