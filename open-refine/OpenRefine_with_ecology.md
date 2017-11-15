# OpenRefine for Data Cleaning

Some of this material is repurposed from [the Data Carpentry lesson on OpenRefine](http://www.datacarpentry.org/OpenRefine-ecology-lesson/), which is released [under an open license](http://www.datacarpentry.org/OpenRefine-ecology-lesson/license/).
This material is released under the same license (CC BY 4.0).

## Getting the Data

The data can be obtained [from this link](https://ndownloader.figshare.com/files/7823341).

## Motivation

In any field, we often work with *messy data.*

- Tables with mixed numeric and text data in a single column;
- Fields that need to be split into two or joined into one;
- Fields with labelled values that have small, insignificant differences, such as capitalization or whitespace;
- Fields with labelled values that are spelled slightly differently for the same underlying feature.

Data from **field surveys** or **volunteered data** often have these kinds of problems.
If the data were collected or entered by multiple people, they may have different formatting standards, abbreviations, or codes that need to be *rectified to a common standard.*

We also may want to make substantive changes to our data based on our analysis goals.
We might, for instance, want to re-code values, change units, or limit values to within a certain range.
**These kinds of changes should be documented so that other people can reproduce or better understand our analysis.**

At the same time, we want to keep our raw data unchanged.
We might change our mind later about how the data should be formatted, or we may find we made a mistake.
If our data came from field surveys, in particular, we should consider it to be a permanent record of whatever we found, including mistakes.

**For all of these reasons, OpenRefine is an incredibly useful tool for transforming our data, for keeping an automatic record of the changes we make, and for applying that workflow to new data.**
Other things to note:

- OpenRefine has a large community of users (check out the [Google Group](https://groups.google.com/forum/?hl=en#!forum/openrefine)) and [a helpful book](http://www.packtpub.com/openrefine-guide-for-data-analysis-and-linking-dataset-to-the-web/book).
- OpenRefine works with tabular data up to hundreds of thousands (X00,000) of rows, but not millions or more.

## First Steps with OpenRefine

Here, we'll use OpenRefine to clean up some example data related to an ecological field survey.
OpenRefine can work with a variety of tabular data formats, including tab-separated (or TSV), comma-separated (or CSV), Excel spreadsheets, XML, and Google Spreadsheets.

1. Launch OpenRefine. Note that while the program runs in your web browser, you do not need an internet connection for any part of it to work.
2. Let's create a new project. Click `Create Project` and, under `Get data from...`, select `This Computer`.
3. Click on the `Choose Files` button, then browser your computer for the `Portal_rodents_19772002_scinameUUIDS.csv`. You should see the file name (abbreviated) next to the `Choose Files` button. Then click `Next`.
4. OpenRefine now shares a preview of our data. We should take a brief look at this preview to make sure there weren't any issues importing the data. For instance, if the data were tab-delimited but OpenRefine thought they were comma-delimited, this preview would look really strange.
5. Since there are no problems, however, we'll click `Create Project` in the upper right.

## Faceting

Our data often contain subgroups of observations, e.g., different field sites or different groups of subjects.
In OpenRefine, these subgroups are called **facets,** and we can use OpenRefine to view and modify subgroups of our table using **faceting.**

Typically, we create a facet on a particular column---the column that has an indicator for each subgroup.
The facet then summarizes the cells in that column to give you a sense of the distribution of unique values, allowing us to subset the rows in our tables to just those that satisfy some constraint.

**Here, we'll use faceting to look for potential errors in the `scientificName` column.**
Again, these data are from a field survey and involved multiple investigators collecting data.
It's possible that one or more species has multiple versions of its scientific name in this column, based on the preferences of the investigator entering the data.

1. Scroll over to the `scientificName` column.
2. Click the downward-pointing arrow to the right of the column name and choose `Facet`, then `Text facet`.

In the left panel, you'll now see a box containing every unique value in the `scientificName` column along with a number representing how many times that value occurs in the column. **We can immediately see that some species names appear multiple times in this list.**

### Name Collisions

Why does `Amphispiza bilineata` appear twice? How can we fix it?

**If you hover over a name in the left-hand list, you'll see two options.**

- We can `include` each set of rows with that unique value; they will appear in the right-hand panel for as many sets we choose.
- We can `edit` the unique value to change it to something else, *for all rows that contain that value.*

If we choose to `edit` one of the *Amphispiza bilineata* entries, we can immediately see what is wrong.
There is extra whitespace in both entries and the amount differs between them.
We certainly don't need this whitespace and it certainly doesn't convey any difference between these two labels.
**We could `edit` these labels to make them the same but OpenRefine offers a faster and more general way to fix these kinds of problems that we'll see in a moment.**

### Challenge: Learning from Faceting

Working alone or with a partner... Try to answer these questions with faceting:

1. How many years are represented in this dataset?
2. Is the column formatted as Number, Date, or Text? How does changing the format change the faceting display?
3. Which years have the most observations? The fewest observations?

## Clustering

In OpenRefine, we can use a technique called *clustering,* to find groups of similar values, or similar labels, within a given column.
This is a powerful approach for cleaning datasets that contain mispelled or mistyped entries.

1. Looking again at the left-hand panel for `scientificName`, click the `Cluster` button.
2. In the pop-up window, we are presented with some options that allow us fine-grained control over how clustering works.

### Challenge: Clustering Similar Names

Working alone or with a partner... Experiment with different methods and **keying functions** to find variations on scientific names that ought to be comined under a single label.

- When you're confident that all of the **`Values in Cluster`** shown are related and you are happy wih the **`New Cell Value`** as the resulting, common label for all of those cases, check the box under `Merge?`.
- When you're confident that you've found all of the clusters in the `scientificName` column. Click the **`Merge Selected & Re-Cluster`** button at the bottom of the box.

## Undo and Redo Steps

**To make sure we're all on the same page, regardless of the clustering method we used, let's "undo" the clustering step.**
As I mentioned earlier, OpenRefine keeps track of every change we make to our data.
This has important implications for the larger goal of **scientific provenance,** that is, the complete record of where our scientific conclusions came from.
In addition to providing this record, OpenRefine allows us to step backwards and forwards in our workflow.

1. Close the clustering pop-up (if necessary) and, at the top-left of the program, find and click on the `Undo/Redo` tab.
2. Here is a list of all the steps we've taken in changing our data. Step 0 is always the creation of our project. We've only made one change so far, which is described as something like "Mass edit X cells in column scientificName."
3. If we click on Step 0 ("Create project"), our working dataset will be reset to the way it looked when we first created our project. That is, the clustering step will be undone.
4. Click on the `Facet/Filter` tab at the top-left to go back to our view of the facet on `scientificName`.

**Now, let's cluster `scientificName` again; this time, we'll all use `key collision` as our method and `cologne-phonetic` as our keying function.**

## Splitting and Merging Columns

If data in a column needs to be split into multiple columns and the parts are separated by a common delimiter (e.g., a comma or space character), then we can use that delimiter to divide up the pieces into their own columns.

1. For example, let's say we want to split `scientificName` into separate columns for genus and species.
2. Click the downward-pointing arrow to the right of the `scientificName` column header. Choose `Edit Column`, and then `Split into several columns...`
3. In the pop-up window, in the `Separator` box, change the comma to a single space character.
4. Uncheck the box that says `Remove this column`.
5. Click `OK`; now we have four new columns named `scientificName 1`, `scientificName 2`, and so on.

**Why do we have four new columns instead of two? Why do the last two appear to be blank for every entry?**
It seems that some of our scientific names still had trailing whitespace characters.
Those entries for `scientificName` must not have been detected by our clustering algorithm.
Next, we'll see a better way to fix leading and trailing whitespace characters.

## Fixing Leading and Trailing Whitespace

**First, let's `Undo` the split we just performed.**

OpenRefine provides a tool to remove blank characters, like tabs and spaces, from the beginning and end of any entries that have them.

1. In the header's drop-down menu for the column `scientificName`, choose `Edit cells`, then `Common transforms`, then `Trim leading and trailing whitespace`.
2. Now, perform the `Split` operation from earlier on the `scientificName` column. This time, you should see only two new columns.

### Challenge: Renaming Columns

As a group... You can rename columns by choosing `Edit Column` and then `Rename this column` from the drop-down menu by the column header. Try renaming the `scientificName 2` column to `species`.

Did you get an error? Why? How can you fix it?

## Filtering

We can filter to a subset of the rows in our table by defining rules for matching rows.

1. In the context menu for `scientificName`, select `Text filter`.
2. Type `bai`; there should be 48 matching rows out of the original 35,549 rows.
3. At the top change the view to `Show` 50 `rows`.

We get two total species returned. If we wanted to limit our selection to one species, *Chaetodipus baileyi,* we could make our search string case-sensitive.

**Faceting and filtering look very similar. A good distinction is that faceting gives you an overview description of all of the data that is currently selected, while filtering allows you to select a subset of your data for analysis.**

Click the `Remove All` button at the top-left before continuing.

## Sorting

`TODO`

## Examining Numeric Data

When a table is first imported into OpenRefine, al of the columns are treated as containing text values.
This provides maximum flexibility, without any danger of unintentional changes to your data.
How can we transform text columns into other data types?

1. From the context menu for `recordID`, select `Edit cells`, then `Common transforms...`, then `To number`.
2. Note the change in alignment and text color for the values in this column.

### Challenge: Transforming Data Types

Transform three more columns, including the `period` column, from text to numbers.
Can all columns be transformed to numbers?

### Missing Values or Errors

In numeric columns, we often have missing values or clearly erroneous values entered.
We can fix these using a `Numeric facet`.

1. For a column you transformed to numbers, edit one or two cells, replacing the numbers with text (such as `x` or `missing`) or make them blank.
2. From the context menu for that column, apply a `Numeric facet`.
3. Note that there are several checkboxes in this facet: `Numeric`, `Non-numeric`, `Blank`, and `Error`. Below these are counts of the number of cells in each category. You should see checkboxes for `Non-numeric` and `Blank` if you changed some values.

**By checking/ un-checking these boxes, we can identify missing or corrupted values in a given numeric column.**

### Scatterplot Faceting

Now that we have multiple columns representing numbers, we can see how they relate to one another using the scatterplot facet.

1. From the context menu for the `recordID` column, select `Facet` and then `Scatterplot facet`.
2. A new window called `Scatterplot Matrix` has appeared.
3. Click on just one of the scatterplots. This will allow us to facet our data using just the relationship between those two variables.
4. In the scatterplot in the left-hand panel, click, hold, and drag the cursor to create a rectangle. **This will facet the table by those records that fall within the parameter space of your rectangle.**

### Challenge: Faceting and Filtering

Apply a text filter again to the `scientificName` column; e.g., search for `bai`. Notice how the scatterplot has changed.
