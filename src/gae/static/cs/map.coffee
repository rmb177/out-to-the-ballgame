# Class to represent the map and handle
# all of the drawing functionality

class ottb.Map

   @IS_ATTENDING: true
   
   # Create, setup, and add map to the page
   #
   constructor: (selectLinkCallback, removeLinkCallback) -> 
      @map = new google.maps.Map(document.getElementById("schedule-map"), gMapOptions)
      @gameMarkers = {}
      @displayedGames = {}
      @lastInfoWindow = null
      @routes = []
      
      @selectLinkCallback = selectLinkCallback
      @removeLinkCallback = removeLinkCallback
      @setupSelectLinkListener()
      @setupRemoveLinkListener()
      
      @animateMarkers()
   
   
   # Add the date picker to the map
   #
   addDatePicker: (datePickerHtml) ->
      @map.controls[google.maps.ControlPosition.TOP_CENTER].push(datePickerHtml)
   
   
   # Add the itinerary section to the map
   #
   addItinerary: (itineraryHtml) ->
      @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(itineraryHtml)
      
   # Draw the given route on the map
   #
   drawRoute: (encodedRoutes) ->
      route.setMap(null) for route in @routes
      @routes = []
      
      for encodedRoute in encodedRoutes
         polyRoute = new google.maps.Polyline(
            path: google.maps.geometry.encoding.decodePath(encodedRoute)
            strokeColor: '#FF0000'
            strokeOpacity: 1
            strokeWeight: 2
         )
         polyRoute.setMap(@map)
         @routes.push(polyRoute)
 

   # Updates the map to show the games for the currently selected date.
   #  newGames - The games for the currently selected date
   #  gamesAttending - The games the user has already added to his itinerary
   displayGames: (newGames, gamesAttending) ->
      @lastInfoWindow.close() if @lastInfoWindow isnt null
      @lastInfoWindow = null
      
      # Keep displayed marker if game is in itinerary or already marks a stadium for
      # a game to be displayed 
      for own teamAbbr, displayedGame of @displayedGames
         if @isAttending(displayedGame, gamesAttending)
            marker = @gameMarkers[displayedGame.home_team_abbr]
            marker.setIcon("/static/images/green-dot.png")
            @setupInfoWindow(displayedGame, marker, Map.IS_ATTENDING)
         else if not newGames.some( (newGame) -> newGame.home_team_abbr == displayedGame.home_team_abbr)
            @fadeOutMarker(@gameMarkers[displayedGame.home_team_abbr])
            delete @displayedGames[displayedGame.home_team_abbr]

        
      for newGame in newGames
         do (newGame) =>
            if not @isAttending(newGame, gamesAttending)
               
               # Create marker if it doesn't yet exist
               marker = @gameMarkers[newGame.home_team_abbr]
               if not marker
                  marker = new google.maps.Marker
                     position: new google.maps.LatLng(parseFloat(newGame.lat), parseFloat(newGame.lon))
                     map: @map
                     opacity: 0
                     optimized: false
                     opacities: []
                     
               marker.setIcon("/static/images/red-dot.png")
               marker.setTitle(newGame.away_team_name + ' @ ' + newGame.home_team_name)
               @setupInfoWindow(newGame, marker, not Map.IS_ATTENDING)
               @fadeInMarker(marker) if not @displayedGames[newGame.home_team_abbr]?
               @gameMarkers[newGame.home_team_abbr] = marker
               @displayedGames[newGame.home_team_abbr] = newGame
           
           
   # return whether or not user is attending given game 
   isAttending: (game, gamesAttending) ->
      gamesAttending.some( (attendedGame) -> attendedGame.home_team_abbr == game.home_team_abbr)
   
   
   # Background listener that attaches listener functions
   # to all of the "Select" links in a game info window.
   #
   setupSelectLinkListener: () ->
      that = this
      $(document).on("click", ".select-game-link a", (event) ->
         that.lastInfoWindow.close() if that.lastInfoWindow isnt null
         that.selectLinkCallback(this.id)
         false
      )
      
      
   # Background listener that attaches listener functions
   # to all of the "Remove" links in a game info window.
   #
   setupRemoveLinkListener: () ->
      that = this
      $(document).on("click", ".remove-game-link a", (event) ->
         that.lastInfoWindow.close() if that.lastInfoWindow isnt null
         that.removeLinkCallback(this.id)
         false
      )
      
   
   # Set up the info window for the given game/markeR
   #
   setupInfoWindow: (game, marker, isAttending) ->
      source = $("#info-window").html()
      template = Handlebars.compile(source)
      context =
         game_id: game.id,
         away_team: game.away_team_abbr, 
         home_team: game.home_team_abbr, 
         game_time: game.game_time
         is_attending: isAttending
               
      google.maps.event.clearInstanceListeners(marker)
      google.maps.event.addListener(marker, 'click', =>
         @lastInfoWindow.close() if @lastInfoWindow isnt null
         @lastInfoWindow = new google.maps.InfoWindow()
         @lastInfoWindow.setContent(template(context))
         @lastInfoWindow.open(@map, marker)
         return false)
      

   # Fade in a marker on the map
   #
   fadeInMarker: (marker) ->
      marker.opacities = marker.opacities.concat([.2, .4, .6, .8, 1])


   # Fade out a marker from the map
   #
   fadeOutMarker: (marker) ->
      if (marker.opacity > 0)
         marker.opacities = marker.opacities.concat([.8, .6, .4, .2, 0])


   # Background thread to fade markers in/out
   #
   animateMarkers: () =>
      for own teamAbbr, aMarker of @gameMarkers
         if aMarker.opacities.length > 0
            aMarker.setOpacity(aMarker.opacities[0])
            aMarker.setVisible(aMarker.opacities[0] != 0) 
            aMarker.opacities.shift()
      setTimeout( =>
         @animateMarkers()
       50)
