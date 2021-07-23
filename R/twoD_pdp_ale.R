#' Plot two-dimensional pdp, ice, ale
#'
#' This function allows to plot 2-dimensional pdp, ale figures.
#' Please note ale for two categorical features is not yet implemented, and that the categorical feature
#' must be placed on the x-axis.
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
#' @param rugs Logical indicating whether rugs should be shown. Default is TRUE
#'
#' @return a plot of type ggplotify
#'
#' @examples
#' \dontrun{
#' N <- 1000
#' x1 <- runif(N, -1, 1)
#' x2 <- runif(N, -1, 1)
#' y <- 5 + 5 * x1 * x2 + rnorm(N,1)
#' dat <- data.frame(x1,x2,y)
#' rfmod <- randomForest::randomForest(y~., dat)
#' pred <- iml::Predictor$new(rfmod)
#' (twoD_pdPlot <- twoD_pdp_ale(pred, features = c("x1", "x2"), method = "pdp"))
#' (twoD_alePlot <- twoD_pdp_ale(pred, features = c("x1", "x2"), method = "ale"))
#' }
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
                         legend_position = "right",
                         rugs = TRUE){
  if (length(features) != 2) stop("Please indicate the names of two features")
  plotDat  <- iml::FeatureEffect$new(pred = pred,
                                     feature = features,
                                     method = method)$results
  if(method == "pdp"){
    plot_2D <- ggplot() +
      geom_raster(data = plotDat, aes(.data[[features[1]]],
                                      .data[[features[2]]],
                                      fill = .data$.value))

    if(is.numeric(pred$data$get.x()[[features[1]]]) | is.numeric(pred$data$get.x()[[features[2]]])){
      if(rugs == TRUE){
        plot_2D <- plot_2D +
          geom_rug(aes(pred$data$get.x()[[features[1]]], pred$data$get.x()[[features[2]]]),
                   inherit.aes = F)
        if(show_data == TRUE){
          plot_2D <-
            plot_2D +
            geom_point(aes(pred$data$get.x()[[features[1]]], pred$data$get.x()[[features[2]]]),
                       shape = 1, size = .2,
                       inherit.aes = F)
        }
      }
    } else warning("Rugs and datapoints are not shown for categorical features")
  }
  if(method == "ale"){
    plot_2D <- ggplot() +
      geom_rect(data = plotDat, aes(xmin = .data$.left,
                                    xmax = .data$.right,
                                    ymin = .data$.bottom,
                                    ymax = .data$.top,
                                    fill = .data$.ale))
    if(is.factor(pred$data$get.x()[[features[1]]])){
      plot_2D <- plot_2D +
        scale_x_continuous(breaks = 1:length(levels(pred$data$get.x()[[features[1]]])), labels = levels(pred$data$get.x()[[features[1]]]))
    }
    if(!is.numeric(pred$data$get.x()[[features[1]]]) | !is.numeric(pred$data$get.x()[[features[2]]])){
      warning("Please note that the categorical variable is always displayed on the x-axis, so make sure that it is the first in the features vector")
    }
    if(is.numeric(pred$data$get.x()[[features[1]]]) & is.numeric(pred$data$get.x()[[features[2]]])){
      if(rugs == TRUE){
        plot_2D <- plot_2D +
          geom_rug(aes(pred$data$get.x()[[features[1]]], pred$data$get.x()[[features[2]]]),
                   inherit.aes = F)
        if(show_data == TRUE){
          plot_2D <-
            plot_2D +
            geom_point(aes(pred$data$get.x()[[features[1]]], pred$data$get.x()[[features[2]]]),
                       shape = 1, size = .2,
                       inherit.aes = F)
        }
      }
    } else warning("Rugs and datapoints are not shown when at least one categorical feature is involved in ALE")
  }
  plot_2D <-
    plot_2D +
    theme_minimal() +
    xlab(xlabel)+
    ylab(ylabel)+
    viridis::scale_fill_viridis(limits = limits) +
    labs(fill= method) +
    theme(legend.position = legend_position) +
    ggtitle(title)
  return(plot_2D)
}

