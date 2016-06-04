accessing
filesFilteringBlock
	^ [ :entries | 
	(showHiddenFiles
		ifTrue: [ entries ]
		ifFalse: [ entries reject: [ :each | (each basename beginsWith: '.') and: [ (each basename = '..') not ] ] ])
		select: [ :each | 
			each isFile & self filteredExtensions isNotEmpty
				ifTrue: [ self filteredExtensions includes: each extension asLowercase ]
				ifFalse: [ true ] ] ]