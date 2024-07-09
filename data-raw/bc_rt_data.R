## code to prepare `bc_rt_data` dataset goes here

library(msm) # need for truncated normal distribution
library(tibble)
library(dplyr)

set.seed(20240305)

n <- 3000 # sample size

# generate covariates
rt <- rbinom(n, 1, p = .6)
age_dx_yrs <- rtnorm(n, mean = 60 - (rt * 5), sd = 14, lower = 18, upper = 95)
tumor_size_cm <- rtnorm(n, mean = 2.1 + (rt * .4), sd = 1, lower = 0)
n_ln_pos_3_vs_1or2 <- rbinom(n, 1, p = .07 + (rt * .13))
nodal_ratio <- rtnorm(n, mean = .2 + (rt * .06), sd = .22, lower = .02,
                      upper = 1)
lvi <- rbinom(n, 1, p = .35 + (rt * .1))
er_or_pr_pos <- rbinom(n, 1, p = .88 - (rt * .01))
her2_pos <- rbinom(n, 1, p = .16 + (rt * .02))
quadrant_inner_vs_other <- rbinom(n, 1, .16)
optimal_systemic_therapy <- rbinom(n, 1, p = .84 + (rt * .09))

# make grade a categorical variable
# But also with indicators for the model
grade <- runif(n)
grade_3cat <- case_when(
  rt == 0 & grade < .14 ~ "I",
  rt == 0 & grade >= .14 & grade < .62 ~ "II",
  rt == 0 & grade >= .62 ~ "III",
  rt == 1 & grade < .10 ~ "I",
  rt == 1 & grade >= .10 & grade < .54 ~ "II",
  rt == 1 & grade >= .54 ~ "III"
)
grade_ind3 = ifelse(grade_3cat == "III", 1, 0)
grade_ind2 = ifelse(grade_3cat == "II", 1, 0)


# weibull event and censoring distribution parameters
event_shape <- 1.54
event_scale <- 21.55
cens_shape <- 2.55
cens_scale <- 8.22

# setup the formula
xform <- rt * log(.8) + age_dx_yrs * log(1.05) + tumor_size_cm * log(1.24) +
  grade_ind3 * log(1.66) + grade_ind2 * log(1.26) +
  n_ln_pos_3_vs_1or2 * log(1.08) +
  nodal_ratio * log(1.23) + lvi * log(1.05) + er_or_pr_pos * log(.86) +
  her2_pos * log(.64) + quadrant_inner_vs_other * log(1.16) +
  optimal_systemic_therapy * log(.48)

# generate the event and censoring times
x <- rweibull(n, event_shape, event_scale / exp(xform / event_shape))
c <- rweibull(n, cens_shape, cens_scale)

# create observed time and event indicator
t <- pmin(x, c)
delta <- ifelse(x <= c, 1, 0)

# Make some covariate data missing completely at random
rand1 <- rbinom(n, 1, p = 0.05)
tumor_size_cm <- ifelse(rand1 == 1, NA, tumor_size_cm)
rand2 <- rbinom(n, 1, p = 0.03)
er_or_pr_pos <- ifelse(rand2 == 1, NA, er_or_pr_pos)
rand3 <- rbinom(n, 1, p = 0.04)
her2_pos <- ifelse(rand3 == 1, NA, her2_pos)

# put everything into dataset
bc_rt_data <- tibble(
  time = t,
  event = delta,
  rt = rt,
  age_dx_yrs = age_dx_yrs,
  tumor_size_cm = tumor_size_cm,
  grade = grade_3cat,
  n_ln_pos_3_vs_1or2 = n_ln_pos_3_vs_1or2,
  nodal_ratio = nodal_ratio,
  lvi = lvi,
  er_or_pr_pos = er_or_pr_pos,
  her2_pos = her2_pos,
  quadrant_inner_vs_other = quadrant_inner_vs_other,
  optimal_systemic_therapy = optimal_systemic_therapy
)

# create the dataset
usethis::use_data(bc_rt_data, overwrite = TRUE)
