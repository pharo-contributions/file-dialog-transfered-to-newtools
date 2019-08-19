Class {
	#name : #FDWindowPathUITest,
	#superclass : #TestCase,
	#instVars : [
		'windowPathUI'
	],
	#category : #'FileDialog-UI'
}

{ #category : #running }
FDWindowPathUITest >> setUp [
	windowPathUI := FDWindowPathUI new.
]

{ #category : #tests }
FDWindowPathUITest >> testRoot [
	windowPathUI currentDirectory: FileLocator root.
	windowPathUI openWithSpec.
	self assert: windowPathUI pathButtons items size equals: 1
]

{ #category : #tests }
FDWindowPathUITest >> testSimplePath [
	| newFile |
	[ newFile := (FileLocator root / 'directoryUseForTestMustBeRemove')
		asFileReference ensureCreateDirectory.
	windowPathUI currentDirectory: newFile.
	self assert: windowPathUI pathButtons items size equals: 2 ]
		ensure: [ newFile delete ]
]
