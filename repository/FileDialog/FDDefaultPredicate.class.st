Class {
	#name : #FDDefaultPredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #applying }
FDDefaultPredicate >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference
]

{ #category : #accessing }
FDDefaultPredicate >> name [
	^ 'no filter'
]

{ #category : #accessing }
FDDefaultPredicate >> predicate: aFileReference [
	^ true
]
