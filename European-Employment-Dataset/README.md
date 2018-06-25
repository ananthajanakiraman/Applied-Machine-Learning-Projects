**Dataset**

We can find a dataset dealing with European employment in 1979 at http://lib.stat.cmu.edu/DASL/Stories/EuropeanJobs.html. This dataset gives the percentage of people employed in each of a set of areas in 1979 for each of a set of European countries. This is a good dataset that works well for visualization of clustering.

Use an agglomerative clusterer to cluster this data. Produce a dendrogram of this data for each of single link, complete link, and group average clustering. You should label the countries on the axis. What structure in the data does each method expose? it's fine to look for code, rather than writing your own. Hint: I made plots I liked a lot using R's hclust clustering function, and then turning the result into a phylogenetic tree and using a fan plot, a trick I found on the web; try plot(as.phylo(hclustresult), type='fan'). You should see dendrograms that "make sense" (at least if you remember some European history), and have interesting differences.
Using k-means, cluster this dataset. What is a good choice of k for this data and why?
