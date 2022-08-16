rs.slaveOk();

db = db.getSiblingDB('brabble');
numFriends = 0,
ilvoloArr = [],
gianlucaginobleArr = [],
pierobaroneArr = [],
iboschettoArr = [],
friendsArr = [],
uniq = [];

function dedupe(array) {
	print('dedupe');
	var i,
    	out = [],
    	obj = {};
 
  	for (i = 0; i < array.length; i++) {
    	obj[array[i]] = 0;
  	}

  	for (i in obj) {
    	out.push(i);
  	}

  	return out;
}


function goIbos() {
	print('goIbos');
	numFriends = 0;
	db.users.find({username : 'iboschetto'}).forEach(
		function(doc) {
			numFriends = doc.friends.length;
			iboschettoArr = doc.friends;		
			if (iboschettoArr.length === numFriends) {
				print('we can go to the next friend now');
				print(iboschettoArr.length + ' total');
				friendsArr = ilvoloArr.concat(gianlucaginobleArr,pierobaroneArr,iboschettoArr);
				uniq = dedupe(friendsArr);
				print(uniq.length+ ' uniq?');
			}
		}
	);
}

function goPier() {
	print('goPier');
	numFriends = 0;
	db.users.find({username : 'pierobarone'}).forEach(
		function(doc) {
			numFriends = doc.friends.length;
			pierobaroneArr = doc.friends;	
			if (pierobaroneArr.length === numFriends) {
				print('we can go to the next friend now');
				print(pierobaroneArr.length + ' pier');
				goIbos();
			}
		}
	);	
}

function goGian() {
	print('goGian');
	numFriends = 0;
	db.users.find({username : 'gianlucaginoble'}).forEach(
		function(doc) {
			numFriends = doc.friends.length;
			gianlucaginobleArr = doc.friends;	
			if (gianlucaginobleArr.length === numFriends) {
				print('we can go to the next friend now');
				print(gianlucaginobleArr.length + ' gian');
				goPier();
			}
		}
	);
}


function init() {
	print('init');
	db.users.find({username : 'ilvolo'}).forEach(
		function(doc) {
			numFriends = doc.friends.length;
			ilvoloArr = doc.friends;	
			if (ilvoloArr.length === numFriends) {
				print('we can go to the next friend now');
				print(ilvoloArr.length + ' ilvolo ');
				goGian();
			}
		}
	);
}


init();