"
A DefartEdgeIdArgMorphTest is a test class for testing the behavior of DefartEdgeIdArgMorph
"
Class {
	#name : #DefartEdgeIdArgMorphTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartEdgeIdArgMorphTest >> newArg [

	^ DefartEdgeIdArgMorph new
]

{ #category : #private }
DefartEdgeIdArgMorphTest >> newCond [

	^ DefartCondMorph new
]

{ #category : #'instance creation' }
DefartEdgeIdArgMorphTest >> newEdge [

	^ DefartEdgeMorph new
]

{ #category : #'instance creation' }
DefartEdgeIdArgMorphTest >> newEditor [

	^ ScratchScriptsMorph new
]

{ #category : #private }
DefartEdgeIdArgMorphTest >> newScript [

	^ DefartScript new
		  project: DefartProject new;
		  setupBlockSpecs;
		  yourself
]

{ #category : #test }
DefartEdgeIdArgMorphTest >> testEvaluate [

	self testId
]

{ #category : #test }
DefartEdgeIdArgMorphTest >> testId [

	| arg cond edge editor |
	cond := self newCond.
	cond receiver: self newScript.
	cond commandSpec: '%E'.
	edge := self newEdge.
	edge condMorph: cond.
	editor := self newEditor.
	editor
		addMorph: cond;
		addMorph: edge.
	arg := cond edgeIdArg.
	self assert: arg id equals: 0.
	edge id: 123.
	self assert: arg id equals: 123
]

{ #category : #test }
DefartEdgeIdArgMorphTest >> testInitialize [

	| arg |
	arg := self newArg.
	self assert: arg id equals: 0
]
