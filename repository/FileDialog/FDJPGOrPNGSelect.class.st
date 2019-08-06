"
I'm selecting only jpg file or PNG file
"
Class {
	#name : #FDJPGOrPNGSelect,
	#superclass : #FDAbstractCompositeSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #initialization }
FDJPGOrPNGSelect >> initialize [
	collectionOfFDAbstractFilter := OrderedCollection new.
	collectionOfFDAbstractFilter add: FDDotJPGSelect new.
	collectionOfFDAbstractFilter add: FDDotPNGSelect new
]

{ #category : #accessing }
FDJPGOrPNGSelect >> name [
	^ '.jpg and .png filter'
]

{ #category : #accessing }
FDJPGOrPNGSelect >> predicate: aFileReference [
	^ collectionOfFDAbstractFilter
		anySatisfy: [ :aFileFilter | aFileFilter predicate: aFileReference  ]
]
