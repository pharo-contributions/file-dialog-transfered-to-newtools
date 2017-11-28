as yet unclassified
testConvertBookmarks
	| dict result |
	dict := OrderedDictionary
		with: root / 'dir' -> (Array with: 'dir' with: Smalltalk ui icons blank).
	result := FDFileDialog convertBookmarks: dict.
	self assert: (result isKindOf: OrderedCollection).
	self assert: result size equals: 1.
	self assert: result first name equals: 'dir'.
	self assert: result first location equals: root / 'dir'.
	self assert: result first icon equals: Smalltalk ui icons blank