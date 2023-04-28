# Script Settings and Resources
library(keyring)
library(RMariaDB)

#Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user="grieb046",
                  password=key_get("latis-mysql","grieb046"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = 'mysql_hotel_umn_20220728_interm.cer'
)

dbExecute(conn, "USE cla_tntlab;")