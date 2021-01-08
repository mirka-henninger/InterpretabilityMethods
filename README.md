# InterpretabilityMethods

This repository facilitates the use of interpretation methods for black-box machine learning models. Most of the functions are wrapper functions based on the R package *iml* and *permimp*. 


It can be installed like an R package using the devtools-package:
----------------------------------------------------------

``` r
install.packages("devtools")
devtools::install_github("mirka-henninger/InterpretationMethods")
library(InterpretationMethods)
```

References
----------
Debeer, D., & Strobl, C. (2020). Conditional permutation importance revisited. BMC Bioinformatics, 21, 1–30. https://doi.org/10.1186/s12859-020-03622-2

Debeer, D., Hothorn, T. & Strobl, C. (2020). permimp: Conditional Permutation Importance. R package version 1.0-0. https://CRAN.R-project.org/package=permimp

Molnar, C. (2019). Interpretable Machine Learning: A Guide for Making Black Box Models Explainable. https://christophm.github.io/interpretable-ml-book

Molnar, C., Bischl, B., & Casalicchio G. (2018). iml: An R package for Interpretable Machine Learning. JOSS, 3, 1-2. https://doi.org/10.21105/joss.00786
