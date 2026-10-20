test_that("cours d'un titre, en ligne", {
  skip_on_cran()
  skip_if_offline("raw.githubusercontent.com")
  options(brvmr.silencieux = TRUE)
  x <- brvm_cours("SNTS", depuis = "2025-01-01")
  expect_s3_class(x$date, "Date")
  expect_true(nrow(x) > 100)
  expect_true(all(c("date", "cloture", "volume_titres") %in% names(x)))
})

test_that("titre inconnu", {
  skip_on_cran()
  skip_if_offline("raw.githubusercontent.com")
  expect_error(brvm_cours("ZZZZ"), "Titre inconnu")
})

test_that("liste des indices", {
  expect_length(brvm_indices(), 18)
})
