// Generated by CoffeeScript 1.3.1
(function() {

  ottb.Communication = (function() {

    Communication.name = 'Communication';

    function Communication() {}

    Communication.prototype.retrieveGamesForDate = function(date, callback) {
      return $.ajax({
        url: 'appdata/games?date=' + date,
        success: function(games) {
          return callback(games, date);
        },
        error: function(response) {
          return alert('Error retrieving games for the selected date.');
        }
      });
    };

    Communication.prototype.retrieveTrips = function(callback) {
      return $.ajax({
        url: 'appdata/trips',
        success: function(trips) {
          return callback(trips);
        },
        error: function(response) {
          return alert('Error retrieving route data.');
        }
      });
    };

    return Communication;

  })();

}).call(this);
