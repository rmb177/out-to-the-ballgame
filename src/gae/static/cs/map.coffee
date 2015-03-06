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
   #  newGames - The games for the currently selected date
   #  gamesAttending - The games the user has already added to his itinerary
   displayGames: (newGames, gamesAttending) ->
       
      @lastInfoWindow.close() if @lastInfoWindow isnt null
      @lastInfoWindow = null
      
      for gameAttending in gamesAttending
         @gameMarkers[gameAttending.home_team_abbr].setOpacity(1)
      
      # Fade out currently displayed games if they are not in the new list of
      # games to display and are not in the current itinerary
      for own teamAbbr, displayedGame of @displayedGames
         keepIt = newGames.some( (newbGame) -> newbGame.home_team_abbr == displayedGame.home_team_abbr) or
                  gamesAttending.some( (gameAttending) -> gameAttending.home_team_abbr == displayedGame.home_team_abbr)
                           
         if not keepIt
            @fadeOutMarker(@gameMarkers[displayedGame.home_team_abbr])
            delete @displayedGames[displayedGame.home_team_abbr]
            
      for newGame in newGames
         do (newGame) =>
            # Create marker if it doesn't yet exist
            marker = @gameMarkers[newGame.home_team_abbr]
            if not marker
               marker = new google.maps.Marker
                  position: new google.maps.LatLng(parseFloat(newGame.lat), parseFloat(newGame.lon))
                  map: @map
                  opacity: 0
                  optimized: false
                  opacities: []
            
            if not gamesAttending.some( (gameAttending) -> gameAttending.home_team_abbr == newGame.home_team_abbr)
               marker.setTitle(newGame.away_team_name + ' @ ' + newGame.home_team_name)
                  
               # Add info window 
               source = $("#info-window").html()
               template = Handlebars.compile(source)
               context =
                  game_id: newGame.id,
                  away_team: newGame.away_team_abbr, 
                  home_team: newGame.home_team_abbr, 
                  game_time: newGame.game_time
               
               google.maps.event.clearInstanceListeners(marker)
               google.maps.event.addListener(marker, 'click', =>
                  @lastInfoWindow.close() if @lastInfoWindow isnt null
                  @lastInfoWindow = new google.maps.InfoWindow()
                  @lastInfoWindow.setContent(template(context))
                  @lastInfoWindow.open(@map, marker)
                  return false)
               
               @fadeInMarker(marker) if not @displayedGames[newGame.home_team_abbr]?
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
      marker.opacities = marker.opacities.concat([.1, .2, .3, .4, .5, .6])
      
   fadeOutMarker: (marker) ->
      if (marker.opacity > 0)
         marker.opacities = marker.opacities.concat([.5, .4, .3, .2, .1, 0])
      
   # Background thread to fade markers in/out
   animateMarkers: () =>
      for own teamAbbr, aMarker of @gameMarkers
         if aMarker.opacities.length > 0
            aMarker.setOpacity(aMarker.opacities[0])
            aMarker.setVisible(aMarker.opacities[0] != 0) 
            aMarker.opacities.shift()
      setTimeout( =>
         @animateMarkers()
       50)
