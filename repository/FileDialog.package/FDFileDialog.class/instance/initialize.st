initialization
initialize
	showHiddenFiles := false.
	onConfirmBlock := [ :selection |  ].
	filter := FDFileFilter new.
	super initialize