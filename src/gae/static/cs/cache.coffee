# Class to represent the cache of information we store
# off after retrieving it from the server

class ottb.Cache

   constructor: () ->
      @gameCache = new Object

   addGames: (games) ->
      for game in games
         @gameCache[game.id] = game

   getGame: (gameId) ->
      @gameCache[gameId]