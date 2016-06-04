bookmarks
addBookmark: aFolder
	CustomBookmarks at: aFolder put: (Array with: aFolder basename with: self icons open).
	bookmarksList items: self bookmarks keys