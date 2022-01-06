_# InterpretableML

This repository facilitates the use of interpretation techniques for black-box machine learning methods. Most of the functions are wrapper functions based on the R package *iml* and *permimp*. 


It can be installed like an R package using the devtools-package:
----------------------------------------------------------

``` r
install.packages("devtools")
devtools::install_github("mirka-henninger/InterpretableML")
library(InterpretableML)
```

It uses mostly the functionality of the [iml](https://github.com/christophM/iml) and [permimp](https://github.com/ddebeer/permimp) package. However, it faciliates the use of the functions and customization of plots for interpretation techniques. 

- PD, ICE, ALE plots (```pdp_ice_ale```)
- two dimensional PD and ALE plots (```twoD_pdp_ale```)
- colored and centered PD plots (```colored_pdp```)
- colored and centered ICE plots (```colored_ice```)
- permutation importance (```permutation_importance```): model-agnostic, random forest, and conditional permutation importance
- interaction statistic (```interaction_statistic```)


Some examples based on the titanic data set: 
``` r
# load data
library(titanic)
titanic <- titanic_train[complete.cases(titanic_train),]
titanic$Survived <- factor(titanic$Survived)
titanic$Pclass <- factor(titanic$Pclass)
titanic$Sex <- factor(titanic$Sex)

# define features
features <- c("Fare", "Pclass", "Age", "Survived")
dat <- titanic[, features]

# fit conditional inference forest
cforest_fit <- partykit::cforest(Fare ~ Pclass + Age + Survived,
                                 data = dat, mtry = 2)

X   <- dat[which(names(dat) != "Fare")]
pred <- iml::Predictor$new(cforest_fit,data = X, y = dat$Fare)

# PDP, ICE, and ALE
pdp <- pdp_ice_ale(pred, c("Pclass","Age", "Survived"), method = "pdp")
ice <- pdp_ice_ale(pred, c("Pclass","Age", "Survived"), method = "ice")
ale <- pdp_ice_ale(pred, c("Pclass","Age", "Survived"), method = "ale")

# two-dimensional PD and ALE
twoD_pdp_ale(pred, c("Age", "Pclass"), method = "pdp")
twoD_pdp_ale(pred, c("Survived", "Pclass"), method = "pdp")
twoD_pdp_ale(pred, c("Survived", "Age"), method = "ale")

# colored PD and ICE
colored_pdp(pred, "Age", "Pclass")
colored_ice(pred, "Age", "Pclass")
colored_ice(pred, "Age", "Pclass", center = TRUE)

# permutation importance
permutation_importance(pred, type = "model-agnostic", loss = "mse")

# overall and two-way interaction statistic
interaction_statistic(pred)
interaction_statistic(pred, type = "2way", feature = "Age")
interaction_statistic(pred, type = "2way", feature = "Pclass")
interaction_statistic(pred, type = "2way", feature = "Survived")
```

References
----------
Debeer, D., & Strobl, C. (2020). Conditional permutation importance revisited. BMC Bioinformatics, 21, 1–30. https://doi.org/10.1186/s12859-020-03622-2

Debeer, D., Hothorn, T. & Strobl, C. (2020). permimp: Conditional Permutation Importance. R package version 1.0-0. https://CRAN.R-project.org/package=permimp

Molnar, C. (2019). Interpretable Machine Learning: A Guide for Making Black Box Models Explainable. https://christophm.github.io/interpretable-ml-book

Molnar, C., Bischl, B., & Casalicchio G. (2018). iml: An R package for Interpretable Machine Learning. JOSS, 3, 1-2. https://doi.org/10.21105/joss.00786
_
