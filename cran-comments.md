## Test environments

* Windows 11, R 4.6.1 (local)
* GitHub Actions : ubuntu-latest et windows-latest, R release

## R CMD check results

0 errors | 0 warnings | 1 note

* New submission.

## Notes

* The package reads data over the internet. Examples that need the network
  are in `\donttest{}`, and network tests are skipped on CRAN and when offline.
* Functions fail with an informative error when the network is unavailable.
