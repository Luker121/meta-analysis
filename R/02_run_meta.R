run_meta <- function(df_clean) {
  suppressPackageStartupMessages(library(meta))

  metacont(n.e        = `n SG`,
           mean.e     = `Mean SG`,
           sd.e       = `Mean SD SG`,
           n.c        = `n CG`,
           mean.c     = `Mean CG`,
           sd.c       = `Mean SD CG`,
           data       = df_clean,
           studlab    = paste(Author),
           sm         = "SMD",
           method.smd = "Hedges",
           random     = TRUE,
           common     = FALSE)
}
