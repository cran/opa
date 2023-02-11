# Tests of results that are computed based on random number generation
# are only run locally as even with a seed the results are slightly 
# different on different machines

set.seed(22)

test_dat <- data.frame(group = c("a", "b", "a", "b"),
                       t1 = c(1, 3, 1, 1),
                       t2 = c(2, 2, 1, 2),
                       t3 = c(4, 1, 1, 1))
test_dat$group = factor(test_dat$group, levels = c("a", "b"))

test_dat_all_wrong <- data.frame(t1 = c(3, 2, 1),
                                 t2 = c(3, 2, 1),
                                 t3 = c(3, 2, 1))

opamod1 <- opa(test_dat[,2:4],
               1:3,
               pairing_type = "pairwise")

opamod1a <- opa(test_dat[,2:4],
               c(3, 1, 2),
               pairing_type = "pairwise")

opamod2 <- opa(test_dat[,2:4],
               1:3,
               pairing_type = "adjacent")

opamod3 <- opa(test_dat[,2:4],
               1:3,
               pairing_type = "pairwise",
               diff_threshold = 1)

opamod4 <- opa(test_dat_all_wrong,
               1:3)

opamod5 <- opa(test_dat[,2:4],
               1:3,
               group = test_dat$group,
               pairing_type = "pairwise")

pw1 <- compare_conditions(opamod1)

# compare group PCCs from 2 different hypotheses
ch1 <- compare_hypotheses(opamod1, opamod1a)
# compare model to itself to produce PCC=0, cval=1
ch2 <- compare_hypotheses(opamod1, opamod1)

# compare subgroup pccs
group_comp <- compare_groups(opamod5, "a", "b")

# test pairwise opa works
expect_equal(opamod1$total_pairs, 12)
expect_equal(opamod1$correct_pairs, 4)
expect_equal(round(opamod1$group_pcc, 2), 33.33)
#expect_equal(round(opamod1$group_cval, 2), 0.63)
expect_equal(round(opamod1$individual_pccs, 2), c(100.00, 0.00, 0.00, 33.33))
#expect_equal(round(opamod1$individual_cvals, 2), c(0.17, 1.00, 1.00, 0.68))

# check adjacent opa works
expect_equal(opamod2$total_pairs, 8)
expect_equal(opamod2$correct_pairs, 3)
expect_equal(round(opamod2$group_pcc, 2), 37.50)
#expect_equal(round(opamod2$group_cval, 2), 0.6)
expect_equal(round(opamod2$individual_pccs, 2), c(100.00, 0.00, 0.00, 50.00))
#expect_equal(round(opamod2$individual_cvals, 2), c(0.17, 1.00, 1.00, 0.68))

# check pairwise opa with diff_threshold works
expect_equal(opamod3$total_pairs, 12)
expect_equal(opamod3$correct_pairs, 2)
expect_equal(round(opamod3$group_pcc, 2), 16.67)
#expect_equal(round(opamod3$group_cval, 2), 0.5)
expect_equal(round(opamod3$individual_pccs, 2), c(66.67, 0.00, 0.00, 0.00))
#expect_equal(round(opamod3$individual_cvals, 2), c(0.33, 1.00, 1.00, 1.00))

# check there aren't problems with 0% fits
expect_equal(opamod4$total_pairs, 9)
expect_equal(opamod4$correct_pairs, 0)
expect_equal(round(opamod4$group_pcc, 2), 0.00)
expect_equal(round(opamod4$group_cval, 2), 1.00)
expect_equal(round(opamod4$individual_pccs, 2), c(0.00, 0.00, 0.00))
expect_equal(round(opamod4$individual_cvals, 2), c(1.00, 1.00, 1.00))

# check pairwise comparisons work
expect_equal(as.double(pw1$pcc[2,1]), 50)
expect_equal(as.double(pw1$pcc[3,1]), 25)
expect_equal(as.double(pw1$pcc[3,2]), 25)
#expect_equal(as.double(pw1$cval[2,1]), 0.529)
#expect_equal(as.double(pw1$cval[3,1]), 0.775)
#expect_equal(as.double(pw1$cval[3,2]), 0.887)

# check hypothesis comparisons work
#expect_equal(round(ch1$pcc_diff, 2), 8.33)
#expect_equal(round(ch1$cval, 2), 0.93)
#expect_equal(round(ch2$pcc_diff, 2), 0)
#expect_equal(round(ch2$cval, 2), 1)

# check subgroup comparisons work
#expect_equal(round(group_comp$pcc_diff, 2), 33.33)
#expect_equal(round(group_comp$cval, 2), 0.38)