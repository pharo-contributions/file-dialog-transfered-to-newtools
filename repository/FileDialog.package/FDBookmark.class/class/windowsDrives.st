default bookmarks
windowsDrives
	^ FileLocator root asFileReference children
		collect:
			[ :each | FDBookmark name: each basename location: each icon: Smalltalk ui icons smallWindow ]