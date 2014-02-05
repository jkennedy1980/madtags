
var express = require('express');
var http = require('http');
var path = require('path');

var app = express();

app.configure(function() {
	app.set('port', process.env.PORT || 80);
	app.set('views', __dirname + '/views');
	app.set('view engine', 'ejs');
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

app.get('/', function(req, res) {
  res.render('index');
});

var server = http.createServer( app );
var io = require('socket.io').listen( server );

server.listen( app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

io.sockets.on( 'connection', function( socket ){
	console.log( "GETTING CONNNECTION" );

	socket.on( 'join', function( data ){
		console.log( "JOINING: ", data );
		socket.emit( 'message', { response: data } );
	});
});