ui requests
chooseFileMatching: patterns label: label
	^ FDOpenFileDialog new
		title: (label ifNil: [ 'Choose File' translated ]);
		fileFilters: patterns;
		openModal