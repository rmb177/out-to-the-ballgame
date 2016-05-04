gMap = null
gDatepicker = null
gCommunication = null
gCache = null
gItinerary = null
gTripPlanner = null


# formats date as mm/dd/yyyy
formatDate = (date) ->
   date.toJSON().slice(0, 10)


# Callback method for when the user selects a new date  
dateChangedCallback = (date) ->
   date.setFullYear(2016)
   dateStr = formatDate(date)
   if gCache.getGamesForDate(dateStr)
      gMap.displayGames(gCache.getGamesForDate(dateStr), gItinerary.getGames())
   else   
      gCommunication.retrieveGamesForDate(formatDate(date), gamesRetrievedCallback)

# Callback method for when games have been retrieved from the server
gamesRetrievedCallback = (games, date) ->
   gCache.addGames(games, date)
   gMap.displayGames(games, gItinerary.getGames())
   
# Callback method for when trips have been retrieved from the server
tripsRetrievedCallback = (trips) ->
   gCache.addTrips(trips)
   
# Callback method for when a "Select" link has been clicked
# in an info window. Add the game to the itinerary and
# move to the next day.
selectLinkCallback = (gameId) ->
   gItinerary.addGame(gCache.getGame(gameId), gMap)
   gDatepicker.gotoNextDay()
   

# Callback method for when a "Remove" link has been clicked
# in an info window. Remove the game from the intinerary and
# reload the map for the current day
removeLinkCallback = (gameId) ->
   gItinerary.removeGame(gCache.getGame(gameId), gMap)
   gDatepicker.reloadCurrentDay()
   
   
$(document).on("click", "#inineraryGoButton", (event) ->
   gTripPlanner.planTrip()
)

initUI = ->   
   gCache = new ottb.Cache
   gItinerary = new ottb.Itinerary(gCache)
      
   gDatepicker = new ottb.Datepicker(dateChangedCallback)
   gMap = new ottb.Map(selectLinkCallback, removeLinkCallback)
   gDatepicker.addToMap(gMap)
   gItinerary.addToMap(gMap)
   
   gCommunication = new ottb.Communication()
   gCommunication.retrieveTrips(tripsRetrievedCallback)
   
   gTripPlanner = new ottb.TripPlanner(gItinerary, gMap, gCache, gCommunication, gDatepicker)

$(document).ready initUI
