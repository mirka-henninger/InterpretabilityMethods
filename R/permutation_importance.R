#' Plot permutation importance
#'
#' This function allows to plot permutation importance based on mean squared error.
#' Three types are implemented: model-based permutation importance, random forest permutation importnance or conditional random forest variable importance
#'
#' @param object A prediction object from package iml for model-based permutation importance or an object as returned by randomForest or cforest
#' @param type A character indicating the type of variable importance: model-agnostic, randomforest, or conditional
#' @param loss A character specifying the loss function for type = model-agnostic. See ?iml::FeatureImp for more details
#' @param xlabel An optional character string indicating the x-axis label
#' @param ylabel An optional character string indicating the y-axis label
#' @param title An optional character string indicating the title of the plot
#' @param limits An optional two-entry vector indicating the limits of the y-axis
#'
#' @return a plot of type ggplot
#'
#' @examples
#' \dontrun{
#' N <- 1000
#' x1 <- runif(N, -1, 1)
#' x2 <- runif(N, -1, 1)
#' x3 <- x2 + runif(N, -1, 1)
#' y <- 5 + 5 * x1 + 5 * x2 + 0 * x3 + rnorm(N,1)
#' dat <- data.frame(x1,x2,x3,y)
#' rfmod <- randomForest::randomForest(y~., dat)
#' pred <- iml::Predictor$new(rfmod)
#' permutation_importance(pred, type = "model-agnostic", limits = c(0,18), loss = "mse")
#' permutation_importance(rfmod, type = "randomforest", limits = c(0,18))
#' permutation_importance(rfmod, type = "conditional", limits = c(0,18))
#'}
#'
#' @export
permutation_importance <- function(object,
                                   type,
                                   loss = NULL,
                                   xlabel = "",
                                   ylabel = type,
                                   title = "",
                                   limits = c(NA,NA)){
  if(!type %in% c("model-agnostic", "randomforest", "conditional")){
    stop("Please specify the type of permutation importance!", show.error.messages = TRUE)
  }
  if(type == "model-agnostic"){
    if(is.null(loss)) stop("Please indicate the desired loss function!")
    temp <- iml::FeatureImp$new(object, loss = loss, compare = "difference")$results
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
    xlab(xlabel) +
    ylab(ylabel) +
    ggtitle(title)
  if (!all(is.na(limits))){
    featPlot <- featPlot + ylim(limits)
  }
  return(featPlot)
}
