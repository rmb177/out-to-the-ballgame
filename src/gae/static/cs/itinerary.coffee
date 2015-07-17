# Class to represent the user's itinerary

class ottb.Itinerary
   
   constructor: (callback) ->
      @itinerary = new Array
      @drawItineraryCallback = callback
      
      source = $("#itinerary-ui").html()
      @template = Handlebars.compile(source)
   
   getGames: () ->
      @itinerary.slice()
      
   addToMap: (map) ->
      map.addItinerary($(@template())[0])

   addGame: (game) ->
      @itinerary.push(game)
      
      # Draw the current itinerary
      $("#itinerary").empty()
      table = $("<table>")
      for game in @itinerary
         source = $("#itinerary-game").html()
         template = Handlebars.compile(source)
         context =
            game_id: game.id,
            away_team: game.away_team_abbr, 
            home_team: game.home_team_abbr, 
         table.append(template(context))
      $("#itinerary").append(table)
      
   removeGame: (gameToDelete) ->
      for game, i in @itinerary
         if game.home_team_abbr == gameToDelete.home_team_abbr
            @itinerary.splice(i, 1);
            break
         
      # Draw the current itinerary
      $("#itinerary").empty()
      table = $("<table>")
      for game in @itinerary
         source = $("#itinerary-game").html()
         template = Handlebars.compile(source)
         context =
            game_id: game.id,
            away_team: game.away_team_abbr, 
            home_team: game.home_team_abbr, 
         table.append(template(context))
      $("#itinerary").append(table)