# Class to represent the user's itinerary

class ottb.Itinerary
   
   constructor: (callback) ->
      @itinerary = new Array
      @drawItineraryCallback = callback
      
      source = $("#itineraryUi").html()
      @template = Handlebars.compile(source)
      
   addToMap: (map) ->
      map.addItinerary($(@template())[0])

   addGame: (game) ->
      @itinerary.push(game)
      
      # Draw the current itinerary
      $("#itinerary").empty()
      for game in @itinerary
         source = $("#info-window").html()
         template = Handlebars.compile(source)
         context =
            game_id: game.id,
            away_team: game.away_team_abbr, 
            home_team: game.home_team_abbr, 
            game_time: game.game_time
            displaySelectGameLink: false
         
         $("#itinerary").append(template(context))      