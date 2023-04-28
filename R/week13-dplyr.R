## Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(dplyr)
library(RMariaDB)

## Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user="grieb046",
                  password=key_get("latis-mysql","grieb046"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = 'mysql_hotel_umn_20220728_interm.cer'
)

dbExecute(conn, "USE cla_tntlab;")

#create dataset called week13_tbl saving week13.csv in data
latisdata <- dbGetQuery(conn, "SELECT * FROM datascience_8960_table")
write.csv(latisdata, "../data/week13.csv")

week13_tbllarge <-read.csv("../data/week13.csv")
week13_tbl <- week13_tbllarge[,2:14]

#Display total number of managers
nrow(week13_tbl)

#Display total number of unique managers (i.e. unique by id number)
length(unique(week13_tbl$employee_id))

#Display a summary of the number of managers split by location, but only include those who were not originally hired as managers.
week13_tbl %>% 
  filter(manager_hire == "N") %>% 
  group_by(city) %>%
  count()

#Display the average and standard deviation of number of years of employment split by performance level (bottom, middle, and top)
week13_tbl %>% 
  group_by(performance_group) %>% 
  summarise(average_years = mean(yrs_employed), sd_years = sd(yrs_employed))

#Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
topmanagers_bylocation<- week13_tbl %>% 
  group_by(city) %>% 
  arrange(city, desc(test_score)) %>% 
  select(employee_id, test_score, city) %>% 
  slice_max(order_by = tibble(city, test_score), n = 3, with_ties = T)
topmanagers_bylocation