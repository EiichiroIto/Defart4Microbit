Class {
	#name : #SpDefartPresenter,
	#superclass : #SpScratchPresenter,
	#instVars : [
		'buttonOpen',
		'buttonSave',
		'buttonConnect',
		'buttonDisconnect',
		'buttonRestart',
		'buttonBreak',
		'buttonSend'
	],
	#category : #'Defart-Spec2'
}

{ #category : #adding }
SpDefartPresenter >> addBlockMenu: aMenu for: aBlockMorph [

	aMenu addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'code' localized;
					action: [ (application partialCodeFor: aBlockMorph) inspect ] ];
			addItem: [ :item | 
				item
					name: 'inspect' localized;
					action: [ aBlockMorph inspect ] ] ].
	super addBlockMenu: aMenu for: aBlockMorph
]

{ #category : #api }
SpDefartPresenter >> addText: aString [

	stageFrame addText: aString
]

{ #category : #initialization }
SpDefartPresenter >> connectPresenters [

	buttonOpen action: [ application openProject ].
	buttonSave action: [ application saveProject ].
	buttonConnect action: [ application connect ].
	buttonDisconnect action: [ application disconnect ].
	buttonRestart action: [ application restart ].
	buttonBreak action: [ application break ].
	buttonSend action: [ application startProgram ].
	stageFrame whenInputClicked: [ application input ]
]

{ #category : #private }
SpDefartPresenter >> defaultExtent [

	^ 1024 @ 768
]

{ #category : #layout }
SpDefartPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: (SpBoxLayout newHorizontal
				   spacing: 4;
				   add: #logo withConstraints: [ :c | c width: 200 ];
				   add: #buttonOpen
				   withConstraints: [ :c | c width: self class iconWidth ];
				   add: #buttonSave
				   withConstraints: [ :c | c width: self class iconWidth ];
				   add: #menu;
				   yourself)
		  withConstraints: [ :c | c height: self class toolbarHeight ];
		  add: (SpBoxLayout newHorizontal
				   add: #viewerPane
				   withConstraints: [ :c | c width: self class viewerPaneWidth ];
				   add: (SpPanedLayout newHorizontal
						    positionOfSlider: 0.7;
						    add: (SpBoxLayout newVertical
								     add: (SpBoxLayout newHorizontal
										      add: #modifiedProjectLabel
										      withConstraints: [ :c | c expand: false ];
										      add: #projectNameLabel;
										      yourself)
								     withConstraints: [ :c | c expand: false ];
								     add: (SpBoxLayout newHorizontal
										      add: #buttonSend;
										      add: #buttonConnect;
										      add: #buttonDisconnect;
										      add: #buttonBreak;
										      add: #buttonRestart;
										      yourself)
								     withConstraints: [ :c | 
								     c height: self class buttonHeight ];
								     add: #editorPane;
								     yourself);
						    add: #stageFrame;
						    yourself);
				   yourself);
		  yourself
]

{ #category : #api }
SpDefartPresenter >> disableConnect [

	buttonConnect disable.
	buttonDisconnect enable
]

{ #category : #'menu building' }
SpDefartPresenter >> edgeMenuFor: anEdgeMorph event: anEvent [

	^ self newMenu in: [ :m | 
		  m
			  addGroup: [ :grp | 
				  grp addItem: [ :item | 
						  item
							  name: 'inspect' localized;
							  action: [ anEdgeMorph inspect ] ] ];
			  addGroup: [ :grp | 
				  grp addItem: [ :item | 
						  item
							  name: 'delete' localized;
							  action: [ anEdgeMorph delete ] ] ];
			  yourself ]
]

{ #category : #api }
SpDefartPresenter >> enableConnect [

	buttonConnect enable.
	buttonDisconnect disable
]

{ #category : #'menu building' }
SpDefartPresenter >> fileMenu [

	| m |
	m := self newMenu.
	m addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'New' localized;
					icon: (self iconNamed: #smallNew);
					action: [ application newProject ] ];
			addItem: [ :item | 
				item
					name: 'Open' localized;
					icon: (self iconNamed: #smallOpen);
					action: [ application openProject ] ];
			addItem: [ :item | 
				item
					name: 'Save' localized;
					icon: (self iconNamed: #smallSave);
					action: [ application saveProjectNoDialog ] ];
			addItem: [ :item | 
				item
					name: 'Save As' localized;
					icon: (self iconNamed: #smallSaveAs);
					action: [ application saveProject ] ] ].

	m addGroup: [ :grp | 
		grp addItem: [ :item | 
			item
				name: 'Show MicroPython code' localized;
				icon: (self iconNamed: #smallWindow);
				action: [ application showMicroPythonCode ] ] ].

	m addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'Close' localized;
					action: [ application closeAllWindows ];
					enabled: [ self settings dontClose not ] ];
			addItem: [ :item | 
				item
					name: 'Quit' localized;
					icon: (self iconNamed: #smallQuit);
					action: [ application class quit ] ] ].
	^ m
]

{ #category : #initialization }
SpDefartPresenter >> initializePresenters [

	super initializePresenters.
	buttonOpen := self newButton
		              icon: (ScratchTheme formAt: #openButton);
		              help: 'Open project';
		              yourself.
	buttonSave := self newButton
		              icon: (ScratchTheme formAt: #saveButton);
		              help: 'Save this project';
		              yourself.
	buttonConnect := self newButton
		                 help: 'Connect to micro:bit';
		                 label: 'Connect' localized;
		                 icon: (ScratchTheme formAt: #connect);
		                 yourself.
	buttonDisconnect := self newButton
		                    help: 'Disconnect from micro:bit';
		                    label: 'Disconnect' localized;
		                    icon: (ScratchTheme formAt: #disconnect);
		                    disable;
		                    yourself.
	buttonRestart := self newButton
		                 help: 'Restart micro:bit';
		                 label: 'Restart' localized;
		                 icon: (self iconNamed: #refresh).
	buttonBreak := self newButton
		               help: 'Stop';
		               label: 'Stop' localized;
		               icon: (ScratchTheme formAt: #stopButton).
	buttonSend := self newButton
		              help: 'Start program';
		              label: 'Start' localized;
		              icon: (ScratchTheme formAt: #goButton).
	self focusOrder
		add: buttonSend;
		add: buttonConnect;
		add: buttonDisconnect;
		add: buttonBreak;
		add: buttonRestart;
		add: editorPane
]

{ #category : #api }
SpDefartPresenter >> message: aString [

	stageFrame message: aString
]

{ #category : #'instance creation' }
SpDefartPresenter >> newStage [

	^ self instantiate: SpDefartStage
]

{ #category : #initialization }
SpDefartPresenter >> setupMenu [

	menu
		addItem: [ :item | 
			item
				name: 'File' localized;
				subMenu: self fileMenu ];
		addItem: [ :item | 
			item
				name: 'Help' localized;
				subMenu: self helpMenu ]
]

{ #category : #api }
SpDefartPresenter >> stageShotExtent: size [

	^ nil
]

{ #category : #api }
SpDefartPresenter >> status: aString [

	stageFrame status: aString
]

{ #category : #accessing }
SpDefartPresenter >> target: aScript [

	viewerPane target: aScript.
	editorPane morph contents: aScript blocksBin.
	editorPane morph contents color: ScratchTheme scriptsPaneColor
]

{ #category : #api }
SpDefartPresenter >> updateViewer [

	viewerPane target: viewerPane target
]

{ #category : #enumerating }
SpDefartPresenter >> whenStepsDo: aBlock [

	stageFrame whenStepsDo: aBlock
]
