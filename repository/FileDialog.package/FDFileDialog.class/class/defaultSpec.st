specs
defaultSpec
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				newColumn: [ :c | c add: #bookmarksList ] width: 150;
				newColumn: [ :c | c add: #filesList ] ];
		newRow: [ :r | 
			r
				add: #nameLabel width: 50;
				add: #nameText;
				add: #extensionDropList width: 200 ]
			height: self toolbarHeight;
		newRow: [ :r | 
			r newColumn: [ :c |  ].
			r
				add: #cancelButton width: 60;
				add: #confirmButton width: 60 ]
			height: self toolbarHeight;
		yourself