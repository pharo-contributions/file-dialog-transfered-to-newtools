Class {
	#name : #FDDirectoryPredicate,
	#superclass : #FDAbstractSimplePredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDirectoryPredicate >> name [
	^ 'directory filter'
]

{ #category : #accessing }
FDDirectoryPredicate >> predicate: aFileReference [
	^ aFileReference isDirectory
]
