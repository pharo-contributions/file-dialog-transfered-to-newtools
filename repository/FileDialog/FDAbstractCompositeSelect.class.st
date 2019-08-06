"
i define compose predicate 
	see my super class for more information
"
Class {
	#name : #FDAbstractCompositeSelect,
	#superclass : #FDAbstractSelect,
	#instVars : [
		'collectionOfFDAbstractFilter'
	],
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractCompositeSelect class >> actions [
	^self allSubclasses collect: [:item |item new ]
]

{ #category : #testing }
FDAbstractCompositeSelect class >> isAbstract [ 
	^ self = FDAbstractCompositeSelect
]

{ #category : #accessing }
FDAbstractCompositeSelect >> collectionOfFDAbstractFilter [
	^ collectionOfFDAbstractFilter
]

{ #category : #accessing }
FDAbstractCompositeSelect >> collectionOfFDAbstractFilter: anObject [
	collectionOfFDAbstractFilter := anObject
]
