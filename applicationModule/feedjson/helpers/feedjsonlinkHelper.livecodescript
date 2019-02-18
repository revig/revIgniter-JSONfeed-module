script "feedjsonlinkHelper"



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
  end if -- if the short name of the target = the short name of me
end libraryStack




/*----------------------------------------------------------------------
--| FUNCTION getHTMLjsonfeedLink
--|
--| Author: rabit
--| Version:  1.0
--| Created: 2018-04-19
--| Last Mod: --
--| Requires: --
--|
--| Summary: Generates an HTML link tag for a JSON feed.
--| 
--| Format:  getHTMLjsonfeedLink(param1)
--|
--| Parameters: string <pURI> URI of the JSON feed module
--|
--| Return: string
----------------------------------------------------------------------*/

function getHTMLjsonfeedLink pURI
  if pURI is empty then
    put rigFetchConfigItem("feedHTMLlinkTag", "feedjson") into pURI
  else
    if char 1 of pURI is "/" then
      put char 2 to -1 of pURI into pURI
    end if
  end if
    
  return rigHtmlLinkTag(pURI, "alternate", "application/json", rigFetchConfigItem("feedTitle", "feedjson"))
end getHTMLjsonfeedLink








--| END OF feedjsonlinkHelper.livecodescript
--| Location:  ./modules/feedjson/helpers/feedjsonlinkHelper.livecodescript
----------------------------------------------------------------------