
loadTeamData = ->
   teamDataIndicator = $('#teamDataIndicator')
   teamDataIndicator.attr('src', '/static/images/ajax_loader.gif')
   teamDataIndicator.show()
   $.post("/admin/teams")
     .done( (response) -> 
         teamDataIndicator.attr('src', '/static/images/green_check_mark.png'))
     .fail(-> 
         teamDataIndicator.attr('src', '/static/images/red_x.gif'))
 
   
init = ->
   $('#teamDataIndicator').hide()
   
   $ ->
      $('#loadTeamData').on('click',
         ->
            loadTeamData()
         )
         
$(document).ready init


