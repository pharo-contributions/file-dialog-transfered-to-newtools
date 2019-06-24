Class {
	#name : #FDAndCompositeFilter,
	#superclass : #FDAbstractCompositeFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDAndCompositeFilter class >> collection: aCollectionOfFilter [
	^ self new collectionOfFDAbstractFilter: aCollectionOfFilter
]

{ #category : #accessing }
FDAndCompositeFilter >> filter: aFileReference [
	^ collectionOfFDAbstractFilter
		reduceLeft:
			[ :itemN0 :itemN1 | (itemN0 filter: aFileReference) and: [ itemN1 filter: aFileReference ] ]
]

{ #category : #accessing }
FDAndCompositeFilter >> name [
	^ 'and composition filter'
]
