tests
testSelectFile
	| selectedFile |
	dialog whenSelected: [ :file | selectedFile := file ].
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'sth.ext'.
	self assert: dialog selectedEntry equals: root / 'sth.ext'.
	dialog confirm.
	self assert: selectedFile equals: root / 'sth.ext'