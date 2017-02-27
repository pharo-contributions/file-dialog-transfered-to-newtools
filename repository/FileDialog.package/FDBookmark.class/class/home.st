default bookmarks
home
	^ FDBookmark
		name: 'home'
		location: FileLocator home asFileReference
		icon: Smalltalk ui icons home