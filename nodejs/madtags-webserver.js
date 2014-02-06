( function(){

	var zeeBox = require('./madtags-zeebox.js');

	module.exports = function( app ){
		app.get( '/', getRoot );
		app.get( '/tv', getTV );
		app.get( '/zee', getZee );
	}

	function getRoot( req, res ){
		res.render('index.html');
	}

	function getTV( req, res ){
		res.render('tv.html');
	}
	
	function getZee( req, res ){
		zeeBox.fetchZeeData( "Modern Family", function( error, response ){
			res.send( {"error": error, "data": response } ).end();
		});
	}

})();