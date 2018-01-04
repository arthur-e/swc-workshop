# Quick Introduction to R

Some of the material is repurposed from [the Data Carpentry lesson on Ecology](http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-r.html), which is released under an open license.
It is intended as a 2-hour (or less) introduction to R for learners with no prior experience whatsoever.

# R Basics

## R as Calculator

We can use R in interactive mode by typing commands directly into the **console** in RStudio.
For instance, we can use R as a fancy calculator by asking it to compute the following mathematical operations.

```r
3 + 5
12 / 7
```

Note that when we hit Enter, the result is printed to the screen immediately.

- If we want to use the result of this calculation later, we need to explicitly store it somewhere.
- R, like most programming languages, allows us to assign names to values and other objects.
- The process of assigning a name to a value is called **variable assignment.**

```r
weight_kg <- 55
```

Here, `weight_kg` is a variable.
**Think of a variable as a sticky note that can be attached to a value.**
The arrow sign is known as the **assignment operator;** it takes whatever value or object is on the right-hand side and *assigns* it the name of the variable on the left-hand side.

```r
weight_kg
```

**What are valid variable names in R?**

- Can contain any alphanumeric characters, `A-Z`, `a-z`, and `0-9`;
- Though name can contain numbers it cannot *start* with a number;
- Can also contain underscores, `_`, and dots `.`;

Now that R has `weight_kg` in memory, we can do arithmetic with it.
For instance, we can convert the weight in kilograms to the weight in pounds by multiplying it by 2.2.

```r
2.2 * weight_kg
```

Again, this new value is not stored in memory until we explicitly assign it to a variable.

```r
weight_lb <- 2.2 * weight_kg
```

Note that we can change a variable's value at any time.

```r
weight_kg <- 100
2.2 * weight_kg
```

And that this doesn't affect any earlier calculations.

```r
weight_lb
```

`weight_lb` isn't changed because anytime we perform a calculation with a variable, R retrieves the value associated with that variable and then ignores the variable name.
Another way of understanding why `weight_lb` isn't changed is to think about our calculations on a timeline.
We changed the value of `weight_kg` *after* we had already stored a previous calculation in `weight_lb`.
Events in the future don't have any affect on events in the past.

Finally, we can tell the R interpreter to ignore some commands that we type.

```r
# like this
```

Anything typed after the **comment character,** `#` is ignored.
This is useful for annotating your code

```r
weight_kg # Report the weight in kilograms
```

### Challenge: Variable Assignment

With a partner, enter the following statements in order. Discuss what you think the stored values are going to be after each line.

```r
mass <- 47.5            # mass?
age  <- 122             # age?
mass <- mass * 2.0      # mass?
age  <- age - 20        # age?
mass_index <- mass/age  # mass_index?
```

## Functions and their Arguments

- A function is a collection of R statements that can be repeatedly invoked to do the same thing over and over again.
- A function can serve as a script to automate more complicated sets of commands including complex calculations.
- Many functions are predefined or can be made available by importing R packages (more on that later).
- A function usually gets one or more inputs called **arguments.** Functions often (but not always) return a value.

A simple example of a function is `sqrt()`.

```r
sqrt(25)
```

Here, the value 25 is the input to the `sqrt()` function.
Arguments go inside the parentheses of a function.
However, even if the function takes no arguments, we still need to use the parentheses to tell R that we are *calling* the function.

```r
ls()
```

**What happens when we forget the parentheses?**

```r
ls
```

The `sqrt()` function is a simply function that takes only one input argument.
We can see what arguments the `sqrt()` function takes and learn even more about it by calling for the help documentation.

```r
help(sqrt)
?sqrt
```

Note that the `help()` function is a function that takes any R object as its argument.
When we pass the `sqrt` function, we don't include the parentheses because, here, we don't want to call the function.
When we call the function, it does something, and it usually returns a new value or R object.
However, the `help()` function doesn't want whatever the output of that function is; it needs the function itself.

**Now let's take a look at a function that takes multiple arguments.**

```r
round(3.14159)
```

Here, we've called the function `round()`, which rounds a number.
The one argument we provided is the number we want to round to.
It seems that by default, `round()` will round the number to the nearest whole number.
**Using the help documentation for `round()`, can you figure out how we can call this function so that it rounds to a specific number of decimal places?**

```r
round(3.14159, digits = 2)
round(3.14159, 2)
```

Note that if we don't provide the names of the arguments, we have to provide the arguments in the correct order.
However, if we do name them, we can provide the arguments in any order.

```r
round(digits = 2, x = 3.14159)
```

## Vectors and Data Types

We usually want to work with more than just a handful of values when we have a real-world analysis problem.
R has several **data structures** that can hold multiple values at once, which allows us to assign a variable name to a series of measurements or related values.

A **vector** is the most common and basic data type in R.
Vectors can be constructed using the `c()` function, which we call the "concatenate" function.
So, suppose we have a set of related animal weight measurements in grams.

```r
weight_g <- c(40, 35, 90)
weight_g
```

A vector can also contain character strings:

```r
animals <- c('mouse', 'rat', 'dog')
animals
```

The quotes around `mouse`, `rat`, and `dog` are essential here.
Without the quotes, R will assume there are variables out there named `mouse`, `rat`, and `dog`.
As these variables don't exist in R's memory, there would be an error message.

**There are many convenience functions in R that allow us to inspect the contents of a vector.**

```r
length(animals)
class(weight_g)
class(animals)
str(weight_g)
```

Here's another type of vector that contains Boolean or logical values.

```r
a_vector <- c(TRUE, FALSE, TRUE)
class(a_vector)
```

We can also use the `c()` function to add new elements to an existing vector.

```r
more_animals <- c(animals, 'cat')
more_animals
more_animals <- c('cat', animals)
more_animals
```

### Challenge: Vectors and Multiple Data Types

We've seen that atomic vectors can be of type character, numeric (or double), integer, and logical.
But what happens if we try to mix these types in a single vector?
With a partner, try to figure out what R is doing in the following examples.
Hint: Remember you can use `class()` to figure out what data type a vector contains.

```r
num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")
```

## Subsetting Vectors

We can extract one or more values from a vector by **indexing.**
That is, we can specify the numerical indices that represent the position or positions of the values we want to extract.

```r
more_animals
more_animals[2]
more_animals[c(3,2)]
more_animals[c(3,2,3,2)]
```

### Conditional Subsetting

Most of the time, we don't want to subset a vector by specifying numerical indices.
Instead, we want to extract those parts of a vector that satisfy a certain condition.
In R, we can use **conditional statements** to extract certain elements.

```r
1 == 1
1 != 2
!TRUE
1 < 2
```

Now, let's take what we've learned about the conditional operators and statements in R and use that to subset a vector.

```r
weight_g
weight_g > 50
```

When we have a logical vector, it can be used to select elements from another vector.
Wherever there is a `TRUE` value in the logical vector, a value is returned.

```r
animals
animals[c(TRUE, TRUE, FALSE)]
```

We've seen that a conditional statement on a vector in R produces a logical vector.
We can combine that knowledge with our knowledge of subsetting R vectors to obtain an easy way to subset any vector.

```r
weight_g[weight_g > 50]
animals[weight_g > 50]
```

We definitely want to make sure the two vectors are of equal length in that second example.

```r
some_animals <- c('cat', 'rat', 'cat', 'dog', 'rat')
some_animals[some_animals == 'cat' | some_animals == 'dog']
some_animals[!(some_animals == 'cat' | some_animals == 'dog')]
some_animals[some_animals == 'cat' & some_animals == 'dog']
```

A common task is to search a vector for the occurrence of some value.

```r
'cat' %in% some_animals
some_animals %in% c('cat')
some_animals[some_animals %in% c('cat')]
```

## Missing Data

Real-world data often include missing values.
This might be because the data come from a survey and a respondent declined to answer a question or the data come from an observational study and a certain measurement could not be made.
In R, missing data are represented as `NA`.

```r
heights <- c(2, 4, 4, NA, 6)
heights
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)
```

If your data include missing values, you want to be come familiar with a few helper functions for handling missing cases.

```r
# Extract elements which are not missing
is.na(heights)
heights[!is.na(heights)]

# Return the vector with all missing cases omitted
heights[complete.cases(heights)]
```

### Challenge: Working with Missing Data

Using the following vector of length measurements:

1) Create a new vector with the `NA` values removed;
2) Calculate the median of the new vector;

Hint: You can use double question-marks and a text string to do a keyword search of the documentation: `??"median"`.

```r
lengths <- c(10, 24, NA, 18, NA, 20)
```

# Getting Started with Data

For this next part, we'll work a real-world dataset.
The data come from a study of the species and weights of animals caught in the study area.
The dataset is stored as a comma-separated variable (CSV) file.
Each row holds information for a single animal.

We'll use the function `download.file()` to download the CSV file that contains the survey data.
Then, we'll use the function `read.csv()` to read-in the contents of the CSV file.

```r
download.file("https://raw.githubusercontent.com/arthur-e/swc-workshop/master/data/ecology-surveys.csv",
              "surveys.csv")

surveys <- read.csv('surveys.csv')
```

Recall that `read.csv()` doesn't return any output here because we've assigned its output to a variable, `surveys`.
The default data structure R uses to represent tabular data is called a **data frame.**

**What are data frames?**
A data frame is a representation of tabular data where the columns are vectors of the same length.
Because the columns are vectors, each contains only one type of data.
However, because there can be multiple columns in a data frame, the data frame itself can contain multiple data types.

There are several helper functions for working with data frames.
After we've brought new data into R, we typically want to check that everything looks okay with the `head()` function.

```r
head(surveys)
```

There are many other helpful functions we can use to interrogate our data frames.

```r
dim(surveys)
nrow(surveys)
ncol(surveys)
head(surveys)
tail(surveys)
names(surveys)
summary(surveys)
```

## Indexing and Subsetting Data Frames

When we were working with vectors, we saw how we could subset a vector by specifying one or more indices representing the position(s) of value(s) stored in that vector.
A vector can be used to represent a column in a data frame.
Because data frames have both rows and columns, we need two numbers to index a value inside a data frame.
In this way, it's kind of like specifying the "coordinates" on a map.

```r
# The first element in the first column
surveys[1, 1]

# The first element in the 6th column
surveys[1, 6]

# The first column in the data frame, a vector
surveys[,1]

# Same as before
surveys[1]
```

The coordinates of a data frame's value are always specified as row-comma-column or `[row, column]`.

```r
# The first *row* in the data frame, also a vector
surveys[1,]
```

We can use a special syntax for creating a sequence of numbers in order to get, say, the first 10 rows of a data frame.

```r
1:10
surveys[1:10,]
surveys[1:10,5]
```

We can also exclude certain columns or rows using a negative sign, `-`.

```r
# All but the first column
surveys[,-1]

# All but the first three rows
surveys[-c(1,2,3),]
```

A better way to extract a named column from a data frame is to use its name.
Note that, in R, there are several ways to do the same thing.
While they each return the same *information,* they return a different data type; the first example returns a data frame, while the other examples return vectors.

```r
surveys['species_id']
surveys[,'species_id']
surveys[['species_id']]
surveys$species_id
```

### Challenge: Working with Data Frames

We saw how we can use the colon character to quickly create numeric sequences and how those numeric sequences can be used to extract the rows of a data frame.

```r
1:5
surveys[1:5,]
```

There's a more general function available in R to create number sequences.
Read the help documentation on the `seq()` function.
Then, use `seq()` to extract every 10th row of the `surveys` data frame, starting with row 10.
