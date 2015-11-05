// Generated by CoffeeScript 1.3.1
(function() {
  var dateChangedCallback, formatDate, gCache, gCommunication, gDatepicker, gItinerary, gMap, gamesRetrievedCallback, initUI, removeLinkCallback, selectLinkCallback, tripsRetrievedCallback;

  gMap = null;

  gDatepicker = null;

  gCommunication = null;

  gCache = null;

  gItinerary = null;

  formatDate = function(date) {
    return date.toJSON().slice(0, 10);
  };

  dateChangedCallback = function(date) {
    var dateStr;
    date.setFullYear(2015);
    dateStr = formatDate(date);
    if (gCache.getGamesForDate(dateStr)) {
      return gMap.displayGames(gCache.getGamesForDate(dateStr), gItinerary.getGames());
    } else {
      return gCommunication.retrieveGamesForDate(formatDate(date), gamesRetrievedCallback);
    }
  };

  gamesRetrievedCallback = function(games, date) {
    gCache.addGames(games, date);
    return gMap.displayGames(games, gItinerary.getGames());
  };

  tripsRetrievedCallback = function(trips) {
    return gCache.addTrips(trips);
  };

  selectLinkCallback = function(gameId) {
    gItinerary.addGame(gCache.getGame(gameId), gMap);
    return gDatepicker.gotoNextDay();
  };

  removeLinkCallback = function(gameId) {
    gItinerary.removeGame(gCache.getGame(gameId), gMap);
    return gDatepicker.reloadCurrentDay();
  };

  $(document).on("click", "#inineraryGoButton", function(event) {});

  initUI = function() {
    gCache = new ottb.Cache;
    gItinerary = new ottb.Itinerary(gCache);
    gCommunication = new ottb.Communication();
    gCommunication.retrieveTrips(tripsRetrievedCallback);
    gDatepicker = new ottb.Datepicker(dateChangedCallback);
    gMap = new ottb.Map(selectLinkCallback, removeLinkCallback);
    gDatepicker.addToMap(gMap);
    return gItinerary.addToMap(gMap);
  };

  $(document).ready(initUI);

}).call(this);
