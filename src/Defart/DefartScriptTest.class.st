"
A DefartScriptTest is a test class for testing the behavior of DefartScript
"
Class {
	#name : #DefartScriptTest,
	#superclass : #TestCase,
	#category : #'Defart-Tests'
}

{ #category : #private }
DefartScriptTest >> newEdge [

	^ DefartEdgeMorph new
]

{ #category : #private }
DefartScriptTest >> newNode [

	^ DefartNodeMorph new
		  commandSpec: 'node %N %h';
		  yourself
]

{ #category : #private }
DefartScriptTest >> newNode: aScript [

	^ DefartNodeMorph new
		  receiver: aScript;
		  commandSpec: 'node %N %h';
		  yourself
]

{ #category : #private }
DefartScriptTest >> newScript [

	^ DefartScript new
		  project: DefartProject new;
		  setupBlockSpecs;
		  yourself
]

{ #category : #test }
DefartScriptTest >> testAssignIds [

	| script n1 n2 n3 e1 e2 |
	script := self newScript.
	n1 := self newNode: script.
	n2 := self newNode: script.
	n3 := self newNode: script.
	e1 := self newEdge.
	e2 := self newEdge.
	e1 fromNode: n1.
	e1 toNode: n2.
	e2 fromNode: n1.
	e2 toNode: n3.
	self assert: n1 id equals: 0.
	self assert: n2 id equals: 0.
	self assert: n3 id equals: 0.
	self assert: e1 id equals: 0.
	self assert: e2 id equals: 0.
	script blocksBin
		addMorphBack: n1;
		addMorphBack: n2;
		addMorphBack: n3;
		addMorphBack: e1;
		addMorphBack: e2.
	script assignIds.
	self assert: n1 id equals: 1.
	self assert: n2 id equals: 2.
	self assert: n3 id equals: 3.
	self assert: e1 id equals: 4.
	self assert: e2 id equals: 5
]

{ #category : #test }
DefartScriptTest >> testAssignIds2 [

	| script n1 n2 n3 e1 e2 |
	script := self newScript.
	n1 := self newNode: script.
	n2 := self newNode: script.
	n3 := self newNode: script.
	e1 := self newEdge.
	e2 := self newEdge.
	e1 fromNode: n1.
	e1 toNode: n2.
	e2 fromNode: n1.
	e2 toNode: n3.
	n1 id: 1.
	n2 id: 6.
	n3 id: 2.
	e1 id: 2.
	e2 id: 3.
	script blocksBin
		addMorphBack: n1;
		addMorphBack: n2;
		addMorphBack: n3;
		addMorphBack: e1;
		addMorphBack: e2.
	script assignIds.
	self assert: n1 id equals: 1.
	self assert: n2 id equals: 5.
	self assert: n3 id equals: 2.
	self assert: e1 id equals: 4.
	self assert: e2 id equals: 3
]

{ #category : #test }
DefartScriptTest >> testVarNames [

	| script a |
	script := self newScript.
	self assert: script varNames isCollection.
	self assert: script varNames isEmpty.
	a := #( a b c ).
	script varNames: a.
	self assert: script varNames identicalTo: a
]
