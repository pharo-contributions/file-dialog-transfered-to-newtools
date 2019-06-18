Class {
	#name : #FDAbstractFilter,
	#superclass : #Object,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'FileDialog-filterStrategie'
}

{ #category : #actions }
FDAbstractFilter class >> actions [
	| filterCollection |
	filterCollection := {}.
	self allSubclasses
		do: [ :class |filterCollection := filterCollection | class actions ].
	^ filterCollection
]

{ #category : #testing }
FDAbstractFilter class >> isAbstract [
	^ self = FDAbstractFilter
]

{ #category : #accessing }
FDAbstractFilter >> filter: aFileReference [
	^ self subclassResponsibility 
]

{ #category : #accessing }
FDAbstractFilter >> name [
	^ self subclassResponsibility 
]
