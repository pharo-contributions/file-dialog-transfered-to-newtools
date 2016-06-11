ui requests
chooseDirectory: label from: dir
	^ FDOpenDirectoryDialog new
		defaultFolder: dir;
		title: (label ifNil: [ 'Choose Directory' translated ]);
		openModal