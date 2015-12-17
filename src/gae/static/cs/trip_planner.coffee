# Class to handle auto-planning of trips

class ottb.TripPlanner

   constructor: (itinerary, map, cache, communication, datePicker) ->
      @itinerary = itinerary
      @map = map
      @cache = cache
      @communication = communication
      @datePicker = datePicker


   planTrip: () ->
      gamesInTrip = @itinerary.getGames()
      teamsVisited = (game.home_team_abbr for game in gamesInTrip)
      lastGame = gamesInTrip[gamesInTrip.length - 1]
      
      # Date is yyyy-mm-dd string
      tokens = lastGame.game_day.split("-")
      nextDay = new Date(parseInt(tokens[0]), parseInt(tokens[1]) - 1, 1 + parseInt(tokens[2]))
      @datePicker.gotoDate(nextDay)
      
      nextDayKey = nextDay.getFullYear() + "-" + 
         @ensureTwoDigitNumber(nextDay.getMonth() + 1) + "-" + 
         @ensureTwoDigitNumber(nextDay.getDate())
         
      todaysGames = @cache.getGamesForDate(nextDayKey)
      
      for game in todaysGames
         alreadyVisited = (team for team in teamsVisited when team is game.home_team_abbr)[0]
         if not alreadyVisited?
            @itinerary.addGame(game, @map)
            break
            
            
            
      #  get date of last game in itinerary
      #  goto that date
      
      #if gCache.getGamesForDate(dateStr)
      #   gMap.displayGames(gCache.getGamesForDate(dateStr), gItinerary.getGames())
      #else   
      #   gCommunication.retrieveGamesForDate(formatDate(date), gamesRetrievedCallback)
      
      #for num in [1..30]
      #   @datePicker.gotoNextDay()
   
   
   ensureTwoDigitNumber: (number) ->
      str = '' + number;
      if str.length < 2
         str = '0' + str;
      return str