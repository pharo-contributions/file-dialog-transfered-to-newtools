"
i'm an abstract class use by the filter system of FDFileDialog


my subclass define:

	predicat: aFileReference
		return a boolean 
	name 
		return String 
		
this architecture is composed of 2 class 

	FDAbstractSimplePredicate
		it's compose of lightest predicate 
	FDAbstractCompositePredicate
		it's compose of predicate compose of FAbstractPredicate
"
Class {
	#name : #FDAbstractPredicate,
	#superclass : #Object,
	#category : #'FileDialog-filterStrategie'
}
