"
i'm an abstract class to define a interface for a preview system 

my subclass have to define :

* canBeUseOn: aFileReference 
	return a Boolean if it can be use on  'aFileReference'
	
* previewOn: aFileReference 
	return a Presenter (son of SpPresenter)  
"
Class {
	#name : #FDAbstractPreviewer,
	#superclass : #Object,
	#instVars : [
		'predicateFunction'
	],
	#category : #'FileDialog-previewerStrategie'
}

{ #category : #testing }
FDAbstractPreviewer class >> isAbstract [
	^ self = FDAbstractPreviewer
]

{ #category : #testing }
FDAbstractPreviewer >> canBeUsedOn: aFileReference [
		^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
FDAbstractPreviewer >> previewOn: aFileReference [
	^ self subclassResponsibility 
]
