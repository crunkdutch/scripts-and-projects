var mongodb = require('mongodb'),
	apns = require('apns'),
    Server = mongodb.Server,
    sys = require("sys"),
    uuid = require("node-uuid"),
    mongoose = require("mongoose"),
    dbconn = mongoose.connect(
        "mongodb://admin:iamthesupermongoadmin@number9.db1.brabblevideo.biz:27017/brabble" 
    ),
    mongoose = require("mongoose"),
    models = require("../models")(mongoose, uuid, dbconn);
	Users = models.User,
	total = 0, 
	cbCounter = 0,
	options = {
    	certFile : "../certs/cert.pem",
    	keyFile : "../certs/key.pem",
     	cert: "../certs/cert.pem",
     	key: "../certs/key.pem",
		cacheLength: 1000,
	    enhanced: false,
		connectionTimeout : "60000",
	    passphrase : "Insul1n!",
		debug: true,
	    gateway : "gateway.sandbox.push.apple.com"
};

connHelper = new apns.Connection(options);
sendNotification = apns.Connection.prototype.sendNotification;

apns.Connection.prototype.sendNotification = function(notification, callBack) {
		sendNotification.apply(this, [notification]);
		this.openSocketDeferred.promise.then(
			function() {
				if (callBack) {
					callBack();
				}
			}	
		);
}

function closeConnectionCheck() {
	console.log(total + ' the total');
	console.log(cbCounter + ' the cbCounter');
	cbCounter ++ ;
	
	if (cbCounter >= total) {
		console.log('we are done...close the script');
		process.exit();	
	}
};


Users.find({},
	function(err, result) {
		if (err) console.log(err + ' we gotta err... ');
		if (result) {
			result.forEach(function(doc){
				for (var i = 0; i < doc.apnsToken.length; i++)
				{
					if (doc.status === 'active') {
						var t = doc.apnsToken[i];

						if (t && (t.length === 64)) {
							for (var j = 0; j < doc.notification_settings.length; j++)
							{
								var n = doc.notification_settings[j];
								if (n === 'brabble_system') {	
									total++;
									var msg = process.argv[2];
									var notification = new apns.Notification();
									notification.device = new apns.Device(t);
									notification.alert = msg;
									connHelper.sendNotification(notification, closeConnectionCheck);	
								}
							}
						}
					}
				}
			});
		}
	}
);