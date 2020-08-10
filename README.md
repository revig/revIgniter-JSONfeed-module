# revIgniter JSONfeed module (v. 2.0.0)

This module enables your revIgniter app to publish JSON feeds.  
In case you never heard of JSON feed, it is a format similar  
to RSS or Atom.
Here is the link to the official web-site:  

[https://jsonfeed.org](https://jsonfeed.org)

### Contents

* **applicationModule:** Includes the actual module data
* **assetsModule:** Includes a stylesheet and images for testing
* **dbTableStructures:** For your convenience there are   
ready-made table structures for Postgre, MySQL and SQLite.
* **testControllerAndViews:** Includes a controller and 2 view  
files so you can test the module right away
* **testDatabase:** A SQLite database including sample data
* **TextMateDragDropData:** Here you find code snippets which  
you can drag and drop if you use TextMate and the LC server  
and revIgniter bundles, otherwise you may just copy and  
paste the code  

### Installation

Place the feedjson folder included in applicationModule  
in your application/modules folder. Place the feedjson  
folder included in assetsModule in your assets/modules folder.  
  
Adapt the settings in application/modules/feedjson/config/config.lc  
according to your desires. Note: For testing purposes you can  
leave the file as is.  
  
Implement a database group in your database.lc config file  
named as chosen in the module configuration file. If you  
use TextMate and the LC server and revIgniter TextMate  
bundles you can just drag the databaseGroup.txt file included  
in TextMateDragDropData into your database config file,  
otherwise copy and paste the sample database configuration.  
This database group is meant to be used as a starting point  
in conjunction with the sample database feedjson.sqlite  
included in folder testDatabase. Place this database in your  
application/db folder.  
  
Finally transfer the routes from  
TextMateDragDropData/feedjsonRoutes.txt to your  
application/config/routes.lc file.  

### Testing

Prior to testing make sure you followed the installation  
guide above. Now place the controller feedJsonModuleTest.lc  
in your application/controllers folder and place the view files  
feedJsonModuleTestView.lc and mynewsItemView.lc in your  
application/views folder. All 3 files can be found in folder  
testControllerAndViews.  
  
Assumed you didn't change the routes settings as provided  
in feedjsonRoutes.txt you can view the test feed using the  
following URL:  

your.domain/mynews  

To check what is sent to news feed clients use this URL:  

your.domain/feedjson  

The data reveals the links to single articles. So, you can  
check how it looks like when someone clicks a headline in  
a news reader. See for example:  

your.domain/mynewsitem/This\_is\_article\_number\_15  


### Customizing

To integrate the module in your app you need to adjust the  
settings in application/modules/feedjson/config/config.lc.  
If you change the value of "routedFeedItemURI" or the  
value of "routedFeedURI" don't forget to adapt the routes  
accordingly.  
  
Choose one of the ready-made table structures to set up  
your database. Add an appropriate database group to your  
database.lc file.  
  
To load the module in your own controller please see the  
comments in feedJsonModuleTest.lc. Then add the appropriate  
code snippets you find in folder TextMateDragDropData to  
your view files. For example to add pagination to your view  
drag the file ajaxPaginationCode.txt into your view file  
(provided you use TextMate and and the LC server and  
revIgniter bundles, otherwise just copy and paste the  
code snippets).  


### JSON feed Versions Compatibility
This version of the JSONfeed-Module reflects the changes in  
version 1.1 of JSON feed, though it is backward compatible  
with JSON feed version 1.0.  


### License
For the license terms see the `LICENSE.txt` file.  


### Meta

- Version: 2.1.0
- Web Site: https://revigniter.com/
- Author:  [Ralf Bitter](mailto:rabit@revigniter.com)