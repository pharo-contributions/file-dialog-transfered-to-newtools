Class {
	#name : #FDFileFilter,
	#superclass : #FDAbstractSimpleFilter,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDFileFilter >> filter: aFileReference [
	^ aFileReference isFile
	
]

{ #category : #accessing }
FDFileFilter >> name [
	^ 'file filter'
]
