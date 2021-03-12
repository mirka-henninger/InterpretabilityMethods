#' Plot colored PD curves
#'
#' This function allows to plot colored pd predictions for one feature, colored by a covariate
#'
#' @param pred A prediction object from package iml
#' @param feature A character vector containing the names of the feature for which the plot should be created
#' @param covar A character string indicating the covariate after which the ICE curves should be colored
#' @param title An optional character string indicating the title of the plot
#' @param xlabel An optional character string of the same length as the number of feature indicating the x-axis label of the single plots
#' @param legend_title A character indicating the legend title. Default is the name of 'covar'
#' @param legend_position Logical indicating whether the legend should be shown. Default is TRUE
#'
#' @return a plot of type ggplotify
#'
#' @export
colored_pdp <- function(pred, feature, covar, title = "", xlabel = feature,
                        legend_title = covar, legend_position = "right"){
  dat <- pred$data$X
  dat$id <- row.names(dat)
  emptyPlot <- ggplot2::ggplot()
  listPlot <- list(emptyPlot)
  # build plot dat
  tempPlot <- iml::FeatureEffect$new(pred, feature = c(feature, covar), method = method)
  plotDat <- tempPlot$results
  
  # plot
  tempPlot <- ggplot2::ggplot(plotDat, aes(x=.data[[feature]], y=.data$.value,
                                           color = .data[[covar]])) +
    geom_line() 
  plotting <- tempPlot +
    theme_bw() +
    xlab(xlabel) +
    ylab("") +
    theme(legend.position = legend_position) + 
    guides(color = guide_legend(title = legend_title,
                                override.aes = list(size = 7)))+ 
    ggtitle(title) + 
    ylab(ylab)
  return(plotting)
}

