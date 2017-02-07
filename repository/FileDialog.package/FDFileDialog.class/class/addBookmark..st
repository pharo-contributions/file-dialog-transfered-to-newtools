adding
addBookmark: aFolder
	self customBookmarks at: aFolder put: (Array with: aFolder basename with: Smalltalk ui icons open)