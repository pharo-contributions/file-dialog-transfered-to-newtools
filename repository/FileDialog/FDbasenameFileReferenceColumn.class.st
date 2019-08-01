Class {
	#name : #FDbasenameFileReferenceColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #templateMethod }
FDbasenameFileReferenceColumn class >> columnTitle [
	"I'm returning a String for the title"

	^ 'basename'
]

{ #category : #templateMethod }
FDbasenameFileReferenceColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference basename
]
