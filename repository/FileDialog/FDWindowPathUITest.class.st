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
