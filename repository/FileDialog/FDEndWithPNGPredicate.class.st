Class {
	#name : #FDEndWithPNGPredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDEndWithPNGPredicate >> name [
	^ 'end with png'
]

{ #category : #accessing }
FDEndWithPNGPredicate >> predicate: aFileReference [
	^ aFileReference basename
		regex: '.*\.png'
		matchesDo: [ :item | ^ true ]
]
