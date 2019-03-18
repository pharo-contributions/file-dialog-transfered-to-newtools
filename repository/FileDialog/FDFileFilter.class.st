"
I help the file dialog with some file filtering (e.g. selecting only files matching an extension, etc.)
"
Class {
	#name : #FDFileFilter,
	#superclass : #Object,
	#category : 'FileDialog'
}

{ #category : #filters }
FDFileFilter >> directoriesOnly: aCollection [
	^ aCollection select: #isDirectory
]

{ #category : #filtering }
FDFileFilter >> files: aCollection matching: patterns [
	^ aCollection select: [ :each | each isDirectory or: [ patterns anySatisfy: [ :pat | pat match: each basename ] ] ]
]

{ #category : #filters }
FDFileFilter >> files: aCollection withExtensions: extensions [
	^ aCollection reject: [ :each | each isFile & (extensions includes: each extension) not ]
]

{ #category : #filters }
FDFileFilter >> noHiddenFiles: aCollection [
	^ aCollection reject: [ :each | (each basename beginsWith: '.') and: [ (each basename = '..') not ] ]
]
