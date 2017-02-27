adding
addBookmark: aFolder
	self customBookmarks
		add: (FDBookmark name: aFolder basename location: aFolder icon: Smalltalk ui icons open)