Class {
	#name : #FDAndCompositePredicate,
	#superclass : #FDAbstractCompositePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDAndCompositePredicate class >> collection: aCollectionOfFilter [
	^ self new collectionOfFDAbstractFilter: aCollectionOfFilter
]

{ #category : #accessing }
FDAndCompositePredicate >> name [
	^ 'and composition filter'
]

{ #category : #accessing }
FDAndCompositePredicate >> predicate: aFileReference [
	^ collectionOfFDAbstractFilter
		reduceLeft: [ :itemN0 :itemN1 | 
			(itemN0 predicate: aFileReference)
				and: [ itemN1 predicate: aFileReference ] ]
]
