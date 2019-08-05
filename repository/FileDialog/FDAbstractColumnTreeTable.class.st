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

{ #category : #testing }
FDAbstractColumnTreeTable class >> isAbstract [ 
	^ self = FDAbstractColumnTreeTable 
]
