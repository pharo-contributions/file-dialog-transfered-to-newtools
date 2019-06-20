Class {
	#name : #FDOrCompositeFilter,
	#superclass : #FDAbstractCompositeFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDOrCompositeFilter class >> collection: aCollectionOfFilter [
	^ self new collectionOfFDAbstractFilter: aCollectionOfFilter
]

{ #category : #accessing }
FDOrCompositeFilter >> filter: aFileReference [
	^ collectionOfFDAbstractFilter
		reduceLeft:
			[ :itemN0 :itemN1 | (itemN0 filter: aFileReference) or: [ itemN1 filter: aFileReference ] ]
]

{ #category : #accessing }
FDOrCompositeFilter >> name [
	^ 'and composition filter'
]
