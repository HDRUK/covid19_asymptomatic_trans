library("tidyverse")
library("rbi")
library("rbi.helpers")

data_cases_symp <- readr::read_csv(file = "data/data_cases_symp.csv") %>% 
  dplyr::mutate(date = onset_date, T = day_no, I_sk = all) %>%
  dplyr::select(time = T, value = I_sk)

data_cases_non_symp <- readr::read_csv(file = "data/data_cases_non_symp.csv") %>% 
  dplyr::mutate(date = test_date, T = day_no, R_n = non_symp) %>%
  dplyr::select(time = T, value = R_n)

obs <- list(symp = data_cases_symp, non_symp = data_cases_non_symp)

data_together <- list(t = length(data_cases_symp$I_sk),
                      y_obs_1 = data_cases_symp$I_sk,
                      y_obs_2 = data_cases_non_symp$R_n,
                      t0 = 0,
                      y0 = c(3710.0,1e-6,1e-6,1e-6,1e-6,1e-6,1e-6,1,0),
                      ts = seq(1,32,1),
                      nu = 0.25,
                      gamma_a = 1.0 / 7.0,
                      gamma_prop = 1.0 / 2.4,
                      gamma_s = 1.0 / 3.2,
                      t_mu = 16.0,
                      mu = 1.0,
                      phi = 199.0/301.0,
                      N = 3711
)



model <- rbi::bi_model(file = "bi/asymptomatic_transmission.bi")

prior_sample <- rbi::sample(model, target = "prior", nsamples = 1000)

res <- bi_read(prior_sample)

## todo

## fit_full <- rstan::sampling(mod_full,
##                             data = data_together, 
##                             chains = 2,
##                             verbose = TRUE,
##                             iter = 1000,
##                             #warmup = 1000,
##                             #algorithm = "Fixed_param",
##                             refresh = 10,
##                             cores = 2)
##                             #control = list(adapt_delta = 0.8))

