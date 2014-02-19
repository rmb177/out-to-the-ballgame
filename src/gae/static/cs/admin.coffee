
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


init = ->
   $('#teamDataIndicator').hide()
   $('#gameDataIndicator').hide()

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
         
$(document).ready init


