Class {
	#name : #FDJPGAndPNGFilter,
	#superclass : #FDAbstractCompositeFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDJPGAndPNGFilter >> filter: aFileReference [
	^ collectionOfFDAbstractFilter
		anySatisfy: [ :aFileFilter | aFileFilter filter: aFileReference  ]
]

{ #category : #initialization }
FDJPGAndPNGFilter >> initialize [
	collectionOfFDAbstractFilter := OrderedCollection new.
	collectionOfFDAbstractFilter add: FDDotJPGFilter new.
	collectionOfFDAbstractFilter add: FDDotPNGFilter new
]

{ #category : #accessing }
FDJPGAndPNGFilter >> name [
	^ '.jpg and .png filter'
]
