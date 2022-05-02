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
wd <- "//akc0ss-n086/NMML_Polar_Imagery/Techniques_Test/KAMERA_InFlightSystem_2019/test_flights_2019/test_kotz_2019"
setwd(wd)

# Create list of camera folders within which data need to be processed 
dir <- list.dirs(wd, full.names = FALSE, recursive = FALSE)
dir <- data.frame(path = dir[grep("fl[0-9][0-9]$", dir)], stringsAsFactors = FALSE)
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
  files <- data.frame(file = files[which(startsWith(files, "test_kotz") == TRUE)], stringsAsFactors = FALSE)
  files$dt <- str_extract(files$file, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]")
  files$type <- ifelse(grepl("rgb", files$file) == TRUE, "rgb_image", 
                             ifelse(grepl("ir", files$file) == TRUE, "ir_image",
                                    ifelse(grepl("uv", files$file) == TRUE, "uv_image", 
                                          ifelse(grepl("meta", files$file) == TRUE, "meta.json", "Unknown"))))
  
  images <- files[which(grepl("Image", files$type)), ]
  images2DB <- rbind(images2DB, images)
  
  meta <- files[which(files$type == "meta.json"), ]
  if (nrow(meta) > 1) {
    for (j in 1:nrow(meta)){
      meta_file <- paste(image_dir$camera_dir[i], meta$file[j], sep = "/")
      metaJ <- data.frame(rjson::fromJSON(paste(readLines(meta_file), collapse="")), stringsAsFactors = FALSE)
      metaJ$meta_file <- basename(meta_file)
      metaJ$dt <- str_extract(metaJ$meta_file, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]") #substring(metaJ$meta_file, 23, 44)
      metaJ$flight <- str_extract(metaJ$meta_file, "fl[0-9][0-9]") #substring(metaJ$meta_file, 16, 19)
      metaJ$camera_view <- substring(str_extract(metaJ$meta_file, "_[A-Z]_"), 2, 2) #substring(metaJ$meta_file, 21, 21)
      meta2DB <- plyr::rbind.fill(meta2DB, metaJ)
    }
  }
}

colnames(meta2DB) <- gsub("\\.", "_", colnames(meta2DB))

images2DB$flight <- str_extract(images2DB$file, "fl[0-9][0-9]")#substring(images2DB$file, 16, 19)
images2DB$camera_view <- substring(str_extract(images2DB$file, "_[A-Z]_"), 2, 2)#substring(images2DB$file, 21, 21)

rm(meta, image_dir, images, metaJ, i, j, meta_file, wd, files)

# Export data to PostgreSQL -----------------------------------------------------------
con <- RPostgreSQL::dbConnect(PostgreSQL(), 
                              dbname = Sys.getenv("pep_db"), 
                              host = Sys.getenv("pep_ip"), 
                              user = Sys.getenv("pep_admin"), 
                              rstudioapi::askForPassword(paste("Enter your DB password for user account: ", Sys.getenv("pep_admin"), sep = "")))

# Create list of data to process
df <- list(images2DB, meta2DB)
dat <- c("tbl_images", "geo_images_meta")

# Identify and delete dependencies for each table
for (i in 1:length(dat)){
  sql <- paste("SELECT fxn_deps_save_and_drop_dependencies(\'surv_test_kamera\', \'", dat[i], "\')", sep = "")
  RPostgreSQL::dbSendQuery(con, sql)
  RPostgreSQL::dbClearResult(dbListResults(con)[[1]])
}
RPostgreSQL::dbSendQuery(con, "DELETE FROM deps_saved_ddl WHERE deps_ddl_to_run NOT LIKE \'%CREATE VIEW%\'")

# Push data to pepgeo database and process data to spatial datasets where appropriate
for (i in 1:length(dat)){
  RPostgreSQL::dbWriteTable(con, c("surv_test_kamera", dat[i]), data.frame(df[i]), overwrite = TRUE, row.names = FALSE)
  if (i == 2) {
    sql1 <- paste("ALTER TABLE surv_test_kamera.", dat[i], " ADD COLUMN geom geometry(POINT, 4326)", sep = "")
    sql2 <- paste("UPDATE surv_test_kamera.", dat[i], " SET geom = ST_SetSRID(ST_MakePoint(ins_longitude, ins_latitude), 4326)", sep = "")
    RPostgreSQL::dbSendQuery(con, sql1)
    RPostgreSQL::dbSendQuery(con, sql2)
  }
}

# Recreate table dependencies
for (i in length(dat):1) {
  sql <- paste("SELECT fxn_deps_restore_dependencies(\'surv_test_kamera\', \'", dat[i], "\')", sep = "")
  RPostgreSQL::dbSendQuery(con, sql)
  RPostgreSQL::dbClearResult(dbListResults(con)[[1]])
}

# Disconnect for database and delete unnecessary variables ----------------------------
RPostgreSQL::dbDisconnect(con)
rm(con, df, dat, i, sql, sql1, sql2)
