gMap = {}
gGameMarkers = []

# formats date as mm/dd/yyyy
formatDate = (date) ->
   date.toJSON().slice(0, 10)

getTemplateAjax = (path, callback) ->
   $.ajax(
      url: path,
      success: (data) ->
         source = data
         template = Handlebars.compile(source);
         callback(template) if callback
   )

dateChanged = ->
   displayGamesForDate(formatDate(new Date($("#datepicker").val())))

displayGamesForDate = (date) ->
   marker.setMap(null) for marker in gGameMarkers
   gGameMarkers = []
   
   $.ajax(
         url: 'appdata/games?date=' + date,
         success: (games) -> 
            for game in games
               do (game) ->
                  marker = new google.maps.Marker
                     position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon))      
                     title: game.away_team + ' @ ' + game.home_team
                     map: gMap
   
                  google.maps.event.addListener(marker, 'click', ->
                     infoWindow = new google.maps.InfoWindow()
                     infoWindow.setContent(marker.title)
                     infoWindow.open(gMap, marker)
                     return false)
                     
                  gGameMarkers.push(marker)
         error: ->
            alert('Error retrieving games for the selected date.')
       )
   
initMap = ->
   options = 
      center: new google.maps.LatLng(39.8111444,-98.5569364),
      zoom: 4,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false
      styles: [
         featureType: "all",
         elementType: "labels",
         stylers: [visibility: "off"]
      ]

   gMap = new google.maps.Map(document.getElementById("schedule-map"), options)
   displayGamesForDate(new Date().toJSON().slice(0, 10))
   
   getTemplateAjax('/static/js/templates/trip_controls.handlebars', (template) ->
      gMap.controls[google.maps.ControlPosition.TOP_RIGHT].push($(template())[0]) 
           
      # TODO: Revisit this...has to be a better way
      setTimeout(-> 
         $("#datepicker").datepicker()
         $("#datepicker").change(dateChanged)
         
         # preventing keyboard-entered dates
         $("#datepicker").keyup( (event)->
            false)
      500)
   )

$(document).ready initMap
