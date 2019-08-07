"
i define simple predicate 
	see my super class for more information
"
Class {
	#name : #FDAbstractSimpleSelect,
	#superclass : #FDAbstractSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractSimpleSelect class >> actions [
	^self allSubclasses collect: [:item |item new ]
]

{ #category : #testing }
FDAbstractSimpleSelect class >> isAbstract [ 
	^self = FDAbstractSimpleSelect 
]
