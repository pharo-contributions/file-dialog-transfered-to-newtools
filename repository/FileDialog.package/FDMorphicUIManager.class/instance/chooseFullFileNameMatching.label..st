ui requests
chooseFullFileNameMatching: patterns label: title
	^ (FDOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (patterns ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		openModal)