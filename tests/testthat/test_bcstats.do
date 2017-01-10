set more off

* Run a basic usage example of bcstats in Stata
* Required packages:
* - bcstats: Because that's the Stata package we're replicating!
* - mat2txt: In order to export the matrices from Stata to a .csv

* First set locals to store paths to data
local survey "../../data/bcstats_survey.dta"
local bc     "../../data/bcstats_bc.dta"

log using "base.smcl", smcl replace name(base)
bcstats,                ///
  surveydata(`survey')  ///
  bcdata(`bc')          ///
  id(id)                ///
  t1vars(gender)        ///
  t2vars(gameresult)    ///
  t3vars(itemssold)     ///
  enumerator(enum)      ///
  enumteam(enumteam)    ///
  backchecker(bcer)     ///
  filename(bc_base.csv) ///
  replace
log close base

foreach bcmat in enum1 enum2 backchecker1 backchecker2 enumteam1 enumteam2 {
	matrix `bcmat' = r(`bcmat')
	mat2txt, matrix(`bcmat') saving(`bcmat'_base.tsv) replace
}
