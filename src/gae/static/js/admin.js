// Generated by CoffeeScript 1.3.1
(function() {
  var generateLoadingFunction, init;

  generateLoadingFunction = function(progressIndicator, postUrl) {
    progressIndicator.attr('src', '/static/images/ajax_loader.gif');
    progressIndicator.show();
    return $.post(postUrl).done(function() {
      return progressIndicator.attr('src', '/static/images/green_check_mark.png');
    }).fail(function() {
      return progressIndicator.attr('src', '/static/images/red_x.gif');
    });
  };

  init = function() {
    $('#teamDataIndicator').hide();
    $('#gameDataIndicator').hide();
    $('#tripDataIndicator').hide();
    $('#routesDataIndicator').hide();
    $(function() {
      return $('#loadTeamData').on('click', function() {
        return generateLoadingFunction($('#teamDataIndicator'), '/admin/teams');
      });
    });
    $(function() {
      return $('#loadGameData').on('click', function() {
        return generateLoadingFunction($('#gameDataIndicator'), '/admin/games');
      });
    });
    $(function() {
      return $('#loadTripData').on('click', function() {
        return generateLoadingFunction($('#tripDataIndicator'), '/admin/trips');
      });
    });
    return $(function() {
      return $('#loadRoutesData').on('click', function() {
        return generateLoadingFunction($('#routesDataIndicator'), '/admin/routes');
      });
    });
  };

  $(document).ready(init);

}).call(this);
