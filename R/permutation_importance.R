#' Plot permutation importance
#'
#' This function allows to plot permutation importance based on mean squared error.
#' Three types are implemented: model-based permutation importance, random forest permutation importnance or conditional random forest variable importance
#'
#' @param object A prediction object from package iml for model-based permutation importance or an object as returned by randomForest or cforest
#' @param type A character indicating the type of variable importance: model, randomforest, or conditional
#' @param title An optional character string indicating the title of the plot
#' @param xlabel An optional character string indicating the x-axis label
#' @param ylabel An optional character string indicating the y-axis label
#' @param limits An optional two-entry vector indicating the limits of the y-axis
#'
#' @return a plot of type ggplot
#'
#' @export
permutation_importance <- function(object, type, title = "",  xlabel = "", ylabel = "Permutation Importance", limits = c(NA,NA)){
  if(!type %in% c("model", "randomforest", "conditional")){
    stop("Please specify the type of permutation importance!", show.error.messages = TRUE)
  }
  if(type == "model"){
    temp <- iml::FeatureImp$new(object, loss = "mse", compare = "difference")$results
  }
  if(type == "randomforest"){
    temp <- permimp::permimp(object, do_check = FALSE, conditional = FALSE)
    temp <- data.frame(feature = names(temp$values), importance = temp$values)
  }
  if(type == "conditional"){
    temp <- permimp::permimp(object, do_check = FALSE, conditional = TRUE)
    temp <- data.frame(feature = names(temp$values), importance = temp$values)
  }
  featPlot <- ggplot(temp,
                     aes (x = .data$feature,
                          y = .data$importance)) +
    geom_point() +
    theme_bw() +
    ggtitle(title) +
    xlab(xlabel) +
    ylab(ylabel)
  return(featPlot)
}
