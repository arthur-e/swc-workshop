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
