rs.slaveOk();
db = db.getSiblingDB('brabble');
counter = 0;
end = new Date(2013, 7, 18);


db.users.find().forEach(
	function(doc){
		if (doc.status === 'active') {
			if (doc.created >= end) {
				counter ++;
				print('new user: ' + doc.username  + ' created on: ' + doc.created +  ' ' + counter);	
			}
		}
	}	
);