bookmarks
addBookmark: aFolder
	self class addBookmark: aFolder.
	self refreshBookmarks
	bookmarksList items: self bookmarks keys