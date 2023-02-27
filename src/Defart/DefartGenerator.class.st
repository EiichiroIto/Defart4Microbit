Class {
	#name : #DefartGenerator,
	#superclass : #MicrobitGenerator,
	#category : #'Defart-Process'
}

{ #category : #private }
DefartGenerator >> dictionaryFromEdgeMorphs: aCollection [

	| dict |
	dict := Dictionary new.
	aCollection do: [ :each | 
		| entry |
		entry := dict
			         at: each fromNode
			         ifAbsentPut: [ OrderedCollection new ].
		entry add: each ].
	dict do: [ :each | each sort: [ :a :b | a priority < b priority ] ].
	^ dict
]

{ #category : #'code generation' }
DefartGenerator >> generateCond: aMorph [

	| expr |
	expr := parser reporterArgString: aMorph reporterMorph.
	self appendWithNewline: 'if ' , expr , ':'
]

{ #category : #'code generation' }
DefartGenerator >> generateIfStatement: anInteger [

	self appendWithNewline: 'if state == ' , anInteger asString , ':'
]

{ #category : #'code generation' }
DefartGenerator >> generateMainStartingAt: anInteger [

	self indent: 0.
	self appendWithNewline: 'state=' , anInteger asString.
	self appendWithNewline: 'while True:'.
	self indent: 1.
	self appendWithNewline: 'next_state = transition()'.
	self appendWithNewline: 'if not(next_state is None):'.
	self indent: 2.
	self appendWithNewline: 'state = next_state'.
	self appendWithNewline: 'eval(''state'' + str(state) + ''()'')'.
	self appendWithNewline: 'print(state)'.
	self indent: 0
]

{ #category : #'code generation' }
DefartGenerator >> generateNodeBegin: aMorph [

	self generateSubHeader: 'state' , aMorph id asString
]

{ #category : #'code generation' }
DefartGenerator >> generateNodeEnd: aMorph [

	"do nothing"
]

{ #category : #'code generation' }
DefartGenerator >> generateReturnStatement: anInteger [

	self appendWithNewline: 'return ' , anInteger asString
]

{ #category : #'code generation' }
DefartGenerator >> generateStates: aCollection [

	aCollection do: [ :each | parser parseBlock: each ]
]

{ #category : #'code generation' }
DefartGenerator >> generateTransitions: aCollection [

	| dict |
	dict := self dictionaryFromEdgeMorphs: aCollection.
	self indent: 0.
	self appendWithNewline: 'def transition():'.
	self indent: 1.
	dict keysAndValuesDo: [ :node :edges | 
		self generateTransitonFrom: node to: edges ]
]

{ #category : #'code generation' }
DefartGenerator >> generateTransitonFrom: aNode to: aCollection [

	self indent: 1.
	self generateIfStatement: aNode id.
	aCollection do: [ :each | 
		self indent: 2.
		each condMorph ifNotNil: [ :cond | 
			self generateCond: cond.
			self indent: 3 ].
		self generateReturnStatement: each toNode id ]
]

{ #category : #parsing }
DefartGenerator >> parseHats: aCollection [

	| code |
	aCollection do: [ :each | each parseUsing: parser ].
	code := self code.
	^ self header , code
]

{ #category : #parsing }
DefartGenerator >> parseScript: aScript [

	| code |
	self generateStates: aScript nodeMorphs.
	self generateTransitions: aScript connectedEdgeMorphs.
	self generateMainStartingAt: aScript startNodeMorph id.
	code := self code.
	^ self header , code
]
