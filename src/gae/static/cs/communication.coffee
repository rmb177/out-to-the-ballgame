# Class to handle all of the communication with the server

class ottb.Communication
   
   constructor: () ->
      # intentionally empty

   retrieveGamesForDate: (date, callback) ->
      $.ajax(
         url: 'appdata/games?date=' + date,
         success: (games) ->
            callback(games, date)
         error: (response) ->
            alert('Error retrieving games for the selected date.'))

   retrieveTrips: (callback) ->
      $.ajax(
         url: 'appdata/trips',
         success: (trips) ->
            callback(trips)
         error: (response) ->
            alert('Error retrieving route data.'))