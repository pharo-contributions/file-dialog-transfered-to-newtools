"
I'm an abstract 

my subclasses have to define:

* columnTitle 
	returning a String 

* evaluateOn:aFileReference r
	return something in function of it's superClass 
	example 
		in FDBasenameFileReferenceColumn my subclass is FDAbstractStringTableColumn 
			so it will creat a SpStringTablePresenter so i have to return a String 
				here I'm asking to the fileReference is basename	
"
Class {
	#name : #FDAbstractFileReferenceColumn,
	#superclass : #Object,
	#category : #'FileDialog-FileTreeStrategie'
}

{ #category : #accessing }
FDAbstractFileReferenceColumn class >> column [
	"I'm returning a SpTreeTableColumn"

	^ self tableColumnClass
		title: self columnTitle
		evaluated: self columnEvaluated
]

{ #category : #templateMethod }
FDAbstractFileReferenceColumn class >> columnEvaluated [
	^ [:selectedFileReference | self evaluateOn: selectedFileReference   ]
]

{ #category : #templateMethod }
FDAbstractFileReferenceColumn class >> columnTitle [
	"I'm returning a String"
	^ self subclassResponsibility
]

{ #category : #templateMethod }
FDAbstractFileReferenceColumn class >> evaluateOn: aFileReference [ 
	^ self subclassResponsibility
]

{ #category : #testing }
FDAbstractFileReferenceColumn class >> isAbstract [ 
	^ self = FDAbstractFileReferenceColumn
]

{ #category : #class }
FDAbstractFileReferenceColumn class >> tableColumnClass [
	"I'm returning a son of SpTreeTableColumn"
	^ self subclassResponsibility 
]
