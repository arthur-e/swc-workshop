# Optimizing R Performance

Optimization is not something we should usually worry about.
Typically, when we start to optimize our code, we end up spending more time tweaking with the code than we save in improved performance.
If our data become very large, we might be forced to consider how to improve our R code in order to get it to run at all.
**In most cases, however, there are well-understood best practices we can follow to get the most out of R.**

There are two areas in particular where less experienced R users end up writing fairly inefficient code: iteratively generating results and applying a function to a data frame or matrix.
**Before we can demonstrate more efficient ways of completing these tasks, we need to develop a way to measure how efficient our R code is.**

```r
install.packages(c('microbenchmark', 'lineprof'))
```

## Benchmarking

Recall that we've seen multiple ways of aggregating data stored in an R data frame.
We might be interested to know which of these ways is "fastest," i.e., completes in the least time, on average, for a wide variety of cases.
**Timing computer operations in order to determine how they could be sped up is called benchmarking.**
[Here are some benchmarks for multiple ways of aggregating data in R.](http://jaredlander.com/content/2015/04/MakingRGoFasterAndBigger.html#29)
Things to note:

- Using `plyr` in parallel is slower than using `plyr` in a single-threaded, single-core fashion. It's important to remember that parallelization incurs overhead which can often take more time than running the same operation on a single thread or single core!
- The built-in `tapply()` function is almost always faster than `ddply` in the `plyr` package.
- `dplyr` is faster still than `tapply()` but not nearly as fast as using `data.table`.

**In R, we can perform benchmarks using the `microbenchmark` package.**

```r
library(microbenchmark)
x <- rnorm(100)
microbenchmark(
  mean(x),
  sum(x) / length(x)
  )
```

Here, we see the minimum, maximum, and mean amount of time it takes to complete two different operations, both designed to calculate the mean of a vector.
The reason that the `mean()` function is slower than dividing the sum by its length is not important but its because the `mean()` function does additional work to improve accuracy.

For clarity and consistency in benchmarking, we usually want to encapsulate whatever we're comparing in separate functions.
For instance, we know there are several ways of accessing the first column of the `gapminder` data frame.

```r
access1 <- function (x) gapminder[,1]
access2 <- function (x) gapminder$country
access3 <- function (x) gapminder['country']
# access4 <- function (x) gapminder[[1]]
# access5 <- function (x) gapminder[['country']]

microbenchmark(
  access1(),
  access2(),
  access3()
  )
```

This way, we can also make sure that our comparisons are valid in that they all produce the same result.

```r
all.equal(access1(), access2(), access3())
```

## Pre-Allocation

Now that we know how to compare the performance of different operations, let's look at a common operation in data analysis in R: growing a data frame or list of results.
You may be tempted to write such a procedure this way.

```r
out1 <- function (n) {
  outputs <- numeric()
  for (i in 1:n) outputs <- c(outputs, i)
}
```

However, what if we told R ahead of time how big the output vector was going to be?
**This is called pre-allocation, because we are pre-allocating the size of our array.**

```r
out2 <- function (n) {
  outputs <- numeric(n)
  for (i in 1:n) outputs[i] <- i
}

microbenchmark(
  out1(1e2),
  out2(1e2),
  out1(1e3),
  out2(1e3)
  )
```

**We see that both methods get slower as the number of iterations increases, as we would expect. However, the first method, growing the output vector, slows down considerably more than the second method.**
This is because, when R starts the `for` loop, it puts the `output` vector somewhere in memory but, as the output vector grows bigger, there's not enough room in that particular location in memory, so R has to stop iterating the loop, move the vector, and grow it again.
If the output vector grows considerably large, R may have to move it around several times!

## Vectorization

Avoiding growing your objects is one way to dramatically "speed up" your R code.
Another technique you may have heard about is called vectorization.
Vectorization involves thinking about a task not just as an operation applied to a single input value over and over again but, rather, the same operation applied to a sequence or *vector* of values.
The main reason why vectorization is faster in R is because vectorized code is implemented in C, a language that compiles to instructions a computer can execute much more quickly than R code.

To understand what a vectorized function looks like, let's turn to one of the built-in functions in R.
**The `log()` function can operate on a single value but also a vector of values in the same way.**

```r
log(1)
log(1:10)
```

Is it faster?
Let's imagine we want to take the sum of the logarithms of a vector.

```r
sum1 <- function (x) {
  output <- 0
  for (i in 1:length(x)) output <- output + log(x[i])
  output
}

sum2 <- function(x) sum(log(x))

x <- runif(100, 1, 100)
all.equal(sum1(x), sum2(x))

microbenchmark(
  sum1(x),
  sum2(x)
  )
```

It may seem obvious why the second method is so much faster--it also requires less typing!
But the challenge for real-world applications that you'll encounter is to find the R function connected to underlying compiled code that does what you need it to do.

Vectorization isn't always the answer and some things that look vectorized, like the `apply()` family of functions, are really `for` loops in disguise.
It's also important to remember that if your dataset is very large with many more rows than columns, vectorization can use a large amount of memory.

**Ultimately, you should only start to optimize your code after you have verified it works exactly as intended and you've done all the debugging you need to do.**
Furthermore, you should only spend time optimizing the slowest parts of your code.
We saw how benchmarking can help you compare the speeds for certain, known operations.
How can we determine which of many different parts in an R script are the slowest?

## Line Profiling

Line profiling is a technique that measures the amount of time and memory each line of your code requires.
