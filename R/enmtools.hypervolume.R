#' THIS FUNCTION IS CURRENTLY DISABLED.  Takes an emtools.species object and environmental layers, and constructs a hypervolume using the R package hypervolume
#'
#' @param species An enmtools.species object
#' @param env A stack of environmental rasters
#' @param samples.per.point To be passed to hypervolume_gaussian
#' @param reduction.factor To be passed to hypervolume_project
#' @param method Method for constructing hypervolumes, defaults to "gaussian"
#' @param verbose Controls printing of various messages progress reports.  Defaults to FALSE.
#' @param clamp When set to TRUE, clamps the environmental layers so that predictions made outside the min/max of the training data for each predictor are set to the value for the min/max for that predictor. Prevents the model from extrapolating beyond the min/max bounds of the predictor space the model was trained in, although there could still be projections outside the multivariate training space if predictors are strongly correlated.
#' @param ... Extra parameters to be passed to hypervolume_gaussian
#'
#' @return An enmtools hypvervolume object containing a hypervolume object, a raster of suitability scores, the species name, and the occurrence data frame.
#'
#' @examples
#' \donttest{
#' #install.extras(repos='http://cran.us.r-project.org')
#' env <- euro.worldclim[[c(1,8,12,17)]]
#' if(requireNamespace("hypervolume", quietly = TRUE)) {
#'     monticola.hv <- enmtools.hypervolume(iberolacerta.clade$species$monticola, env = env)
#' }
#' }

enmtools.hypervolume <- function(species, env, samples.per.point = 10, reduction.factor = 0.1, method = "gaussian",  verbose = FALSE, clamp = TRUE, ...){

  return("This function is currently disabled, will be re-enabled once hypervolume on CRAN is working with the terra package.")

  assert.extras.this.fun()

  hypervolume.precheck(species, env)

  for(i in 1:length(names(env))){
    env[[i]] <- (env[[i]] - as.numeric(terra::global(env[[i]], "mean", na.rm = TRUE)))/as.numeric(terra::global(env[[i]], "sd", na.rm = TRUE))
  }

  climate <- terra::extract(env, species$presence.points, ID = FALSE)

  this.hv = NA

  if(method == "gaussian"){
    this.hv <- hypervolume::hypervolume_gaussian(climate, name = species$species.name, samples.per.point = samples.per.point, ...)
  } else if(method == "svm"){
    this.hv <- hypervolume::hypervolume_svm(climate, name = species$species.name, samples.per.point = samples.per.point, ...)
  }


  this.map <- hypervolume::hypervolume_project(this.hv, env, reduction.factor = reduction.factor)

  output <- list(hv = this.hv,
                 suitability = this.map,
                 species.name = species$species.name,
                 analysis.df = species$presence.points)

  class(output) <- "enmtools.hypervolume"

  return(output)
}


# Summary for objects of class enmtools.hypervolume
summary.enmtools.hypervolume <- function(object, plot = TRUE, ...){

  print(object$hv)

  if(plot) {
    plot(object)
  }

}

# Print method for objects of class enmtools.hypervolume
print.enmtools.hypervolume <- function(x, ...){

  print(summary(x, ...))

}


# Plot method for objects of class enmtools.hypervolume
plot.enmtools.hypervolume <- function(x, ...){

  suit.points <- data.frame(rasterToPoints2(x$suitability))
  colnames(suit.points) <- c("x", "y", "Suitability")
  test <- terra::as.data.frame(x$test.data, geom = "XY")

  suit.plot <- ggplot(data = suit.points,  aes(y = .data$y, x = .data$x)) +
    geom_raster(aes(fill = .data$Suitability)) +
    scale_fill_viridis_c(option = "B", guide = guide_colourbar(title = "Suitability")) +
    coord_fixed() + theme_classic() +
    geom_point(data = x$analysis.df,  aes(y = .data$y, x = .data$x),
               pch = 21, fill = "white", color = "black", size = 2)

  if(inherits(x$test.data, "SpatVector")){
    suit.plot <- suit.plot + geom_point(data = test,  aes(y = .data$y, x = .data$x),
                                        pch = 21, fill = "green", color = "black", size = 2)
  }

  if(!is.na(x$species.name)){
    title <- paste("Hypervolume model for", x$species.name)
    suit.plot <- suit.plot + ggtitle(title) + theme(plot.title = element_text(hjust = 0.5))
  }

  plot(x$hv)
  return(suit.plot)

}


# Predict method for models of class enmtools.hypervolume
predict.enmtools.hypervolume <- function(object, env, reduction.factor = 0.1){

  # Make a plot of habitat suitability in the new region
  suitability <- hypervolume::hypervolume_project(object$hv, env, reduction.factor = reduction.factor)
  suit.points <- data.frame(rasterToPoints2(suitability))
  colnames(suit.points) <- c("x", "y", "Suitability")

  suit.plot <- ggplot(data = suit.points,  aes(y = .data$y, x = .data$x)) +
    geom_raster(aes(fill = .data$Suitability)) +
    scale_fill_viridis_c(option = "B", guide = guide_colourbar(title = "Suitability")) +
    coord_fixed() + theme_classic()

  if(!is.na(object$species.name)){
    title <- paste("Hypervolume model projection for", object$species.name)
    suit.plot <- suit.plot + ggtitle(title) + theme(plot.title = element_text(hjust = 0.5))
  }
  output <- list(suitability.plot = suit.plot,
                 suitability = suitability)

  return(output)
}


# Function for checking data prior to running enmtools.hypervolume
hypervolume.precheck <- function(species, env){

  ### Check to make sure the data we need is there
  if(!inherits(species, "enmtools.species")){
    stop("Argument \'species\' must contain an enmtools.species object!")
  }

  check.species(species)

  if(!inherits(species$presence.points, "SpatVector")){
    stop("Species presence.points do not appear to be an object of class SpatVector")
  }

  if(!inherits(env, c("SpatRaster"))){
    stop("No environmental rasters were supplied!")
  }

}
