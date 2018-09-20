Class {
	#name : #FDTest,
	#superclass : #TestCase,
	#instVars : [
		'filter',
		'root'
	],
	#category : 'FileDialog-Tests'
}

{ #category : #'instance creation' }
FDTest >> createRoot [
	(root := (FileLocator imageDirectory / 'fd-test') asFileReference) ensureCreateDirectory.
	(root / 'dir') ensureCreateDirectory.
	(root / 'dir.ext') ensureCreateDirectory.
	(root / '.hidden-dir') ensureCreateDirectory.
	(root / '.hidden') ensureCreateFile.
	(root / 'sth.ext') ensureCreateFile.
	(root / 'sth.aaa') ensureCreateFile.
	^ root
]

{ #category : #'instance creation' }
FDTest >> inspectRoot [
	<script: 'self basicNew createRoot asFileReference inspect'>
	
]

{ #category : #running }
FDTest >> setUp [
	filter := FDFileFilter new.
	self createRoot
]
