( function(){
	
	var game = require('./madtags-game.js');
	var tags = require('./madtags-tags.js');
	var socketUtils = require('./madtags-socketutils.js');
	var zeeBox = require('./madtags-zeebox.js');

	module.exports = function( io ){
		io.sockets.on( 'connection', function( socket ){
			console.log( "GETTING CONNNECTION" );

			socket.on( 'ping', function( data ){
				console.log( "GETTING PING: ", data );
				socket.emit( "pong", {} );
			});

			/**
			CLIENT CLIENT CLIENT CLIENT CLIENT CLIENT 
			*/
			socket.on( 'joinClient', function( data ){
				console.log( "GETTING JOIN: ", data );
				game.joinClient( socket, data.gameCode, data.username );
			});

			socket.on( 'tag', function( data ){
				console.log( "GETTING TAG: ", data );
				tags.addTag( data.tag );

				zeeBox.fetchZeeData( tag, function( error, words ){
					console.log( "GOT ZEE TAGS: ", error, words );
					if( !error && words && words.length ){
						for( var i = 0; i < words.length; i++ ){
							var word = words[i];
							console.log( "ADDING ZEETAG: ", word );
							tags.addTag( word );
							socketUtils.sendMessageToAllTVs( socket, 'tag', { 'tag' : word, 'source' : "ZeeBox" });
							socketUtils.sendMessageToAllClients( socket, 'tag', { 'tag' : word, 'source' : "ZeeBox" });
						}
					}
				})

				socketUtils.sendMessageToAllTVs( socket, 'tag', { 'tag' : data.tag, 'source' : data.source });
				socketUtils.sendMessageToAllClients( socket, 'tag', { 'tag' : data.tag, 'source' : data.source });
			});

			socket.on( 'start', function( data ){
				console.log( "STARTING: ", data );
				game.startTurn( socket, data.gameCode );
			});

			socket.on( 'submit', function( data ){
				console.log( "SUBMITTING: ", data );
				game.submit( socket, data.gameCode, data.selectedSentence, data.username );
			});

			socket.on( 'getSubmissions', function( data ){
				console.log( "GETTING SUBMISSIONS: ", data );
				game.getSubmissions( socket, data.gameCode );
			});

			socket.on( 'judgement', function( data) {
				console.log( "GOT A JUDGEMENT", data );
				game.judgment( socket, data.sentence );
			});

			socket.on( 'restart', function( data ){
				console.log( "RESTARTING: ", data );
				game.restartGame( socket, data.gameCode );
			});

			/**
			TV TV TV TV TV TV TV TV TV TV TV TV TV TV
			*/
			socket.on( 'joinTV', function( data ){
				console.log( "GETTING JOIN: ", data );
				game.joinTV( socket, data.gameCode  );
			});
			
		});
	};

})();