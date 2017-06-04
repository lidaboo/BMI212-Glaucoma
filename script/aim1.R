library(lme4)
library(dplyr)
# specific aim 1
matched <- read.csv('PSMmatched.csv', stringsAsFactors=F)
data.all <- read.csv('WHImerged.csv', stringsAsFactors=F)

# create the data matrix for specific aim 1
data.all <- data.all %>%
  mutate(AGE=AGE*365+date) %>%
  filter(ID %in% unlist(matched))
data.all$AGE <-  as.numeric(scale(data.all$AGE))
data.all$BMI <- as.numeric(scale(data.all$BMI))
data.all$NDD <- apply(cbind(data.all$ALZHEIM, data.all$PARKINS, data.all$ALS, data.all$MS), 
                      1, function(x) x[1] | x[2] | x[3] | x[4])


# baseline model
# model.baseline <- glmer(formula = NDD ~ AGE + diab + RACE + diab:AGE + (1 | ID), 
#                        data=data.all, na.action=na.omit,
#                        family=binomial(link = "logit"), verbose=1)
# summary(model.baseline)

# full model
model.NDD <- glmer(formula = NDD ~ AGE + diab + BMI + RACE + diab:AGE + BMI:AGE + (1 | ID), 
                   data=data.all, na.action=na.omit, 
                   family=binomial(link = "logit"), verbose=1)
summary(model.NDD)

write.table(data.all, file='NDDPSM.csv', sep=',', row.names=F, col.names=T, quote=F)
save(model.NDD, 'specificAim1.RData')