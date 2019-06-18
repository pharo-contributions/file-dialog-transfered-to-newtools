Class {
	#name : #FDDefaultFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDDefaultFilter >> filter: aFileReference [
	^ true
]

{ #category : #accessing }
FDDefaultFilter >> name [
	^ 'no filter'
]
