accessing
separator
	^ OSPlatform current isWindows
		ifTrue: [ '\' ]
		ifFalse: [ '/' ]