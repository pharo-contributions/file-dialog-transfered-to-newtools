"
i'm an abstract class use by the filter system of FDFileDialog

my subclass define:

	predicat: aFileReference
		return a boolean 
	name 
		return String 
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

{ #category : #accessing }
FDAbstractPredicate >> name [
	^ self subclassResponsibility 
]

{ #category : #accessing }
FDAbstractPredicate >> predicate: aFileReference [
	^ self subclassResponsibility 
]
