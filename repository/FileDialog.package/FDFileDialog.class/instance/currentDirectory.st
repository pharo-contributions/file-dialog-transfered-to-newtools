accessing
currentDirectory
	^ currentDirectory
		ifNil: [ currentDirectory := FileLocator imageDirectory asFileReference ]