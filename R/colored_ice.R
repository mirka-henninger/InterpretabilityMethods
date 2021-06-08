#' Plot colored ICE curves
#'
#' This function allows to plot colored ice predictions for a set of features, colored by a covariate
#'
#' @param pred A prediction object from package iml
#' @param features A character vector containing the names of the features for which the plot should be created
#' @param covar A character string indicating the covariate after which the ICE curves should be colored
#' @param title An optional character string indicating the title of the plot
#' @param xlabel An optional character string of the same length as the number of features indicating the x-axis label of the single plots
#' @param center Logical indicating whether ICE curves should be centered at the minimum. Default is FALSE
#' @param limits An optional two-entry vector indicating the limits of the y-axis
#' @param colors An optional vector with entries for each level of 'covar'
#' @param nCol An optional numeric entry indicating the number of columns when plots are created for several features
#' @param alpha An optional numeric entry indicating the alpha-level of ICE curves
#' @param legend_title A character indicating the legend title. Default is the name of 'covar'
#' @param legend_position Logical indicating whether the legend should be shown. Default is TRUE
#'
#' @return a plot of type ggplotify
#'
#' @export
colored_ice <- function(pred,
                        features,
                        covar,
                        title = "",
                        xlabel = features,
                        center = FALSE,
                        limits = c(NA,NA),
                        nCol = NA,
                        colors = NULL,
                        alpha = 1,
                        legend_title = covar,
                        legend_position = "right"){
  dat <- pred$data$X
  names(dat) <- paste0(colnames(dat),"_")
  covarName <- paste0(covar,"_")
  dat$id <- row.names(dat)
  emptyPlot <- ggplot2::ggplot()
  listPlot <- list(emptyPlot)
  for (nfeat in 1:length(features)){
    # build plot dat
    feature <- features[nfeat]
    tempPlot <- iml::FeatureEffect$new(pred, feature = feature, method = "ice")
    if(center == TRUE){
      tempPlot <- iml::FeatureEffect$new(pred, feature = feature, method = "ice",
                                         center = min(pred$data$X[[feature]]))
    }

    plotDat <- tempPlot$results
    names(plotDat) <- c(features[nfeat], "yhat","type","id")
    plotDat$id <- as.character(plotDat$id)

    # merge X dat with plot dat
    plotDat <- dplyr::left_join(plotDat, dat, by = "id")
    plotDat$id <- as.factor(plotDat$id)

    # plot
    tempPlot <- ggplot2::ggplot(plotDat,
                                aes(x=.data[[features[nfeat]]],
                                    y=.data$yhat,
                                    group = .data$id,
                                    color = .data[[covarName]])) +
      # geom_point(alpha = alpha) +
      geom_line(alpha = alpha) +
      theme_bw() +
      xlab(xlabel[nfeat]) +
      ylab("") +
      theme(legend.position = legend_position)
    if(!is.null(colors)){
      tempPlot <- tempPlot + scale_color_manual(values = colors)
    }
    tempPlot <- tempPlot +
      guides(color = guide_legend(title = legend_title,
                                  override.aes = list(size = 7)))
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

