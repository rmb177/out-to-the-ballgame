# Class to represent the map and handle
# all of the drawing functionality

class ottb.Map

   # Creates and adds the map to the page
   constructor: (selectLinkCallback) ->   
      @map = new google.maps.Map(document.getElementById("schedule-map"), gMapOptions)
      @gameMarkers = {}
      @lastInfoWindow = null
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
      
      #aMarker.setMap(null) for own teamAbbr, aMarker of that.gameMarkers
      that.fadeOutMarker(aMarker) for own teamAbbr, aMarker of that.gameMarkers
      that.lastInfoWindow = null
      for game in games
         do (game) ->
            
            marker = that.gameMarkers[game.home_team_abbr]
            if not marker?
               marker = new google.maps.Marker
                  position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon))
                  map: that.map
                  opacity: 0
            
            marker.setTitle(game.away_team + ' @ ' + game.home_team)
            
            #maraker.setPosition()
            #marker = new google.maps.Marker
            #   position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon))
            #   title: game.away_team + ' @ ' + game.home_team
            #   map: that.map
            #   opacity: 0
            
            that.fadeInMarker(marker, 0)
                 
            source = $("#info-window").html()
            template = Handlebars.compile(source)
            context =
               game_id: game.id,
               away_team: game.away_team_abbr, 
               home_team: game.home_team_abbr, 
               game_time: game.game_time
               displaySelectGameLink: true
                     
            google.maps.event.addListener(marker, 'click', ->
               that.lastInfoWindow.close() if that.lastInfoWindow isnt null
               that.lastInfoWindow = new google.maps.InfoWindow()
               that.lastInfoWindow.setContent(template(context))
               that.lastInfoWindow.open(that.map, marker)
               return false)   
            that.gameMarkers[game.home_team_abbr] = marker

   # Background listener that attaches listener functions
   # to all of the "Select" links in a game info window.
   setupSelectLinkListener: () =>
      that = @
      $(document).on("click", ".select-game-link a", (event) ->
         that.lastInfoWindow.close() if that.lastInfoWindow isnt null
         that.selectLinkCallback(this.id)
         false
      )
   
   # Fade a marker onto the map
   fadeInMarker: (marker, opacity) ->
      that = @
      setTimeout( ->
         marker.setOpacity(opacity)
         that.fadeInMarker(marker, opacity + .2) if opacity < 1
      50)

   # Fade a marker out of the map
   fadeOutMarker: (marker) ->
      that = @
      opacity = marker.getOpacity()
      if (Math.abs(opacity) < 0.000001)
         marker.setOpacity(0)
      else
         marker.setOpacity(opacity - .2)
         setTimeout( ->
            that.fadeOutMarker(marker)
          50)
