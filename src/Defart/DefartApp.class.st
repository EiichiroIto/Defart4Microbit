Class {
	#name : #DefartApp,
	#superclass : #SpScratchApp,
	#instVars : [
		'process',
		'proxy',
		'showOutput',
		'lastInput'
	],
	#classVars : [
		'LoadedModules'
	],
	#category : #'Defart-Spec2'
}

{ #category : #constants }
DefartApp class >> aboutAppString [

	^ self appName , ' v' , self appVersion , '
Copyright © 2023 Eiichiro Ito (eiichiro.ito@gmail.com)
All rights reserved.

Based on Scratch from the MIT Media Lab, v' , self basedVersion , '
Copyright © 2009 Massachusetts Institute of Technology.
All rights reserved.
'
]

{ #category : #constants }
DefartApp class >> appFolderName [

	^ 'defart'
]

{ #category : #accessing }
DefartApp class >> appName [

	^ 'Defart'
]

{ #category : #constants }
DefartApp class >> appVersion [

	^ '0.0.1'
]

{ #category : #accessing }
DefartApp class >> availableModuleNames [

	^ LoadedModules keys \ self mainModuleNames
]

{ #category : #accessing }
DefartApp class >> blockSpecsFor: aString [

	^ LoadedModules at: aString
]

{ #category : #accessing }
DefartApp class >> extension [

	^ 'da'
]

{ #category : #initialization }
DefartApp class >> initialize [

	"self initialize"

	self loadModules.
	ScratchTheme
		themesURL: self themesURL;
		setupThemeNamed: self appFolderName.
	ObjStream setupVariables
]

{ #category : #testing }
DefartApp class >> isAvailableModule: aString [
	^ self availableModuleNames includes: aString
]

{ #category : #private }
DefartApp class >> loadModuleExtension: ext into: aDictionary [

	(self moduleDirectory filesMatching: '*.' , ext) do: [ :each | 
		each readStreamDo: [ :stream | 
			| importer |
			importer := self newModuleImporter
				            moduleName: each base;
				            yourself.
			aDictionary at: each base put: (importer import: stream contents) ] ]
]

{ #category : #utilities }
DefartApp class >> loadModules [

	| dict |
	dict := Dictionary new.
	self loadModuleExtension: self moduleExtension into: dict.
	LoadedModules := dict
]

{ #category : #accessing }
DefartApp class >> loadedModules: aDictionary [

	LoadedModules := aDictionary
]

{ #category : #constants }
DefartApp class >> mainModuleNames [

	^ #( microbit )
]

{ #category : #'world menu' }
DefartApp class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: self appName asSymbol)
		order: 0.5;
		target: self;
		action: [self open]; 
		icon: self icon
]

{ #category : #private }
DefartApp class >> moduleDirectory [
	| dir |
	dir := FileSystem workingDirectory / 'Modules'.
	dir isDirectory
		ifFalse: [ dir createDirectory ].
	^ dir
]

{ #category : #constants }
DefartApp class >> moduleExtension [

	^ 'mw*'
]

{ #category : #private }
DefartApp class >> newModuleImporter [

	self flag: #ToBeChanged.

	^ ModuleImporter new
		  appName: 'Microwitch' "self appName";
		  yourself
]

{ #category : #constants }
DefartApp class >> presentationClass [

	^ SpDefartPresenter
]

{ #category : #accessing }
DefartApp class >> projectClass [

	^ DefartProject
]

{ #category : #constants }
DefartApp class >> settingsClass [

	^ DefartSettings
]

{ #category : #accessing }
DefartApp class >> themesURL [

	^ 'https://github.com/EiichiroIto/Defart4Microbit/raw/main/misc/Themes.zip'
]

{ #category : #proxy }
DefartApp >> autoConnectIfFail: aBlock [

	proxy isReady ifTrue: [ ^ self ]. 
	self connectIfFail: aBlock.
	proxy break.
	proxy waitPromptIfError: aBlock
]

{ #category : #proxy }
DefartApp >> autoSelectPortName [

	| list ret |
	list := self availablePortNames.
	list isEmpty ifTrue: [ ^ self ].
	ret := list first.
	list size > 1 ifTrue: [ 
		ret := presenter
			       select: 'Select port' localized
			       chooseFrom: list.
		ret ifNil: [ ^ self ] ].
	proxy portName: ret
]

{ #category : #proxy }
DefartApp >> availablePortNames [

	^ (proxy portNames \ (settings unusedPortNames splitOn: $,)) sorted
]

{ #category : #private }
DefartApp >> backupProject [

	self shouldNotImplement
]

{ #category : #proxy }
DefartApp >> break [

	self stopAllProcesses.
	proxy isIdle ifTrue: [ ^ self ].
	proxy isNotConnected ifTrue: [ 
		proxy open ifFalse: [ 
			presenter enableConnect.
			^ presenter message: 'cannot open:' localized , proxy comm portName ] ].
	proxy break.
	presenter disableConnect.
	presenter message: 'stopped' localized
]

{ #category : #private }
DefartApp >> checkScriptsIfError: aBlock [

	project scripts do: [ :each | 
		each startNodeMorphs size = 1 ifFalse: [ 
			presenter alert: 'Start state only needs one' localized.
			aBlock value ] ]
]

{ #category : #proxy }
DefartApp >> connect [

	self connectIfFail: [ ^ self ].
	proxy break
]

{ #category : #proxy }
DefartApp >> connectIfFail: aBlock [

	proxy isIdle ifTrue: [ 
		self autoSelectPortName.
		proxy isIdle ifTrue: [ 
			presenter message: 'cannot select port' localized.
			^ aBlock value ] ].
	proxy isNotConnected ifTrue: [ 
		proxy open ifFalse: [ 
			presenter message: 'cannot open:' localized , proxy comm portName.
			^ aBlock value ] ].
	presenter disableConnect
]

{ #category : #'instance creation' }
DefartApp >> createComm [

	^ SerialComm new
]

{ #category : #'instance creation' }
DefartApp >> createProcess [

	^ MicroPythonProcess new
]

{ #category : #'instance creation' }
DefartApp >> createProxy [

	^ MicroPythonProxy new
]

{ #category : #proxy }
DefartApp >> disconnect [

	presenter enableConnect.
	proxy disconnect.
	presenter message: 'port closed' localized
]

{ #category : #proxy }
DefartApp >> evaluate: aString [

	| ret |
	self autoConnectIfFail: [ ^ 'Error!' ].
	ret := proxy evaluate: aString ifError: [ :msg | 
		       presenter message: msg.
		       ^ 'Error!' ].
	presenter message: 'done' localized.
	^ ret
]

{ #category : #proxy }
DefartApp >> execute: aString [

	self autoConnectIfFail: [ ^ self ].
	proxy execute: aString.
	presenter message: 'done' localized
]

{ #category : #proxy }
DefartApp >> getDirectory [

	| cmd ret |
	self autoConnectIfFail: [ ^ nil ].
	cmd := 'import os' , String lf , 'os.listdir()'.
	ret := proxy evaluate: cmd ifError: [ :msg | 
		       presenter message: msg.
		       ^ nil ].
	ret ifNil: [ ^ nil ].
	^ MicroPythonParser new parse: ret
]

{ #category : #initialization }
DefartApp >> initialize [

	super initialize.
	showOutput := true.
	lastInput := ''
]

{ #category : #proxy }
DefartApp >> input [

	| ret |
	self autoConnectIfFail: [ ^ self ].
	ret := presenter
		       multiLineRequest: 'Enter expression' localized
		       initialAnswer: lastInput.
	ret ifNil: [ ^ self ].
	lastInput := ret.
	proxy isReady ifFalse: [ ^ self ].
	proxy execute: ret
]

{ #category : #private }
DefartApp >> installNewProject: aProject [

	self stopAllProcesses.
	project := aProject.
	project application: self.
	project assureExistsBreed: 'main'.
	project setupScripts.
	self setupProxy.
	project setupBlockSpecs.
	self setupView.
	Smalltalk garbageCollect.
	project modified: false
]

{ #category : #processes }
DefartApp >> isProcessRunning [

	^ process notNil and: [ process isRunning ]
]

{ #category : #accessing }
DefartApp >> lastInput [

	^ lastInput
]

{ #category : #accessing }
DefartApp >> lastInput: anObject [

	lastInput := anObject
]

{ #category : #micropython }
DefartApp >> modulesNeedToUpload [

	| existings |
	existings := self getDirectory.
	existings ifNil: [ ^ nil ].
	^ project moduleFiles
		reject: [ :each | existings includes: each basename ]
]

{ #category : #'instance creation' }
DefartApp >> newCode [
	^ DefartGenerator new
		parser: DefartBlockParser new;
		yourself
]

{ #category : #'instance creation' }
DefartApp >> newSerializer [

	^ DefartSexpGenerator new
		parser: DefartBlockParser new;
		yourself
]

{ #category : #api }
DefartApp >> partialCodeFor: aMorph [

	aMorph receiver fixScriptBeforeWriting.
	^ self newCode
		  withHeader: true;
		  withDef: false;
		  parseBlock: aMorph
]

{ #category : #accessing }
DefartApp >> process [

	^ process
]

{ #category : #accessing }
DefartApp >> process: anObject [

	^ process := anObject
]

{ #category : #accessing }
DefartApp >> proxy [

	^ proxy
]

{ #category : #accessing }
DefartApp >> proxy: anObject [

	proxy := anObject
]

{ #category : #micropython }
DefartApp >> pyExtension [

	^ 'py'
]

{ #category : #proxy }
DefartApp >> restart [

	presenter enableConnect.
	proxy restart.
	presenter message: 'restarted' localized
]

{ #category : #proxy }
DefartApp >> restartAfterUpload [

	presenter enableConnect.
	proxy thenRestart
]

{ #category : #proxy }
DefartApp >> setupProxy [

	| comm |
	proxy ifNotNil: [ proxy close ].
	proxy := self createProxy.
	comm := self createComm.
	comm baudRate: proxy defaultBaudRate.
	proxy comm: comm.
	presenter updateViewer
]

{ #category : #'menu actions' }
DefartApp >> showEdgeMenu: anEdgeMorph event: anEvent [

	| menu |
	menu := presenter edgeMenuFor: anEdgeMorph event: anEvent.
	menu ifNil: [ ^ self ].
	menu openWithSpecAt: anEvent cursorPoint
]

{ #category : #'menu actions' }
DefartApp >> showMicroPythonCode [

	| str |
	self target fixScriptBeforeWriting.
	self checkScriptsIfError: [ ^ self ].
	str := self newCode parseScript: self target.
	str isEmpty ifTrue: [ ^ self ].
	str inspect
]

{ #category : #accessing }
DefartApp >> showOutput [

	^ showOutput
]

{ #category : #accessing }
DefartApp >> showOutput: anObject [

	showOutput := anObject
]

{ #category : #processes }
DefartApp >> startProcessFor: aTopBlock [

	| code |
	self stopAllProcesses.
	code := self partialCodeFor: aTopBlock.
	code isEmpty ifTrue: [ ^ nil ].
	process := self createProcess
		           proxy: self proxy;
		           topBlock: aTopBlock;
		           yourself.
	aTopBlock scratchProc: process.
	self execute: code.
	^ process
]

{ #category : #'menu actions' }
DefartApp >> startProgram [

	self checkScriptsIfError: [ ^ self ].
	self autoConnectIfFail: [ ^ self ].
	self uploadModuleFiles.
	self uploadProgram.
	self restartAfterUpload
]

{ #category : #processes }
DefartApp >> stepProcesses [

	process ifNotNil: #step.
	self stepProxy
]

{ #category : #proxy }
DefartApp >> stepProxy [

	| out |
	proxy step.
	presenter status: proxy state asString.
	proxy isReady ifTrue: [ 
		showOutput := true.
		self stopAllProcesses ].
	out := proxy receiveQueue getAll.
	showOutput ifTrue: [ 
		out do: [ :each | presenter addText: each asString ] ].
	proxy ifTimeoutDo: [ presenter message: 'timeout' localized ]
]

{ #category : #processes }
DefartApp >> stopAllProcesses [

	process ifNotNil: [ 
		process stop.
		process := nil ].
	project ifNotNil: [ project stopAllProcesses ]
]

{ #category : #proxy }
DefartApp >> upload: aString fileNamed: aString2 [

	proxy isReady ifFalse: [ 
		presenter message: 'device is not ready' localized.
		^ nil ].
	proxy upload: aString fileNamed: aString2.
	showOutput := false
]

{ #category : #micropython }
DefartApp >> uploadModuleFiles [

	| list |
	list := self modulesNeedToUpload.
	list ifNil: [ ^ self ].
	list do: [ :each | 
		self upload: each contents fileNamed: each basename ]
]

{ #category : #micropython }
DefartApp >> uploadProgram [

	project scripts do: [ :each | 
		| code |
		each fixScriptBeforeWriting.
		code := self newCode parseScript: self target.
		code isEmpty ifFalse: [ 
			self upload: code fileNamed: each objName , '.' , self pyExtension ] ]
]

{ #category : #private }
DefartApp >> windowClosing [

	self proxy close
]
