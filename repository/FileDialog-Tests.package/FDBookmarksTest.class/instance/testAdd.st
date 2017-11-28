tests
testAdd
	self assert: FDFileDialog customBookmarks isEmpty.
	FDFileDialog addBookmark: FileLocator D asFileReference / 'prog'.
	self assert: FDFileDialog customBookmarks size equals: 1