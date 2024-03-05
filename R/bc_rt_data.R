#' Simulated data on overall survival from breast cancer with radiation therapy
#'
#' These data are simulated in the context of the use of post-mastectomy
#' radiation therapy in women with pathologic stage T1-2N1M0 breast cancer.
#' Data on various patient and disease characteristics are available.
#'
#' @format ## `bc_rt_data`
#' A data frame with 3,000 rows and 13 columns:
#' \describe{
#'   \item{time}{Overall survival time in years}
#'   \item{event}{Death indicator, 1 = dead, 0 = censored}
#'   \item{rt}{PMRT indicator, 1 = yes, 0 = no}
#'   \item{age_dx_yrs}{Age at diagnosis in years}
#'   \item{tumor_size_cm}{Tumor size in cm}
#'   \item{grade_3_vs_1or2}{Tumor grade, 1 = grade 3, 0 = grade 1 or 2}
#'   \item{n_ln_pos_3_vs_1or2}{Number of positive lymph nodes, 1 = 3,
#'   0 = 1 or 2}
#'   \item{nodal_ratio}{Ratio of number of positive lymph nodes to number of
#'   sampled lymph nodes}
#'   \item{lvi}{Lymphovascular invasion, 1 = yes, 0 = no}
#'   \item{er_or_pr_pos}{ER/PR status, 1 = ER+ or PR+, 0 = ER- and PR-}
#'   \item{her2_pos}{Her2 status, 1 = positive, 0 = negative}
#'   \item{quadrant_inner_vs_other}{Tumor location, 1 = inner quadrant,
#'   0 = other quadrant (centeral, outer, multiple)}
#'   \item{optimal_systemic_therapy}{Receipt of optimal systemic therapy,
#'   1 = yes (endocrine therapy if ER+ or PR+, trastuzumab if Her2+,
#'   and CHT if ER- and PR-), 0 = no}
#' }
"bc_rt_data"
