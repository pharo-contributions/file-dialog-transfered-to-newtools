"
I'm selecting file
"
Class {
	#name : #FDIsFileSelect,
	#superclass : #FDAbstractSimpleSelect,
	#category : #'FileDialog-filterStrategie'
}

{ #category : #accessing }
FDIsFileSelect >> name [
	^ 'file filter'
]

{ #category : #accessing }
FDIsFileSelect >> predicate: aFileReference [
	^ aFileReference isFile
	
]
