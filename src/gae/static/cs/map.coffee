# Class to represent the map and handle
# all of the drawing functionality

class ottb.Map

   # Creates and adds the map to the page
   constructor: (selectLinkCallback) ->   
      @map = new google.maps.Map(document.getElementById("schedule-map"), gMapOptions)
      @gameMarkers = {}
      @displayedGames = {}
      @lastInfoWindow = null
      @selectLinkCallback = selectLinkCallback
      @setupSelectLinkListener()
      @animateMarkers()
      
   addDatePicker: (datePickerHtml) ->
      @map.controls[google.maps.ControlPosition.TOP_CENTER].push(datePickerHtml)
      
   addItinerary: (itineraryHtml) ->
      @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(itineraryHtml)


   # Updates the map to show the games for the currently selected date.
   displayGames: (newGames) ->
      that = @
      
      @lastInfoWindow.close() if @lastInfoWindow isnt null

      # Fade out currently displayed games if they are not in the new list of
      # games to display
      for own teamAbbr, displayedGame of @displayedGames
         hasIt = newGames.some( (newGame) -> newGame.home_team_abbr == displayedGame.home_team_abbr)
         if not hasIt
            @fadeOutMarker(@gameMarkers[displayedGame.home_team_abbr])
            delete @displayedGames[displayedGame.home_team_abbr]
            
      for newGame in newGames
         do (newGame) =>
            marker = @gameMarkers[newGame.home_team_abbr]
            if not marker?
               marker = new google.maps.Marker
                  position: new google.maps.LatLng(parseFloat(newGame.lat), parseFloat(newGame.lon))
                  map: @map
                  opacity: 0
                  opacities: []
            
            marker.setTitle(newGame.away_team_name + ' @ ' + newGame.home_team_name)
            
            hasIt = @displayedGames[newGame.home_team_abbr]?
            @fadeInMarker(marker, 0) if not hasIt
                 
            source = $("#info-window").html()
            template = Handlebars.compile(source)
            context =
               game_id: newGame.id,
               away_team: newGame.away_team_abbr, 
               home_team: newGame.home_team_abbr, 
               game_time: newGame.game_time
               displaySelectGameLink: true
                     
            google.maps.event.addListener(marker, 'click', =>
               @lastInfoWindow.close() if @lastInfoWindow isnt null
               @lastInfoWindow = new google.maps.InfoWindow()
               @lastInfoWindow.setContent(template(context))
               @lastInfoWindow.open(that.map, marker)
               return false)   
            @gameMarkers[newGame.home_team_abbr] = marker
            @displayedGames[newGame.home_team_abbr] = newGame

   # Background listener that attaches listener functions
   # to all of the "Select" links in a game info window.
   setupSelectLinkListener: () ->
      that = this
      $(document).on("click", ".select-game-link a", (event) ->
         that.lastInfoWindow.close() if that.lastInfoWindow isnt null
         that.selectLinkCallback(this.id)
         false
      )
      
   # Fade a marker onto the map
   fadeInMarker: (marker) ->
      marker.opacities = marker.opacities.concat([.2, .4, .6, .8, 1])
      
   fadeOutMarker: (marker) ->
      if (marker.opacity > 0)
         marker.opacities = marker.opacities.concat([.8, .6, .4, .2, 0])
      
   # Background thread to fade markers in/out
   animateMarkers: () =>
      for own teamAbbr, aMarker of @gameMarkers
         if aMarker.opacities.length > 0
            aMarker.setOpacity(aMarker.opacities[0])
            aMarker.opacities.shift()
      setTimeout( =>
         @animateMarkers()
       50)
