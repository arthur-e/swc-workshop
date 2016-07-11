# Introduction to R

Adapted from [Tracy K. Teal's lesson](http://tracykteal.github.io/r-novice-gapminder/) and [John Moreau's workshop at the Federal Reserve Board](https://github.com/JohnRMoreau/2016-04-07-FederalReserveBoard/wiki) under a CC-By-SA license.

## Overview

The goal of this lesson is to introduce non-programmers or begining programmers to the R programming language.
R is commonly used in many scientific disciplines for statistical analysis.
This workshop will focus on R as a general purpose programming language and data analysis tool, not on any specific statistical analysis.

### The Data

In this workshop, we will be using a subset of [the Gapminder dataset](http://www.gapminder.org/).
This is world wide statistical data collected and curated to allow for a "fact based worldview."
These data includes things like employment rates, birth rates, death rates, percent of GDP that's from agriculture and more.
There are currently 519 variables overall, each as a time series.

You can see some examples of Gapminder's visualizations [in this TED video](http://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen).
In this workshop, we'll focus just on **life expectancy at birth** and **per-capita GDP** by country, continent, and total population.

## Introduction to R and RStudio

There are two tools we're going to be using for this part of the workshop.
One is the R programming language.
**A programming language contains keywords and a prescribed grammar for linking words together** in a way that makes sense, just like a natural human language.
Programming languages differ in that **they describe a task or a series of tasks we would like a computer to execute.**

The other tool we're using is called RStudio.
**RStudio is what we would call an interactive development environment, or IDE.**
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

## Introduction to the R Language

**As we're going to be learning about the R programming language, we'll first use it interactively.**
The pane where we enter R commands interactively is called the **R console.**
Some things to note about the R console:

* The version of R that we have installed is indicated by the version number printed on the first line. The R Foundation also gives cute names to these versions that may or may not be easier to remember.
* The R console prompts us to type in commands with a right angle-bracket. This angle bracket is called **the prompt** and it simply tells us that R is ready to receive our commands. When R is executing a command that takes a little bit of time, we might not see the prompt, like this in example, where I tell R to sleep for 5 seconds:
```r
Sys.sleep(5)
```

* The lack of a prompt means that R is busy. Notice that there is a little red stop sign at the top right of the console when R is busy. **If I want to tell R to stop what it's doing an return to waiting for my commands, I can hit the stop button. You can also hit the Esc key.** Unless my computer is so overloaded that it can't even respond, I should get my prompt back immediately after hitting this button.

### Using R as a Calculator

One of the simplest things we can use R for is arithmetic.
Try typing in these examples as I do.

```r
1 + 100
```

I hit the Enter key after typing this line to ask R to interpret my command and evaluate it.
Note that R prints the output directly below the line where I entered it and, once it is done, it displays a new prompt for my next input.
It also displays the number 1 in brackets: "[1]" right before the answer.
We'll talk about this later so, for now, just think of this as indicating the output.
**If I type an incomplete command and hit Enter, R will wait for me to complete the command on the next line.**

```r
1 +
```

The plus sign shown here isn't the plus sign in my addition problem.
Rather, anytime that you see this symbol instead of the prompt, it indicates that R is waiting for you to complete your command.
If you want to cancel this command in progress, you can hit the Esc key.

When using R as a calculator, the order of operations is just as you'd expect:

```r
3 + 5 * 2
```

However, we can use parentheses to specify the order of operations manually.
It's generally a good idea to use parentheses anytime the order of operations isn't clear from glancing at the code.

```r
(3 + 5) * 2
```

In R, very large or small numbers will often be expressed in scientific notation.

```r
2/10000
```

We can write in scientific notation as well.

```r
5e3
```

### Mathematical Functions

R has a number of built in mathematical functions.
We'll discuss how to create functions in R later.
To execute a function in R, we type its name, followed by parentheses.
**This is referred to as calling the function.**
Anything we type inside the parentheses are referred to as **arguments of the function.**

Here is the natural logarithm:

```r
log(1)
```

**Here, the number 1 is the argument of the natural log function.**
We are asking for the natural logarithm of the number 1.
The base-10 logarithm is called like this:

```r
log10(10)
```

**How can we remember all of these function names?**
We don't have to.
We can rely on R to help us by either autocompleting a function whose name we remember part of or by searching for a function's name.

For example, **if I type the following and then hit the Tab key:**

```r
?ex
```

I can see all the function names that begin with these two letters.
The function I was thinking of is the `exp()` function; the inverse of the natural logarithm.
If I use the question mark with a full function name and hit Enter, I can pull up the help documentation for that function.

```r
?exp
```

Two question marks will perform a keyword search of the available help documentation.

```r
??exponential
```

### Other Operators in R

**The mathematical symbols we just saw are referred to as operators in R.**
There are other operators we can use to compare things, as in the following examples.

```r
1 == 1
```

Here, `TRUE` in all capital letters is a special value that indicates something is true.
The double-equal sign is one of a group of **comparison operators**; this one tests to see whether or not two values, one of the left side and the other on the right side, are equal to each other.
Here's another example that is `TRUE`.

```r
1 != 2
```

This operator is the opposite of the comparison operator we just saw; this one determines whether or not the two values are *not* alike.
The exclamation mark, in general, can be read as "not."
It has a meaning that is the opposite of what it is attached to.
For instance:

```r
!TRUE
```

**As we can see, "not true" is indeed false.**
`FALSE`, in all capital letters, is a special value that is the opposite of the special value `TRUE`.
Here are some examples of comparison operators.

```r
1 < 2
```

"One less than two" is just what we'd expect.
Same for less-than-or-equal, greater-than, and greater-than-or-equal.

```r
1 <= 1
1 > 0
1 >= -3
```

### Variables and Assignment

When we want R to remember a value or store the result of a calculation, we can give that value or result a name.
**The name itself is called a variable, because the name could be given to any other value. We assign values to variables using the assignment operator.**

```r
x <- 1/2
```

<!--TODO for advanced version of lesson: Discuss alternative equal sign as assignment operator and edge cases:
log(x=5)
x
log(x <- 5)
x
-->

You can think of the assignment operator as an arrow from the value to the variable; it "points" where to put the value.
Note that when we use assignment to store a variable, the result isn't printed to the screen.
We can request R to read the result back to us when we ask R for the value of the named variable.

```r
x
```

It's important to put proper spacing around the assignment operator.
Otherwise, it can be confusing whether you intended to type:

```r
x<-4
x < -4 # less than -4?
x <- 4 # or store the value -4?
```

If we look in the **Environment** tab, we can see the value of our variable `x` at any time.
We can now use `x` in place of its value in any calculation that expects a number.

```r
log(x)
```

**We can re-assign variables to new values.**

```r
x <- 100
x
```

We can also use the value of a variable to update that same variable.
**More generally, the right side of an assignment expression can be any valid R expression.**

```r
x <- (x + 1)
x
```

#### Variable Names

There are some restrictions on the names we can use for variables.
**Variable names can contain only letters, numbers, underscores, and periods.**
Here are some examples:

* `periods.between.words`
* `underscores_between_words`
* `camelCaseVariableNames`

<!--TODO for advanced: Suggestions of idiomatic R variable names-->

## Conclusion and Summary

**Now you should be familiar with the following:**

* The user interface of the RStudio IDE;
* Variables in R and their assignment;
* Managing your workspace in an interactive R session;
* Use of mathematical and comparison operators in R;
* Calling functions in R.
