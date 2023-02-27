"
A DefartNodeNameArgMorphTest is a test class for testing the behavior of DefartNodeNameArgMorph
"
Class {
	#name : #DefartNodeNameArgMorphTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartNodeNameArgMorphTest >> newArg [

	^ DefartNodeNameArgMorph new
]

{ #category : #test }
DefartNodeNameArgMorphTest >> testNodeName [

	| arg |
	arg := self newArg.
	self assert: arg nodeName isEmpty.
	arg nodeName: 'abc'.
	self assert: arg nodeName equals: 'abc'
]
