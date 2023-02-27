"
A DefartLineMorphTest is a test class for testing the behavior of DefartLineMorph
"
Class {
	#name : #DefartEdgeMorphTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartEdgeMorphTest >> newEdge [

	^ DefartEdgeMorph new
]

{ #category : #private }
DefartEdgeMorphTest >> newNode [

	^ DefartNodeMorph new
]

{ #category : #private }
DefartEdgeMorphTest >> newScript [

	^ DefartScript new
		  project: DefartProject new;
		  setupBlockSpecs;
		  yourself
]

{ #category : #test }
DefartEdgeMorphTest >> testAsBlockTuple [

	| edge r node1 node2 morph |
	edge := self newEdge.
	r := edge asBlockTuple.
	self assert: r isArray.
	self assert: r first equals: #edge:priority:from:to:.
	self assert: r second equals: 0.
	self assert: r third equals: 0.
	self assert: r fourth equals: 0.
	self assert: r fifth equals: 0.
	edge
		id: 9;
		priority: 10.
	morph := self newScript.
	node1 := self newNode
		         receiver: morph;
		         commandSpec: 'node %N %h';
		         id: 123;
		         yourself.
	node2 := self newNode
		         receiver: morph;
		         commandSpec: 'node %N %h';
		         id: 456;
		         yourself.
	morph blocksBin
		addMorph: node1;
		addMorph: node2;
		addMorph: edge.
	edge
		receiver: morph;
		fromNode: node1;
		toNode: node2.
	r := edge asBlockTuple.
	self assert: r isArray.
	self assert: r first equals: #edge:priority:from:to:.
	self assert: r second equals: 9.
	self assert: r third equals: 10.
	self assert: r fourth equals: 123.
	self assert: r fifth equals: 456
]

{ #category : #test }
DefartEdgeMorphTest >> testCondMorph [

	| edge m |
	edge := self newEdge.
	self assert: edge condMorph isNil.
	m := Morph new.
	edge condMorph: m.
	self assert: edge condMorph identicalTo: m
]

{ #category : #test }
DefartEdgeMorphTest >> testEdgeColor [

	self assert: self newEdge edgeColor isColor
]

{ #category : #test }
DefartEdgeMorphTest >> testFromNode [

	| morph n |
	morph := self newEdge.
	self assert: morph fromNode isNil.
	n := self newNode.
	morph fromNode: n.
	self assert: morph fromNode identicalTo: n
]

{ #category : #test }
DefartEdgeMorphTest >> testId [

	| obj |
	obj := self newEdge.
	self assert: obj id equals: 0.
	obj id: 123.
	self assert: obj id equals: 123.
	obj id: 456.
	self assert: obj id equals: 456
]

{ #category : #test }
DefartEdgeMorphTest >> testIsEdgeMorph [

	self assert: self newEdge isEdgeMorph
]

{ #category : #test }
DefartEdgeMorphTest >> testIsHatBlock [

	self deny: self newEdge isHatBlock
]

{ #category : #test }
DefartEdgeMorphTest >> testIsInBlockPalette [

	self deny: self newEdge isInBlockPalette
]

{ #category : #test }
DefartEdgeMorphTest >> testLastHandleMorph [

	| edge r |
	edge := self newEdge.
	r := edge lastHandleMorph.
	self assert: r isMorph
]

{ #category : #test }
DefartEdgeMorphTest >> testNodes [

	| morph r |
	morph := self newEdge.
	r := morph nodes.
	self assert: r isArray.
	self assert: r size equals: 2.
	self assert: r first isNil.
	self assert: r second isNil
]

{ #category : #test }
DefartEdgeMorphTest >> testPriority [

	| obj |
	obj := self newEdge.
	self assert: obj priority equals: 0.
	obj priority: 123.
	self assert: obj priority equals: 123.
	obj priority: 456.
	self assert: obj priority equals: 456
]

{ #category : #test }
DefartEdgeMorphTest >> testPriorityMorph [

	| edge morph |
	edge := self newEdge.
	self assert: edge priorityMorph isMorph.
	morph := Morph new.
	edge priorityMorph: morph.
	self assert: edge priorityMorph identicalTo: morph
]

{ #category : #test }
DefartEdgeMorphTest >> testReceiver [

	| edge script |
	edge := self newEdge.
	self assert: edge receiver isNil.
	script := self newScript.
	edge receiver: script.
	self assert: edge receiver identicalTo: script
]

{ #category : #test }
DefartEdgeMorphTest >> testSetup [

	| edge |
	edge := self newEdge.
	self assert: edge id equals: 0.
	self assert: edge nodes isArray.
	self assert: edge nodes size equals: 2
]

{ #category : #test }
DefartEdgeMorphTest >> testToNode [

	| morph n |
	morph := self newEdge.
	self assert: morph toNode isNil.
	n := self newNode.
	morph toNode: n.
	self assert: morph toNode identicalTo: n
]
