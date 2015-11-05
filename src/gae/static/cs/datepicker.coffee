# Class to represent and handle functionality
# for the datepicker users use to retrieve games

class ottb.Datepicker
   
   @OPENING_DAY = new Date("4/5/2016")
   
   constructor: (dateChangedCallback) ->
      source = $("#datepicker-ui").html()
      @template = Handlebars.compile(source)
      @dateChangedCallback = dateChangedCallback
      
   reloadCurrentDay: () ->
      currentDate = new Date($("#datepicker").val())
      currentDate.setFullYear(2016)
      newDay = new Date(currentDate)
      @dateChangedCallback(newDay)

   gotoNextDay: () ->
      @moveOneDay(1)
      
   gotoPrevDay: () ->
      @moveOneDay(-1)

   moveOneDay: (forwardOrBackward) ->
      currentDate = new Date($("#datepicker").val())
      currentDate.setFullYear(2016)
      newDay = new Date(currentDate)
      newDay.setDate(currentDate.getDate() + forwardOrBackward)
      @datepicker.datepicker("setDate", newDay)
      @dateChangedCallback(newDay)
      
      
   # Return the initial date we should load on the map. Opening Day if the current date is before 
   # Opening Day, otherwise the current date
   getInitialMapDate: () ->
      today = new Date
      if today > Datepicker.OPENING_DAY then today else Datepicker.OPENING_DAY
   
   # TODO: Revisit this...has to be a better way. jQuery doesn't seem to be
   # able to find the datepicker component until some time has passed. Is there
   # a delay when adding the template to the map??   
   addToMap: (map) ->
      map.addDatePicker($(@template())[0])
   
      setTimeout( =>
         @datepicker = $("#datepicker")
         @datepicker.datepicker()
         @datepicker.datepicker("option", "dateFormat", "D, MM d")
         @datepicker.datepicker("setDate", @getInitialMapDate())
         @dateChangedCallback(new Date(@datepicker.val()))
         @datepicker.change( (event) =>
            @dateChangedCallback(new Date(@datepicker.val())))
   
         # preventing keyboard-entered dates
         @datepicker.keydown( (event) ->
            false)
         
         $("#prevDayArrow").on("click",  =>
            @gotoPrevDay()
         )
      
         $("#nextDayArrow").on("click", =>
            @gotoNextDay()
         )
       1000)
   
   
   
      
   