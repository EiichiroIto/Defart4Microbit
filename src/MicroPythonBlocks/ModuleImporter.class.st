Class {
	#name : #ModuleImporter,
	#superclass : #Object,
	#instVars : [
		'moduleName',
		'appName'
	],
	#category : #'MicroPythonBlocks-Converter'
}

{ #category : #accessing }
ModuleImporter >> appName [

	^ appName
]

{ #category : #accessing }
ModuleImporter >> appName: anObject [

	appName := anObject
]

{ #category : #importing }
ModuleImporter >> category: aString [

	^ ScratchBlockCategory new
		  categoryName: aString;
		  yourself
]

{ #category : #importing }
ModuleImporter >> choiceArg: aString options: aCollection [

	^ ScratchChoiceArgDef new
		arg: aString first;
		options: aCollection;
		yourself
]

{ #category : #importing }
ModuleImporter >> commandBlock: aString args: aCollection code: aString3 imports: aCollection4 selector: aString5 [

	^ self newBlockSpec
		  type: #isCommandBlock;
		  label: aString;
		  arguments: aCollection;
		  code: aString3;
		  imports: aCollection4;
		  selector: aString5 asSymbol;
		  yourself
]

{ #category : #importing }
ModuleImporter >> commandBlock: aString args: aCollection code: aString3 selector: aString4 [

	^ self newBlockSpec
		  type: #isCommandBlock;
		  label: aString;
		  arguments: aCollection;
		  code: aString3;
		  selector: aString4 asSymbol;
		  yourself
]

{ #category : #importing }
ModuleImporter >> commandBlock: aString args: aCollection code: aString3 var: aString4 imports: aCollection5 selector: aString6 [

	^ self newBlockSpec
		  type: #isCommandBlock;
		  label: aString;
		  arguments: aCollection;
		  code: aString3;
		  var: aString4;
		  imports: aCollection5;
		  selector: aString6 asSymbol;
		  yourself
]

{ #category : #api }
ModuleImporter >> import: aString [
	| lex list |
	lex := SexpLexer new read: aString.
	list := SexpParser new parse: lex.
	^ self importFrom: list
]

{ #category : #private }
ModuleImporter >> importBlockDef: anArray [

	^ self
		  perform: anArray first asSymbol
		  withArguments: anArray allButFirst
]

{ #category : #private }
ModuleImporter >> importFrom: anArray [

	anArray first = appName ifFalse: [ self error: 'invalid appName' ].
	^ self
		  perform: anArray second first asSymbol
		  withArguments: anArray second allButFirst
]

{ #category : #accessing }
ModuleImporter >> moduleName [

	^ moduleName
]

{ #category : #accessing }
ModuleImporter >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #importing }
ModuleImporter >> name: aString blocks: anArray [

	^ MicroPythonModule new
		  name: aString;
		  blockSpecs:
			  (anArray collect: [ :each | self importBlockDef: each ]);
		  yourself
]

{ #category : #private }
ModuleImporter >> newBlockSpec [

	^ MicroPythonBlockSpec new
		  moduleName: moduleName;
		  yourself
]

{ #category : #importing }
ModuleImporter >> reporterBlock: aString args: aCollection return: aString3 code: aString4 imports: aCollection5 selector: aString6 [

	^ self newBlockSpec
		  type: (self typeOf: aString3);
		  label: aString;
		  arguments: aCollection;
		  code: aString4;
		  imports: aCollection5;
		  selector: aString6 asSymbol;
		  yourself
]

{ #category : #importing }
ModuleImporter >> reporterBlock: aString args: aCollection return: aString3 code: aString4 selector: aString5 [

	^ self newBlockSpec
		  type: (self typeOf: aString3);
		  label: aString;
		  arguments: aCollection;
		  code: aString4;
		  selector: aString5 asSymbol;
		  yourself
]

{ #category : #importing }
ModuleImporter >> separator [
	^ ScratchBlockSeparator new
]

{ #category : #importing }
ModuleImporter >> specialCommandBlock: aString args: aCollection code: aString3 imports: aCollection4 selector: aString5 [

	^ self newBlockSpec
		  type: #isSpecialForm;
		  label: aString;
		  arguments: aCollection;
		  code: aString3;
		  imports: aCollection4;
		  selector: aString5 asSymbol;
		  yourself
]

{ #category : #importing }
ModuleImporter >> timedCommandBlock: aString args: aCollection code: aString3 imports: aCollection4 selector: aString5 [

	^ self newBlockSpec
		  type: #isTimedBlock;
		  label: aString;
		  arguments: aCollection;
		  code: aString3;
		  imports: aCollection4;
		  selector: aString5 asSymbol;
		  yourself
]

{ #category : #private }
ModuleImporter >> typeOf: aString [

	aString = '-' ifTrue: [ ^ #isCommandBlock ].
	aString = 'r' ifTrue: [ ^ #isReporterBlock ].
	aString = 'b' ifTrue: [ ^ #isBooleanReporter ].
	aString = 's' ifTrue: [ ^ #isSpecialForm ].
	aString = 't' ifTrue: [ ^ #isTimedBlock ].
	self error
]
