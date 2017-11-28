tests
testOpenFolder
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog openFolder: root / 'dir'.
	self assert: dialog currentDirectory equals: root / 'dir'