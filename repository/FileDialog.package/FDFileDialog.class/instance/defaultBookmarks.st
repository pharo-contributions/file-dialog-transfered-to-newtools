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
			self icons open}} asOrderedDictionary.
	OSPlatform current isWindows
		ifFalse: [ preset
				at: FileLocator root asFileReference
				put:
					{'file system'.
					self icons smallWindow} ].
	OSPlatform current isWindows
		ifTrue: [ FileLocator root asFileReference children
				do: [ :each | 
					preset
						at: each
						put:
							{each basename.
							self icons smallWindow} ] ].
	^ preset