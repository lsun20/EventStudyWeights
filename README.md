# EventStudyWeights

**eventstudyweights** is a Stata package that estimates the implied weights on the cohort-specific average treatment effects 
on the treated (CATTs) underlying two-way fixed effects regressions 
with relative time indicators (event study specifications) as derived in Sun and Abraham (2020).  An accompanying package [eventstudyinteract](https://github.com/lsun20/EventStudyInteract)
implements the interaction weighted estimator for an event study proposed by Sun and Abraham (2020) as an alternative to the canonical two-way fixed effects regressions with relative time indicators.  

## Installation
**eventstudyweights** can be installed easily via the `github` package, which is available at [https://github.com/haghish/github](https://github.com/haghish/github).  Specifically execute the following code in Stata:

`net install github, from("https://haghish.github.io/github/")`

To install the **eventstudyweights** package , execute the following in Stata:

`github install lsun20/eventstudyweights`

which should install the dependency packages.  If not working, try manually install

`ssc install hdfe`  

To update the **eventstudyweights**  package, execute the following in Stata:

`github update eventstudyweights`

Documentation is included in the Stata help file that is installed along with the package.  An empirical example is provided in the help file.

## Authors and acknowledgment
Liyang Sun

Preprint of Sun and Abraham (2020) is available on [my personal website](http://economics.mit.edu/files/14964).

Thank you to the users of the program who devoted time to reporting
the bugs that they encountered.