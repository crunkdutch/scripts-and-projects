
var mongodb = require('mongodb'),
    Server = mongodb.Server,
    sys = require("sys"),
    uuid = require("node-uuid"),
    mongoose = require("mongoose"),

    dbconn = mongoose.connect(
        "mongodb://localhost/brabble"
    ),
    mongoose = require("mongoose"),
    models = require("../models")(mongoose, uuid, dbconn);
    Users = models.User,
    savedusers = 0;


function callback(err, id, len) {
    if (id) {
    	savedusers++;
    }
       
    if (savedusers>=len) {
    	process.exit();
    }
       
    else {
    	console.log(err);
    }
}


function docSave(doc,len,callback){

  	doc.save(function(err,doc1) {
      	console.log('poing ' + savedusers + ' len ' + len);
   		if (err) {
       		//will only go into recursion if dup error thrown
      		if (err && err.code === 11001) {
         		doc.username = doc.username + savedusers;
         		docSave(doc,len,callback);
      		}
       		
       		console.log(err);
       		callback(err,false,len);

     	}	
     
     	if (doc1) {
       		callback('yay',doc1._id,len);
      	}
  	});
}


Users.find({}, function (err, result) {

    var doc, error, len = result.length, pending = 0;
    result.forEach(function (doc) {

        if (doc.firstName && doc.lastName) {

            var firstName = (doc.firstName.trim() === undefined ? 'firstName' + pending : doc.firstName.trim());
            var lastName = (doc.lastName.trim() === undefined ? 'lastName' + pending : doc.lastName.trim());
            var trimmedName = firstName + lastName;
            doc.firstName = firstName;
            doc.lastName = lastName;

        } 
        else {
            var firstName = (doc.firstName === undefined ? 'firstName' + pending : doc.firstName.trim());
            var lastName = (doc.lastName === undefined ? 'lastName' + pending : doc.lastName.trim());

        }

        if (!doc.username) {

            doc.username = (trimmedName === undefined ? 'woof' + pending : trimmedName);
        } 

        else {
            doc.username = doc.username.trim();
        }
        
        docSave(doc,len,callback);

    });
});