ui requests
fileSave: title extensions: exts path: path
	^ (FDSaveFileDialog new
		title: (title ifNil: [ 'Choose File' translated ]);
		fileFilters: (exts ifNil: [ #() ] ifNotNil: [ :e | e collect: [ :each | '*.' , each ] ]);
		defaultFolder: path;
		openModal)