ui requests
chooseFileName: title extensions: exts path: path preview: preview
	^ (FDOpenFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		defaultFolder: path;
		openModal) ifNotNil: #basename