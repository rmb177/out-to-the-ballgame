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
            
         destTeam["distance"] = parseInt(trip.distance)
         destTeam["distance_desc"] = trip.distance_desc
         destTeam["duration"] = parseInt(trip.duration)
         destTeam["duration_desc"] = trip.duration_desc
         destTeam["route"] = trip.route
         
         origTeam[trip.dest_team_id] = destTeam
         @tripsCache[trip.orig_team_id] = origTeam
         
   getTripDistance: (origTeamId, destTeamId) ->
      return @tripsCache[origTeamId][destTeamId]["distance"]
      
   getTripDuration: (origTeamId, destTeamId) ->
      return @tripsCache[origTeamId][destTeamId]["duration"]
      
   getTripRoute: (origTeamId, destTeamId) ->
      return @tripsCache[origTeamId][destTeamId]["route"]