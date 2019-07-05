Class {
	#name : #FDEndWithJPGPredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDEndWithJPGPredicate >> name [
	^ 'end with jpg'
]

{ #category : #accessing }
FDEndWithJPGPredicate >> predicate: aFileReference [
	^ aFileReference basename
		regex: '.*\.jpg'
		matchesDo: [ :item | ^ true ]
]
