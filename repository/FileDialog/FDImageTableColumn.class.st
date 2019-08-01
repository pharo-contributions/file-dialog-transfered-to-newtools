Class {
	#name : #FDImageTableColumn,
	#superclass : #FDAbstractFileReferenceColumn,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #testing }
FDImageTableColumn class >> isAbstract [ 
	^ self = FDImageTableColumn
]

{ #category : #'as yet unclassified' }
FDImageTableColumn class >> tableColumnClass [
	"I'm returning a class son of SpTableColumn"
	^ SpImageTableColumn 
]
