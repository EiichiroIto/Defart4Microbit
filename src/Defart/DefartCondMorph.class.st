Class {
	#name : #DefartCondMorph,
	#superclass : #CommandBlockMorph,
	#traits : 'TGraphObject',
	#classTraits : 'TGraphObject classTrait',
	#category : #'Defart-Blocks'
}

{ #category : #'dropping/grabbing' }
DefartCondMorph >> aboutToBeGrabbedBy: aHandMorph [

	self clearMyself
]

{ #category : #'dropping/grabbing' }
DefartCondMorph >> attachToEdge: anEdgeMorph [

	anEdgeMorph ifNil: [ ^ self ].
	anEdgeMorph condMorph: self
]

{ #category : #private }
DefartCondMorph >> blockAttachPoints: aSet [

	"aSet add: self topLeft -> self"
]

{ #category : #private }
DefartCondMorph >> clearMyself [

	owner ifNil: [ ^ self ].
	owner submorphsDo: [ :each | 
		(each isEdgeMorph and: [ each condMorph = self ]) ifTrue: [ 
			each condMorph: nil ] ]
]

{ #category : #accessing }
DefartCondMorph >> closestAttachTargetIn: newOwner [

	^ nil
]

{ #category : #'submorphs - add/remove' }
DefartCondMorph >> delete [

	self clearMyself.
	super delete
]

{ #category : #drawing }
DefartCondMorph >> drawBottomEdgeOn: aCanvas [

	| right y |
	right := self width - 1.
	y := self height - 7.
	self
		drawHLineFrom: 1
		to: right - 1
		y: y
		color: color
		on: aCanvas.
	self
		drawHLineFrom: 2
		to: right - 2
		y: y + 1
		color: color
		on: aCanvas
]

{ #category : #drawing }
DefartCondMorph >> drawTopEdgeOn: aCanvas [

	| right |
	right := self width - 1.
	self
		drawHLineFrom: 2
		to: right - 2
		y: 0
		color: highlightColor1
		on: aCanvas.
	self
		drawHLineFrom: 1
		to: right - 1
		y: 1
		color: highlightColor2
		on: aCanvas.
	self
		drawHLineFrom: 0
		to: right
		y: 2
		color: color
		on: aCanvas.
	self
		drawHLineFrom: 0
		to: right
		y: 3
		color: color
		on: aCanvas.
	self
		drawHLineFrom: 0
		to: right
		y: 4
		color: color
		on: aCanvas
]

{ #category : #private }
DefartCondMorph >> edgeIdArg [

	^ submorphs detect: [ :each | each isKindOf: DefartEdgeIdArgMorph ]
]

{ #category : #accessing }
DefartCondMorph >> edgeMorph [

	owner ifNil: [ ^ nil ].
	^ owner
		  submorphThat: [ :each | 
		  each isEdgeMorph and: [ each condMorph = self ] ]
		  ifNone: [ nil ]
]

{ #category : #'code generation' }
DefartCondMorph >> emitCode: aGenerator indent: indent [

	aGenerator emitCond: self indent: indent
]

{ #category : #private }
DefartCondMorph >> id [

	^ self edgeMorph ifNil: [ 0 ] ifNotNil: [ :edge | edge id ]
]

{ #category : #testing }
DefartCondMorph >> isCondMorph [

	^ true
]

{ #category : #testing }
DefartCondMorph >> isForever [

	^ true
]

{ #category : #private }
DefartCondMorph >> nextBlock [

	^ nil
]

{ #category : #'dropping/grabbing' }
DefartCondMorph >> onlyDroppedIntoScriptEditor [

	| edge |
	owner ifNil: [ ^ self ].
	edge := owner
		        submorphThat: [ :each | 
			        each isEdgeMorph and: [ 
				        each containsPoint: self activeHand cursorPoint ] ]
		        ifNone: [ nil ].
	self attachToEdge: edge
]

{ #category : #private }
DefartCondMorph >> reporterMorph [

	^ submorphs detect: [ :each | each isKindOf: ReporterBlockMorph ] ifNone: [ nil ]
]

{ #category : #initialization }
DefartCondMorph >> setEdgeWithId: anInteger [

	(receiver edgeMorphWithId: anInteger) ifNotNil: [ :edge | 
		edge condMorph: self ]
]
