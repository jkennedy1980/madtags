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

})();