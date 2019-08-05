"
I'm use to give you an Icon 
	
"
Class {
	#name : #FDIconFileReferenceTableColumn,
	#superclass : #FDImageTableColumn,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #templateMethod }
FDIconFileReferenceTableColumn class >> columnTitle [
	"I'm returning a String for the title"

	^ 'icon'
]

{ #category : #templateMethod }
FDIconFileReferenceTableColumn class >> evaluateOn: aFileReference [
	"I'm provide action for fileReference"

	^ aFileReference isDirectory ifTrue: [ self iconNamed: #configNew ]
	ifFalse: [ self iconNamed: #page ]
]
