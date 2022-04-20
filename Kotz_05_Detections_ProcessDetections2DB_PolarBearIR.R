# Process Kotz detection data to DB
# S. Hardy, 10 August 2020

# Install libraries
library(tidyverse)
library(RPostgreSQL)

# Set variables for processing
wd <- "C:/skh"
processed_file <- "2019TestF7C_tinyYolo_ir_20200219_updatedIR.csv"
flight <- "fl07"
camera <- "C"

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
#RPostgreSQL::dbSendQuery(con, "DELETE FROM surv_polar_bear.tbl_detections_processed_ir")

# Import data and process
## PROCESSED DATA
processed_id <- RPostgreSQL::dbGetQuery(con, "SELECT max(id) FROM surv_polar_bear.tbl_detections_processed_ir")
processed_id$max <- ifelse(length(processed_id) == 0, 0, processed_id$max)

processed <- read.csv(processed_file, skip = 2, header = FALSE, stringsAsFactors = FALSE, col.names = c("detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", "score", "length", "detection_type", "type_score"))
processed <- processed %>%
  mutate(image_name = sapply(strsplit(image_name, split= "\\/"), function(x) x[length(x)])) %>%
  mutate(id = 1:n() + processed_id$max) %>%
  mutate(detection_file = processed_file) %>%
  mutate(flight = flight) %>%
  mutate(camera_view = camera) %>%
  mutate(detection_id = paste("polar_bear", flight, camera, detection, sep = "_")) %>%
  select("id", "detection", "image_name", "frame_number", "bound_left", "bound_top", "bound_right", "bound_bottom", "score", "length", "detection_type", "type_score", "flight", "camera_view", "detection_id", "detection_file")

rm(processed_id)

# Import data to DB
RPostgreSQL::dbWriteTable(con, c("surv_polar_bear", "tbl_detections_processed_ir"), processed, append = TRUE, row.names = FALSE)
RPostgreSQL::dbDisconnect(con)
rm(con)
