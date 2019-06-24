Class {
	#name : #FDAbstractBookMark,
	#superclass : #Object,
	#instVars : [
		'name',
		'icon'
	],
	#category : #FileDialog
}

{ #category : #accessing }
FDAbstractBookMark >> icon [
	^ self subclassResponsibility 
]

{ #category : #testing }
FDAbstractBookMark >> isComposite [
	^ self subclassResponsibility.
]

{ #category : #accessing }
FDAbstractBookMark >> name [
	^ self subclassResponsibility
]
