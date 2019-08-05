"
I'm an abstract class use to define TreeTable
"
Class {
	#name : #FDAbstractColumnTreeTable,
	#superclass : #Object,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #accessing }
FDAbstractColumnTreeTable class >> column [
	"I'm returning a SpTreeTableColumn"

	^ self tableColumnClass
		title: self columnTitle
		evaluated: self columnEvaluated
]

{ #category : #templateMethod }
FDAbstractColumnTreeTable class >> columnEvaluated [
	"I'm returning a block for evaluated for TreeTableColumn"
	 ^ self subclassResponsibility 
]

{ #category : #templateMethod }
FDAbstractColumnTreeTable class >> columnTitle [
	"I'm returning a String"
	^ self subclassResponsibility
]

{ #category : #testing }
FDAbstractColumnTreeTable class >> isAbstract [ 
	^ self = FDAbstractColumnTreeTable
]

{ #category : #class }
FDAbstractColumnTreeTable class >> tableColumnClass [
	"I'm returning a son of SpTreeTableColumn"
	^ self subclassResponsibility 
]
