# Packages
library(randomForestSRC)
library(dplyr)
library(scales)
library(data.table)
library(survival)
library(ranger)

# Load raw data
transplant <- read.csv("txp_data.final1.csv", row.names = 1)
transplant[is.na(transplant)] <- 0
select_var <- transplant %>% dplyr::select(c("tx_deathorfail365","tx_time365", "tx_time")) # Save features from the end


# Check if binary
df_new <- data.table::data.table(row=1:nrow(transplant))
is_binary <- function(column) {
  unique_values <- unique(column)
  return(all(unique_values %in% c(0, 1)) && length(unique_values) == 2)
}


# Loop through columns and only scale and normalize columns with continuous variables
for (col_name in colnames(transplant)) {
  
  if (is.numeric(transplant[[col_name]]) && !is_binary(transplant[[col_name]]) && !grepl("DON_|ID", col_name)) {
    
    # Log transformation
    transplant[[col_name]] <- log2(transplant[[col_name]] + 1)
    
    # Scale
    transplant[[col_name]] <- rescale(transplant[[col_name]])
    
    # Add to new data frame
    df_new[[col_name]] <- transplant[[col_name]]
    
  }
  
  if(is_binary(transplant[[col_name]]) & !grepl("DON_|ID", col_name)){
    df_new[[col_name]] <- transplant[[col_name]]
    
  }
}


df_new <- df_new %>% as.data.frame() %>% dplyr::select(-c("row","tx_deathorfail365","tx_time365", "tx_time")) 
df_new_1 <- cbind(df_new, select_var)
df_new_1 <- df_new_1  %>% filter(merg_ventilator==1)


## Random survival forest (without supervision)
o <- rfsrc(Surv(tx_deathorfail365, tx_time365) ~ ., df_new_1)

# Minimal depth values
md <- max.subtree(o)$order[, 1]
md[order(md)]

# Copy vector of minimal depth values
md[md < mean(md)] %>% as.data.frame()%>% clipr::write_clip()



# Final data after feature selection
select_vector <- c("REC_MED_COND", "REC_FUNCTN_STAT", 
  "REC_PHYSC_CAPACITY", "REC_WORK_NO_STAT", "REC_HGT_CM", "REC_WGT_KG", "REC_BMI", 
  "REC_ANTIVRL_THERAPY_TY", "REC_ANTIVRL_THERAPY_TY_ACYCLOVIR", "REC_ANTIVRL_THERAPY_TY_CYTOVENE", 
  "REC_ANTIVRL_THERAPY_TY_VALCYTE", "REC_ANTIVRL_THERAPY_TY_HBIG", "REC_ANTIVRL_THERAPY_TY_OTHER", 
  "REC_TX_TY", "REC_VENTILATOR", "REC_LIFE_SUPPORT_OTHER",
  "REC_TUMOR_TY", "REC_SGPT", "REC_PROCEDURE_TY_LI", 
  "REC_WARM_ISCH_TM", "REC_COLD_ISCH_TM", "REC_DGN2", "CAN_LAST_ALBUMIN.x", 
  "CAN_LAST_ASCITES.x", "CAN_LAST_BILI.x", "CAN_LAST_ENCEPH.x", "CAN_LAST_INR.x", 
  "CAN_LAST_SERUM_CREAT.x", "CAN_LAST_SERUM_SODIUM.x", 
  "REC_A1", "REC_A2", "REC_B1", "REC_B2", "REC_DR1", "REC_DR2", 
  "CAN_HGT_CM.x", "CAN_WGT_KG.x", "CAN_DGN.x", "CAN_DIAB_TY.x", "CAN_PEPTIC_ULCER.x", 
  "CAN_ANGINA_CAD.x", "REC_MM_EQUIV_TX", "REC_MM_EQUIV_CUR", 
  "CANHX_MPXCPT_HCC_APPROVE_IND", "CANHX_MPXCPT_HCC_APPLY_IND", "HBA1C", "waittime", 
  "dri_1", "CAN_MAX_MILE",
  "CAN_MIN_WGT", "CAN_MAX_WGT", "CAN_YEAR_ENTRY_US", "CAN_MED_COND", 
  "CAN_VENTILATOR", "CAN_LIFE_SUPPORT_OTHER", "CAN_FUNCTN_STAT", "CAN_PHYSC_CAPACITY", 
  "CAN_WORK_NO_STAT", "CAN_WORK_YES_STAT",
  "Stat1A_initial", "Stat1A_last", "can_diabetes_ty", "MELD_initial", 
  "MELD_last", "can_dialysis", "rec_age_in_years", "tx_deathorfail365"
)


# Save data for SVM
df_final <- df_new_1 %>% select(select_vector)
write.csv(df_final, "features_selected.csv")
df_final %>% group_by(tx_deathorfail365) %>% summarise(n())



# COX proportional hazard
cox <- coxph(Surv(tx_deathorfail365, tx_time365) ~ .,df_new_1)
cox_summary <- as.data.frame(cox$coefficients)





