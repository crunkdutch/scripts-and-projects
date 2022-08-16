rs.slaveOk();
db = db.getSiblingDB('brabble');
counter = 0;
end = new Date(2013, 7, 18); 

db.users.find().forEach(
	function(doc){
		if (doc.friends) {
			if (doc.friends.length > 1 && doc.status === 'active') {
				if (doc.lastLogin > end) {
					counter ++;
					print('username: ' + doc.username + '  last login: ' + doc.lastLogin + ' ' + counter );
				}
			}
		}
	}	
);