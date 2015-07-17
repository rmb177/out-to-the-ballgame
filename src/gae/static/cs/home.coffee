gMap = null
gDatepicker = null
gCommunication = null
gCache = null
gItinerary = null


# formats date as mm/dd/yyyy
formatDate = (date) ->
   date.toJSON().slice(0, 10)


# Callback method for when the user selects a new date  
dateChangedCallback = (date) ->
   date.setFullYear(2015)
   gCommunication.retrieveGamesForDate(formatDate(date), gamesRetrievedCallback)

# Callback method for when games have been retrieved from the server
gamesRetrievedCallback = (games) ->
   gCache.addGames(games)
   gMap.displayGames(games, gItinerary.getGames())
   
# Callback method for when a "Select" link has been clicked
# in an info window. Add the game to the itinerary and
# move to the next day.
selectLinkCallback = (gameId) ->
   gItinerary.addGame(gCache.getGame(gameId))
   gDatepicker.gotoNextDay()
   

# Callback method for when a "Remove" link has been clicked
# in an info window. Remove the game from the intinerary and
# reload the map for the current day
removeLinkCallback = (gameId) ->
   gItinerary.removeGame(gCache.getGame(gameId))
   gDatepicker.reloadCurrentDay()


initUI = ->   
   gCache = new ottb.Cache
   gItinerary = new ottb.Itinerary()
   gCommunication = new ottb.Communication()
   gDatepicker = new ottb.Datepicker(dateChangedCallback)
   gMap = new ottb.Map(selectLinkCallback, removeLinkCallback)
      
   gDatepicker.addToMap(gMap)
   gItinerary.addToMap(gMap)

$(document).ready initUI
