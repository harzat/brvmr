test_that("nombres avec espaces et pourcent", {
  nbsp <- intToUtf8(0x00A0)
  x <- c("8 900", "1.12%", "", paste0("23", nbsp, "895", nbsp, "000"))
  expect_equal(brvmr:::.brvm_nombre(x), c(8900, 1.12, NA, 23895000))
})
