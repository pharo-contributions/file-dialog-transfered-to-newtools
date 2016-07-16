utility
currentFolderTitleFor: aString
	| e optimal max leftBarWidth |
	e := self window ifNil: [ self initialExtent ] ifNotNil: [ self window window extent ].
	leftBarWidth := 200.
	optimal := (LabelMorph contents: aString) optimalExtent x.
	max := e x - leftBarWidth.
	optimal < max
		ifTrue: [ ^ aString , self delimiter ].
	^ '... ' , (aString last: (aString size * (max / optimal)) rounded) , self delimiter