// Generated by CoffeeScript 1.3.1
(function() {
  var init, loadGameData, loadTeamData;

  loadTeamData = function() {
    var teamDataIndicator;
    teamDataIndicator = $('#teamDataIndicator');
    teamDataIndicator.attr('src', '/static/images/ajax_loader.gif');
    teamDataIndicator.show();
    return $.post('/admin/teams').done(function() {
      return teamDataIndicator.attr('src', '/static/images/green_check_mark.png');
    }).fail(function() {
      return teamDataIndicator.attr('src', '/static/images/red_x.gif');
    });
  };

  loadGameData = function() {
    var gameDataIndicator;
    gameDataIndicator = $('#gameDataIndicator');
    gameDataIndicator.attr('src', '/static/images/ajax_loader.gif');
    gameDataIndicator.show();
    return $.post('/admin/games').done(function() {
      return gameDataIndicator.attr('src', '/static/images/green_check_mark.png');
    }).fail(function() {
      return gameDataIndicator.attr('src', '/static/images/red_x.gif');
    });
  };

  init = function() {
    $('#teamDataIndicator').hide();
    $('#gameDataIndicator').hide();
    $(function() {
      return $('#loadTeamData').on('click', function() {
        return loadTeamData();
      });
    });
    return $(function() {
      return $('#loadGameData').on('click', function() {
        return loadGameData();
      });
    });
  };

  $(document).ready(init);

}).call(this);
