actions
openFolder: aFolder
	| newIndex |
	currentDirectory := aFolder pathString asFileReference.
	filesList items: self currentFiles.
	filesList resetSelection.
	newIndex := self bookmarks keys indexOf: currentDirectory.
	newIndex = bookmarksList selectedIndex
		ifFalse: [ bookmarksList setSelectedIndex: newIndex ]