// Generated by CoffeeScript 1.3.1
(function() {
  var dateChangedCallback, formatDate, gCache, gCommunication, gDatepicker, gItinerary, gMap, gamesRetrievedCallback, initUI, selectLinkCallback;

  gMap = null;

  gDatepicker = null;

  gCommunication = null;

  gCache = null;

  gItinerary = null;

  formatDate = function(date) {
    return date.toJSON().slice(0, 10);
  };

  dateChangedCallback = function(date) {
    date.setFullYear(2015);
    return gCommunication.retrieveGamesForDate(formatDate(date), gamesRetrievedCallback);
  };

  gamesRetrievedCallback = function(games) {
    gCache.addGames(games);
    return gMap.displayGames(games);
  };

  selectLinkCallback = function(gameId) {
    gItinerary.addGame(gCache.getGame(gameId));
    return gDatepicker.gotoNextDay();
  };

  initUI = function() {
    gCache = new ottb.Cache;
    gItinerary = new ottb.Itinerary();
    gCommunication = new ottb.Communication();
    gDatepicker = new ottb.Datepicker(dateChangedCallback);
    gMap = new ottb.Map(selectLinkCallback);
    gDatepicker.addToMap(gMap);
    return gItinerary.addToMap(gMap);
  };

  $(document).ready(initUI);

}).call(this);
