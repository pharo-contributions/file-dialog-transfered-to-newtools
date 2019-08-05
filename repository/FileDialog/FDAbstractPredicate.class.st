"
i'm an abstract class use by the filter system of FDFileDialog


my subclass define:

	predicat: aFileReference
		return a boolean 
	name 
		return String 
		
this architecture is composed of 2 class 

	FDAbstractSimplePredicate
		it's compose of lightest predicate 
	FDAbstractCompositePredicate
		it's compose of predicate compose of FAbstractPredicate
"
Class {
	#name : #FDAbstractPredicate,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractPredicate class >> actions [
	| filterCollection |
	filterCollection := {}.
	self allSubclasses
		do: [ :class |filterCollection := filterCollection | class actions ].
	^ filterCollection
]

{ #category : #testing }
FDAbstractPredicate class >> isAbstract [
	^ self = FDAbstractPredicate
]

{ #category : #applying }
FDAbstractPredicate >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference select: [:eachFileReference | self predicate: eachFileReference   ]
]

{ #category : #comparing }
FDAbstractPredicate >> equals: aPredicate [
	^ self className = aPredicate className
]

{ #category : #accessing }
FDAbstractPredicate >> name [
	^ self subclassResponsibility 
]

{ #category : #accessing }
FDAbstractPredicate >> predicate: aFileReference [
	^ self subclassResponsibility 
]
