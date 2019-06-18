Class {
	#name : #FDAbstractSimpleFilter,
	#superclass : #FDAbstractFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractSimpleFilter class >> actions [
	^self allSubclasses collect: [:item |item new ]
]

{ #category : #testing }
FDAbstractSimpleFilter class >> isAbstract [ 
	^self = FDAbstractSimpleFilter 
]
