( function(){
	
	exports.sendMessageToAllTVs = function( socket, message, data ){
		socket.manager.sockets.in( exports.tvRoomNameForSocket(socket) ).emit( message, data );
	}

	exports.sendMessageToAllClients = function( socket, message, data ){
		socket.manager.sockets.in( exports.clientRoomNameForSocket(socket) ).emit( message, data );
	}

	exports.tvRoomNameForSocket = function( socket ){
		return socket.madtagsGameCode + "-tv";
	}

	exports.clientRoomNameForSocket = function( socket ){
		return socket.madtagsGameCode + "-client";
	}

	exports.allClientSockets = function( socket ){
		return socket.manager.sockets.in( exports.clientRoomNameForSocket(socket) ).sockets;
	}

	exports.respondOnSocket = function( socket, gamePhase, data ){
		var payload = {};
		payload.phase = gamePhase;
		if( data ) payload.data = data;
		socket.emit( 'gamePhase', payload );

		console.log( "SENT 1 CLIENT: ", payload );
	}

	exports.respondOnAllClientSockets = function( socket, gamePhase, data ){
		var payload = {};
		payload.phase = gamePhase;
		if( data ) payload.data = data;
		socket.manager.sockets.in( exports.clientRoomNameForSocket(socket) ).emit( 'gamePhase', payload );

		console.log( "SENT ALL CLIENTS: ", payload );
	}

	exports.respondOnTVSocket = function( gamePhase, data ){
		var payload = {};
		payload.phase = gamePhase;
		if( data ) payload.data = data;
		socket.manager.sockets.in( exports.tvRoomNameForSocket(socket) ).emit( 'gamePhase', payload );

		console.log( "SENT TO TV: ", payload );
	}


})();