
# Test against Stata equivalent
# bcstats,                         ///
#   surveydata(bcstats_survey.dta) ///
#   bcdata(bcstats_bc.dta)         ///
#   id(id)                         ///
#   t1vars(gender)                 ///
#   t2vars(gameresult)             ///
#   t3vars(itemssold)              ///
#   enumerator(enum)               ///
#   enumteam(enumteam)             ///
#   backchecker(bcer)              ///
#   replace

result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer",
                  nodiff      = list(gameresult = 10))

stata_raw <- 'id,enum,type,variable,survey,back_check
              5,"dean","type 1","gender","female","."
              7,"dean","type 1","gender","female","."
              6,"annie","type 1","gender",".","male"
              2,"mark","type 1","gender","female","."
              9,"brooke","type 1","gender","female","."
              11,"lisa","type 1","gender","female","."
              12,"hana","type 1","gender","female","."
              14,"rohit","type 1","gender","female","."
              6,"annie","type 2","gameresult","10","."
              8,"annie","type 2","gameresult","7","."
              4,"ife","type 2","gameresult","10","."
              10,"brooke","type 2","gameresult","14","."
              3,"lisa","type 2","gameresult","12","."
              1,"hana","type 2","gameresult","10","."
              13,"mateo","type 2","gameresult","14","."
              14,"rohit","type 2","gameresult","11","14"
              5,"dean","type 3","itemssold","3","5"
              6,"annie","type 3","itemssold","7","."
              8,"annie","type 3","itemssold","3","."
              2,"mark","type 3","itemssold","7","10"
              4,"ife","type 3","itemssold","5","."
              10,"brooke","type 3","itemssold","1","."
              3,"lisa","type 3","itemssold","1","."
              1,"hana","type 3","itemssold","2","."
              12,"hana","type 3","itemssold","3","6"
              13,"mateo","type 3","itemssold","1","."'

csv.con         <- textConnection(stata_raw)
stata.backcheck <- read.csv(csv.con,
                            quote            = "",
                            stringsAsFactors = FALSE)
close(csv.con)

compare(stata.backcheck,
        result$backcheck, equal = TRUE)
