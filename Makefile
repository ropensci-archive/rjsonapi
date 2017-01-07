test:
	Rscript -e 'Sys.setenv(NOT_CRAN = "true"); Sys.setenv(TRAVIS = "true"); devtools::test()'
