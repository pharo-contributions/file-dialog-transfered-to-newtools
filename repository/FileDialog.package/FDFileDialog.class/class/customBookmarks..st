adding
customBookmarks: aCollection
	self assert: [ aCollection isKindOf: OrderedCollection ].
	self assert: [ aCollection allSatisfy: [ :each | each isKindOf: FDBookmark ] ].
	CustomBookmarks := aCollection