Class {
	#name : #FDAbstractCompositePredicate,
	#superclass : #FDAbstractPredicate,
	#instVars : [
		'collectionOfFDAbstractFilter'
	],
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractCompositePredicate class >> actions [
	^self allSubclasses collect: [:item |item new ]
]

{ #category : #testing }
FDAbstractCompositePredicate class >> isAbstract [ 
	^ self = FDAbstractCompositePredicate
]

{ #category : #accessing }
FDAbstractCompositePredicate >> collectionOfFDAbstractFilter [
	^ collectionOfFDAbstractFilter
]

{ #category : #accessing }
FDAbstractCompositePredicate >> collectionOfFDAbstractFilter: anObject [
	collectionOfFDAbstractFilter := anObject
]
