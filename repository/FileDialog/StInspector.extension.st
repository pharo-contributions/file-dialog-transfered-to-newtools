Extension { #name : #StInspector }

{ #category : #'*FileDialog' }
StInspector class >> instanciateOn: anObject [
	^ self on: (StInspectorModel on: anObject)
]
