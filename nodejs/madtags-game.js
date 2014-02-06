  ( function(){

	var socketUtils = require('./madtags-socketutils.js');
	var cardDeck = require('./madtags-cards.js');
	var tags = require('./madtags-tags.js');
	var game = new Game();
	var lifetimePlayerIndex = 0;

	exports.joinClient = function( socket, gameCode, username ){
		socket.madtagsType = 'client';
		socket.madtagsGameCode = gameCode;
		socket.join( socketUtils.clientRoomNameForSocket( socket ) );

		var player = game.newPlayer( username, socket );

		if( game.gamePhase === 'INIT' ){

			console.log("Making Judge: ", username );
			game.gamePhase = 'JOINING';
			player.role = 'JUDGE';
			game.judgeSocket = socket;
		} else if ( game.gamePhase !== 'JOINING' ){

			game.otherPlayerSockets.push(socket);
			console.log("STATE NO MAKE SENSE: ", game.gamePhase, "WE AINT JOINING" );
			socketUtils.respondOnSocket( socket, 'error', { 'message' : 'Sorry. The game has already started' } );
			return;

		}

		socket.madtagsPlayer = player;
		socketUtils.respondOnSocket( socket, 'waitingForPlayers', { 'role' : player.role, 'playerIndex' : lifetimePlayerIndex++ } );
	}

	exports.joinTV = function( socket, gameCode ){

		socket.madtagsType = 'tv';
		socket.madtagsGameCode = gameCode;
		socket.join( socketUtils.tvRoomNameForSocket( socket ) );

		game.tvSockets.push(socket);

		socketUtils.respondOnSocket( socket, 'waitingForPlayers', { 'role' : 'TV' } );
	}

	exports.startTurn = function( socket, gameCode ){
		if( game.gamePhase !== 'JOINING' ){
			console.log("STATE NO MAKE SENSE: ", game.gamePhase, ". WE AINT JOINING" );
			return;
		}

		game.gamePhase = 'PLAYING';
		var cards = cardDeck.cards();
		var tag = tags.nextTag();
		game.tag = tag;
		socketUtils.respondOnAllClientSockets( socket, 'Playing', { 'sentences' : cards, 'tag' : tag });

		socketUtils.sendMessageToAllTVs(socket, 'playing', { 'tag' : tag } );
	}

	exports.submit = function( socket, gameCode, card ){

		if( game.gamePhase !== 'PLAYING' ){
			console.log("STATE NO MAKE SENSE: ", game.gamePhase, ". WE AINT PLAYING" );
			return;
		}

		socketUtils.sendMessageToAllTVs( socket, 'submission', { 'card' : card, 'tag' : game.tag });
		game.playedCards.push( card );
	}

	exports.getSubmissions = function( socket, gameCode ){

		if( game.gamePhase !== 'PLAYING' ){
			console.log("STATE NO MAKE SENSE: ", game.gamePhase, ". WE AINT PLAYING" );
			return;
		}

		game.gamePhase = 'JUDGING';
		socketUtils.respondOnAllClientSockets( socket, 'Judging', { 'sentences' : game.playedCards, 'tag' : game.tag });
		socketUtils.sendMessageToAllTVs( socket, 'judging', { 'tag' : game.tag });
	}

	exports.judgment = function( socket, gameCode, card ){
		socketUtils.sendMessageToAllTVs( socket, 'final', { 'card' : game.card, 'tag' : game.tag });
		game = new Game();
	}

	exports.restartGame = function( socket, gameCode ){
		game = new Game();
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
			self.judge.role = 'PLAYER';
			self.judge = player;
			self.judge.role = 'JUDGE';
		}

		return {
			"gameCode" : gameCode,
			"players" : [],
			"gamePhase" : 'INIT',
			"judge" : false,
			"setJudge" : _setJudge,
			"newPlayer" : _newPlayer,
			"tag" : false,
			// "restart" : _restart,
			"playedCards" : [],
			"judgeSocket" : false,
			"otherPlayerSockets" : Array(),
			"tvSockets" : Array()

		}

	}

})();