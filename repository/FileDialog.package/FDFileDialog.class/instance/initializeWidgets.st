initialization
initializeWidgets
	bookmarksList := self instantiate: IconListModel.
	filesList := self instantiate: IconListModel.
	pathLabel := self newLabel.
	createFolderButton := self newButton.
	(nameLabel := self newLabel) label: 'Name:'.
	(nameText := self newTextInput) autoAccept: true.
	(cancelButton := self newButton) label: 'Cancel'.
	(confirmButton := self newButton)
		label: 'Confirm';
		disable.
	extensionDropList := self newDropList.
	self title: self initialTitle.
	self focusOrder
		add: nameText;
		add: extensionDropList;
		add: cancelButton;
		add: confirmButton