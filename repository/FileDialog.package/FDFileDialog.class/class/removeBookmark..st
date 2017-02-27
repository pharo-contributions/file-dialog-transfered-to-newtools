adding
removeBookmark: aFolder
	self customBookmarks removeAllSuchThat: [ :each | each location = aFolder ]