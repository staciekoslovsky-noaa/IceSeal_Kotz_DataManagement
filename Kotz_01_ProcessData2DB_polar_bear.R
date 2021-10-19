# In Flight System: Process Data/Images to DB
# S. Hardy, 5APR2019

# Create functions -----------------------------------------------
# Function to install packages needed
install_pkg <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE)
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}

# Install libraries ----------------------------------------------
install_pkg("RPostgreSQL")
install_pkg("rjson")
install_pkg("plyr")
install_pkg("stringr")

# Run code -------------------------------------------------------
# Set initial working directory
wd <- "//nmfs/akc-nmml/Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/polar_bear_2019"
setwd(wd)

# Create list of camera folders within which data need to be processed 
dir <- list.dirs(wd, full.names = FALSE, recursive = FALSE)
dir <- data.frame(path = dir[grep("fl", dir)], stringsAsFactors = FALSE)
image_dir <- merge(dir, c("LEFT", "CENT", "RGHT"), ALL = true)
colnames(image_dir) <- c("path", "camera_loc")
image_dir$camera_dir <- paste(wd, image_dir$path, image_dir$camera_loc, sep = "/")

# Process images and meta.json files
images2DB <- data.frame(file = as.character(""), dt = as.character(""), type = as.character(""), stringsAsFactors = FALSE)
images2DB <- images2DB[which(images2DB == "test"), ]
meta2DB <- data.frame(rjson::fromJSON(paste(readLines("//nmfs/akc-nmml/Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/polar_bear_2019/Template4Import.json"), collapse="")))
meta2DB$meta_file <- ""
meta2DB$dt <- ""
meta2DB$flight <- ""
meta2DB$camera_view <- ""
meta2DB <- meta2DB[which(meta2DB == "test"), ]

for (i in 1:nrow(image_dir)){
  files <- list.files(image_dir$camera_dir[i], full.names = FALSE, recursive = FALSE)
  files <- data.frame(file = files[which(startsWith(files, "polar_bear_2019") == TRUE)], stringsAsFactors = FALSE)
  files$dt <- substring(files$file, 24, 45)
  files$type <- ifelse(grepl("rgb", files$file) == TRUE, "RGB Image", 
                             ifelse(grepl("ir", files$file) == TRUE, "IR Image",
                                    ifelse(grepl("uv", files$file) == TRUE, "UV Image", 
                                          ifelse(grepl("meta", files$file) == TRUE, "meta.json", "Unknown"))))
  
  images <- files[which(grepl("Image", files$type)), ]
  images2DB <- rbind(images2DB, images)
  
  meta <- files[which(files$type == "meta.json"), ]
  if (nrow(meta) > 1) {
    for (j in 1:nrow(meta)){
      meta_file <- paste(image_dir$camera_dir[i], meta$file[j], sep = "/")
      metaJ <- data.frame(rjson::fromJSON(paste(readLines(meta_file), collapse="")), stringsAsFactors = FALSE)
      metaJ$meta_file <- basename(meta_file)
      metaJ$dt <- substring(metaJ$meta_file, 24, 45)
      metaJ$flight <- substring(metaJ$meta_file, 17, 20)
      metaJ$camera_view <- substring(metaJ$meta_file, 22, 22)
      meta2DB <- plyr::rbind.fill(meta2DB, metaJ)
    }
  }
}

colnames(meta2DB) <- gsub("\\.", "_", colnames(meta2DB))

images2DB$flight <- substring(images2DB$file, 17, 20)
images2DB$camera_view <- substring(images2DB$file, 22, 22)

# Process effort logs
# logs2DB <- data.frame(effort_log = as.character(""), gps_time = as.character(""), sys_time = as.character(""), note = as.character(""), stringsAsFactors = FALSE)
# logs2DB <- logs2DB[which(logs2DB == "test"), ]
# 
# for (i in 1:nrow(dir)){
#   logs <- list.files(dir$path[i], pattern = ".txt", full.names = FALSE, recursive = FALSE)
#   if (length(logs) != 0){
#     for (j in 1:length(logs)){
#       log <- paste(wd, dir$path[i], logs[j], sep = "/")
#       log_file <- scan(log,
#                        sep = "\n",
#                        multi.line = TRUE,
#                        what = "list")
#       log_file <- log_file[which(log_file != "" & log_file != "---")]
#       log_file <- gsub("'", "", log_file)
#       log_file <- paste(log_file, sep = "", collapse = "") 
#       log_file <- strsplit(log_file, "}")
#       log_file <- data.frame(parsed = unlist(log_file), stringsAsFactors = FALSE)
#       log_file$effort_log <- logs[j]
#       
#       # Extract GPS time
#       log_file$dt_gps <- str_match(log_file$parsed, "\\{gps_time: !!timestamp (.*?), note")
#       log_file$dt_gps <- log_file$dt_gps[, 2]
#       log_file$dt_gps <- gsub("-", "", log_file$dt_gps)
#       log_file$dt_gps <- gsub(":", "", log_file$dt_gps)
#       log_file$dt_gps <- gsub(" ", "_", log_file$dt_gps)
#       
#       # Extract SYS time
#       log_file$dt_sys <- substring(log_file$parsed, nchar(log_file$parsed)-22, nchar(log_file$parsed))
#       
#       # Extract note
#       log_file$note <- str_match(log_file$parsed, "note: (.*) sys_time")
#       log_file$note <- trimws(log_file$note[, 2])
#       log_file$note <- gsub(",*$", "", log_file$note, perl = T)
#       
#       # Final processing
#       log_file <- log_file[, c("effort_log", "dt_gps", "dt_sys", "note")]
#       logs2DB <- rbind(logs2DB, log_file)
#     }
#   }
# }
# logs2DB$flight <- substring(logs2DB$effort_log, 17, 20)
# logs2DB$effort <- ifelse(grepl("Selected effort:", logs2DB$note), logs2DB$note, NA)
# logs2DB$collection <- ifelse(grepl("Setting collection mode", logs2DB$note), logs2DB$note, NA)

rm(meta, image_dir, images, log_file, metaJ, i, j, log, logs, meta_file, wd, files)

# Export data to PostgreSQL -----------------------------------------------------------
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

# Create list of data to process
df <- list(images2DB, logs2DB, meta2DB)
dat <- c("tbl_images", "tbl_event_logs", "geo_images_meta")

# Identify and delete dependencies for each table
for (i in 1:length(dat)){
  sql <- paste("SELECT fxn_deps_save_and_drop_dependencies(\'surv_polar_bear\', \'", dat[i], "\')", sep = "")
  RPostgreSQL::dbSendQuery(con, sql)
  RPostgreSQL::dbClearResult(dbListResults(con)[[1]])
}
RPostgreSQL::dbSendQuery(con, "DELETE FROM deps_saved_ddl WHERE deps_ddl_to_run NOT LIKE \'%CREATE VIEW%\'")

# Push data to pepgeo database and process data to spatial datasets where appropriate
for (i in 1:length(dat)){
  RPostgreSQL::dbWriteTable(con, c("surv_polar_bear", dat[i]), data.frame(df[i]), overwrite = TRUE, row.names = FALSE)
  if (i == 3) {
    sql1 <- paste("ALTER TABLE surv_polar_bear.", dat[i], " ADD COLUMN geom geometry(POINT, 4326)", sep = "")
    sql2 <- paste("UPDATE surv_polar_bear.", dat[i], " SET geom = ST_SetSRID(ST_MakePoint(ins_longitude, ins_latitude), 4326)", sep = "")
    RPostgreSQL::dbSendQuery(con, sql1)
    RPostgreSQL::dbSendQuery(con, sql2)
  }
}

# Recreate table dependencies
for (i in length(dat):1) {
  sql <- paste("SELECT fxn_deps_restore_dependencies(\'surv_polar_bear\', \'", dat[i], "\')", sep = "")
  RPostgreSQL::dbSendQuery(con, sql)
  RPostgreSQL::dbClearResult(dbListResults(con)[[1]])
}

# Disconnect for database and delete unnecessary variables ----------------------------
RPostgreSQL::dbDisconnect(con)
rm(con, df, dat, i, sql, sql1, sql2)
