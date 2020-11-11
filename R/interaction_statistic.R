#' Plot feature interaction
#'
#' This function allows to plot the Hamilton feature interaction statistic
#'
#' @param pred A prediction object from package iml
#' @param type A character string indicating the type of the interaction statistic. Either "overall" (Default) or "2way"
#' @param feature A character string indicating the name of the feature that is the basis for 2-way interactions
#' @param limits An optional two-entry vector indicating the y-axis limits. Default is c(0,1)
#' @param title An optional character string indicating the title of the plot
#' @param xlabel An optional character string indicating x-axis label
#' @param ylabel  An optional character string indicating y-axis label
#' @return a plot of type ggplot
#'
#' @export
interaction_statistic <- function(pred,
                                  type = "overall",
                                  feature = NA,
                                  limits = c(0,1),
                                  title = "",
                                  xlabel = "",
                                  ylabel = "Interaction Statistic"){
  if (type != "overall" & type != "2way") stop("Please indicate the type of the interaction statistic, either 'overall' or '2way'")
  if (type == "overall"){
    message("Calculating overall interaction strength")
    plotDat <- iml::Interaction$new(pred)$results
  }
  if (type == "2way"){
    if (is.na(feature)) stop("Please indicate feature name for 2-way interactions")
    message(paste("Calculating 2-way interaction strength for", feature))
    plotDat <- iml::Interaction$new(pred, feature = feature)$results
  }
  featPlot <- ggplot(plotDat,
                     aes(x = .data$.feature, y = .data$.interaction)) +
    geom_point()+
    theme_bw() +
    ylim(limits)+
    ggtitle(title) +
    ylab(ylabel) +
    xlab(xlabel)
  return(featPlot)
}
