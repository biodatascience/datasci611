# Calculate the area of a circle based on the 
# radius provided
get_area_from_radius <- function(radius){
  
  # Verify that radius is a number
  stopifnot(is.numeric(radius))
  
  # Calculate area
  area = pi * radius^2
  return(area)
}