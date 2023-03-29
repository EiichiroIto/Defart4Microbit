Class {
	#name : #DefartProject,
	#superclass : #ScratchProject,
	#instVars : [
		'modules'
	],
	#category : #'Defart-Project'
}

{ #category : #constants }
DefartProject class >> fileVersion [

	^ 1
]

{ #category : #constants }
DefartProject class >> fileVersionTag [

	^ 'DefartV'
]

{ #category : #'ston-core' }
DefartProject class >> stonAllInstVarNames [

	^ super stonAllInstVarNames , #(modules)
]

{ #category : #adding }
DefartProject >> addBlockSpecsTo: aBlockMorphBuilder [

	DefartApp mainModuleNames , modules do: [ :name | 
		(DefartApp blockSpecsFor: name) blockSpecs do: [ :each | 
			aBlockMorphBuilder addBlockSpec: each ] ]
]

{ #category : #accessing }
DefartProject >> assureExistsScriptNamed: each [

	self assert: [ each = 'main' ].
	scripts notEmpty ifTrue: [ ^ self ].
	self addScript: self newScript
]

{ #category : #evaluation }
DefartProject >> evaluateBlock: aTopBlock [

	^ application evaluateBlock: aTopBlock
]

{ #category : #initialization }
DefartProject >> initialize [

	super initialize.
	modules := Array new
]

{ #category : #private }
DefartProject >> moduleFileFor: aString [

	| file |
	file := DefartApp moduleDirectory / (aString , '.' , application pyExtension).
	file isFile
		ifFalse: [ ^ nil ].
	^ file
]

{ #category : #accessing }
DefartProject >> moduleFiles [

	| list |
	list := modules collect: [ :each | self moduleFileFor: each ].
	^ list reject: #isNil
]

{ #category : #'instance creation' }
DefartProject >> newObjStream [

	^ STONObjStream new
]

{ #category : #'instance creation' }
DefartProject >> newScript [

	^ DefartScript new
		  project: self;
		  yourself
]

{ #category : #api }
DefartProject >> setupScripts [

	self assureExistsScriptNamed: 'main'.
	scripts do: #updateEdgesPosition
]

{ #category : #processes }
DefartProject >> stopAllProcesses [

	scripts do: #stopAllProcesses
]
