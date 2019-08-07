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
	#name : #FDAbstractSelect,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractSelect class >> actions [
	| filterCollection |
	filterCollection := {}.
	self allSubclasses
		do: [ :class |filterCollection := filterCollection | class actions ].
	^ filterCollection
]

{ #category : #testing }
FDAbstractSelect class >> isAbstract [
	^ self = FDAbstractSelect
]

{ #category : #applying }
FDAbstractSelect >> applyOn: aCollectionOfFileReference [
	^ aCollectionOfFileReference select: [:eachFileReference | self predicate: eachFileReference   ]
]

{ #category : #comparing }
FDAbstractSelect >> equals: aPredicate [
	^ self className = aPredicate className
]

{ #category : #accessing }
FDAbstractSelect >> name [
	^ self subclassResponsibility 
]

{ #category : #accessing }
FDAbstractSelect >> predicate: aFileReference [
	^ self subclassResponsibility 
]
