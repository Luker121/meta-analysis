make_panel <- function(meta_obj, panel_title,
                       xlim_common,
                       left_pad_mm = 2,
                       title_gap   = 0) {

  suppressPackageStartupMessages({
    library(grid)
    library(gridExtra)
  })

  fg <- grid.grabExpr(
    forest(meta_obj,
           newpage     = FALSE,
           sortvar     = meta_obj$studlab,
           sortstudies = TRUE,
           xlim        = xlim_common,
           xlab        = "Hedges' g",
           digits.sd   = 2,
           digits.pval = 3,
           digits      = 2,
           digits.w    = 2)
  )

  arrangeGrob(
    textGrob(panel_title,
             x   = unit(left_pad_mm, "mm"),
             just = "left",
             gp   = gpar(fontface = "bold", cex = .9)),
    fg,
    ncol    = 1,
    heights = unit.c(unit(title_gap, "lines"),
                     unit(1, "null"))
  )
}

plot_stacked <- function(panels, study_label, outfile) {
  suppressPackageStartupMessages({
    library(grid)
    library(gridExtra)
  })

  spacer   <- unit(5, "mm")
  combined <- arrangeGrob(grobs   = c(rbind(panels, list(nullGrob())))[-length(panels)*2],
                          ncol    = 1,
                          heights = rep_len(unit.c(unit(1, "null"), spacer),
                                            length.out = length(panels)*2 - 1))

  pdf(outfile, width = 7, height = 9)
  grid.newpage()
  grid.text(study_label,
            gp = gpar(fontface = "bold", cex = 1.2),
            y  = unit(1, "npc") - unit(.7, "lines"))
  grid.draw(combined)
  dev.off()

  msg("Figure written to ", outfile)
}
