Class {
	#name : #SpDefartStage,
	#superclass : #SpPresenter,
	#instVars : [
		'buttonInput',
		'buttonClear',
		'notebook',
		'morphTimer',
		'labelStatus',
		'labelMessage',
		'textOutput'
	],
	#category : #'Defart-Spec2'
}

{ #category : #api }
SpDefartStage >> addText: aString [

	textOutput morph
		put: aString;
		changed
]

{ #category : #'button actions' }
SpDefartStage >> clear [

	textOutput morph
		clearScreen;
		changed
]

{ #category : #initialization }
SpDefartStage >> connectPresenters [

	buttonClear action: [ self clear ]
]

{ #category : #'instance creation' }
SpDefartStage >> createConsoleMorph [

	^ ScratchConsoleMorph new
]

{ #category : #'instance creation' }
SpDefartStage >> createTextPage [

	textOutput := self newMorph.
	textOutput morph: self createConsoleMorph.
	^ SpNotebookPage
		  title: self textLabel
		  icon: (self iconNamed: #morph)
		  provider: [ textOutput ]
]

{ #category : #'instance creation' }
SpDefartStage >> createTimerMorph [

	^ ScratchStepperMorph new
		stepTime: self defaultStepTime;
		yourself
]

{ #category : #layout }
SpDefartStage >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #morphTimer withConstraints: [ :c | c height: 5 ];
		  add: #labelStatus
		  withConstraints: [ :c | c height: self class buttonHeight ];
		  add: #labelMessage
		  withConstraints: [ :c | c height: self class buttonHeight ];
		  add: (SpBoxLayout newVertical
				   add: (SpBoxLayout newHorizontal
						    add: #buttonInput;
						    add: #buttonClear;
						    yourself)
				   withConstraints: [ :c | c height: self class buttonHeight ];
				   add: #notebook;
				   yourself);
		  yourself
]

{ #category : #constants }
SpDefartStage >> defaultStepTime [

	^ 100
]

{ #category : #initialization }
SpDefartStage >> initializePresenters [

	buttonInput := self newButton
		               label: 'input' localized;
		               icon: (self iconNamed: #edit);
		               yourself.
	buttonClear := self newButton
		               label: 'clear' localized;
		               icon: (self iconNamed: #glamorousClose);
		               yourself.
	notebook := self newNotebook
		            addPage: self createTextPage;
		            yourself.
	morphTimer := self newMorph
		              morph: self createTimerMorph;
		              yourself.
	labelStatus := self newLabel
		               label: '';
		               yourself.
	labelMessage := self newLabel
		                label: '';
		                yourself
]

{ #category : #api }
SpDefartStage >> message: aString [

	labelMessage label: aString
]

{ #category : #'stepping and presenter' }
SpDefartStage >> startStepping [

	morphTimer morph startStepping
]

{ #category : #api }
SpDefartStage >> status: aString [

	labelStatus label: aString localized
]

{ #category : #constants }
SpDefartStage >> textLabel [

	^ 'Output' localized
]

{ #category : #accessing }
SpDefartStage >> whenInputClicked: aBlock [

	buttonInput action: aBlock
]

{ #category : #accessing }
SpDefartStage >> whenStepsDo: aBlock [

	morphTimer morph whenStepsDo: aBlock
]
