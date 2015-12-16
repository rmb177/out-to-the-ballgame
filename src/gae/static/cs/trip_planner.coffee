# Class to handle auto-planning of trips

class ottb.TripPlanner

   constructor: (itinerary, map, cache, communication, datePicker) ->
      @itinerary = itinerary
      @map = map
      @cache = cache
      @communication = communication
      @datePicker = datePicker


   planTrip: () ->
      games = @itinerary.getGames()
      lastGame = games[games.length - 1]
      
      # Date is yyyy-mm-dd string
      tokens = lastGame.game_day.split("-")
      @datePicker.gotoDate(new Date(parseInt(tokens[0]), parseInt(tokens[1]) - 1, 1 + parseInt(tokens[2])))
      
      
      #  get date of last game in itinerary
      #  goto that date
      
      #if gCache.getGamesForDate(dateStr)
      #   gMap.displayGames(gCache.getGamesForDate(dateStr), gItinerary.getGames())
      #else   
      #   gCommunication.retrieveGamesForDate(formatDate(date), gamesRetrievedCallback)
      
      #for num in [1..30]
      #   @datePicker.gotoNextDay()