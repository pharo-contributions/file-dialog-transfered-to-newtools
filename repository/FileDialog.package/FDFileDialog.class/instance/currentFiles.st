accessing
currentFiles
	^ ((self isRootDirectory: currentDirectory)
		ifTrue: [ {} ]
		ifFalse: [ {self currentDirectory / '..'} ]) , self currentDirectory children