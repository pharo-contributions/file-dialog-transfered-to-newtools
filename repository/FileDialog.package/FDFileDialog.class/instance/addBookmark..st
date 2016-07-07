bookmarks
addBookmark: aFolder
	self customBookmarks at: aFolder put: (Array with: aFolder basename with: self icons open).
	bookmarksList ifNotNil: [ bookmarksList items: self bookmarks keys ]