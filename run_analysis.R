#!/usr/bin/env Rscript
# Main script: loads data, runs meta‑analysis, and saves stacked forest plots
# ---------------------------------------------------------------------------

suppressPackageStartupMessages({
  library(here)        # install.packages("here")
  library(gtable)
})

source(here("R/01_load_and_clean.R"))
source(here("R/02_run_meta.R"))
source(here("R/03_plot_forest.R"))

# ---------------------------------------------------------------------------
# 1. PARAMETERS ---------------------------------
# ---------------------------------------------------------------------------
xlsx_files <- list(
  burden     = here("data/Burden.xlsx"),
  depression = here("data/Depression.xlsx"),
  anxiety    = here("data/Anxiety.xlsx")
)
sheets      <- c("EoT", "FU")       # Excel tabs we need
out_dir     <- here("output")

if (!dir.exists(out_dir)) dir.create(out_dir)

# ---------------------------------------------------------------------------
# 2. ANALYSIS LOOP -------------------------------
# ---------------------------------------------------------------------------
for (study in names(xlsx_files)) {

  msg("Processing ", study, "...")

  metas <- lapply(
    sheets,
    function(sh) {
      df  <- load_and_clean(xlsx_files[[study]], sh)
      run_meta(df)
    }
  )
  names(metas) <- sheets

  # common x‑limits
  xlim_common <- range(
    floor(min(sapply(metas, `[[`, "lower")) * 10) / 10,
    ceiling(max(sapply(metas, `[[`, "upper")) * 10) / 10
  )

  # build panels
  panels <- list(
    make_panel(metas$EoT, "A) End of Treatment", xlim_common),
    make_panel(metas$FU,  "B) Follow‑Up",        xlim_common)
  )

  # plot & save
  plot_stacked(panels,
               paste("Forest Plots for", tools::toTitleCase(study),
                     "(EoT and Follow‑Up)"),
               file.path(out_dir,
                         paste0("forest_", study, ".pdf")))
}
