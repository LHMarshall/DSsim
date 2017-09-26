#' @importFrom graphics points
#' @importFrom rgeos gBuffer gIntersects gDistance
#' @importFrom sp SpatialPointsDataFrame SpatialPoints Lines Line SpatialLinesDataFrame SpatialLines coordinates
calc.poss.detect.dists.lines.largeN <- function(population, survey, perp.truncation, plot = FALSE){
# Calculates the possible detection distances to the transects
# Arguments:
#   population - object of S4 Population Class
#   survey - object of S4 Survey Class
#   perp.truncation - perpendicular truncation distance
# Returns:
#   A data frame of possible detection distances
  
  subset.buff.func <- function(i, pop, sampler.info, perp.truncation = 10){
    #returns the locations of the population within the truncation distance if transect i.
    # make individuals points
    ind_sp <- sp::SpatialPointsDataFrame(sp::SpatialPoints(pop[,c("x","y")]), pop)
    #get single transect
    transect <- sampler.info[i,]
    #Make Lines object
    sp.lines <- list()
    coords <- matrix(as.numeric(c(transect[,c("start.X","end.X", "start.Y","end.Y")])), nrow = 2)
    next.line <- sp::Line(coords)
    sp.lines[[1]] <- sp::Lines(list(next.line), ID = transect$ID)  
    spl <- sp::SpatialLinesDataFrame(sp::SpatialLines(sp.lines), sampler.info)
    #Create buffer
    spl_b <- rgeos::gBuffer(spl, width=perp.truncation, capStyle="SQUARE")
    # which points are within the buffer
    available_ind <- which(rgeos::gIntersects(ind_sp, spl_b, byid=TRUE))
    #get the points in the region
    sub.pop <- pop[available_ind,]
    #now calculate dists to transect
    #find the angle between the transect and the vector from the animal to the start of the transect
    transect.angle <- atan2(transect[["end.Y"]]-transect[["start.Y"]], transect[["end.X"]]-transect[["start.X"]]) 
    animal.angle <- atan2(sub.pop$y-transect[["start.Y"]], sub.pop$x-transect[["start.X"]])
    delta.angle <- abs(animal.angle-transect.angle)
    delta.angle <- (ifelse(delta.angle > pi, 2*pi - delta.angle, delta.angle))
    #calculate the distance from the transect start to the animal (the hypotenuse)
    hyp <- sqrt((sub.pop$y-transect[["start.Y"]])^2+(sub.pop$x-transect[["start.X"]])^2)
    #calculate the perpendicular distance (the opposite side of the RA triangle)
    perp.dists  <- hyp*sin(delta.angle) 
    #Check intersection (might be faster to calculate rectangles around transects rather than buffer and therefore can exclude this part!)
    intersects.transects <- apply(data.frame(x = sub.pop$x, y = sub.pop$y), 1, FUN = check.intersection, transect = transect)
    #Make new dataset
    new.data <- data.frame(object = sub.pop$object, transect.ID = rep(transect$ID, nrow(sub.pop)), distance = perp.dists, available = rep(TRUE, nrow(sub.pop)), x = sub.pop$x, y = sub.pop$y, strata = sub.pop$strata, scale.param = sub.pop$scale.param)
    #Subset based on intersection results
    new.data <- new.data[intersects.transects,]
    return(new.data)
  }  
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #Main function begins
  #Extract info from objects
  sampler.info <- survey@sampler.info
  pop.data <- pop@population
  #get all possible detection distances
  all.poss.detects <- lapply(1:nrow(sampler.info), 
                             FUN = subset.buff.func, 
                             pop = pop.data, 
                             sampler.info = sampler.info, 
                             perp.truncation = perp.truncation)
  #Build up into a sinlge data.frame
  sub.pop.size <- 0
  for(i in seq(along = all.poss.detects)){
    sub.pop.size <- sub.pop.size + nrow(all.poss.detects[[i]])
  }
  temp <- rep(NA, sub.pop.size)
  new.dataframe <- data.frame(object = temp, transect.ID = temp, distance = temp, available = temp, x = temp, y = temp, strata = temp, scale.param = temp)
  index <- 1
  for(i in seq(along = all.poss.detects)){
    new.dataframe[index:(index+nrow(all.poss.detects[[i]])-1),] <- all.poss.detects[[i]]
    index <- index + nrow(all.poss.detects[[i]])
  } 
  return(new.dataframe)
}



