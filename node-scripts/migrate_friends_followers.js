/*
	mongo migration script - 
	
	gets all the friends from the users collection and creates new documents in the followers collection. 

	run via command line on the database server - example `mongo brabble migrateFriendsFollowers.js

*/

var array = [];
var counter = 0;

db.users.find().forEach(
	function(doc){
		var o = {
				user: doc._id,
				friends : doc.friends
			};

		array.push(o);
	}
);

function goFollowers() {
	for (var i = 0; i < array.length; i++) {
		db.followers.update(
			{ user : array[i]['user'] },
	        { $addToSet: { followed_by_me : { $each : array[i]['friends'] } } }
		);
	}
}

if (array.length === db.users.count()) {
	goFollowers();
}