
loadTeamData = ->
   teamDataIndicator = $('#teamDataIndicator')
   teamDataIndicator.attr('src', '/static/images/ajax_loader.gif')
   teamDataIndicator.show()
   $.post('/admin/teams')
     .done( -> 
         teamDataIndicator.attr('src', '/static/images/green_check_mark.png'))
     .fail( -> 
         teamDataIndicator.attr('src', '/static/images/red_x.gif'))

loadGameData = ->
   gameDataIndicator = $('#gameDataIndicator')
   gameDataIndicator.attr('src', '/static/images/ajax_loader.gif')
   gameDataIndicator.show()
   $.post('/admin/games')
     .done( -> 
         gameDataIndicator.attr('src', '/static/images/green_check_mark.png'))
     .fail( -> 
         gameDataIndicator.attr('src', '/static/images/red_x.gif'))
         
loadTripData = ->
   tripDataIndicator = $('#tripDataIndicator')
   tripDataIndicator.attr('src', '/static/images/ajax_loader.gif')
   tripDataIndicator.show()
   $.post('/admin/trips')
     .done( -> 
         tripDataIndicator.attr('src', '/static/images/green_check_mark.png'))
     .fail( -> 
         tripDataIndicator.attr('src', '/static/images/red_x.gif'))


init = ->
   $('#teamDataIndicator').hide()
   $('#gameDataIndicator').hide()
   $('#tripDataIndicator').hide()

   $ ->
      $('#loadTeamData').on('click',
         ->
            loadTeamData()
         )
         
   $ ->
      $('#loadGameData').on('click',
         ->
            loadGameData()
         )
   
   $ ->
      $('#loadTripData').on('click',
         ->
            loadTripData()
         )
         
$(document).ready init


