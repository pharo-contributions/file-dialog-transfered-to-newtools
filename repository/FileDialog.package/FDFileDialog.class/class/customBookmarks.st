adding
customBookmarks
	CustomBookmarks isDictionary
		ifTrue: [ CustomBookmarks := self convertBookmarks: CustomBookmarks ].
	^ CustomBookmarks ifNil: [ CustomBookmarks := OrderedCollection new ]