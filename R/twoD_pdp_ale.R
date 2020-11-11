#' Plot two-dimensional pdp, ice, ale
#'
#' This function allows to plot 2-dimensional pdp, ice, ale figures
#'
#' @param pred A prediction object from package iml
#' @param features A character vector containing the names of two features for which the plot should be created
#' @param method A character string indicating the method to be applied: either "pdp", "pdp+ice", "ice", or "ale"
#' @param title An optional character string indicating the title of the plot
#' @param xlabel An optional character string indicating x-axis label (same for all panels)
#' @param ylabel  An optional character string indicating y-axis label (same for all panels)
#' @param limits An optional two-entry vector indicating the limits of the y-axis
#' @param show_data Logical indicating whether datapoints should be plotted. Default is FALSE
#' @param legend_position Logical indicating whether the legend should be shown. Default is TRUE
#'
#' @return a plot of type ggplotify
#'
#' @export
twoD_pdp_ale <- function(pred,
                         features,
                         method,
                         title = "",
                         xlabel = features[1],
                         ylabel = features[2],
                         limits = c(NA,NA),
                         show_data = FALSE,
                         legend_position = "right"){
  if (length(features) != 2) stop("Please indicate the names of two features")
  plotDat  <- iml::FeatureEffect$new(pred = pred,
                                      feature = features,
                                      method = method)
  plot_2D <- plot(plotDat, show.data = show_data) + ggtitle(title) +
    viridis::scale_fill_viridis(limits = limits) +
    scale_x_continuous(name = xlabel) +
    scale_y_continuous(name = ylabel) +
    labs(fill= method) +
    theme(legend.position = legend_position)
  return(plot_2D)
}

