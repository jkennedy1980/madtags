( function(){
	
	var game = require('./madtags-game.js');

	module.exports = function( io ){
		io.sockets.on( 'connection', function( socket ){
			console.log( "GETTING CONNNECTION" );

			socket.on( 'joinClient', function( data ){
				console.log( "GETTING JOIN: ", data );
				game.joinClient( socket, data.gameCode, data.username );
			});

			socket.on( 'joinTV', function( data ){
				console.log( "GETTING JOIN: ", data );
				game.joinTV( socket, data.gameCode  );
			});
		});
	};

})();