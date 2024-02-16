## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

palette(c("#56B4E9", "#E69F00", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"))

library(lattice)

## ----load_opa-----------------------------------------------------------------
library(opa)

## ----str_data-----------------------------------------------------------------
str(pituitary)

## ----plot_data, fig.width=6, fig.height=6-------------------------------------
xyplot(distance ~ age | individual, pituitary, type = c("g", "p", "l"),
       groups = sex, cex = 1.2, pch = 21,
       fill = c("#E69F0070", "#0072B270"),
       col = c("#E69F00", "#0072B2"),
       scales = list(x = list(at = c(8, 10, 12, 14))),
       xlab = "Age (years)",
       ylab = "Distance (mm)",
       main = "Pituitary-Pterygomaxillary Fissure Distance",
       key = list(space = "bottom", columns = 2,
                  text = list(c("Female", "Male")),
                  lines = list(col = c("#E69F00", "#0072B2")),
                  points = list(pch = 21, fill = c("#E69F0070", "#0072B270"),
                                col = c("#E69F00", "#0072B2"))))

## ----reshape_data-------------------------------------------------------------
dat_wide <- reshape(data = pituitary,
                    direction = "wide",
                    idvar = c("individual", "sex"),
                    timevar = "age",
                    v.names = "distance")

## -----------------------------------------------------------------------------
head(dat_wide)

## ----define_h1----------------------------------------------------------------
h1 <- hypothesis(c(1, 2, 3, 4), type = "pairwise")

## ----print_h1-----------------------------------------------------------------
print(h1)

## ----plot_h1, fig.width=4, fig.height=4---------------------------------------
plot(h1)

## ----fit_model1---------------------------------------------------------------
m1 <- opa(dat_wide[,3:6], h1)

## ----summary_model1-----------------------------------------------------------
summary(m1)

## ----plot_model1, fig.width=7, fig.height=5-----------------------------------
plot(m1)

## ----compare_conds_model1-----------------------------------------------------
compare_conditions(m1)

## ----define_h2----------------------------------------------------------------
h2 <- hypothesis(c(2, 1, 3, 4))

## ----print_h2-----------------------------------------------------------------
print(h2)

## ----fit_model2---------------------------------------------------------------
m2 <- opa(dat_wide[,3:6], h2)

## ----compare_hypotheses-------------------------------------------------------
compare_hypotheses(m1, m2)

## ----fit_model3---------------------------------------------------------------
m3 <- opa(dat_wide[,3:6], h1, group = dat_wide$sex)

## ----compare_groups-----------------------------------------------------------
compare_groups(m3, "M", "F")

## ----fit_model4---------------------------------------------------------------
m4 <- opa(dat_wide[,3:6], h1, group = dat_wide$sex, diff_threshold = 1)

## ----diff_threshold_results---------------------------------------------------
group_results(m4)

## ----compare_groups_with_diff_threshold---------------------------------------
compare_groups(m4, "M", "F")

