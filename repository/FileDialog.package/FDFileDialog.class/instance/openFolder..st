actions
openFolder: aFolder
	| newIndex |
	currentDirectory := aFolder pathString asFileReference.
	currentFolderLabel
		label: (self currentFolderTitleFor: currentDirectory pathString);
		help: (currentDirectory pathString, self separator).
	filesList items: self currentFiles.
	filesList resetSelection.
	newIndex := self bookmarks keys indexOf: currentDirectory.
	newIndex = bookmarksList selectedIndex
		ifFalse: [ bookmarksList setSelectedIndex: newIndex ]