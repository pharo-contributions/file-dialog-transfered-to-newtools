Class {
	#name : #FDJPGAndPNGPredicate,
	#superclass : #FDAbstractCompositePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #initialization }
FDJPGAndPNGPredicate >> initialize [
	collectionOfFDAbstractFilter := OrderedCollection new.
	collectionOfFDAbstractFilter add: FDDotJPGPredicate new.
	collectionOfFDAbstractFilter add: FDDotPNGPredicate new
]

{ #category : #accessing }
FDJPGAndPNGPredicate >> name [
	^ '.jpg and .png filter'
]

{ #category : #accessing }
FDJPGAndPNGPredicate >> predicate: aFileReference [
	^ collectionOfFDAbstractFilter
		anySatisfy: [ :aFileFilter | aFileFilter predicate: aFileReference  ]
]
