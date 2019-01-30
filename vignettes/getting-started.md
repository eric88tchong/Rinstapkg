---
title: "Getting Started"
author: "Steven M. Mortimer"
date: "2018-03-12"
output:
  rmarkdown::html_vignette:
    toc: true
    toc_depth: 4
    keep_md: true
vignette: >
  %\VignetteIndexEntry{Getting Started}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



First, load the `salesforcer` package and login. There are two ways to authenticate: 
1) OAuth 2.0 and 2) Basic Username-Password. It is recommended to use OAuth 2.0 so that 
passwords do not have to be shared/embedded within scripts. User credentials will 
be stored in locally cached file entitled ".httr-oauth-salesforcer" in the current working 
directory.




```r
suppressWarnings(suppressMessages(library(dplyr)))
library(salesforcer)
sf_auth()
```

Just a note, that it's not necessary to setup your own Connected App in Salesforce 
to use OAuth 2.0 authentication. The only difference is that the authentication 
will be run through the client created and associated with the `salesforcer` 
package. By using the package client, you will *NOT* be giving access to Salesforce 
to anyone, the package is just the medium for you to connect to your own data. 
If you wanted more control you would specify those options like so: 


```r
options(salesforcer.consumer_key = "012345678901-99thisisatest99connected33app22key")
options(salesforcer.consumer_secret = "Th1s1sMyConsumerS3cr3t")

sf_auth()
```

After logging in with `sf_auth()`, you can check your connectivity by looking at 
the information returned about the current user. It should be information about you!


```r
# pull down information of person logged in
# it's a simple easy call to get started 
# and confirm a connection to the APIs
user_info <- sf_user_info()
sprintf("User Id: %s", user_info$id)
#> [1] "User Id: 0056A000000MPRjQAO"
sprintf("User Active?: %s", user_info$isActive)
#> [1] "User Active?: TRUE"
```

### Create
Salesforce has objects and those objects contain records. One default object is the 
"Contact" object. This example shows how to create two records in the Contact object.


```r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, "Contact")
created_records
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <chr>  
#> 1 0036A00000SncEJQAZ true   
#> 2 0036A00000SncEKQAZ true
```

### Retrieve
Retrieve pulls down a specific set of records and fields. It's very similar to 
running a query, but doesn't use SOQL. Here is an example where we retrieve the 
data we just created.


```r
retrieved_records <- sf_retrieve(ids=created_records$id, 
                                 fields=c("FirstName", "LastName"), 
                                 object_name="Contact")
retrieved_records
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0036A00000SncEJQAZ Test      Contact-Create-1
#> 2 0036A00000SncEKQAZ Test      Contact-Create-2
```


### Query

Salesforce has proprietary form of SQL called SOQL (Salesforce Object Query 
Language). SOQL is a powerful tool that allows you to return the attributes of records 
on almost any object in Salesforce including Accounts, Contacts, Tasks, Opportunities, 
even Attachments! Below is an example where we grab the data we just created 
including Account object information for which the Contact record is associated 
with. The Account column is all `NA` since we have yet to provide information to 
link these Contacts with Accounts.


```r
my_soql <- sprintf("SELECT Id, 
                           Account.Name, 
                           FirstName, 
                           LastName 
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$id , collapse="','"))

queried_records <- sf_query(my_soql)
queried_records
#> # A tibble: 2 x 4
#>   Id                 Account FirstName LastName        
#> * <chr>              <lgl>   <chr>     <chr>           
#> 1 0036A00000SncEJQAZ NA      Test      Contact-Create-1
#> 2 0036A00000SncEKQAZ NA      Test      Contact-Create-2
```

### Update

After creating records you can update them using `sf_update()`. Updating a record 
requires you to pass the Salesforce `Id` of the record. Salesforce creates a unique 
18-character identifier on each record and uses that to know which record to 
attach the update information you provide. Simply include a field or column in your 
update dataset called "Id" and the information will be matched. Here is an example 
where we update each of the records we created earlier with a new first name 
called "TestTest".


```r
# Update some of those records
queried_records <- queried_records %>%
  mutate(FirstName = "TestTest") %>% 
  select(-Account)

updated_records <- sf_update(queried_records, object_name="Contact")
updated_records
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <chr>  
#> 1 0036A00000SncEJQAZ true   
#> 2 0036A00000SncEKQAZ true
```

### Delete
You can also delete records in Salesforce. The method implements a "soft" delete 
meaning that the deleted records go to the Recycle Bin which can be emptied or 
queried against later in the event that the record needed.


```r
deleted_records <- sf_delete(updated_records$id)
deleted_records
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000SncEJQAZ TRUE    <list [0]>
#> 2 0036A00000SncEKQAZ TRUE    <list [0]>
```

### Upsert
Finally, Salesforce has a unique method called "upsert" that allows you to 
create and/or update records at the same time. More specifically, if the record 
is not found based an an "External Id" field, then Salesforce will create the 
record instead of updating one. Below is an example where we create 2 records, 
then upsert 3, where 2 are matched and updated and one is created. **NOTE**: You 
will need to create a custom field on the target object and ensure it is labeled as 
an "External Id" field. Read more at http://blog.jeffdouglas.com/2010/05/07/using-exernal-id-fields-in-salesforce/.


```r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n), 
                       My_External_Id__c=letters[1:n])
created_records <- sf_create(new_contacts, "Contact")

upserted_contacts <- tibble(FirstName = rep("Test", n),
                            LastName = paste0("Contact-Upsert-", 1:n), 
                            My_External_Id__c=letters[1:n])
new_record <- tibble(FirstName = "Test",
                     LastName = paste0("Contact-Upsert-", n+1), 
                     My_External_Id__c=letters[n+1])
upserted_contacts <- bind_rows(upserted_contacts, new_record)

upserted_records <- sf_upsert(input_data=upserted_contacts, 
                              object_name="Contact", 
                              external_id_fieldname="My_External_Id__c")
upserted_records
#> # A tibble: 3 x 3
#>   created id                 success
#>   <chr>   <chr>              <chr>  
#> 1 false   0036A00000SncEOQAZ true   
#> 2 false   0036A00000SncEPQAZ true   
#> 3 true    0036A00000SncETQAZ true
```



### Check out the Tests

The **salesforcer** package has quite a bit of unit test coverage to track any 
changes made between newly released versions of the Salesforce API (typically 4 each year). 
These tests are an excellent source of examples because they cover most all cases of 
utilizing the package functions. 
