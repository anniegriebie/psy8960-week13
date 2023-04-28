## Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)

## Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user="grieb046",
                  password=key_get("latis-mysql","grieb046"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = '../mysql_hotel_umn_20220728_interm.cer')

dbExecute(conn, "USE cla_tntlab;")

## Analysis

#Display total number of managers
dbGetQuery(conn, "SELECT COUNT(manager_hire) 
           FROM datascience_8960_table;")

#Display total number of unique managers (i.e. unique by id number)
dbGetQuery(conn, "SELECT COUNT(DISTINCT employee_id) 
           FROM datascience_8960_table;")

#Display a summary of the number of managers split by location but only include those who were not originally hired as managers.
dbGetQuery(conn, "SELECT city, COUNT(employee_id) 
           FROM datascience_8960_table
           WHERE manager_hire = 'N'
           GROUP BY city;")

#Display the average and standard deviation of number of years of employment split by performance level (bottom, middle and top)
dbGetQuery(conn, "SELECT performance_group, 
            AVG(yrs_employed), 
            STDDEV(yrs_employed)
            FROM datascience_8960_table
            GROUP BY performance_group;")

#Display the location and ID numbers of the top 3 managers from each location, in alphabetical order by location and then descending order of test score. If there are ties, include everyone reaching rank 3.
dbGetQuery(conn, "WITH temp_ranked AS (
           SELECT *, 
           DENSE_RANK() OVER(PARTITION BY city ORDER BY test_score DESC) AS manager_rank
           FROM datascience_8960_table)
           SELECT employee_id, city, test_score
           FROM temp_ranked
           WHERE manager_rank IN (1,2,3);")

#pulled checking to see if worked