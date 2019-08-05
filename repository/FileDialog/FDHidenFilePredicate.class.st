Class {
	#name : #FDHidenFilePredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDHidenFilePredicate >> name [
	^ 'filter hidden file'
]

{ #category : #accessing }
FDHidenFilePredicate >> predicate: aFileReference [
	OSPlatform current isWindows
		ifTrue: [ aFileReference isHiddenInWindows not ].
	^ (aFileReference basename matchesRegex: '\.[^.].*') not.
]
