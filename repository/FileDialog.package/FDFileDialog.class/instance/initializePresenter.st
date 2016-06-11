initialization
initializePresenter
	self initializeBookmarksList.
	self initializeFilesList.
	self initializeFiltersDropList.
	self initializeDragAndDrop.
	cancelButton action: [ self delete ].
	confirmButton action: [ self confirm ].
	nameText whenTextChanged: [ self nameChanged ]