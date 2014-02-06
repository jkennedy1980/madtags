( function(){
	
	var request = require('request');

	exports.fetchZeeData = function( title, callback ){
		exports.fetchBrandData( title, function( error, brandId ){
			if( error ) return callback( error, false );
			if( !brandId ) return callback( false, false );

			console.log( "GOT BRAND ID: ", brandId );

			exports.fetchLastOnForBrand( brandId, function( error, epg ){
				if( error ) return callback( error, false );
				if( !epg ) return callback( false, false );

				console.log( "GOT AN EPG: ", epg );
				exports.fetchZeeTagsForEpg( epg, function( error, response ){
					if( error ) return callback( error, false );
				
					console.log( "GET A RESPONSE: ", response );

					callback( false, epg );

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
			if( !parsedBody.length ) return callback( false, false );

			var result1 = parsedBody[0];
			callback( false, result1.epg );
		});
	}

	exports.fetchZeeTagsForEpg = function( epg, callback ){
		var req = {
			url: epg
		};

		request( req, function( error, response, body ){
			if( error ) return callback( error, false );
			if( !body ) return callback( false, false );

			console.log( "RESPONSE: ", body );

			var parsedBody = JSON.parse( body );
			if( !parsedBody.length ) return callback( false, false );


			callback( false, parsedBody );
		});
	}

})();