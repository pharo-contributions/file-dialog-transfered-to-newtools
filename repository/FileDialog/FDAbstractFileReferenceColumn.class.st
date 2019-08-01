"
I'm an abstract 

my subclasses have to define:
"
Class {
	#name : #FDAbstractFileReferenceColumn,
	#superclass : #Object,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #testing }
FDAbstractFileReferenceColumn class >> isAbstract [ 
	^ self = FDAbstractFileReferenceColumn
]
