initialization
initializePresenter
	self initializeBookmarksList.
	self initializeFilesList.
	self initializeExtensionDropList.
	self initializeDragAndDrop.
	cancelButton action: [ self delete ].
	confirmButton action: [ self confirm ].
	nameText whenTextChanged: [ self nameChanged ]