actions
selectFile: aFile
	filesList selectedItem = aFile
		ifFalse: [ filesList setSelectedIndex: (filesList listItems indexOf: aFile) ].
	nameText text: aFile basename