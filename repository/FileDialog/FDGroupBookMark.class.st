Class {
	#name : #FDGroupBookMark,
	#superclass : #FDAbstractBookMark,
	#instVars : [
		'collection'
	],
	#category : #FileDialog
}

{ #category : #'as yet unclassified' }
FDGroupBookMark class >> CreatWithname: aName WithContent: aCollection withIconName: icon [
	^ self new
		name: aName;
		collection: aCollection;
		iconNamed: icon;
		yourself
]

{ #category : #accessing }
FDGroupBookMark >> collection [
	^ collection
]

{ #category : #accessing }
FDGroupBookMark >> collection: anObject [
	collection := anObject
]

{ #category : #accessing }
FDGroupBookMark >> icon [
	^ icon
]

{ #category : #accessing }
FDGroupBookMark >> icon: anObject [
	icon := anObject
]

{ #category : #testing }
FDGroupBookMark >> isComposite [
	^ true
]

{ #category : #accessing }
FDGroupBookMark >> name [
	^ name
]

{ #category : #accessing }
FDGroupBookMark >> name: anObject [
	name := anObject
]
