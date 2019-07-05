Class {
	#name : #FDOrCompositePredicate,
	#superclass : #FDAbstractCompositePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDOrCompositePredicate class >> collection: aCollectionOfFilter [
	^ self new collectionOfFDAbstractFilter: aCollectionOfFilter
]

{ #category : #accessing }
FDOrCompositePredicate >> name [
	^ 'and composition filter'
]

{ #category : #accessing }
FDOrCompositePredicate >> predicate: aFileReference [
	^ collectionOfFDAbstractFilter
		reduceLeft:
			[ :itemN0 :itemN1 | (itemN0 predicate: aFileReference) or: [ itemN1 predicate: aFileReference ] ]
]
