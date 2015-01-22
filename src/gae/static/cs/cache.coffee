# Class to represent the cache of information we store
# off after retrieving it from the server

class ottb.Cache

   constructor: () ->
      @gameCache = new Object

   addGame: (game) ->
      @gameCache[game.id] = game

   getGame: (gameId) ->
      @gameCache[gameId]