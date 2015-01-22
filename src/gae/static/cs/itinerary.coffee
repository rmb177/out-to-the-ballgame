# Class to represent the user's itinerary

class ottb.Itinerary
   
   constructor: (callback) ->
      @itinerary = new Array
      @drawItineraryCallback = callback

   addGame: (game) ->
      @itinerary.push(game)
      @drawItineraryCallback(@itinerary)      