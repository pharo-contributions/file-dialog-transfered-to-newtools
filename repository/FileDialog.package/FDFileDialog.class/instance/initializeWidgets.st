initialization
initializeWidgets
	bookmarksList := self instantiate: IconListModel.
	(currentFolderLabel := self newLabel)
		color: Smalltalk ui theme textColor.
	filesList := self instantiate: IconListModel.
	createFolderButton := self newButton.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	(cancelButton := self newButton) label: 'Cancel'.
	(confirmButton := self newButton)
		label: 'Confirm';
		disable.
	filtersDropList := self newDropList.
	self title: self initialTitle.
	self focusOrder
		add: nameText;
		add: filtersDropList;
		add: cancelButton;
		add: confirmButton