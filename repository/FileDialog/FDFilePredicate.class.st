Class {
	#name : #FDFilePredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDFilePredicate >> name [
	^ 'file filter'
]

{ #category : #accessing }
FDFilePredicate >> predicate: aFileReference [
	^ aFileReference isFile
	
]
