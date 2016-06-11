ui requests
chooseDirectory: label path: path
	^ FDOpenDirectoryDialog new
		defaultFolder: path;
		title: (label ifNil: [ 'Choose Directory' translated ]);
		openModal