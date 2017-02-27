default bookmarks
tmp
	^ FDBookmark
		name: 'tmp'
		location: FileLocator temp asFileReference
		icon: Smalltalk ui icons open