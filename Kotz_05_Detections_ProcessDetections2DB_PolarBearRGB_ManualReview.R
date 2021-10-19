# Process manually reviewed polar_bear detection data to DB
# S. Hardy, 10 August 2020

# Install libraries
library(tidyverse)
library(RPostgreSQL)

# Set variables for processing
wd <- "C:/Users/stacie.hardy/Work/Work/Projects/AS_Detections/Data/Kotz_2019/F07"
original_file <- "2019TestF7L_imagesRGB_manualReview_20201023_complete_fromCLC.csv"
image_list <- "2019TestF7L_imagesRGB_manualReview.txt"
flight <- "fl07"
camera <- "L"
reviewer <- "CLC"

# Set up working environment
"%notin%" <- Negate("%in%")
setwd(wd)
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              #port = Sys.getenv("pep_port"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

# Delete data from tables (if needed)
#RPostgreSQL::dbSendQuery(con, "DELETE FROM surv_polar_bear.tbl_detections_manualreview")

# Import data and process
## ORIGINAL DATA
original_id <- RPostgreSQL::dbGetQuery(con, "SELECT max(id) FROM surv_polar_bear.tbl_detections_manualreview")
original_id$max <- ifelse(length(original_id) == 0, 0, original_id$max)

fields <- max(count.fields(original_file, sep = ','))
original <- read.csv(original_file, header = FALSE, stringsAsFactors = FALSE, skip = 2, col.names = paste("V", seq_len(fields)))
colnames(original) <- c("detection", "image_name", "frame_number", "bound_left", "bound_bottom", "bound_right", "bound_top", "score", "length", "detection_proc", "type_score")

original <- original %>%
  mutate(image_name = sapply(strsplit(image_name, split= "\\/"), function(x) x[length(x)])) %>%
  mutate(id = 1:n() + original_id$max) %>%
  mutate(detection_file = original_file) %>%
  mutate(flight = flight) %>%
  mutate(camera_view = camera) %>%
  separate(detection_proc, c("detection_type", "detection_type_conf", "age_class", "age_class_conf"), "_") %>%
  mutate(detection_type = ifelse(detection_type == "ringed", "ringed_seal",
                                 ifelse(detection_type == "beard", "bearded_seal",
                                        ifelse(detection_type == "unk", "unknown_seal",
                                               age_class)))) %>%
  mutate(detection_type_conf = ifelse(detection_type_conf == "g", "guess",
                                      ifelse(detection_type_conf == "p", "probably",
                                             ifelse(detection_type_conf == "l", "likely", detection_type_conf)))) %>%
  mutate(age_class = ifelse(age_class == "seal", "nonpup",
                            ifelse(age_class == "bird", "not_applicable", age_class))) %>%
  mutate(age_class_conf = ifelse(age_class_conf == "g", "guess",
                                    ifelse(age_class_conf == "p", "probably",
                                           ifelse(age_class_conf == "l", "likely", age_class_conf)))) %>%
  mutate(detection_id = paste("manual_review", flight, camera, detection, sep = "_")) %>%
  select("id", "detection", "image_name", "frame_number", "bound_left", "bound_bottom", "bound_right", "bound_top", "score", "length", "detection_type", "type_score", "detection_type_conf", "age_class", "age_class_conf", "flight", "camera_view", "detection_id", "detection_file")

rm(fields, original_id)

## IMAGE LIST
images <- read.table(image_list, stringsAsFactors = FALSE)
colnames(images) <- "image_list"

# Import data to DB
RPostgreSQL::dbWriteTable(con, c("surv_polar_bear", "tbl_detections_manualreview"), original, append = TRUE, row.names = FALSE)
RPostgreSQL::dbWriteTable(con, c("surv_polar_bear", "temp_images"), images, append = TRUE, row.names = FALSE)
RPostgreSQL::dbSendQuery(con, "UPDATE surv_polar_bear.tbl_images SET rgb_manual_review = \'Y\' WHERE image_name IN (SELECT * FROM surv_polar_bear.temp_images)")
RPostgreSQL::dbSendQuery(con, "DROP TABLE surv_polar_bear.temp_images")
RPostgreSQL::dbDisconnect(con)
rm(con)
