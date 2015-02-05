# global variable that contains all of our Google map options

noCountryLabels = 
   featureType: "administrative.country"
   elementType: "labels"
   stylers: [visibility: "off"]
      
noStateLabels =
   featureType: "administrative.province"
   elementType: "labels"
   stylers: [visibility: "off"]
         
waterFeature =
   featureType: "water"
   elementType: "all"
   stylers: [
      (visibility: "on")
      (color: "#acbcc9")
   ]

poiFeature =
   featureType: "poi"
   elementType: "all"
   stylers: [visibility: "off"]
      
window.gMapOptions = 
   center: new google.maps.LatLng(39.8111444,-98.5569364),
   zoom: 4,
   minZoom: 4,
   mapTypeId: google.maps.MapTypeId.ROADMAP,
   mapTypeControl: false
   panControl: false
   streetViewControl : false
   zoomControl: false
   styles: [noCountryLabels, noStateLabels, waterFeature, poiFeature]