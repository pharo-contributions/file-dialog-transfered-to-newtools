accessing
iconFor: anEntry
	| icons ext |
	icons := self icons.
	anEntry isDirectory
		ifTrue: [ ^ #open asIcon ].
	ext := anEntry extension.
	^ self class allIcons asDictionary
		at: ext
		ifPresent: [ :icon | icon ]
		ifAbsent: [ #page asIcon ]