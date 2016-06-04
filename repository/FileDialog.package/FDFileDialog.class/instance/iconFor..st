accessing
iconFor: anEntry
	| icons |
	icons := self icons.
	anEntry isDirectory
		ifTrue: [ ^ icons open ].
	(#(st txt) includes: anEntry extension)
		ifTrue: [ ^ icons smallLeftFlush ].
	(#(png jpg gif svg) includes: anEntry extension)
		ifTrue: [ ^ icons komitter ].
	^ icons page