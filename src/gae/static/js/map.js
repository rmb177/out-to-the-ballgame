// Generated by CoffeeScript 1.3.1
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty;

  ottb.Map = (function() {

    Map.name = 'Map';

    Map.IS_ATTENDING = true;

    function Map(selectLinkCallback, removeLinkCallback) {
      this.animateMarkers = __bind(this.animateMarkers, this);
      this.map = new google.maps.Map(document.getElementById("schedule-map"), gMapOptions);
      this.gameMarkers = {};
      this.displayedGames = {};
      this.lastInfoWindow = null;
      this.routes = [];
      this.selectLinkCallback = selectLinkCallback;
      this.removeLinkCallback = removeLinkCallback;
      this.setupSelectLinkListener();
      this.setupRemoveLinkListener();
      this.animateMarkers();
    }

    Map.prototype.addDatePicker = function(datePickerHtml) {
      return this.map.controls[google.maps.ControlPosition.TOP_CENTER].push(datePickerHtml);
    };

    Map.prototype.addItinerary = function(itineraryHtml) {
      return this.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(itineraryHtml);
    };

    Map.prototype.drawRoute = function(encodedRoutes) {
      var encodedRoute, polyRoute, route, _i, _j, _len, _len1, _ref, _results;
      _ref = this.routes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        route = _ref[_i];
        route.setMap(null);
      }
      this.routes = [];
      _results = [];
      for (_j = 0, _len1 = encodedRoutes.length; _j < _len1; _j++) {
        encodedRoute = encodedRoutes[_j];
        polyRoute = new google.maps.Polyline({
          path: google.maps.geometry.encoding.decodePath(encodedRoute),
          strokeColor: '#FF0000',
          strokeOpacity: 1,
          strokeWeight: 2
        });
        polyRoute.setMap(this.map);
        _results.push(this.routes.push(polyRoute));
      }
      return _results;
    };

    Map.prototype.displayGames = function(newGames, gamesAttending) {
      var displayedGame, marker, newGame, teamAbbr, _i, _len, _ref, _results,
        _this = this;
      if (this.lastInfoWindow !== null) {
        this.lastInfoWindow.close();
      }
      this.lastInfoWindow = null;
      _ref = this.displayedGames;
      for (teamAbbr in _ref) {
        if (!__hasProp.call(_ref, teamAbbr)) continue;
        displayedGame = _ref[teamAbbr];
        if (this.isAttending(displayedGame, gamesAttending)) {
          marker = this.gameMarkers[displayedGame.home_team_abbr];
          marker.setIcon("/static/images/green-dot.png");
          this.setupInfoWindow(displayedGame, marker, Map.IS_ATTENDING);
        } else if (!newGames.some(function(newGame) {
          return newGame.home_team_abbr === displayedGame.home_team_abbr;
        })) {
          this.fadeOutMarker(this.gameMarkers[displayedGame.home_team_abbr]);
          delete this.displayedGames[displayedGame.home_team_abbr];
        }
      }
      _results = [];
      for (_i = 0, _len = newGames.length; _i < _len; _i++) {
        newGame = newGames[_i];
        _results.push((function(newGame) {
          if (!_this.isAttending(newGame, gamesAttending)) {
            marker = _this.gameMarkers[newGame.home_team_abbr];
            if (!marker) {
              marker = new google.maps.Marker({
                position: new google.maps.LatLng(parseFloat(newGame.lat), parseFloat(newGame.lon)),
                map: _this.map,
                opacity: 0,
                optimized: false,
                opacities: []
              });
            }
            marker.setIcon("/static/images/red-dot.png");
            marker.setTitle(newGame.away_team_name + ' @ ' + newGame.home_team_name);
            _this.setupInfoWindow(newGame, marker, !Map.IS_ATTENDING);
            if (!(_this.displayedGames[newGame.home_team_abbr] != null)) {
              _this.fadeInMarker(marker);
            }
            _this.gameMarkers[newGame.home_team_abbr] = marker;
            return _this.displayedGames[newGame.home_team_abbr] = newGame;
          }
        })(newGame));
      }
      return _results;
    };

    Map.prototype.isAttending = function(game, gamesAttending) {
      return gamesAttending.some(function(attendedGame) {
        return attendedGame.home_team_abbr === game.home_team_abbr;
      });
    };

    Map.prototype.setupSelectLinkListener = function() {
      var that;
      that = this;
      return $(document).on("click", ".select-game-link a", function(event) {
        if (that.lastInfoWindow !== null) {
          that.lastInfoWindow.close();
        }
        that.selectLinkCallback(this.id);
        return false;
      });
    };

    Map.prototype.setupRemoveLinkListener = function() {
      var that;
      that = this;
      return $(document).on("click", ".remove-game-link a", function(event) {
        if (that.lastInfoWindow !== null) {
          that.lastInfoWindow.close();
        }
        that.removeLinkCallback(this.id);
        return false;
      });
    };

    Map.prototype.setupInfoWindow = function(game, marker, isAttending) {
      var context, source, template,
        _this = this;
      source = $("#info-window").html();
      template = Handlebars.compile(source);
      context = {
        game_id: game.id,
        away_team: game.away_team_abbr,
        home_team: game.home_team_abbr,
        game_time: game.game_time,
        is_attending: isAttending
      };
      google.maps.event.clearInstanceListeners(marker);
      return google.maps.event.addListener(marker, 'click', function() {
        if (_this.lastInfoWindow !== null) {
          _this.lastInfoWindow.close();
        }
        _this.lastInfoWindow = new google.maps.InfoWindow();
        _this.lastInfoWindow.setContent(template(context));
        _this.lastInfoWindow.open(_this.map, marker);
        return false;
      });
    };

    Map.prototype.fadeInMarker = function(marker) {
      return marker.opacities = marker.opacities.concat([.2, .4, .6, .8, 1]);
    };

    Map.prototype.fadeOutMarker = function(marker) {
      if (marker.opacity > 0) {
        return marker.opacities = marker.opacities.concat([.8, .6, .4, .2, 0]);
      }
    };

    Map.prototype.animateMarkers = function() {
      var aMarker, teamAbbr, _ref,
        _this = this;
      _ref = this.gameMarkers;
      for (teamAbbr in _ref) {
        if (!__hasProp.call(_ref, teamAbbr)) continue;
        aMarker = _ref[teamAbbr];
        if (aMarker.opacities.length > 0) {
          aMarker.setOpacity(aMarker.opacities[0]);
          aMarker.setVisible(aMarker.opacities[0] !== 0);
          aMarker.opacities.shift();
        }
      }
      return setTimeout(function() {
        return _this.animateMarkers();
      }, 50);
    };

    return Map;

  })();

}).call(this);
