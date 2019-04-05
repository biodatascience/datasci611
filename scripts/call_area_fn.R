source("area_fn.R")

a1 = get_area_from_radius(1)
a25 = get_area_from_radius(25)
a122 = get_area_from_radius(122)
a122 = get_area_from_radius('122') # This should fail

print(c(a1, a25, a122))
