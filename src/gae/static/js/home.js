// Generated by CoffeeScript 1.3.1
(function() {
  var dateChanged, displayGamesForDate, formatDate, gGameMarkers, gMap, getTemplateAjax, initMap;

  gMap = {};

  gGameMarkers = [];

  formatDate = function(date) {
    return date.toJSON().slice(0, 10);
  };

  getTemplateAjax = function(path, callback) {
    return $.ajax({
      url: path,
      success: function(data) {
        var source, template;
        source = data;
        template = Handlebars.compile(source);
        if (callback) {
          return callback(template);
        }
      }
    });
  };

  dateChanged = function() {
    return displayGamesForDate(formatDate(new Date($("#datepicker").val())));
  };

  displayGamesForDate = function(date) {
    var marker, _i, _len;
    for (_i = 0, _len = gGameMarkers.length; _i < _len; _i++) {
      marker = gGameMarkers[_i];
      marker.setMap(null);
    }
    gGameMarkers = [];
    return $.ajax({
      url: 'appdata/games?date=' + date,
      success: function(games) {
        var game, _j, _len1, _results;
        _results = [];
        for (_j = 0, _len1 = games.length; _j < _len1; _j++) {
          game = games[_j];
          _results.push((function(game) {
            marker = new google.maps.Marker({
              position: new google.maps.LatLng(parseFloat(game.lat), parseFloat(game.lon)),
              title: game.away_team + ' @ ' + game.home_team,
              map: gMap
            });
            google.maps.event.addListener(marker, 'click', function() {
              var infoWindow;
              infoWindow = new google.maps.InfoWindow();
              infoWindow.setContent(marker.title);
              infoWindow.open(gMap, marker);
              return false;
            });
            return gGameMarkers.push(marker);
          })(game));
        }
        return _results;
      },
      error: function() {
        return alert('Error retrieving games for the selected date.');
      }
    });
  };

  initMap = function() {
    var options;
    options = {
      center: new google.maps.LatLng(39.8111444, -98.5569364),
      zoom: 4,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControl: false,
      styles: [
        {
          featureType: "all",
          elementType: "labels",
          stylers: [
            {
              visibility: "off"
            }
          ]
        }
      ]
    };
    gMap = new google.maps.Map(document.getElementById("schedule-map"), options);
    displayGamesForDate(new Date().toJSON().slice(0, 10));
    return getTemplateAjax('/static/js/templates/trip_controls.handlebars', function(template) {
      gMap.controls[google.maps.ControlPosition.TOP_RIGHT].push($(template())[0]);
      return setTimeout(function() {
        $("#datepicker").datepicker();
        $("#datepicker").change(dateChanged);
        return $("#datepicker").keyup(function(event) {
          return false;
        });
      }, 500);
    });
  };

  $(document).ready(initMap);

}).call(this);
