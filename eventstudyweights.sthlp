{smcl}
{* *! version 0.0  28aug2020}{...}
{viewerjumpto "Syntax" "eventstudyweights##syntax"}{...}
{viewerjumpto "Description" "eventstudyweights##description"}{...}
{viewerjumpto "Options" "eventstudyweights##options"}{...}
{viewerjumpto "Examples" "eventstudyweights##examples"}{...}
{viewerjumpto "Saved results" "eventstudyweights##saved_results"}{...}
{viewerjumpto "Author" "eventstudyweights##author"}{...}
{viewerjumpto "Acknowledgements" "eventstudyweights##acknowledgements"}{...}
{title:Title}

{p2colset 5 19 21 2}{...}
{p2col :{hi:eventstudyweights} {hline 2}}calculate weights underlying two-way fixed effects regressions with relative time indicators{p_end}
{p2colreset}{...}
 
{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:eventstudyweights}
{rel_time_list} {ifin}
{weight}
[{cmd:,} {it:options}]
 
{pstd}
where {it:rel_time_list} is the list of relative time indicators as specified in your two-way fixed effects regression
{p_end}
		{it:rel_time_1} [{it:rel_time_2} [...]]  

{synoptset 26 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{opth cohort(varname)}}numerical variable that corresponds to cohort (see {help eventstudyweights##by_notes:important notes below}){p_end}
{synopt :{opth rel_time(varname)}}numerical variable that corresponds to relative time

{pstd}
{opt eventstudyweights} requires {helpb hdfe} (Sergio 2015) to be installed to partial out controls and fixed effects from the relative time indicators.
{opt eventstudyweights} will prompt the user for installation of
{helpb hdfe} if necessary.
  
{syntab :Controls}
{synopt :{opth control:s(varlist)}}residualize the relative time indicators on controls and fixed effects
  
{syntab :Save Output}
{synopt :{opt saveweights(filename)}}save weights to {it:filename}.xlsx along with cohort and relative time, using Stata's built-in {helpb putexcel} {p_end}
{synoptline}
{p 4 6 2}
{opt aweight}s and {opt fweight}s are allowed;
see {help weight}.
{p_end}
 
{marker description}{...}
{title:Description}

{pstd}
{opt eventstudyweights} calculate weights underlying two-way fixed effects regressions with relative time indicators, 
and is optimized for speed in large datasets thanks to {helpb hdfe}.

{pstd}
Researchers are often also interested in dynamic treatment effects, which they estimate by the coefficients   associated with indicators for
being l periods relative to the treatment, in a specification with unit and time (two-way) fixed effects and covariates. Units are categorized into different
cohorts based on their initial treatment timing. The relative times  included in this specification cover most of
the possible relative periods, but may still exclude some periods. (Sun and Abraham 2020) show these coefficients can be written as
 a linear combination of cohort-specific effects from both its own relative period and other relative periods.

{pstd}
For each relative time indicator specified in {it:rel_time_list}, {opt eventstudyweights} calculates the weights 
underlying the linear combination of treatment effects in its associated coefficients using
an auxiliary regression. It provides built-in options to control for fixed effects and covariates
(see {help eventstudyweights##syntax:Controls}).    {cmd:eventstudyweights} exports these weights to a spreadsheet that can be analyzed separately.
 This spreadsheet also contains the cohort and relative time each weight corresponds to, with headers as specified in {opt cohort()} and {opt rel_time()}.


{dlgtab:Main}

{marker by_notes}{...}
{phang}{opth cohort(varname)} is a categorical varaible that contains the   initial treatment timing of each unit.

{phang}{opth rel_time(varname)} is a categorical varaible that contains the the relative time for each unit at each calendar time.

{pmore}
Users should shape their dataset to a long format where each observation is at the unit-time level. Users should prepare the cohort and relative time variables as illustrated in the example. 
 
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

{pstd}Suppose we will later use a specification with lead=2 and lag=0,1,2.{p_end}
{phang2}. {stata gen g_2 = ry == -2}{p_end}
{phang2}. {stata gen g0 = ry == 0}{p_end}
{phang2}. {stata gen g1 = ry == 1}{p_end}
{phang2}. {stata gen g2 = ry == 2}{p_end}

{pstd} Calculate the weights and export to a spreadsheet "weights.xlsx".{p_end}
{phang2}. {stata eventstudyweights g_2 g0 g1 g2, controls(i.idcode i.year) cohort(first_union) rel_time(ry) saveweights("weights") }{p_end}
 
{marker acknowledgements}{...}
{title:Acknowledgements}
  
{pstd}Thank you to the users of early versions of the program who devoted time to reporting
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
