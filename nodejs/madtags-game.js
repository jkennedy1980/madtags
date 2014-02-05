( function(){

	exports.joinClient = function( socket, gameCode, username ){
		socket.madtagsType = 'client';
		socket.join( gameCode );
		emitChangeGamePhase( socket, 'waitingForPlayers', { "role": "admin" } );
	}

	exports.joinTV = function( socket, gameCode ){
		socket.madtagsType = 'tv';
		socket.join( gameCode );
		emitChangeGamePhase( socket, 'waitingForPlayers', {} );
	}

	exports.startGame = function( socket, gameCode ){
		emitChangeGamePhase( socket, 'waitingForTags', {} );
	}

	function emitChangeGamePhase( socket, phaseToChangeTo, data ){
		var messageData = {};
		messageData.phase = phaseToChangeTo;
		if( data ) messageData.data = data;
		socket.emit( 'changeGamePhase', messageData );
	}

})();