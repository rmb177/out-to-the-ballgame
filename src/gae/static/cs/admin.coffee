
generateLoadingFunction = (progressIndicator, postUrl) ->
   progressIndicator.attr('src', '/static/images/ajax_loader.gif')
   progressIndicator.show()
   $.post(postUrl)
     .done( -> 
         progressIndicator.attr('src', '/static/images/green_check_mark.png'))
     .fail( -> 
         progressIndicator.attr('src', '/static/images/red_x.gif'))
   
init = ->
   $('#teamDataIndicator').hide()
   $('#gameDataIndicator').hide()
   $('#tripDataIndicator').hide()
   $('#routesDataIndicator').hide()

   $ ->
      $('#loadTeamData').on('click',
         ->
            generateLoadingFunction($('#teamDataIndicator'), '/admin/teams')
         )
         
   $ ->
      $('#loadGameData').on('click',
         ->
            generateLoadingFunction($('#gameDataIndicator'), '/admin/games')
         )
   
   $ ->
      $('#loadTripData').on('click',
         ->
            generateLoadingFunction($('#tripDataIndicator'), '/admin/trips')
         )
         
   $ ->
      $('#loadRoutesData').on('click',
         ->
            generateLoadingFunction($('#routesDataIndicator'), '/admin/routes')
         )
         
$(document).ready init


