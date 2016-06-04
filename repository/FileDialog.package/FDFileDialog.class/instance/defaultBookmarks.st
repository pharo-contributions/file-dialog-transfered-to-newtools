bookmarks
defaultBookmarks
	| preset |
	preset := {FileLocator imageDirectory asFileReference
		->
			{'image directory'.
			self icons komitterNewSlice}.
	FileLocator home asFileReference
		->
			{'home'.
			self icons home}.
	FileLocator temp asFileReference
		->
			{'tmp'.
			self icons open}.
	FileLocator root asFileReference
		->
			{'file system'.
			self icons smallWindow}} asOrderedDictionary.
	^ preset