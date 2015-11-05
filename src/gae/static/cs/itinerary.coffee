# Class to represent the user's itinerary

class ottb.Itinerary
   @NUM_SECONDS_IN_DAY = 24 * 60 * 60
   @NUM_SECONDS_IN_HOUR = 60 * 60
   
   constructor: (cache) ->
      @itinerary = new Array
      @duration = 0
      @distance = 0
      @routes = []
      @cache = cache
      @polygon = undefined
      
      itinerarySource = $("#itinerary-ui").html()
      @itineraryTemplate = Handlebars.compile(itinerarySource)
      
      distanceDurationSource = $("#itinerary-distance-duration").html()
      @distanceDurationTemplate = Handlebars.compile(distanceDurationSource)
      
      goButtonSource = $("#itinerary-go-button").html()
      @goButtonTemplate = Handlebars.compile(goButtonSource)
      
      gameSource = $("#itinerary-game").html()
      @gameTemplate = Handlebars.compile(gameSource)
      
   
   getGames: () ->
      @itinerary.slice()
     
      
   addToMap: (map) ->
      map.addItinerary($(@itineraryTemplate())[0])


   addGame: (game, map) ->
      @itinerary.push(game)
      @itinerary.sort(@sortGameByDay)
      @calculateTimeAndDistance()
      @drawItinerary(map)
      
      
   removeGame: (gameToDelete, map) ->
      for game, i in @itinerary
         if game.home_team_abbr == gameToDelete.home_team_abbr
            @itinerary.splice(i, 1);
            break     
      
      @calculateTimeAndDistance()
      @drawItinerary(map)


   calculateTimeAndDistance: () ->
      @duration = 0
      @distance = 0
      @routes = []
      prevGame = null
      for game, i in @itinerary         
         # skip first game since that's our origin
         if 0 == i
            prevGame = game
            continue
         
         @routes.push(@cache.getTripRoute(prevGame.home_team_id, game.home_team_id))
         @duration += @cache.getTripDuration(prevGame.home_team_id, game.home_team_id)
         @distance += @cache.getTripDistance(prevGame.home_team_id, game.home_team_id)
         prevGame = game
      
      
   drawItinerary: (map) ->
      $("#itinerary").empty()
      table = $("<table>")
      
      if @itinerary.length > 0
         table.append(@goButtonTemplate())
      
      if @itinerary.length > 1
         numDays = Math.floor(@duration / ottb.Itinerary.NUM_SECONDS_IN_DAY)
         numHours = Math.round((@duration - (numDays * ottb.Itinerary.NUM_SECONDS_IN_DAY)) / ottb.Itinerary.NUM_SECONDS_IN_HOUR)

         context = 
            distance: Math.round(@distance / 1609.34) + " miles"
            duration: numDays + " days " + numHours + " hours"
         table.append(@distanceDurationTemplate(context))
         
      map.drawRoute(@routes)
      
      for game in @itinerary
         context =
            game_id: game.id,
            away_team: game.away_team_abbr, 
            home_team: game.home_team_abbr, 
         table.append(@gameTemplate(context))
         
      $("#itinerary").append(table)
      
   sortGameByDay: (game1, game2) ->
      return (game1.game_day > game2.game_day) - (game2.game_day > game1.game_day)
   