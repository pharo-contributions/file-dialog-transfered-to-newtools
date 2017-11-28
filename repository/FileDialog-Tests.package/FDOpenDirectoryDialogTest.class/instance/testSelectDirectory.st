tests
testSelectDirectory
	| selectedDirectory |
	dialog whenSelected: [ :dir | selectedDirectory := dir ].
	window := dialog open.
	self assert: dialog currentDirectory equals: root.
	dialog selectFile: root / 'dir'.
	self assert: dialog selectedEntry equals: root / 'dir'.
	dialog confirm.
	self assert: selectedDirectory equals: root / 'dir'