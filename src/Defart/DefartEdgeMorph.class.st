Class {
	#name : #DefartEdgeMorph,
	#superclass : #PolygonMorph,
	#traits : 'TGraphObject',
	#classTraits : 'TGraphObject classTrait',
	#instVars : [
		'nodes',
		'condMorph',
		'id',
		'priorityMorph',
		'receiver'
	],
	#category : #'Defart-Blocks'
}

{ #category : #'instance creation' }
DefartEdgeMorph class >> new [

	^ super new
		  setup;
		  yourself
]

{ #category : #converting }
DefartEdgeMorph >> asBlockTuple [

	^ { 
		  #edge:priority:from:to:.
		  (id ifNil: [ 0 ]).
		  (self priority ifNil: [ 0 ]).
		  (self fromNode ifNil: [ 0 ] ifNotNil: [ :node | node id ]).
		  (self toNode ifNil: [ 0 ] ifNotNil: [ :node | node id ]) }
]

{ #category : #testing }
DefartEdgeMorph >> checkEdgeIndex: anInteger node: aNode [

	self isConnected ifFalse: [ ^ false ].
	^ anInteger = 1
		  ifTrue: [ aNode hasEdgeTo: nodes second ]
		  ifFalse: [ nodes first hasEdgeTo: aNode ]
]

{ #category : #'event handling' }
DefartEdgeMorph >> click: evt [

	self toggleHandles
]

{ #category : #accessing }
DefartEdgeMorph >> condMorph [

	^ condMorph
]

{ #category : #accessing }
DefartEdgeMorph >> condMorph: anObject [

	condMorph := anObject
]

{ #category : #'event handling' }
DefartEdgeMorph >> dragVertex: ix event: evt fromHandle: handle [

	nodes at: ix put: nil.
	super dragVertex: ix event: evt fromHandle: handle
]

{ #category : #'event handling' }
DefartEdgeMorph >> dropVertex: ix event: evt fromHandle: handle [

	| node edges oppositeNode |
	owner ifNil: [ ^ self ].
	node := owner
		        submorphThat: [ :each | 
		        each isNodeMorph and: [ each containsPoint: handle center ] ]
		        ifNone: [ nil ].
	node ifNil: [ ^ self ].
	self removeHandles.
	(self checkEdgeIndex: ix node: node) ifTrue: [ ^ self delete ].
	nodes at: ix put: node.
	oppositeNode := nodes at: 3 - ix.
	oppositeNode ifNil: [ ^ self ].
	edges := receiver edgeMorphsConnectingWith: node and: oppositeNode.
	edges size > 1 ifTrue: [ 
		edges do: [ :each | each updatePositionDelta: 10 ] ]
]

{ #category : #private }
DefartEdgeMorph >> edgeColor [

	^ Color h: 41 s: 0.85 v: 0.9
]

{ #category : #accessing }
DefartEdgeMorph >> fromNode [

	^ nodes first
]

{ #category : #accessing }
DefartEdgeMorph >> fromNode: aNodeMorph [

	nodes at: 1 put: aNodeMorph
]

{ #category : #'event handling' }
DefartEdgeMorph >> handlesMouseDown: evt [

	^ true
]

{ #category : #'event handling' }
DefartEdgeMorph >> handlesMouseOverDragging: evt [

	^ true
]

{ #category : #accessing }
DefartEdgeMorph >> id [

	^ id
]

{ #category : #accessing }
DefartEdgeMorph >> id: anObject [

	id := anObject
]

{ #category : #testing }
DefartEdgeMorph >> isConnected [

	^ nodes allSatisfy: #notNil
]

{ #category : #testing }
DefartEdgeMorph >> isConnectingWith: aNode and: anotherNode [

	(self fromNode = aNode and: [ self toNode = anotherNode ]) ifTrue: [ 
		^ true ].
	(self fromNode = anotherNode and: [ self toNode = aNode ]) ifTrue: [ 
		^ true ].
	^ false
]

{ #category : #testing }
DefartEdgeMorph >> isEdgeMorph [

	^ true
]

{ #category : #testing }
DefartEdgeMorph >> isHatBlock [

	^ false
]

{ #category : #testing }
DefartEdgeMorph >> isInBlockPalette [

	^ false
]

{ #category : #accessing }
DefartEdgeMorph >> lastHandleMorph [

	handles ifNil: [ self addHandles ].
	^ handles last
]

{ #category : #'event handling' }
DefartEdgeMorph >> mouseDown: evt [

	evt hand newKeyboardFocus: nil.
	evt yellowButtonPressed ifTrue: [ ^ self rightButtonMenu: evt ].
	evt hand waitForClicksOrDrag: self event: evt
]

{ #category : #'event handling' }
DefartEdgeMorph >> mouseEnterDragging: evt [

	self borderColor: Color white
]

{ #category : #'event handling' }
DefartEdgeMorph >> mouseLeaveDragging: evt [

	self borderColor: self edgeColor
]

{ #category : #accessing }
DefartEdgeMorph >> nodes [

	^ nodes
]

{ #category : #accessing }
DefartEdgeMorph >> nodes: anObject [

	nodes := anObject
]

{ #category : #accessing }
DefartEdgeMorph >> priority [

	^ priorityMorph contents asNumberNoError
]

{ #category : #accessing }
DefartEdgeMorph >> priority: anObject [

	priorityMorph contents: anObject asString
]

{ #category : #accessing }
DefartEdgeMorph >> priorityMorph [

	^ priorityMorph
]

{ #category : #accessing }
DefartEdgeMorph >> priorityMorph: anObject [

	priorityMorph := anObject
]

{ #category : #accessing }
DefartEdgeMorph >> project [

	^ receiver project
]

{ #category : #accessing }
DefartEdgeMorph >> receiver [

	^ receiver
]

{ #category : #accessing }
DefartEdgeMorph >> receiver: anObject [

	receiver := anObject
]

{ #category : #private }
DefartEdgeMorph >> rightButtonMenu: anEvent [

	self project ifNotNil: [ :p | p application showEdgeMenu: self event: anEvent ]
]

{ #category : #initialization }
DefartEdgeMorph >> setup [

	nodes := Array new: 2.
	id := 0.
	self
		vertices: { 
				(0 @ 0).
				(50 @ 50) }
		color: Color black
		borderWidth: 2
		borderColor: self edgeColor.
	self makeForwardArrow.
	priorityMorph := StringMorph new
		                 font: ScratchTranslator argFont;
		                 color: Color white.
	self addMorph: priorityMorph.
	self priority: 0
]

{ #category : #stepping }
DefartEdgeMorph >> step [

	"self updatePosition"
]

{ #category : #processes }
DefartEdgeMorph >> stopProcess [

	"do nothing"
]

{ #category : #accessing }
DefartEdgeMorph >> toNode [

	^ nodes second
]

{ #category : #accessing }
DefartEdgeMorph >> toNode: aNodeMorph [

	nodes at: 2 put: aNodeMorph
]

{ #category : #'block enumerating' }
DefartEdgeMorph >> tupleSequence [

	^ { self asBlockTuple }
]

{ #category : #api }
DefartEdgeMorph >> updatePosition [

	self updatePositionDelta: 0
]

{ #category : #api }
DefartEdgeMorph >> updatePositionDelta: anInteger [

	| node1 node2 pos1 pos2 delta |
	node1 := self fromNode.
	node2 := self toNode.
	(node1 isNil and: [ node2 isNil ]) ifTrue: [ ^ self ].
	pos1 := node1
		        ifNotNil: [ :node | node center ]
		        ifNil: [ vertices first ].
	pos2 := node2
		        ifNotNil: [ :node | node center ]
		        ifNil: [ vertices second ].
	node1 ifNotNil: [ pos1 := node1 bounds pointNearestTo: pos2 ].
	node2 ifNotNil: [ pos2 := node2 bounds pointNearestTo: pos1 ].
	(anInteger > 0 and: [ node1 notNil and: [ node2 notNil ] ]) ifTrue: [ 
		delta := Point r: anInteger degrees: (pos2 - pos1) degrees - 90.
		pos1 := pos1 + delta.
		pos2 := pos2 + delta ].
	self verticesAt: 1 put: pos1.
	self verticesAt: 2 put: pos2.
	priorityMorph center:
		pos1 + (Point r: 10 degrees: (pos2 - pos1) degrees).
	condMorph ifNil: [ ^ self ].
	condMorph center: ((pos1 distanceTo: pos2) < 100
			 ifTrue: [ pos1 + pos2 // 2 ]
			 ifFalse: [ pos1 + (Point r: 50 degrees: (pos2 - pos1) degrees) ])
			rounded
]

{ #category : #stepping }
DefartEdgeMorph >> wantsSteps [

	^ true
]
