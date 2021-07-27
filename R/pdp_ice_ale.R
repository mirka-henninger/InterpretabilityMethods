#' Plot PD, ICE, and ALE curves
#'
#' This function allows to create PD, ICE, ALE plots
#' ICE plots can be centered at the minimum
#' Plots for several features of one model can be created at the same time
#'
#' @param pred A prediction object from package iml
#' @param features A character vector containing the names of the features for which the plot should be created
#' @param method A character string indicating the method to be applied: either "pdp", "pdp+ice", "ice", or "ale"
#' @param xlabel An optional character vector indicating x-axis label
#' @param ylabel  An optional character string indicating y-axis label
#' @param title An optional character string indicating the title of the plot
#' @param center Logical indicating whether ICE curves should be centered at the minimum. Default is FALSE
#' @param limits An optional two-entry vector indicating the limits of the y-axis
#' @param nCol An optional numeric entry indicating the number of columns when plots are created for several features
#' @param alpha An optional numeric entry indicating the alpha-level of ICE curves
#' @param sample_prop An optional numeric entry between 0 and 1 indicating the percentage of individiuals that should be sampled for ICE curves
#'
#' @return a plot of type ggplotify
#'
#' @examples
#' \dontrun{
#' N <- 1000
#' x1 <- runif(N, -1, 1)
#' x2 <- runif(N, -1, 1)
#' y <- 5 + 2 * x1 + x2 + rnorm(N,1)
#' dat <- data.frame(x1,x2,y)
#' rfmod <- randomForest::randomForest(y~., dat)
#' pred <- iml::Predictor$new(rfmod)
#' pdp <- pdp_ice_ale(pred,  "x1", method = "pdp")
#' ice <- pdp_ice_ale(pred,  "x1", method = "ice")
#' ale <- pdp_ice_ale(pred,  c("x1", "x2"), method = "ale", ylabel = "ALE")
#'}
#'
#' @export
#'
pdp_ice_ale <- function(pred,
                        features,
                        method,
                        xlabel = features,
                        ylabel = method,
                        title = "",
                        center = FALSE,
                        limits = c(NA,NA),
                        nCol = NA,
                        alpha = .5,
                        sample_prop = .5){
  emptyPlot <- ggplot()
  listPlot <- list(emptyPlot)
  for (nfeat in 1:length(features)){
    # build plot dat
    feature <- features[nfeat]
    if(center == FALSE){
      tempDat <- iml::FeatureEffect$new(pred, feature = feature, method = method)
    }
    if(center == TRUE){
      tempDat <- iml::FeatureEffect$new(pred, feature = feature, method = method,
                                         center.at = min(pred$data$X[[feature]]))
    }
    plotDat <- tempDat$results
    if(".class" %in% names(plotDat)){
      if(method == "ice") stop("ICE plots are not yet implemented for categorical outcomes")
      plotDat <- plotDat[plotDat$.class==1,]
    }
    # optional sampling
    if(method == "ice" | method == "pdp+ice"){
      samp <- c(sample(1:nrow(plotDat), nrow(plotDat) * sample_prop, replace = FALSE), NA)
      plotDat <- plotDat[plotDat$.id %in% samp,]
      tempPlot <- ggplot(plotDat,
                         aes(x = .data[[feature]],
                             y = .data$.value,
                             group = .data$.id,
                             size = .data$.type,
                             color = .data$.type)) +
        # geom_point() +
        geom_line() +
        scale_color_manual(values = c("#344037", "gold")) +
        scale_alpha_manual(values = c(alpha, 1)) +
        scale_size_manual(values = c(.5,2))
    }
    if(method != "ice" & method != "pdp+ice"){
      tempPlot <- ggplot(plotDat,
                         aes(x = .data[[feature]],
                             y = .data$.value)) +
        geom_point() +
        geom_line(alpha = alpha)
    }
    # plot
    listPlot[[nfeat]] <- tempPlot
    # add titles, labels
    tempPlot <- tempPlot +
      theme_bw() +
      xlab(xlabel[nfeat]) +
      ylab(ylabel) +
      theme(legend.position = "none")
    if(!all(is.na(xlabel))){
      tempPlot <- tempPlot + xlab(xlabel[nfeat])
    }
    if (!all(is.na(limits))){
      tempPlot <- tempPlot + ylim(limits)
    }
    listPlot[[nfeat]] <- tempPlot
  }
  namesPlots <- paste0("tempPlot_",1:length(features))
  if(is.na(nCol)){
    nCol <- ceiling(length(features)/2)
  }
  plotting <- do.call("grid.arrange", c(listPlot, ncol=nCol))
  plotting <- ggplotify::as.ggplot(plotting) + ggtitle(title)
  return(plotting)
}


