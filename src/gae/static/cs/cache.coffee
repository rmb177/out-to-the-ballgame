# Class to represent the cache of information we store
# off after retrieving it from the server

class ottb.Cache

   constructor: () ->
      @gameCache = new Object
      @tripsCache = new Object

   addGames: (games) ->
      for game in games
         @gameCache[game.id] = game

   getGame: (gameId) ->
      @gameCache[gameId]
      
   addTrips: (trips) ->
      for trip in trips
         origTeam = @tripsCache[trip.orig_team_id]
         if !origTeam?
            origTeam = new Object
            
         destTeam = origTeam[trip.dest_team_id]
         if !destTeam?
            destTeam = new Object
            
         destTeam["distance"] = trip.distance
         destTeam["distance_desc"] = trip.distance_desc
         destTeam["duration"] = trip.duration
         destTeam["duration_desc"] = trip.duration_desc
         
         origTeam[trip.dest_team_id] = destTeam
         @tripsCache[trip.orig_team_id] = origTeam