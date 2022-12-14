script "feedjsonmodel"



global gRigA





 /*----------------------------------------------------------------------
 --| COMMAND libraryStack
 --|
 --| Author: rabit
 --| Version:  1.0
 --| Created: 2019-02-18
 --| Last Mod: --
 --| Requires: --
 --|
 --| Summary:  Run security check.
 --| 
 --| Parameters: --
 --|
 --| Return: empty
 ----------------------------------------------------------------------*/
 
on libraryStack
  if (gRigA is not an array) and (the environment is "server") then
    put "No direct script access allowed."
    exit to top
  end if

  if the short name of the target <> the short name of me then
    pass libraryStack
  end if -- if the short name of the target <> the short name of me
end libraryStack





/*----------------------------------------------------------------------
--| FUNCTION newsFetchAllData
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-21
--| Last Mod: 2018-04-21
--| Requires: rigDbOrderBy, rigDbWhere, rigDbGet()
--|
--| Summary: Return query result as array.
--| 
--| Format:  newsFetchAllData(param1)
--|
--| Parameters: string <pTable> the name of the table
--|
--| Return: array
----------------------------------------------------------------------*/

function newsFetchAllData pTable
	rigDbOrderBy "postdate", "desc"
	rigDbWhere "postvisible", 1

	put rigDbGet(pTable) into tQueryResult
	if tQueryResult["numrows"] > 0 then
		return tQueryResult
	end if

	return FALSE
end newsFetchAllData



/*----------------------------------------------------------------------
--| FUNCTION newsFetchLimitData
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-21
--| Last Mod: 2018-04-21
--| Requires: rigDbOrderBy, rigDbWhere, rigDbLimit, rigDbGet()
--|
--| Summary: Return limit query result as array.
--| 
--| Format:  newsFetchLimitData(param1, param2, param3)
--|
--| Parameters: string <pTable> the name of the table, integer <pLimit>, integer <pOffset>
--|
--| Return: array
----------------------------------------------------------------------*/

function newsFetchLimitData pTable pLimit pOffset
	if pOffset is empty then
		put 0 into tOffset
	else
		put pOffset into tOffset
	end if

	rigDbOrderBy "postdate", "desc"
	rigDbWhere "postvisible", 1
	rigDbLimit pLimit, tOffset

	put rigDbGet(pTable) into tQueryResult
	if tQueryResult["numrows"] > 0 then
		return tQueryResult
	end if

	return FALSE
end newsFetchLimitData




/*----------------------------------------------------------------------
--| FUNCTION newsFetchItem
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-30
--| Last Mod: 2018-04-30
--| Requires: rigDbGetWhere(), rigDbRow(), rigSqlDateTimeToIntDate()
--|
--| Summary: Return news item.
--| 
--| Format:  newsFetchItem(param1, param2)
--|
--| Parameters: string <pTable> the name of the table, integer <pTitle>
--|
--| Return: array
----------------------------------------------------------------------*/

function newsFetchItem pTable pTitle
	put pTitle into tArray["title"]
	put 1 into tArray["postvisible"]

	put rigDbGetWhere(pTable, tArray) into tQueryResult
	if tQueryResult["numrows"] > 0 then
		put rigDbRow(1) into tRowData

		put rigSqlDateTimeToIntDate(tRowData["postdate"]) into tDate
		convert tDate to long date

		put tRowData["title"] into tTitle
		replace "_" with space in tTitle

    put tTitle into tNewsItemA["title"]
    put tRowData["body"] into tNewsItemA["body"]
    put tDate into tNewsItemA["newsDate"]

		return tNewsItemA
	end if

	return FALSE
end newsFetchItem



/*----------------------------------------------------------------------
--| FUNCTION titleBodyData
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-05-06
--| Last Mod: 2018-05-06
--| Requires: rigDbRow(), rigSqlDateTimeToIntDate()
--|
--| Summary: Return news title and body html data.
--| 
--| Format:  titleBodyData(param1)
--|
--| Parameters: string <pQuery>
--|
--| Return: string
----------------------------------------------------------------------*/

function titleBodyData pQuery
	if pQuery["numrows"] > 0 then
		put "<hr class=" & quote & "half-rule" & quote & ">" into tHalfRule
		put return into tNewsdata
		
		repeat with i = 1 to pQuery["numrows"]
			put rigDbRow(i) into tRowData

			put rigSqlDateTimeToIntDate(tRowData["postdate"]) into tDate
			convert tDate to long date

			put tRowData["title"] into tTitle
			replace "_" with space in tTitle
			
			# BUILD NEWS ITEM HTML CODE
			put return & "<article class=" & quote & "newsItem" & quote & ">" & return after tNewsdata			
			put "<header><h3>" & tTitle & "</h3></header>" & return & tRowData["body"] & return after tNewsdata
			put "<p><span class=" & quote & "postdate" & quote & ">Posted on" && tDate & "</span></p>" & return & tHalfRule & return & "</article>" & return after tNewsdata
			#
		end repeat
		
	else
		put "" into tNewsdata
	end if

	return tNewsdata
end titleBodyData



/*----------------------------------------------------------------------
--| FUNCTION fetchRecentPosts
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-21
--| Last Mod: 2018-04-21
--| Requires: rigDbOrderBy, rigDbWhere, rigDbLimit, rigDbGet(), getItemsJSONdata()
--|
--| Summary: Retrieve recent posts.
--| 
--| Format:  fetchRecentPosts()
--|
--| Parameters: integer <pLimit>
--|
--| Return: string
----------------------------------------------------------------------*/

function fetchRecentPosts pLimit
	rigDbOrderBy "postdate", "desc"
	rigDbWhere "postvisible", 1
	rigDbLimit pLimit

	put rigDbGet("news") into tQueryResult
	if tQueryResult["numrows"] > 0 then
		return getItemsJSONdata(tQueryResult)
	else
		return FALSE
	end if
end fetchRecentPosts




/*----------------------------------------------------------------------
--| FUNCTION getItemsJSONdata
--|
--| Author: rabit
--| Version:  1.1
--| Created: 2018-04-21
--| Last Mod: 2020-08-09
--| Requires: rigSiteURL(), rigFetchConfigItem(), rigDbRow(), formatForFeed(), jsonStringEscape()
--|            rigStripHTML(), rigHumanToTimestamp(), rigStandardDate(), getAuthorsJSONdata()
--|
--| Summary: Get JSON feed data. Make sure all feed dates are UTC.
--| 
--| Format:  getItemsJSONdata(param1)
--|
--| Parameters: string <pQuery>
--|
--| Return: string
----------------------------------------------------------------------*/

function getItemsJSONdata pQuery
  local tItemControllerURL, tMinNumChars, tAllRowData, tRowData, tItemsJSONdata
  local tResourceURL, tTitle, tBody, tSummary, tDotOffset, tPostTimestamp
  local tPostModifiedTimestamp, tItemID, tAuthorsJSONdata
  
  if pQuery["numrows"] > 0 then
    # GET URL OF FEED ITEM CONTROLLER
    put rigSiteURL(rigFetchConfigItem("routedFeedItemURI", "feedjson")) & "/" into tItemControllerURL
    
    # GET MINIMUM NUMBER OF CHARS TO BE SHOWN IN SUMMARIES
    put rigFetchConfigItem("minNumChars", "feedjson") into tMinNumChars
    
    repeat with i = 1 to pQuery["numrows"]
      put rigDbRow(i) into tAllRowData[i]
    end repeat

    # PREPARE JSON DATA
     repeat with i = 1 to the number of lines in the keys of tAllRowData
      put tAllRowData[i] into tRowData

      put "{" & return after tItemsJSONdata
      put tItemControllerURL & tRowData["title"] into tResourceURL
      put formatForFeed("id", tResourceURL) after tItemsJSONdata
      put formatForFeed("url", tResourceURL) after tItemsJSONdata
      
      put tRowData["title"] into tTitle
      replace "_" with space in tTitle
      put formatForFeed("title", tTitle) after tItemsJSONdata
			
      put jsonStringEscape(tRowData["body"]) into tBody
      put formatForFeed("content_html", tBody) after tItemsJSONdata
      
      put rigStripHTML(tBody) into tSummary
      # GET FIRST SENTENCE, BUT AT LEAST A MINIMUM NUMBER OF CHARACTERS AS DEFINED IN THE CONFIG FILE
      put offset(". ", tSummary, tMinNumChars) into tDotOffset
      # MAY BE THERE IS NO SENTENCE TERMINATED WITH ". "
      # SO, CHECK IF THERE IS A DOT MISSING A SPACE
      if tDotOffset is 0 then
         put offset(".", tSummary, tMinNumChars) into tDotOffset
      end if
      # IF tDotOffset IS STILL 0 ADD "..." AFTER THE SUMMARY
      if tDotOffset is 0 then
        put (byte 1 to tMinNumChars of tSummary) && "..." into tSummary
      else
        put byte 1 to (tMinNumChars + tDotOffset) of tSummary into tSummary
      end if
      put formatForFeed("summary", tSummary) after tItemsJSONdata
      
      put rigHumanToTimestamp(tRowData["postdate"]) into tPostTimestamp
      put formatForFeed("date_published", rigStandardDate("DATE_W3C", tPostTimestamp)) after tItemsJSONdata
      
      put rigHumanToTimestamp(tRowData["postmodified"]) into tPostModifiedTimestamp
      if tPostModifiedTimestamp <> false then
        put formatForFeed("date_modified", rigStandardDate("DATE_W3C", tPostModifiedTimestamp)) after tItemsJSONdata
      end if
      
      # AUTHOR (JSON feed VERSION 1.0)
      if tRowData["authorname"] is "NULL" then
        put "" into tRowData["authorname"]
      end if -- if tRowData["authorname"] is "NULL"
      put quote & "author" & quote & ": {" & return & quote & "name" & quote & ":" && quote & tRowData["authorname"] & quote & return & "}," & return after tItemsJSONdata

      # AUTHORS DATA (JSON feed VERSION 1.1)
     put tRowData["id"] into tItemID
     put getAuthorsJSONdata(tItemID) into tAuthorsJSONdata
     if tAuthorsJSONdata <> empty then
       put quote & "authors" & quote & ": [" & return & tAuthorsJSONdata & return & "]" & return after tItemsJSONdata
     end if -- if tAuthorsJSONdata <> empty
     
      put "}," & return after tItemsJSONdata
    end repeat
  else
    put "" into tItemsJSONdata
  end if
  #
  
  delete char -4 to -5 of tItemsJSONdata

  return char 1 to -3 of tItemsJSONdata
end getItemsJSONdata





/*----------------------------------------------------------------------
--| FUNCTION getAuthorsJSONdata
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2020-08-08
--| Last Mod: 2020-08-08
--| Requires: rigDbSelect, rigDbFrom, rigDbJoin, rigDbWhere, rigDbGet(), rigDbRow(), formatForFeed
--|
--| Summary: Build authors (JSON feed version 1.1) JSON data.
--| 
--| Format:  getAuthorsJSONdata([param1])
--|
--| Parameters: integer <pNewsID> (optional)
--|
--| Return: string
----------------------------------------------------------------------*/

function getAuthorsJSONdata pNewsID
  local tQuery, tUndefinedAuthors, tRowData, tAuthorsJSONdata
  local tURL, tAvatar, tAvatarFormatted
  
  if pNewsID <> empty then
    rigDbSelect "name,url,avatar"
    rigDbFrom "authors"
    rigDbJoin "news_authors", "authors.id = news_authors.authors_id"
    rigDbJoin "news", "news_authors.news_id = news.id"
    rigDbWhere "news.id", pNewsID

    put rigDbGet() into tQuery
  
    if tQuery["numrows"] is 0 then
      put TRUE into tUndefinedAuthors
    end if
  end if
  
  # FALLBACK IF NO NEWS ID WAS SPECIFIED: GET TOP-LEVEL AUTHORS DATA
  if (pNewsID is empty) or (tUndefinedAuthors is TRUE) then
    rigDbFrom "authors"
    put rigDbGet() into tQuery
  end if

  if tQuery["numrows"] > 0 then
    repeat with i = 1 to tQuery["numrows"]
      put rigDbRow(i) into tRowData
    
      put "{" & return after tAuthorsJSONdata
      
      # NAME
      put tRowData["name"] into tName
      put formatForFeed("name", tName) after tAuthorsJSONdata
      
      #URL
      put tRowData["url"] into tURL
      if tURL is "NULL" then
        put "" into tURL
      end if
      put formatForFeed("url", tURL) after tAuthorsJSONdata
      
      #AVATAR
      put tRowData["avatar"] into tAvatar
      if tAvatar is "NULL" then
        put "" into tAvatar
      end if
      put formatForFeed("avatar", tAvatar) into tAvatarFormatted
      delete char -2 of tAvatarFormatted
      put tAvatarFormatted after tAuthorsJSONdata
    
      put "}," & return after tAuthorsJSONdata
    end repeat
  
  else
    put "" into tAuthorsJSONdata
  end if
  
  delete char -4 to -5 of tAuthorsJSONdata

  return char 1 to -3 of tAuthorsJSONdata
end getAuthorsJSONdata





/*----------------------------------------------------------------------
--| FUNCTION formatForFeed
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-22
--| Last Mod: 2018-04-22
--| Requires: --
--|
--| Summary: Use a list item name and item data to return a JSON formated list entry.
--| 
--| Format:  formatForFeed(param1, param2)
--|
--| Parameters: string <pItemName>, string <pItemData>
--|
--| Return: string
----------------------------------------------------------------------*/

function formatForFeed pItemName pItemData
  return quote & pItemName & quote & ":" && quote & pItemData & quote & "," & return
end formatForFeed




/*----------------------------------------------------------------------
--| FUNCTION jsonStringEscape
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-22
--| Last Mod: 2018-04-22
--| Requires: --
--|
--| Summary: Escapes double quotes and backslash.
--| 
--| Format:  jsonStringEscape(param)
--|
--| Parameters: string <pStr>
--|
--| Return: string
----------------------------------------------------------------------*/

function jsonStringEscape pStr
  replace "\" with "\\" in pStr
  replace quote with "\" & quote in pStr
  
  return pStr
end jsonStringEscape




/*----------------------------------------------------------------------
--| FUNCTION mostRecentModDate
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-27
--| Last Mod: 2018-04-27
--| Requires: rigDbQuery(), rigSqlDateTimeToIntDate()
--|
--| Summary: Get date of most recent feed modification. Make sure all feed dates are UTC. 
--| 
--| Format:  mostRecentModDate()
--|
--| Parameters: --
--|
--| Return: string 
----------------------------------------------------------------------*/

function mostRecentModDate
  put rigDbPlatform() into tDbPlatform
  
  switch tDbPlatform
    case "postgre"
      put rigDbQuery("SELECT CASE WHEN MAX(postmodified) IS NOT NULL THEN GREATEST(MAX(postdate), MAX(postmodified)) ELSE MAX(postdate) END AS mostRecentModDate FROM news WHERE postvisible = '1'") into tQueryResult
    break
    
    case "mysql"
      put rigDbQuery("SELECT IF((SELECT MAX(postmodified) FROM news WHERE postvisible = '1') IS NOT NULL, (SELECT GREATEST(MAX(postdate), MAX(postmodified)) FROM news WHERE postvisible = '1'), (SELECT MAX(postdate) FROM news WHERE postvisible = '1'))") into tQueryResult
    break
    
    case "sqlite"
      put rigDbQuery("SELECT CASE WHEN MAX(postmodified) NOT NULL THEN MAX(MAX(postdate), MAX(postmodified)) ELSE MAX(postdate) END mostRecentModDate FROM news WHERE postvisible = '1'") into tQueryResult
  end switch

  if tQueryResult["numrows"] > 0 then
    # rigDbRow() DOES NOT WORK HERE
    put tQueryResult["resultarray"][1][1] into tMostRecentModDate

    # CONVERT DATE TO RFC 1123
    # REPLACE TIME OFFSET WITH GMT
    put rigSqlDateTimeToIntDate(tMostRecentModDate) into tDate
    put "GMT" into char -5 to -1 of tDate

    return tDate

  else
    return FALSE
  end if
end mostRecentModDate





--| END OF feedjsonmodel.livecodescript
--| Location:  ./modules/feedjson/models/feedjsonmodel.livecodescript
----------------------------------------------------------------------