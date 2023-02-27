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

{ #category : #constants }
DefartProject class >> objStreamClass [

	^ STONObjStream
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

{ #category : #adding }
DefartProject >> addScriptNamed: aString [

	| script |
	script := self newScript
		project: self;
		objName: aString;
		yourself.
	self addScript: script.
	^ script
]

{ #category : #accessing }
DefartProject >> assureExistsBreed: each [

	((self scripts collect: #objName) includes: each)
		ifTrue: [ ^ self ].
	self addScriptNamed: each
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
DefartProject >> newScript [

	^ DefartScript new
]

{ #category : #api }
DefartProject >> setupScripts [

	scripts do: #updateEdgesPosition
]

{ #category : #processes }
DefartProject >> stopAllProcesses [

	scripts do: #stopAllProcesses
]
