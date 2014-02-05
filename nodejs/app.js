
var express = require('express');
var http = require('http');
var path = require('path');
var connect = require('connect');


var app = express();

app.configure(function() {
	app.set('port', process.env.PORT || 80);
	app.engine( 'html', require('ejs').renderFile );
	app.set( 'views', __dirname + '/views' );
	app.set( 'view engine', 'ejs' );
	app.set( 'view options', { layout: false } );
	app.use(express.favicon());
	app.use(express.logger('dev')); //default dev
	app.use(express.compress());
	app.use(connect.urlencoded())
	app.use(connect.json());
	app.use(express.methodOverride());
	app.use(express.cookieParser('madtagsftw--secret'));
	app.use(express.session());
	app.use(app.router);
	app.use(express.static(path.join(__dirname, 'public')));
});


var server = http.createServer( app );
var io = require('socket.io').listen( server );



require('./madtags-sockets.js')( io );

require('./madtags-webserver.js')( app );


server.listen( app.get('port'), function(){
  console.log( "Express server listening on port " + app.get('port') );
});