( function(){
	
	module.exports = function( app ){
		app.get( '/', getRoot );
		app.get( '/tv', getTV );
	}

	function getRoot( req, res ){
		res.render('index.html');
	}

	function getTV( req, res ){
		res.render('tv.html');
	}
	
})();