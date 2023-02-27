"
A NodeMorphTest is a test class for testing the behavior of NodeMorph
"
Class {
	#name : #DefartNodeMorphTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartNodeMorphTest >> newEdge [

	^ DefartEdgeMorph new
]

{ #category : #private }
DefartNodeMorphTest >> newNode [

	^ DefartNodeMorph new
]

{ #category : #test }
DefartNodeMorphTest >> testClearMyself [

	| node1 node2 morph edge |
	node1 := self newNode.
	node2 := self newNode.
	edge := self newEdge.
	morph := ScratchScriptsMorph new.
	morph
		addMorph: node1;
		addMorph: node2;
		addMorph: edge.
	edge fromNode: node1.
	edge toNode: node2.
	self deny: edge fromNode isNil.
	self deny: edge toNode isNil.
	node1 clearMyself.
	self assert: edge fromNode isNil.
	self deny: edge toNode isNil.
	node2 clearMyself.
	self assert: edge fromNode isNil.
	self assert: edge toNode isNil
]

{ #category : #test }
DefartNodeMorphTest >> testIsNodeMorph [

	self assert: self newNode isNodeMorph
]
