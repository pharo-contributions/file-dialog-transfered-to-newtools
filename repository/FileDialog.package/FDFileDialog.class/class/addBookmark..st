adding
addBookmark: aFolder
	self customBookmarks detect: [ :each | each location = aFolder ] ifFound: [ ^ self ].
	self customBookmarks
		add: (FDBookmark name: aFolder basename location: aFolder icon: Smalltalk ui icons open)