"
An EdgeMorphTest is a test class for testing the behavior of EdgeMorph
"
Class {
	#name : #DefartCondMorphTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartCondMorphTest >> newCond [

	^ DefartCondMorph new
]

{ #category : #private }
DefartCondMorphTest >> newEdge [

	^ DefartEdgeMorph new
]

{ #category : #private }
DefartCondMorphTest >> newEditor [

	^ ScratchScriptsMorph new
]

{ #category : #private }
DefartCondMorphTest >> newNode [

	^ DefartNodeMorph new
]

{ #category : #private }
DefartCondMorphTest >> newScript [

	^ DefartScript new
		  project: DefartProject new;
		  setupBlockSpecs;
		  yourself
]

{ #category : #test }
DefartCondMorphTest >> testAttachToEdge [

	| cond edge editor |
	cond := self newCond.
	cond receiver: self newScript.
	cond commandSpec: '%E'.
	self assert: cond id equals: 0.
	edge := self newEdge.
	edge id: 123.
	editor := self newEditor.
	editor
		addMorph: cond;
		addMorph: edge.
	cond attachToEdge: edge.
	self assert: edge condMorph identicalTo: cond.
	self assert: cond id equals: 123
]

{ #category : #test }
DefartCondMorphTest >> testClearMyself [

	| cond1 cond2 morph edge1 edge2 |
	cond1 := self newCond.
	cond2 := self newCond.
	edge1 := self newEdge.
	edge2 := self newEdge.
	morph := self newEditor.
	morph
		addMorph: cond1;
		addMorph: cond2;
		addMorph: edge1;
		addMorph: edge2.
	edge1 condMorph: cond1.
	edge2 condMorph: cond2.
	self deny: edge1 condMorph isNil.
	self deny: edge2 condMorph isNil.
	cond1 clearMyself.
	self assert: edge1 condMorph isNil.
	self deny: edge2 condMorph isNil.
	cond2 clearMyself.
	self assert: edge1 condMorph isNil.
	self assert: edge2 condMorph isNil
]

{ #category : #test }
DefartCondMorphTest >> testCommandSpec [

	| morph |
	morph := self newCond.
	self assert: morph commandSpec isEmpty.
	morph commandSpec: 'abc'.
	self assert: morph commandSpec equals: 'abc'
]

{ #category : #test }
DefartCondMorphTest >> testDefaultArgs [

	self newCond defaultArgs: #().
	self newCond defaultArgs: #(a b c)
]

{ #category : #test }
DefartCondMorphTest >> testEdgeIdArg [

	| cond r |
	cond := self newCond.
	self should: [ cond edgeIdArg ] raise: Error.
	cond receiver: self newScript.
	cond commandSpec: '%E'.
	r := cond edgeIdArg.
	self assert: (r isKindOf: DefartEdgeIdArgMorph)
]

{ #category : #test }
DefartCondMorphTest >> testEdgeMorph [

	| cond edge script |
	cond := self newCond.
	self assert: cond edgeMorph isNil.
	edge := self newEdge.
	edge condMorph: cond.
	self assert: cond edgeMorph isNil.
	script := self newEditor.
	script
		addMorph: cond;
		addMorph: edge.
	self assert: cond edgeMorph identicalTo: edge
]

{ #category : #test }
DefartCondMorphTest >> testId [

	| cond edge morph |
	cond := self newCond.
	cond receiver: self newScript.
	cond commandSpec: '%E'.
	self assert: cond id equals: 0.
	edge := self newEdge.
	edge condMorph: cond.
	edge id: 123.
	self assert: cond id equals: 0.
	morph := self newEditor.
	morph
		addMorph: cond;
		addMorph: edge.
	self assert: cond id equals: 123
]

{ #category : #test }
DefartCondMorphTest >> testIsForever [

	self assert: self newCond isForever
]

{ #category : #test }
DefartCondMorphTest >> testNextBlock [

	self assert: self newCond nextBlock isNil
]
