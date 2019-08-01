"
I'm a column use to display StringTableColumn 

overide me if you want to use SpStringTableColumn

"
Class {
	#name : #FDAbstractStringTableColumn,
	#superclass : #FDAbstractFileReferenceColumn,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #testing }
FDAbstractStringTableColumn class >> isAbstract [
	^ self = FDAbstractStringTableColumn
]

{ #category : #'as yet unclassified' }
FDAbstractStringTableColumn class >> tableColumnClass [
	^ SpStringTableColumn
]
