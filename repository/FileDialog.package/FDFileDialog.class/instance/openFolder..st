actions
openFolder: aFolder
	currentDirectory := self canonicalize: aFolder.
	currentFolderLabel
		label: (self currentFolderTitleFor: currentDirectory pathString);
		help: currentDirectory pathString , self delimiter.
	filesList items: self currentFiles.
	filesList resetSelection.
	self selectBookmarkFor: currentDirectory