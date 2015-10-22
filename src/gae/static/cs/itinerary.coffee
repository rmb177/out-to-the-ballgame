# Class to represent the user's itinerary

class ottb.Itinerary
   @NUM_SECONDS_IN_DAY = 24 * 60 * 60
   @NUM_SECONDS_IN_HOUR = 60 * 60
   
   constructor: (cache) ->
      @itinerary = new Array
      @duration = 0
      @distance = 0
      @cache = cache
      
      source = $("#itinerary-ui").html()
      @template = Handlebars.compile(source)
   
   getGames: () ->
      @itinerary.slice()
     
      
   addToMap: (map) ->
      map.addItinerary($(@template())[0])


   addGame: (game) ->
      @itinerary.push(game)
      @itinerary.sort(@sortGameByDay)
      @calculateTimeAndDistance()
      @drawItinerary()
      
      
   removeGame: (gameToDelete) ->
      for game, i in @itinerary
         if game.home_team_abbr == gameToDelete.home_team_abbr
            @itinerary.splice(i, 1);
            break     
      
      @calculateTimeAndDistance()
      @drawItinerary()


   calculateTimeAndDistance: () ->
      @duration = 0
      @distance = 0
      prevGame = null
      for game, i in @itinerary         
         # skip first game since that's our origin
         if 0 == i
            prevGame = game
            continue
         
         @duration += @cache.getTripDuration(prevGame.home_team_id, game.home_team_id)
         @distance += @cache.getTripDistance(prevGame.home_team_id, game.home_team_id)
         prevGame = game
      
      
   drawItinerary: () ->
      $("#itinerary").empty()
      table = $("<table>")
      
      gameSource = $("#itinerary-game").html()
      gameTemplate = Handlebars.compile(gameSource)
      
      if @itinerary.length > 1
         numDays = Math.floor(@duration / ottb.Itinerary.NUM_SECONDS_IN_DAY)
         numHours = Math.round((@duration - (numDays * ottb.Itinerary.NUM_SECONDS_IN_DAY)) / ottb.Itinerary.NUM_SECONDS_IN_HOUR)

         distanceDurationSource = $("#itinerary-distance-duration").html()
         distanceDurationTemplate = Handlebars.compile(distanceDurationSource)
         context = 
            distance: Math.round(@distance / 1609.34) + " miles"
            duration: numDays + " days " + numHours + " hours"
         table.append(distanceDurationTemplate(context))

      for game in @itinerary
         context =
            game_id: game.id,
            away_team: game.away_team_abbr, 
            home_team: game.home_team_abbr, 
         table.append(gameTemplate(context))
      $("#itinerary").append(table)
      
   sortGameByDay: (game1, game2) ->
      return (game1.game_day > game2.game_day) - (game2.game_day > game1.game_day)
   