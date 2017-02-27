default bookmarks
root
	^ FDBookmark
		name: 'file system'
		location: FileLocator root asFileReference
		icon: Smalltalk ui icons smallWindow