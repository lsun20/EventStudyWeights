{smcl}
{* *! version 0.2  29aug2021}{...}
{viewerjumpto "Syntax" "eventstudyweights##syntax"}{...}
{viewerjumpto "Description" "eventstudyweights##description"}{...}
{viewerjumpto "Options" "eventstudyweights##options"}{...}
{viewerjumpto "Examples" "eventstudyweights##examples"}{...}
{viewerjumpto "Saved results" "eventstudyweights##saved_results"}{...}
{viewerjumpto "Author" "eventstudyweights##author"}{...}
{viewerjumpto "Acknowledgements" "eventstudyweights##acknowledgements"}{...}
{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{hi:eventstudyweights} {hline 2}}
estimate the implied weights on the cohort-specific average treatment effects 
on the treated (CATTs) underlying two-way fixed effects regressions 
with relative time indicators (event study specifications).
To estimate the dynamic effects of an absorbing treatment, researchers often use two-way fixed effects regressions that include leads and lags of the treatment (event study specification). 
Units are categorized into different cohorts based on their initial treatment timing. 
Sun and Abraham (2020) show the coefficients in this event study specification can be written as a linear combination of cohort-specific effects from both its own relative period and other relative periods. 
{opt eventstudyweights} is a Stata module that estimates these weights for any given event study specification.
For the latest version, please check {browse "https://github.com/lsun20/EventStudyWeights":https://github.com/lsun20/EventStudyWeights}.
{break}
Sun and Abraham (2020) also propose the interaction weighted (IW) estimator as an alternative estimator for the estimation of dynamic effects.
{opt eventstudyinteract} is a Stata model that implements the IW estimator and is maintained at
{browse "https://github.com/lsun20/eventstudyinteract":https://github.com/lsun20/eventstudyinteract}.
{p2colreset}{...}

 
{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:eventstudyweights}
{rel_time_list} {ifin}
{weight} {cmd:,} {opth cohort:(eventstudyweights##main:variable)}
            {opth rel_time:(eventstudyweights##main:variable)} 
			{opth absorb:(reghdfe##absvar:absvars)} 
 [{it:options} {opth covariates:(eventstudyweights##main:varlist)} {opth saveweights:(eventstudyweights##main:filename)}]
 
{pstd}
where {it:rel_time_list} is the list of relative time indicators as specified in your two-way fixed effects regression. See {help eventstudyweights##examples:illustration} for an example of generating these relative time indicators. 
The relative time indicators should take the value of zero for never treated units.  {p_end} 

{pstd}
Users should shape their dataset to a long format where each observation is at the unit-time level. 
The syntax is similar to {helpb reghdfe} in specifying fixed effects (with {help hdfe##opt_absorb:absorb}) and regressors other than the relative time indicators need to be specified separately in {opth covariates(varlist)}.
Furthermore, the syntax also requires the user to specify the cohort categories as well as the relative time categories (see {help eventstudyweights##main:explanations below}). 
See {help eventstudyweights##examples:illustration} for an example of specifying the syntax.

{synoptset 26 tabbed}{...}
{synopthdr :options}
{synoptline}
{marker main}{...}
{syntab :Main}
{synopt :{opth cohort(varname)}}categorical varaible that contains the initial treatment timing of each unit. This categorical variable should be set to be missing for never treated units.{p_end}
{synopt :{opth rel_time(varname)}}categorical varaible that contains the time relative to initial treatment for each unit at each calendar time.

{pstd}
{opt eventstudyweights} requires {helpb hdfe} (Sergio 2015) to be installed to partial out controls from the relative time indicators.
{opt eventstudyweights} will prompt the user for installation of
{helpb hdfe} if necessary.
  
{syntab :Controls}
{synopt :{opth absorb(varlist)}}specifies unit and time fixed effects.{p_end}
{synopt :{opth covariates(varlist)}}specify covariates that lend validity to the parallel trends assumption, i.e. covariates you would have included in the canonical two-way fixed effects regressions. {p_end}

{syntab :Save Output}
{synopt :{opt saveweights(filename)}}if specified, save weights to {it:filename}.xlsx along with cohort and relative time, using Stata's built-in {helpb putexcel} {p_end}
{synoptline}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed;
see {help weight}.
{p_end}
 
{marker description}{...}
{title:Description}

{pstd}
{opt eventstudyweights} estimate weights underlying two-way fixed effects regressions with relative time indicators, 
It is optimized for speed in large panel datasets thanks to {helpb hdfe}.


{pstd}
For each relative time indicator specified in {it:rel_time_list}, {opt eventstudyweights} estimates the weights 
underlying the linear combination of treatment effects in its associated coefficients using
an auxiliary regression. It provides built-in options to control for fixed effects and covariates
(see {help eventstudyweights##syntax:Controls}).    {cmd:eventstudyweights} saves these weights in {cmd:e(weights)}.  If specified in in {cmd:saveweights}, exports these weights to a spreadsheet that can be analyzed separately.
 This spreadsheet also contains the cohort and relative time each weight corresponds to, with headers as specified in {opt cohort()} and {opt rel_time()}.

{marker examples}{...}
{title:Examples}

{pstd}Load the 1968 extract of the National Longitudinal Survey of Young Women and Mature Women.{p_end}
{phang2}. {stata webuse nlswork, clear}{p_end}

{pstd}Code the cohort categorical variable based on when the individual first joined the union.{p_end}
{phang2}. {stata gen union_year = year if union == 1 }{p_end}
{phang2}. {stata "bysort idcode: egen first_union = min(union_year)"}{p_end}
{phang2}. {stata drop union_year }{p_end}
 
{pstd}Code the relative time categorical variable.{p_end}
{phang2}. {stata gen ry = year - first_union}{p_end}

{pstd}Suppose we will later use a specification with lead<=-2 and lag=0,1,>=2 to estimate the dynamic effect of union status on income.  We first generate these relative time indicators.{p_end}
{phang2}. {stata gen g_2 = ry <= -2}{p_end}
{phang2}. {stata gen g0 = ry == 0}{p_end}
{phang2}. {stata gen g1 = ry == 1}{p_end}
{phang2}. {stata gen g2 = ry >= 2}{p_end}

{pstd} For the coefficient associate with each of the above relative time indicators in a two-way fixed effects regression, we can estimate the weights and export to a spreadsheet "weights.xlsx".{p_end}
{phang2}. {stata eventstudyweights g_2 g0 g1 g2, absorb(i.idcode i.year) cohort(first_union) rel_time(ry) saveweights("weights") }{p_end}
{pstd} Alternatively, we can view the weights in Stata.{p_end}
{phang2}. {stata eventstudyweights g_2 g0 g1 g2, absorb(i.idcode i.year) cohort(first_union) rel_time(ry) }{p_end}
{phang2}. {stata mat list e(weights)}{p_end}
 
{pstd} To examine  the weights underlying the coefficient associate with, e.g.,  relative time indicator lead=2, you may try {p_end}
{phang2}. {stata import excel "weights.xlsx", clear firstrow}{p_end}
{phang2}. {stata keep g_2 first_union ry}{p_end}

{pstd} You may also check the weights have properties discussed in the paper and visualize the properties: {p_end}
{phang2}. {stata collapse (sum) w_sum = g_2, by(ry)}{p_end}
{phang2}. {stata label variable w_sum "cohort-ry weights in TWFE g_2 coefficient (sum across cohorts)"}{p_end}
{phang2}. {stata twoway bar w_sum ry, graphregion(fcolor(white)) scheme(sj)}{p_end}


{marker acknowledgements}{...}
{title:Acknowledgements}
  
{pstd}Thank you to the users of the program who devoted time to reporting
the bugs that they encountered.
 
{marker references}{...}
{title:References}
 
{marker SC2015}{...}
{phang}
Correia, S. 2015.
HDFE: Stata module to partial out variables with respect to a set of fixed effects
{browse "https://ideas.repec.org/c/boc/bocode/s457985.html":https://ideas.repec.org/c/boc/bocode/s457985.html
{p_end}

{marker SA2020}{...}
{phang}
Sun, L. and Abraham, S. 2020.
Estimating Dynamic Treatment Effects in Event Studies with
Heterogeneous Treatment Effects
{p_end}

{marker citation}{...}
{title:Citation of eventstudyweights}

{pstd}{opt eventstudyweights} is not an official Stata command. It is a free contribution
to the research community, like a paper. Please cite it as such: {p_end}

{phang}Sun, L., 2020.
eventstudyweights: weights underlying two-way fixed effects event studies regressions.
{browse "https://github.com/lsun20/EventStudyWeights":https://github.com/lsun20/EventStudyWeights}.
 
{marker author}{...}
{title:Author}

{pstd}Liyang Sun{p_end}
{pstd}lsun20@mit.edu{p_end}
