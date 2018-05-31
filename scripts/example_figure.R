library(tidyverse)
library(reshape2)

co2_t = as.tibble(CO2)

ggplot(co2_t, aes(x=conc, y=uptake, group=Type)) +
  geom_point(size=3, alpha=0.3, aes(color=Type)) + 
  geom_smooth(alpha=0.1, size=2, se=FALSE, aes(color=Type)) +
  geom_vline(xintercept=375, linetype='dashed') +
  theme_minimal() +
  labs(
    title = expression(paste("Quebec grasses uptake more CO"[2])),
    x = expression(paste("CO"[2], " Concentration (mL/L)")),
    y = expression(paste("CO"[2], " Uptake (",mu,"mol/m"^2, "sec)")),
    color = "Grass origin"
  )

ggsave("datasci611_src/data/co2_uptake.png", width=6, height=3.5)
