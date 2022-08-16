var config = require('../config/v1-development'),
	iu = require('../utils/imageUtils')(config),
	aws = require('aws-sdk'),
	mongodb = require('mongodb'),
    Server = mongodb.Server,
    sys = require("sys"),
    uuid = require("node-uuid"),
    mongoose = require("mongoose"),
    gm     = require('gm'),
    dbconn = mongoose.connect(
        "mongodb://localhost/brabble"
    ),

    mongoose = require("mongoose"),
    models = require("../models")(mongoose, uuid, dbconn);
	Users = models.User,
	fs = require('fs'),
	idArr = [],
	files = []
	thumbs = [];

	aws.config.update({
		accessKeyId: config.s3.key, 
	  	secretAccessKey: config.s3.secret,
	  	region: 'us-east-1'
	});

var s3 = new aws.S3().client;
var counter = 0,
	gmcounter = 0,
	ulcounter = 0,
	batch = 200,
	gmbatch = 4,
	ulbatch = 1,
	gmTotal,
	dlTotal,
	ulTotal;

function downloadOrigin(toFile, fileName, callback) {
    var file = fs.createWriteStream(toFile);
    console.log('downoading ' +  fileName);
    var reader = s3.getObject({Bucket: config.s3.bucket, Key: fileName}).createReadStream();

    reader.on("end", function (err) {
        console.log('end event');
        counter ++;
        if (err) console.log(err);
        callback(err);
    });

    reader.on("data", function (err) {
        // work around for 0.10.4
    });

    reader.on("error", function (err) {
        console.log('error event');
        counter ++;
        if (err) console.log(err); 
        callback(err);

        fs.unlink(toFile, 
        	function (err) {
			  if (err) throw err;
			  console.log('successfully deleted ' + toFile);
			}
		);
    });

    reader.pipe(file);
}

function uploadThumb(srcFile, dstFile, type, callback) {
    if (!fs.existsSync(srcFile)) {
        callback(srcFile + " does not exist on fs");
    }
    else {
        console.log("Uploading file " + srcFile + " to " + dstFile);
        var data = fs.readFileSync(srcFile);
        s3.putObject({
            Bucket: config.s3.bucket,
            Key: dstFile,
            ContentType: type,
            Body: data
        }, function (err, res) {
            data = null;
            if (err) {
                console.log(err);
                callback(err,null);
            } 
            if (res) {
                console.log("Uploaded file " + srcFile + " to " + dstFile);
                console.log('res' + res.ETag);
                /*fs.unlink(srcFile, function() {
             		console.log('deleted the file we just uploaded -----' +  srcFile);	   	
					//still fucked up 
                });*/
                ulcounter++;
                callback(null, res);
            }
        }); // s3.putObject ends
    } // if nds
}

function convertToThumb(srcFile, newFile, callback) {
    gm(srcFile).thumbnail(140, 140).write(newFile, 
    	function (err) {
    		gmcounter++;
            if (err) {
            	callback(err, null);
            }
            else {
            	callback(null, newFile);
            }
        }
    );
}

/*
	BATCH OPERATIONS
*/

function batchUpload(val) {
	for (var k = 0; k < val; k++) {
		uploadThumb('/Users/jeremy/Desktop/thumbs/' + thumbs[k],
			thumbs[k], 'image/jpeg',
			function(err, data) {
				thumbs.shift();
				if (err) {
					console.log(err)
				}
				if (data) {
					console.log(data.ETag + ' is the same ETag from the rwapper ? \n');
					console.log(ulcounter + ' should be ' + ulTotal);
					var a = Math.abs(ulTotal - ulcounter);
					if (ulcounter % ulTotal === 0) {
						console.log('we good right now.....exit ' + ulcounter + ' counter ' + ulTotal + ' total');
						process.exit();
					}
					else {
						if (a < ulbatch) {
							batchUpload(a);
						}
						else {
							batchUpload(ulbatch);	
						}
					}
				}
			}
		)
	}
}

function batchConvert(val) {
	console.log(gmTotal + 'length of files in dir to convert');
	for (var j = 0; j < val; j++) {
		convertToThumb('/Users/jeremy/Desktop/pixs/' + files[j],
			'/Users/jeremy/Desktop/thumbs/' + files[j] + '-thumb.jpg',
			function(err, data) {
				files.shift();
				if (err) {
					console.log(err);
				}
				if (data) {
					console.log(data);
					console.log(gmcounter + ' gmcounter in convert');
					var s = Math.abs(gmTotal - gmcounter);
					console.log(s + ' the difference ');
					if (gmcounter % gmTotal === 0) {
						thumbs = fs.readdirSync('/Users/jeremy/Desktop/thumbs/');
						ulTotal = thumbs.length;
						batchUpload(ulbatch);
						return;
					}
					else {
						if (s < gmbatch) {
							batchConvert(s);
						}
						else {
							batchConvert(gmbatch);
						}
					}
				}
			}
		);

		break;

	}
}

function batchDownload(val) {
	for (var i = 1; i <= val; i++) {
		downloadOrigin('/Users/jeremy/Desktop/pixs/' + idArr[i], idArr[i] + '.jpg',
			function(err) {
				idArr.shift();
				if (err) {
					console.log(err);
				}
				else {
					var t = Math.abs(dlTotal - counter);
					if (counter % dlTotal ===  0) {
						files = fs.readdirSync('/Users/jeremy/Desktop/pixs/');
						gmTotal = files.length;
						console.log('WE HAVE FINISHED, lets do the resize');
						batchConvert(gmbatch);
					}
					else {
						if (counter === batch) {
							if (t < batch) {
								batchDownload(t)
							}
							else {
								batchDownload(batch);
							}	
						} 
					}
				}
			}
		);	
	}
}

Users.find({},
	function(err, result) {
		if (err) console.log(err);
		
		if (result) {
			result.forEach(function(doc) {
				idArr.push(doc._id);
			});
			
			dlTotal = idArr.length;
			batchDownload(batch);
		}
	}
);