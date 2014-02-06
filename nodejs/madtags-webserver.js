( function(){

	var zeeBox = require('./madtags-zeebox.js');
	var game = require('./madtags-game.js');

	module.exports = function( app ){
		app.get( '/', getRoot );
		app.get( '/tv', getTV );
		app.get( '/zee', getZee );
		app.get( '/bounce', bounce );
	}

	function getRoot( req, res ){
		res.render('index.html');
	}

	function getTV( req, res ){
		res.render('tv.html');
	}
	
	function getZee( req, res ){
		zeeBox.fetchZeeData( "Modern Family", function( error, words ){
			console.log( "GOT WOREDS", words );
			res.send( { "error": error, "data": words } ).end();
		});
	}

	function bounce( req, res ){
		game.restartGame( null, '1234');
		res.send('OK');
	}

})();