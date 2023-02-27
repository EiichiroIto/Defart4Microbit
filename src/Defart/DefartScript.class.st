Class {
	#name : #DefartScript,
	#superclass : #ScratchScript,
	#instVars : [
		'objName',
		'varNames'
	],
	#category : #'Defart-Project'
}

{ #category : #'ston-core' }
DefartScript class >> stonAllInstVarNames [

	^ super stonAllInstVarNames , #(objName varNames)
]

{ #category : #adding }
DefartScript >> addArgBuilder [

	argMorphBuilder
		addNodeNameArg: $N;
		addNodeHandleArg: $h;
		addEdgeIdArg: $E;

		addBooleanArg: $b;
		addEventTitleArg: $e;
		addChoiceArg: $f
		options:
			#( 'abs' 'sqrt' 'sin' 'cos' 'tan' 'asin' 'acos' 'atan' 'ln' 'log'
			   'e ^' '10 ^' )
		initialChoice: 'sqrt';
		addLocalVarArg: $l;
		addChoiceArg: $L selector: #listVarNames;
		addSpriteArg: $m;
		addNumberExpressArg: $n initialExpression: '10';
		addChoiceArg: $S selector: #subNames;
		addStringExpressArg: $s;
		addChoiceArg: $v selector: #varNames;
		addChoiceArg: $a selector: #allSubNames;
		addNumberExpressArg: $i
		selector: #listIndexNames
		target: self
		initialExpression: '0';
		addChoiceArg: $B options: #( a b ) initialChoice: 'a';
		add: $C builder: [ MicrobitLedArgMorph new ];
		addNumberExpressArg: $y
		selector: #listIndexForDeleteNames
		target: self
		initialExpression: '0';
		addChoiceArg: $T
		options: #( pin_logo pin0 pin1 pin2 )
		initialChoice: 'pin_logo'.
	project addBlockSpecsTo: argMorphBuilder
]

{ #category : #adding }
DefartScript >> addBlockSpecs [

	self
		addControlBlockSpecs;
		addIoBlockSpecs;
		addVariableBlockSpecs.
	project addBlockSpecsTo: blockMorphBuilder.
	self addOperatorsBlockSpecs
]

{ #category : #adding }
DefartScript >> addControlBlockSpecs [

	blockMorphBuilder
		addCategory: 'control';
		addStartNode: 'when start' selector: #initialState:;
		addSeparator;
		addNode: 'state %N %h' selector: #state:id: named: 'state';
		addCond: 'cond %b %E' selector: #cond:id:;
		addSeparator;
		addCBlock: 'do %s each %l' selector: #doIterate arguments: #( 'list' )
]

{ #category : #adding }
DefartScript >> addIoBlockSpecs [

	blockMorphBuilder
		addCategory: 'io';
		addBooleanReporter: 'button %B is pressed' selector: #buttonIsPressed:;
		addBooleanReporter: 'button %B was pressed' selector: #buttonWasPressed:;
		addBooleanReporter: '%T is touched' selector: #pinIsTouched: arguments: #( pin_logo );
		addReporter: 'count of button %B pressed' selector: #countOfButtonPressed:;
		addSeparator;
		addCommand: 'servo set pin %G %n msec %n to %n' selector: #setServo:msec:min:max: arguments: #( 0 5 100 500 );
		addCommand: 'servo write pin %G to %n degrees' selector: #writeServo:to: arguments: #( 0 180 )
]

{ #category : #adding }
DefartScript >> addOperatorsBlockSpecs [

	blockMorphBuilder
		addCategory: 'operators';
		addReporter: '%f of %n'
		selector: #computeFunction:of:
		arguments: #( 'sqrt' 10 )
]

{ #category : #adding }
DefartScript >> addVariableBlockSpecs [

	blockMorphBuilder
		addCategory: nil;
		addReporter: 'dummy' selector: #getVar: arguments: #( 0 );
		addCommand: 'dummy' selector: #setVar:to: arguments: #( 0 0 );
		addCommand: 'dummy' selector: #changeVar:by: arguments: #( 0 0 )
]

{ #category : #api }
DefartScript >> assignIds [

	| list rest assigned |
	list := blocksBin submorphs select: [ :each | 
		        each isNodeMorph or: [ each isEdgeMorph ] ].
	list := list sorted: [ :a :b | a id <= b id ].
	rest := (1 to: list size) asOrderedCollection \ (list collect: #id).
	assigned := Set new.
	list withIndexDo: [ :each :index | 
		| id |
		id := each id.
		(id = 0 or: [ id > list size or: [ assigned includes: id ] ]) 
			ifTrue: [ 
				id := rest removeFirst.
				each id: id ].
		assigned add: id ]
]

{ #category : #'block building' }
DefartScript >> blockMorphsForWriting [

	| list |
	list := blocksBin submorphs select: [ :m | 
		        m respondsTo: #tupleSequence ].
	^ (list select: #isNodeMorph) , (list select: #isEdgeMorph)
	  , (list select: #isCondMorph)
]

{ #category : #'block specs' }
DefartScript >> cBlockSelectors [

	^ super cBlockSelectors , #( state:id: )
]

{ #category : #accessing }
DefartScript >> connectedEdgeMorphs [

	^ blocksBin submorphsSatisfying: [ :each | 
		  each isEdgeMorph and: [ each isConnected ] ]
]

{ #category : #'block building' }
DefartScript >> convertEventHatTuple: anArray [

	anArray first = #EventHatMorph ifTrue: [ ^ Array with: #startNode ].
	^ super convertEventHatTuple: anArray
]

{ #category : #api }
DefartScript >> edgeMorphWithId: anInteger [

	^ blocksBin
		  submorphThat: [ :each | 
		  each isEdgeMorph and: [ each id = anInteger ] ]
		  ifNone: [ nil ]
]

{ #category : #accessing }
DefartScript >> edgeMorphs [

	^ blocksBin 	submorphsSatisfying: [ :each | each isEdgeMorph ]
]

{ #category : #api }
DefartScript >> edgeMorphsConnectingWith: aNode [

	^ blocksBin submorphs select: [ :each | 
		  each isEdgeMorph and: [ 
			  each fromNode = aNode or: [ each toNode = aNode ] ] ]
]

{ #category : #accessing }
DefartScript >> fixScriptBeforeWriting [

	super fixScriptBeforeWriting.
	self assignIds
]

{ #category : #'block specs' }
DefartScript >> foreverBlockSelectors [

	^ super foreverBlockSelectors , #( #node: )
]

{ #category : #initialization }
DefartScript >> initialize [

	super initialize.
	varNames := OrderedCollection new
]

{ #category : #'argument menus' }
DefartScript >> listVarNames [

	^ #()
]

{ #category : #'block specs' }
DefartScript >> loopBlockSelectors [

	^ super loopBlockSelectors , #( doWhile doIterate )
]

{ #category : #api }
DefartScript >> multipleEdgesOf: aCollection [

	| result rest edge edges |
	result := Set new.
	rest := aCollection copy asOrderedCollection.
	[ rest isEmpty ] whileFalse: [ 
		edge := rest removeFirst.
		edges := rest select: [ :each | 
			         each isConnectingWith: edge fromNode and: edge toNode ].
		edges isEmpty ifFalse: [ 
			result add: edge.
			result addAll: edges ].
		rest removeAll: edges ].
	^ result
]

{ #category : #'instance creation' }
DefartScript >> newArgMorphBuilder [

	^ DefartArgMorphBuilder new
]

{ #category : #'instance creation' }
DefartScript >> newBlockMorphBuilder [

	^ DefartBlockMorphBuilder new
		  script: self;
		  yourself
]

{ #category : #api }
DefartScript >> nodeMorphWithId: anInteger [

	^ blocksBin
		  submorphThat: [ :each | 
		  each isNodeMorph and: [ each id = anInteger ] ]
		  ifNone: [ nil ]
]

{ #category : #accessing }
DefartScript >> nodeMorphs [

	^ blocksBin 	submorphsSatisfying: [ :each | each isNodeMorph ]
]

{ #category : #accessing }
DefartScript >> objName [

	^ objName
]

{ #category : #accessing }
DefartScript >> objName: anObject [

	objName := anObject
]

{ #category : #'block specs' }
DefartScript >> setupBlockCategory [

	blockMorphBuilder
		setCategory: 'control' color: (Color h: 41 s: 0.85 v: 0.9);
		setCategory: 'operators' color: (Color h: 93 s: 0.9 v: 0.76);
		setCategory: 'sensing' color: (Color h: 200 s: 0.98 v: 0.86);
		setCategory: 'variables' color: ScratchTheme variableBlockColor;
		setCategory: 'lists' color: ScratchTheme listBlockColor;
		setCategory: 'misc' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'io' color: (Color h: 225 s: 0.65 v: 0.83);
		setCategory: 'accelerometer' color: (Color h: 200 s: 0.98 v: 0.86);
		setCategory: 'compass' color: (Color h: 200 s: 0.98 v: 0.86);
		setCategory: 'radio' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'uart' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'i2c' color: (Color h: 165 s: 1 v: 0.63);
		setCategory: 'music' color: (Color h: 264 s: 0.62 v: 0.89);
		setCategory: 'display' color: (Color h: 264 s: 0.62 v: 0.89);
		setCategory: 'neopixel' color: (Color h: 264 s: 0.62 v: 0.89)
]

{ #category : #'block specs' }
DefartScript >> startHatBlockNames [

	^ #( initialState: )
]

{ #category : #accessing }
DefartScript >> startNodeMorph [

	^ blocksBin submorphs detect: [ :each | each isStartNodeMorph ]
]

{ #category : #accessing }
DefartScript >> startNodeMorphs [

	^ blocksBin submorphs select: [ :each | each isStartNodeMorph ]
]

{ #category : #processes }
DefartScript >> stopAllProcesses [

	blocksBin isArray
		ifTrue: [ ^ self ].
	blocksBin
		submorphsDo: [ :each | 
			each isBlockMorph
				ifTrue: [ each clearProcess.
					each litUp: false ] ]
]

{ #category : #api }
DefartScript >> updateEdgesPosition [

	| singles multiples |
	singles := self connectedEdgeMorphs.
	multiples := self multipleEdgesOf: singles.
	singles := singles \ multiples.
	singles do: #updatePosition.
	multiples do: [ :each | each updatePositionDelta: 10 ]
]

{ #category : #'argument menus' }
DefartScript >> varNames [

	^ varNames
]

{ #category : #accessing }
DefartScript >> varNames: anObject [

	varNames := anObject
]
