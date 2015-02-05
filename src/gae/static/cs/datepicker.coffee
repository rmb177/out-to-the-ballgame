# Class to represent and handle functionality
# for the datepicker users use to retrieve games

class ottb.Datepicker
   
   @openingDay = new Date("4/5/2015")
   
   constructor: (dateChangedCallback) ->
      source = $("#datePickerUi").html()
      @template = Handlebars.compile(source)
      
      @dateChangedCallback = dateChangedCallback
      
   gotoNextDay: () ->
      currentDate = new Date($("#datepicker").val())
      nextDay = new Date(currentDate)
      nextDay.setDate(currentDate.getDate() + 1)
      @datepicker.datepicker("setDate", nextDay)
      @dateChangedCallback(nextDay)
      
   # Return the initial date we should load on the map. Opening Day if the current date is before 
   # Opening Day, otherwise the current date
   getInitialMapDate: () ->
      today = new Date
      if today > Datepicker.openingDay then today else Datepicker.openingDay
   
   # TODO: Revisit this...has to be a better way. jQuery doesn't seem to be
   # able to find the datepicker component until some time has passed. Is there
   # a delay when adding the template to the map??   
   addToMap: (map) ->
      map.addDatePicker($(@template())[0])
   
      setTimeout( =>
         @datepicker = $("#datepicker")
         @datepicker.datepicker()
         @datepicker.datepicker("setDate", @getInitialMapDate())
         @dateChangedCallback(new Date(@datepicker.val()))
         @datepicker.change( (event) =>
            @dateChangedCallback(new Date(@datepicker.val())))
   
         # preventing keyboard-entered dates
         @datepicker.keyup( (event) ->
            false)
       1000)
   
   
   
      
   