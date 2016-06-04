bookmarks
removeBookmark: aFolder
	CustomBookmarks removeKey: aFolder.
	bookmarksList items: self bookmarks keys