#' Virtual Class "Survey.Design" 
#'
#' Virtual Class \code{"Survey.Design"} is an S4 class detailing the survey 
#' design. Currently only line transect designs are implemented and transects 
#' from these designs must be generated using the Distance software in 
#' advance.
#' 
#' @name Survey.Design-class
#' @title S4 Class "Survey.Design"
#' @slot design.axis Object of class \code{"numeric"}; the angle of
#'  the design axis.
#' @slot spacing Object of class \code{"numeric"}; the spacing of
#'  the design.
#' @slot region.obj Object of class \code{"character"}; The name of
#'  the region which the survey design has been made for.
#' @slot plus.sampling Object of class \code{"logical"}; Whether 
#'  a plus sampling protocol is to be used.
#' @slot path Object of class \code{"character"}; Describing the
#'  folder where the shapefiles containing the transects are located.
#' @slot filenames Object of class \code{"character"}; stores the 
#'  filenames of the transect shapefiles. These are automatically added
#'  when the object is created using all the files in the specified path.
#' @slot file.index Object of class \code{"numeric"}; Keeps track
#'  of which shapefile is to be loaded.
#' @keywords classes
#' @export
#' @seealso \code{\link{make.design}}
setClass(Class = "Survey.Design", 
         representation = representation(design.axis = "numeric",
                                         spacing = "numeric",
                                         region.obj = "character",
                                         plus.sampling = "logical",  
                                         path = "character",
                                         filenames = "character",
                                         file.index = "numeric", "VIRTUAL")
)

setMethod(
  f="initialize",
  signature="Survey.Design",
  definition=function(.Object, region, spacing, design.axis, plus.sampling, path = character(0), ...){
    filenames <- character(0)
    file.index <- numeric(0)
    if(length(path) > 0){
      filenames  <- get.shapefile.names(path)
      file.index <- 1
    }
    #Set slots
    .Object@region.obj    <- region
    .Object@plus.sampling <- plus.sampling
    .Object@spacing       <- spacing
    .Object@design.axis   <- design.axis
    .Object@path          <- path
    .Object@filenames     <- filenames
    .Object@file.index    <- file.index
    #Check object is valid
    validObject(.Object)
    # return object
    return(.Object)
  }
)

setValidity("Survey.Design",
            function(object){
              if(length(object@path) > 1){
                return("You must only specify one path. All transect shapefiles must be in the same folder.")
              }
              return(TRUE)
            }
)


# GENERIC METHODS DEFINITIONS --------------------------------------------













