tests
testSelectNonexistingDirectory
	dialog defaultFolder: root / 'idontexist'.
	self assert: dialog selectedEntry equals: FileLocator imageDirectory asFileReference