// Generated by CoffeeScript 1.3.1
(function() {

  ottb.Datepicker = (function() {

    Datepicker.name = 'Datepicker';

    Datepicker.OPENING_DAY = new Date("4/5/2016");

    function Datepicker(dateChangedCallback) {
      var source;
      source = $("#datepicker-ui").html();
      this.template = Handlebars.compile(source);
      this.dateChangedCallback = dateChangedCallback;
    }

    Datepicker.prototype.reloadCurrentDay = function() {
      var currentDate, newDay;
      currentDate = new Date($("#datepicker").val());
      currentDate.setFullYear(2016);
      newDay = new Date(currentDate);
      return this.dateChangedCallback(newDay);
    };

    Datepicker.prototype.gotoNextDay = function() {
      return this.moveOneDay(1);
    };

    Datepicker.prototype.gotoPrevDay = function() {
      return this.moveOneDay(-1);
    };

    Datepicker.prototype.moveOneDay = function(forwardOrBackward) {
      var currentDate, newDay;
      currentDate = new Date($("#datepicker").val());
      currentDate.setFullYear(2016);
      newDay = new Date(currentDate);
      newDay.setDate(currentDate.getDate() + forwardOrBackward);
      this.datepicker.datepicker("setDate", newDay);
      return this.dateChangedCallback(newDay);
    };

    Datepicker.prototype.getInitialMapDate = function() {
      var today;
      today = new Date;
      if (today > Datepicker.OPENING_DAY) {
        return today;
      } else {
        return Datepicker.OPENING_DAY;
      }
    };

    Datepicker.prototype.addToMap = function(map) {
      var _this = this;
      map.addDatePicker($(this.template())[0]);
      return setTimeout(function() {
        _this.datepicker = $("#datepicker");
        _this.datepicker.datepicker();
        _this.datepicker.datepicker("option", "dateFormat", "D, MM d");
        _this.datepicker.datepicker("setDate", _this.getInitialMapDate());
        _this.dateChangedCallback(new Date(_this.datepicker.val()));
        _this.datepicker.change(function(event) {
          return _this.dateChangedCallback(new Date(_this.datepicker.val()));
        });
        _this.datepicker.keydown(function(event) {
          return false;
        });
        $("#prevDayArrow").on("click", function() {
          return _this.gotoPrevDay();
        });
        return $("#nextDayArrow").on("click", function() {
          return _this.gotoNextDay();
        });
      }, 1000);
    };

    return Datepicker;

  })();

}).call(this);
