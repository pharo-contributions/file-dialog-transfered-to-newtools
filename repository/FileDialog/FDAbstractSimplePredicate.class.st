Class {
	#name : #FDAbstractSimplePredicate,
	#superclass : #FDAbstractPredicate,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractSimplePredicate class >> actions [
	^self allSubclasses collect: [:item |item new ]
]

{ #category : #testing }
FDAbstractSimplePredicate class >> isAbstract [ 
	^self = FDAbstractSimplePredicate 
]
