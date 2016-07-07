bookmarks
removeBookmark: aFolder
	self customBookmarks removeKey: aFolder.
	bookmarksList items: self bookmarks keys