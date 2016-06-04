accessing
currentFiles
	^ (self currentDirectory isRoot
		ifTrue: [ {} ]
		ifFalse: [ {self currentDirectory / '..'} ]) , self currentDirectory children