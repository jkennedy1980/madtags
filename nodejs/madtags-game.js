  ( function(){

	var socketUtils = require('./madtags-socketutils.js');
	var game = new Game();

	exports.joinClient = function( socket, gameCode, username ){
		socket.madtagsType = 'client';
		socket.madtagsGameCode = gameCode;
		socket.join( socketUtils.clientRoomNameForSocket( socket ) );

		var player = game.newPlayer( username );
		var role = player.isJudge() ? 'judge' : 'player';

		socketUtils.respondOnSocket( socket, 'waitingForPlayers', { 'role' : role } );
	}

	exports.joinTV = function( socket, gameCode ){
		socket.madtagsType = 'tv';
		socket.madtagsGameCode = gameCode;
		socket.join( socketUtils.tvRoomNameForSocket( socket ) );

		socketUtils.respondOnSocket( socket, 'waitingForPlayers', { 'role' : role })
		emitChangeGamePhase( socket, 'waitingForPlayers', {} );
	}

	exports.startGame = function( socket, gameCode ){
		emitChangeGamePhase( socket, 'waitingForTags', {} );
	}

	// function emitChangeToGamePhase( socket, phaseToChangeTo, data ){
	// 	var messageData = {};
	// 	messageData.phase = phaseToChangeTo;
	// 	if( data ) messageData.data = data;
	// 	socket.emit( 'changeGamePhase', messageData );
	// }




	// ========    GAME   ======= //

	function Game( gameCode ){
		var self = this;

		var _nextUserId = 0;
		var _hasJudge = false;
		var _gameCode = gameCode;

		function _newPlayer( username ){

			var _isJudge = (self.hasJudge) ? false : true;
			self._nextUserId++;

			return {
				"username" : username,
				isJudge : false,
				userId : _nextUserId
			}
		}

		function _hasJudge() {
			return _hasJudge;
		}

		return {
			"gameCode" : _gameCode,
			"hasJudge" : _hasJudge,
			"players" : Array(),
			"newPlayer" : _newPlayer
		}

	}

})();