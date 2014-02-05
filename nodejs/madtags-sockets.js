( function(){
	
	module.exports = function( io ){
		io.sockets.on( 'connection', function( socket ){
			console.log( "GETTING CONNNECTION" );
			socket.on( 'join', socketJoin( socket ) );
		});
	};

	function socketJoin( socket ){
		return function( data ){
			console.log( "GETTING JOIN: ", data );
			socket.emit( 'message', { response: data } );
		};
	}

})();