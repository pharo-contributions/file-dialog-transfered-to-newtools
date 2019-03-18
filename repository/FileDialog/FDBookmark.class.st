"
I represent a bookmark having location, icon, and a name.
"
Class {
	#name : #FDBookmark,
	#superclass : #Object,
	#instVars : [
		'location',
		'name',
		'icon'
	],
	#category : 'FileDialog'
}

{ #category : #'default bookmarks' }
FDBookmark class >> home [
	^ FDBookmark
		name: 'home'
		location: FileLocator home asFileReference
		icon: Smalltalk ui icons home
]

{ #category : #'default bookmarks' }
FDBookmark class >> image [
	^ FDBookmark
		name: 'image directory'
		location: FileLocator imageDirectory asFileReference
		icon: Smalltalk ui icons komitterNewSlice
]

{ #category : #'instance creation' }
FDBookmark class >> name: aName location: aLocation icon: anIcon [
	^ self new
		name: aName;
		location: aLocation;
		icon: anIcon;
		yourself
]

{ #category : #'default bookmarks' }
FDBookmark class >> root [
	^ FDBookmark
		name: 'file system'
		location: FileLocator root asFileReference
		icon: Smalltalk ui icons smallWindow
]

{ #category : #'default bookmarks' }
FDBookmark class >> tmp [
	^ FDBookmark
		name: 'tmp'
		location: FileLocator temp asFileReference
		icon: Smalltalk ui icons open
]

{ #category : #'default bookmarks' }
FDBookmark class >> windowsDrives [
	^ FileLocator root asFileReference directories
		collect:
			[ :each | FDBookmark name: each basename location: each icon: Smalltalk ui icons smallWindow ]
]

{ #category : #comparing }
FDBookmark >> = aBookmark [
	self species = aBookmark species
		ifFalse: [ ^ false ].
	^ self icon = aBookmark icon & (self location = aBookmark location)
		& (self name = aBookmark name)
]

{ #category : #comparing }
FDBookmark >> hash [
	^ (self icon hash bitXor: self location hash) bitXor: self name hash
]

{ #category : #accessing }
FDBookmark >> icon [
	^ icon
]

{ #category : #accessing }
FDBookmark >> icon: anIcon [
	icon := anIcon
]

{ #category : #accessing }
FDBookmark >> location [
	^ location
]

{ #category : #accessing }
FDBookmark >> location: aFileReference [
	location := aFileReference
]

{ #category : #accessing }
FDBookmark >> name [
	^ name
]

{ #category : #accessing }
FDBookmark >> name: aString [
	name := aString
]

{ #category : #printing }
FDBookmark >> printOn: aStream [
	super printOn: aStream.
	aStream
		<< '(''';
		<< name;
		<< '''->''';
		<< location fullName;
		<< ''')'
]
