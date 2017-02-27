tests
testOpenFolder
	window := opener open.
	self assert: opener currentDirectory equals: root.
	opener openFolder: root / 'dir'.
	self assert: opener currentDirectory equals: root / 'dir'