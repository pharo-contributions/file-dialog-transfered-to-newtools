"
I'm selecting file not hiddenfile
"
Class {
	#name : #FDHidenSelect,
	#superclass : #FDAbstractSimpleSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDHidenSelect >> name [
	^ 'filter hidden file'
]

{ #category : #accessing }
FDHidenSelect >> predicate: aFileReference [
	OSPlatform current isWindows
		ifTrue: [ aFileReference isHiddenInWindows not ].
	^ (aFileReference basename matchesRegex: '\.[^.].*') not.
]
