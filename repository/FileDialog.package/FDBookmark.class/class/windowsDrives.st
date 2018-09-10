default bookmarks
windowsDrives
	^ FileLocator root asFileReference directories
		collect:
			[ :each | FDBookmark name: each basename location: each icon: Smalltalk ui icons smallWindow ]