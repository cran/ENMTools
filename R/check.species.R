#' Checking compliance for an object of class enmtools.species.
#'
#' @param this.species An enmtools.species object to be checked.
#' @param env Environmental rasters that will be used for modeling.  If provided to check.species, ENMTools will remove occurrence points that have NA values for any layer in env.
#' @param trim.dupes Controls whether to trim duplicate occurrence points from the presence data.  Defaults to FALSE, which leaves duplicates in place.  Alternatives are "exact", which will remove points with the same lat/long as another point, or "grid", which will trim data so that there is at most one point per grid cell for the rasters in env, and centers those points in the cells.
#'
#' @return An enmtools.species object with appropriate formatting.
#'
#' @examples
#' check.species(iberolacerta.clade$species$monticola)


check.species <- function(this.species, env = NA, trim.dupes = FALSE){


  # This bit replaces NULL values with NA values
  expect <- c("presence.points", "background.points",
              "models", "species.name", "range")
  nulls <- names(which(sapply(expect, function(x) is.null(this.species[[x]]))))

  # Have to do this in a loop because sapply won't assign NAs for some reason
  for(i in nulls){
    this.species[[i]] <- NA
  }

  if(!is.logical(this.species$range) || !is.na(this.species$range)){
    this.species$range <- check.raster(this.species$range, "range")
  }
  if(!inherits(this.species$range, "SpatRaster")){
    if(!is.na(this.species$range)){
      stop("Argument range requires an object of or coercible to class SpatRaster")
    }
  }

  if(inherits(this.species$range, "SpatRaster")){
    if(is.na(terra::crs(this.species$range))){
      warning("Species range raster does not have a CRS set")
    }
  }


  if(!is.logical(this.species$presence.points) || !all(is.na(this.species$presence.points))){
    this.species$presence.points <- check.points(this.species$presence.points, "presence.points")
  }
  if(!inherits(this.species$presence.points, "SpatVector")){
    if(!all(is.na(this.species$presence.points))){
      "Species presence points require an object of or coercible to class SpatVector"
    }
  }

  if(!is.logical(this.species$background.points) || !all(is.na(this.species$background.points))){
    this.species$background.points <- check.points(this.species$background.points, "background.points")
  }
  if(!inherits(this.species$background.points, "SpatVector")){
    if(!all(is.na(this.species$background.points))){
      "Species background points require an object of or coercible to class SpatVector"
    }
  }


  if(!inherits(this.species$species.name, "character")){
    if(!is.na(this.species$species.name)){
      stop("Argument species.name requires an object of class character")
    }
  }


  # Extracts data from env at presence points, uses that to remove points that have NA in any layer
  if(!is.logical(env) || !is.na(env)) {
    env <- check.raster(env, "env")
  }
  if(inherits(env, "SpatRaster")){
    temp.df <- terra::extract(env, this.species$presence.points, ID = FALSE)
    this.species$presence.points <- this.species$presence.points[complete.cases(temp.df),]
  }

  # Removing duplicates
  if(trim.dupes == "exact"){
    this.species$presence.points <- unique(this.species$presence.points)
  }

  if(trim.dupes == "grid"){
    if(inherits(env, "SpatRaster")){
      this.species$presence.points <- trimdupes.by.raster(terra::crds(this.species$presence.points, env))
    } else {
      stop("Trim dupes by grid specified but env was either not supplied or was not a SpatRaster object!")
    }
  }

  # Return the formatted species object
  return(this.species)
}


reformat.latlon <- function(latlon){

  # Basically this bit just tries to auto-identify the lat and lon columns, then returns a
  # reformatted data frame with col names "x" and "y"

  # Try to figure out which columns contain "lon" or "x"
  loncols <- c(which(grepl("^lon", colnames(latlon), ignore.case = TRUE)), match("x", tolower(colnames(latlon))))
  if(any(!is.na(loncols))){
    loncols <- loncols[which(!is.na(loncols))]
  }

  # Ditto for "lat" and "y"
  latcols <- c(which(grepl("^lat", colnames(latlon), ignore.case = TRUE)), match("y", tolower(colnames(latlon))))
  if(any(!is.na(latcols))){
    latcols <- latcols[which(!is.na(latcols))]
  }


  # Check whether we've got one column for each, and make sure they're not the same column
  if(is.na(latcols)){
    stop("Unable to auotmatically determine x and y columns.  Please rename to x and y.")
  }

  if(is.na(loncols)){
    stop("Unable to auotmatically determine x and y columns.  Please rename to x and y.")
  }

  if(length(latcols == 1) & length(loncols == 1) & latcols != loncols){
    output <- data.frame(cbind(latlon[,loncols], latlon[,latcols]))
    colnames(output) <- c("x", "y")
  } else {
    stop("Unable to auotmatically determine x and y columns.  Please rename to x and y.")
  }
  return(output)
}
