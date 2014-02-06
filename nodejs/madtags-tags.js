( function(){

	var tags = [
		"Toyota", "Kleenex", "Automobile", "XFinity", "Tylenol", "Arthritis", "Sports Car", "Economy Car", "Shampoo", "Toilet Paper",
		"Pizza Hut", "McDonalds", "Kentucky Fried Chicken", "Folgers", "Your Father's Oldsmobile", "Spanx", "Apple", "Google"
	];

	var nextTagIndex = Math.floor( Math.random() * tags.length );

	exports.nextTag = function(){
		var tag = tags[ nextTagIndex++ ];
		if( nextTagIndex >= tags.length ) nextTagIndex = 0;
		return tag;
	}

	exports.addTag = function( tag ){
		tags.push( tag );
	}

})();