Class {
	#name : #FDDefaultPredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDefaultPredicate >> name [
	^ 'no filter'
]

{ #category : #accessing }
FDDefaultPredicate >> predicate: aFileReference [
	^ true
]
