Class {
	#name : #FDAccessRightFileReferenceColumn,
	#superclass : #FDAbstractStringTableColumn,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #templateMethod }
FDAccessRightFileReferenceColumn class >> columnTitle [
	"I'm returning a String for the title"

	^ 'Access right'
]

{ #category : #templateMethod }
FDAccessRightFileReferenceColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference permissions
]
