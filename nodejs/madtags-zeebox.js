( function(){
	
	var request = require('request');

	exports.fetchZeeData = function( title, callback ){
		exports.fetchBrandData( title, function( error, brandId ){
			if( error ) return callback( error, false );
			if( !brandId ) return callback( false, false );

			console.log( "GOT BRAND ID: ", brandId );

			exports.fetchLastOnForBrand( brandId, function( error, broadCastId ){
				if( error ) return callback( error, false );
				if( !broadCastId ) return callback( false, false );

				console.log( "GOT AN BROADCAST ID: ", broadCastId );
				exports.fetchZeeTagsForBroadcastId( broadCastId, function( error, words ){
					if( error ) return callback( error, false );
				
					console.log( "GET A RESPONSE: ", words );

					callback( false, words );

				});
			});
		});
	}

	exports.fetchBrandData = function( title, callback ){
		var escapedTitle = encodeURIComponent( title );
		var req = {
			url: "https://api.zeebox.com/meta/brand?q=" + escapedTitle
		};

		request( req, function( error, response, body ){
			if( error ) return callback( error, false );

			if( !body ) return callback( false, false );

			var parsedBody = JSON.parse( body );
			if( !parsedBody.length ) return callback( false, false );

			var result1 = parsedBody[0];
			callback( false, result1.brand_id );
		});
	};

	exports.fetchLastOnForBrand = function( brandId, callback ){

		var req = {
			url: "https://api.zeebox.com/meta/laston?brand=" + brandId
		};

		request( req, function( error, response, body ){
			if( error ) return callback( error, false );
			if( !body ) return callback( false, false );

			var parsedBody = JSON.parse( body );
			console.log( "LAST ON: ", parsedBody );

			if( !parsedBody.length ) return callback( false, false );

			var result1 = parsedBody[0];
			callback( false, result1.epg.replace( 'https://w.zeebox.com/epg/1/broadcastevent/', '' ) );
		});
	}

	exports.fetchZeeTagsForBroadcastId = function( broadcastId, callback ){
		var req = {
			url: "http://w.zeebox.com/zta/zeetags?broadcastevent=" + broadcastId
		};

		request( req, function( error, response, body ){
			if( error ) return callback( error, false );
			if( !body ) return callback( false, false );

			var parsedBody = JSON.parse( body );
			if( !parsedBody.zeetags ) return callback( false, false );

			var zeeTags = parsedBody.zeetags;
			if( !zeeTags ) return callback( false, false );

			var words = [];
			for( var i = 0; i < zeeTags.length; i++ ){
				var zeeTag = zeeTags[i];
				if( zeeTag.icon === 'place' || zeeTag.icon === 'info' ){
					console.log( "ZEE TAG: ", zeeTag );
					words.push( zeeTag.title );
				}
			}

			callback( false, words );
		});
	}

})();