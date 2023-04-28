library(dplyr)
library(RMariaDB)


# in console
ibrary(keyring)
key_set_with_value(service="latis-mysql", username="username", password="password")

## Data Import and Cleaning
library(keyring)
(embedded somewhere:) password = key_get("latis-mysql", "username")