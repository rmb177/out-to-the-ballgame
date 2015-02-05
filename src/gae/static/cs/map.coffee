# Class to represent the map and handle
# all of the drawing functionality

class ottb.Map

   # Creates and adds the map to the page
   constructor: (selectLinkCallback) ->   
      @map = new google.maps.Map(document.getElementById("schedule-map"), gMapOptions)
      @gameMarkers = {}
      @selectLinkCallback = selectLinkCallback
      @setupSelectLinkListener()

   addDatePicker: (datePickerHtml) ->
      @map.controls[google.maps.ControlPosition.TOP_CENTER].push(datePickerHtml)
      
   addItinerary: (itineraryHtml) ->
      @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(itineraryHtml)


   # Removes all of the current markers from the map and adds markers for 
   # the given game.
   displayGames: (games) ->
      that = @
      
      aMarker.setMap(null) for own gameId, aMarker of that.gameMarkers
      lastInfoWindow = null
      for game in games
         do (game) ->
            marker = new google.maps.Marker
               position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon))      
               title: game.away_team + ' @ ' + game.home_team
               map: that.map
                 
            source = $("#info-window").html()
            template = Handlebars.compile(source)
            context =
               game_id: game.id,
               away_team: game.away_team_abbr, 
               home_team: game.home_team_abbr, 
               game_time: game.game_time
               displaySelectGameLink: true
                     
            google.maps.event.addListener(marker, 'click', ->
               lastInfoWindow.close() if lastInfoWindow isnt null
               lastInfoWindow = new google.maps.InfoWindow()
               lastInfoWindow.setContent(template(context))
               lastInfoWindow.open(that.map, marker)
               return false)   
            that.gameMarkers[game.id] = marker
         

   # Background listener that attaches listener functions
   # to all of the "Select" links in a game info window.
   setupSelectLinkListener: () =>
      that = @
      $(document).on("click", ".select-game-link a", (event) ->
         that.selectLinkCallback(this.id)
         false
      )