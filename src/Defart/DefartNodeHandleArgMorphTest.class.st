"
A DefartNodeHandleArgMorphTest is a test class for testing the behavior of DefartNodeHandleArgMorph
"
Class {
	#name : #DefartNodeHandleArgMorphTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartNodeHandleArgMorphTest >> newArg [

	^ DefartNodeHandleArgMorph new
]

{ #category : #private }
DefartNodeHandleArgMorphTest >> newNode [

	^ DefartNodeMorph new
]

{ #category : #test }
DefartNodeHandleArgMorphTest >> testEvaluate [

	self testId
]

{ #category : #test }
DefartNodeHandleArgMorphTest >> testId [

	| arg |
	arg := self newArg.
	self assert: arg id equals: 0.
	arg id: 123.
	self assert: arg id equals: 123
]

{ #category : #test }
DefartNodeHandleArgMorphTest >> testInitialize [

	| arg |
	arg := self newArg.
	self assert: arg id equals: 0
]

{ #category : #test }
DefartNodeHandleArgMorphTest >> testScriptEditorIfNil [

	| arg node morph |
	arg := self newArg.
	node := self newNode.
	node addMorph: arg.
	self assert: (arg scriptEditorIfNil: [ nil ]) isNil.
	morph := ScratchScriptsMorph new.
	morph addMorph: node.
	self assert: (arg scriptEditorIfNil: [ nil ]) identicalTo: morph
]
