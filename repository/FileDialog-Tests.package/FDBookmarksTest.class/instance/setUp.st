tests
setUp
	super setUp.
	existingBookmarks := FDFileDialog customBookmarks copy.
	FDFileDialog customBookmarks: OrderedCollection new