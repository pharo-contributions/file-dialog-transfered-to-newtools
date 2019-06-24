Class {
	#name : #FDHidenFileFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDHidenFileFilter >> filter: aFileReference [
	OSPlatform current isWindows
		ifTrue: [ aFileReference isHiddenInWindows ].
	^ aFileReference basename matchesRegex: '\.[^.].*'.
]

{ #category : #accessing }
FDHidenFileFilter >> name [
	^ 'filter hidden file'
]
