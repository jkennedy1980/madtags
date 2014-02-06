  ( function(){

	var socketUtils = require('./madtags-socketutils.js');
	var cardDeck = require('./madtags-cards.js');
	var tags = require('./madtags-tags.js');
	var game = new Game();

	exports.joinClient = function( socket, gameCode, username ){
		socket.madtagsType = 'client';
		socket.madtagsGameCode = gameCode;
		socket.join( socketUtils.clientRoomNameForSocket( socket ) );

		var player = game.newPlayer( username, socket );

		if( game.gamePhase === 'INIT' ){
			game.gamePhase = 'JOINING';
			player.role = 'JUDGE';
		} else if ( game.gamePhase !== 'JOINING' ){
			console.log("STATE NO MAKE SENSE: ", game.gamePhase, "WE AINT JOINING" );
			socketUtils.respondOnSocket( socket, 'error', { 'message' : 'Sorry. The game has already started' } );
			return;
		}

		socket.madtagsPlayer = player;
		socketUtils.respondOnSocket( socket, 'waitingForPlayers', { 'role' : player.role } );
	}

	exports.joinTV = function( socket, gameCode ){
		socket.madtagsType = 'tv';
		socket.madtagsGameCode = gameCode;
		socket.join( socketUtils.tvRoomNameForSocket( socket ) );

		socketUtils.respondOnSocket( socket, 'waitingForPlayers', { 'role' : 'TV' } );
	}

	exports.startTurn = function( socket, gameCode ){
		if( game.gamePhase !== 'JOINING' ){
			console.log("STATE NO MAKE SENSE: ", game.gamePhase, "WE AINT JOINING" );
			return;
		}

		game.gamePhase = 'PLAYING';
		var cards = cardDeck.cards();
		var tag = tags.nextTag();
		socketUtils.respondOnAllClientSockets( socket, 'Playing', { 'sentences' : cards, 'tag' : tag });
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


	// PHASES: INIT, JOINING, READY, PLAYING, JUDGING, DONE

	// ========    GAME   ======= //

	function Game( gameCode ){
		var self = this;

		var _nextUserId = 0;

		function _newPlayer( username ){

			var _isJudge = (self.hasJudge) ? false : true;
			self._nextUserId++;

			return {
				"username" : username,
				"role" : 'PLAYER',
				"userId" : _nextUserId
			}
		}

		function _setJudge( player ){
			if( self.judge != false ) {
				console.error( "I already have a judge, bro" );
				return;
			}

			self.judge = player;
			player.role = 'JUDGE';
		}

		return {
			"gameCode" : gameCode,
			"players" : [],
			"gamePhase" : 'INIT',
			"judge" : false,
			"setJudge" : _setJudge,
			"newPlayer" : _newPlayer
		}

	}

})();