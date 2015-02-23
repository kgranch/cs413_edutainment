import starling.display.Sprite;
import starling.display.Image;
import starling.core.Starling;
import starling.text.TextField;
import starling.events.KeyboardEvent;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.SelectorFilter;
import starling.animation.Transitions;
import starling.animation.Tween;

import flash.media.SoundTransform;
import flash.media.SoundChannel;
import flash.media.Sound;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;

import haxe.Timer;

import flash.ui.Keyboard;

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var levelFile:String;
	
	var errorsSkipped = 0;
	var strikes = 0;
	var fieldProgress = 0; // Determines what textobject should be popped next
	var fields:Array<TextObject>; // All of the textobject fields
	var introFields:Array<TextObject>; // All of the intro fields
	var outroFields:Array<TextObject>; // All of the outro fields
	
	var currentField:TextObject;
	var fieldState = FieldState.INTRO;
	var renderProgress = 0; // How far in rendering the text animation we are (in characters)
	var animating = false;
	var soundCounter = 0;
	var menuSelection = 0;
	var waveRate = 0.125;
	
	var animTimer:Timer;
	
	var textBox:TextField = new TextField(512, 50, "", "5x7");
	var angryFilter:SelectorFilter;
	var normalFilter:SelectorFilter;

	var bg:Image;
	var textBubble:Image;
	var grandpa:Grandpa;
	var boy:Boy;
	var fire: Fire;
	var strikeImages:Array<Image>;
	
	var transitionSpeed = 0.5;
	
	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
		this.levelFile = "chapter1";
		
		introFields = [
			new TextObject("Hey Grandpa, can you tell me a story about the Great Depression?\n I have a paper to write!", Speakers.TIMMY),
			new TextObject("Sure, little Timmy, I'd love to!", Speakers.GRANDPA),
			new TextObject("Let's see...                    \nWhere to begin...?                          \nAH! I know!", Speakers.GRANDPA)
		];
		
		outroFields = [
			new TextObject("Well, that's all I've got for you today, Timmy. Good luck on your paper!", Speakers.GRANDPA),
			new TextObject("Okay Gramps.. Thanks for all of the help! See ya!", Speakers.TIMMY)
		];
		
		load();
	}
	
	public function start() {
		
		var stage = Starling.current.stage;
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;
		
		errorsSkipped = 0;
		strikes = 0;
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		bg = new Image(Root.assets.getTexture("Background"));
		grandpa = new Grandpa();
		boy = new Boy();
		fire = new Fire();
		textBubble = new Image(Root.assets.getTexture("TextBubble"));

		grandpa.x = 270;
		grandpa.y = 190;
		boy.x = 190;
		boy.y = 250;
		fire.x = 435;
		fire.y = 235;
		textBubble.x = 13;
		textBubble.y = stageHeight - 80;
		this.addChild(bg);
		this.addChild(grandpa);
		this.addChild(boy);
		this.addChild(fire);
		this.addChild(textBubble);
		
		strikeImages = new Array<Image>();
		for (i in 0...3) {
			var img = new Image(Root.assets.getTexture("StrikeGray"));
			img.x = 10 + 40 * i;
			img.y = 10;
			strikeImages.push(img);
			this.addChild(img);
		}

		rootSprite.addChild(this);
		
		textBox.x = 20;
		textBox.y = stageHeight - 70;
		textBox.fontSize = 16;
		textBox.color = 0xffffff;
		textBox.hAlign = "left";
		textBox.vAlign = "top";
		
		angryFilter = new SelectorFilter(0.25, 125.0, 10.25, 0.0);
		normalFilter = new SelectorFilter(0.0, 0.0, 10.25, 0.0);
		textBox.filter = normalFilter;
		
		this.addChild(textBox);
		
		currentField = popTextObject();
		
		startTextAnim();
		
		rootSprite.addChild(this);
		
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		animTimer.stop();
	}
	
	function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.SPACE) {
			if(animating)
				skipTextAnim();
			else if (fieldState != FieldState.CORRECTIONS) {
				if (fieldState == FieldState.CORRECTION_TRANSITION) {
					if(currentField.correct) {
						fieldState = FieldState.NO_ERROR_RESPONSE;
						addStrike();
					}
					else {
						fieldState = FieldState.CORRECTIONS;
						menuSelection = 0;
						normalFilter.selected = true;
						normalFilter.selectedLine = 0;
					}
					startTextAnim();
				}
				else
				{
					if (fieldState == FieldState.TEXT && !currentField.correct) {
						errorsSkipped++;
					}
					
					if(fieldState != FieldState.INTRO && fieldState != FieldState.OUTRO)
						fieldState = FieldState.TEXT;
					advanceField();
				}
			}
			else {
				normalFilter.selected = false;
				if (currentField.checkAnswer(menuSelection + 1))
					fieldState = FieldState.ERROR_CORRECT_RESPONSE;
				else {
					fieldState = FieldState.ERROR_INCORRECT_RESPONSE;
					errorsSkipped++;
					addStrike();
				}
				startTextAnim();
			}
		}
		else if (event.keyCode == Keyboard.C) {
			if (fieldState == FieldState.TEXT) {
				fieldState = FieldState.CORRECTION_TRANSITION;
				startTextAnim();
			}
		}
		else if (fieldState == FieldState.CORRECTIONS) {
			switch(event.keyCode) {
				case Keyboard.UP:
					menuSelection--;
					if (menuSelection < 0)
						menuSelection = 3;
				case Keyboard.DOWN:
					menuSelection++;
					if (menuSelection > 3)
						menuSelection = 0;
			}
			normalFilter.selectedLine = menuSelection;
		}
	}
	
	function onEnterFrame(event:EnterFrameEvent) {
		angryFilter.clk += waveRate * event.passedTime;
		if (fieldState == FieldState.NO_ERROR_RESPONSE || fieldState == FieldState.ERROR_INCORRECT_RESPONSE)
			textBox.filter = angryFilter;
		else
			textBox.filter = normalFilter;
	}
	
	function addStrike() {
		strikeImages[strikes].texture = Root.assets.getTexture("Strike");
		strikes++;
		if (strikes == 4) {
			
			// Exit
			var gameover = new GameOver(rootSprite, fieldProgress, fields.length, errorsSkipped, strikes);
			gameover.start();
			cleanup();
			transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});
		}
	}
	
	function advanceField() {
		currentField = popTextObject();
		if (currentField == null)
		{
			// Exit
			var gameover = new GameOver(rootSprite, fieldProgress, fields.length, errorsSkipped, strikes);
			gameover.start();
			cleanup();
			transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});
		}
		else
		{
			startTextAnim();
		}
	}
	
	function startTextAnim() {
		renderProgress = 0;
		animating = true;
		if(animTimer != null)
			animTimer.stop();
		animTimer = new Timer(25);
		animTimer.run = animationTick;
	}
	
	function skipTextAnim() {
		textBox.text = getText();
		animating = false;
		animTimer.stop();
	}
	
	function animationTick() {
		var fullText = getText();
		textBox.text = fullText.substr(0, renderProgress);
		
		if(textBox.text.substr(-2, 1) == " ") {
			soundCounter = 0;
		} else if(soundCounter == 0) {
			var st:SoundTransform = new SoundTransform(0.25, 0);
			var sc:SoundChannel = Root.assets.playSound("text_sound_2");
			sc.soundTransform = st;
		}
		soundCounter ++;
		if(soundCounter == 2)
			soundCounter = 0;

		if (renderProgress < fullText.length)
			renderProgress++;
		else {
			animTimer.stop();
			animating = false;
		}
	}
	
	function getText():String {
		var text = "";
		switch(fieldState) {
			case FieldState.TEXT: 						text = currentField.text;
			case FieldState.INTRO: 						text = currentField.text;
			case FieldState.OUTRO: 						text = currentField.text;
			case FieldState.CORRECTION_TRANSITION:		text = "No grandpa... That's not right...";
			case FieldState.CORRECTIONS: 				text = currentField.getOptionText();
			case FieldState.ERROR_CORRECT_RESPONSE:		text = currentField.revised;
			case FieldState.ERROR_INCORRECT_RESPONSE:	text = "DO YOU REALLY THINK THAT'S RIGHT, KIDDO?! REALLY!? THAT!?";
			case FieldState.NO_ERROR_RESPONSE:			text = "SONNY BOY, DON'T QUESTION ME. I WAS THERE, REMEMBER?";
		}
		
		return text;
	}
	
	function load() {
		
		var byteArray = Root.assets.getByteArray(this.levelFile);
		var bytes = Bytes.ofData(byteArray);
		var bi = new BytesInput(bytes);
		
		var fields = new Array<TextObject>();
		try {
			while (true) {
				var field = new TextObject();
				field.correct = bi.readLine() == "C";
				field.text = bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine();
				if(!field.correct) {
					field.options = new Array<String>();
					field.options.push(bi.readLine().substr(3));
					field.options.push(bi.readLine().substr(3));
					field.options.push(bi.readLine().substr(3));
					field.options.push(bi.readLine().substr(3));
					field.revised = bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine() + "\n" + bi.readLine();
				}
				fields.push(field);
			}
		} catch (e:Eof) { }
		
		bi.close();
		
		this.fields = fields;
		
	}
	
	function popTextObject():TextObject {
		
		var fields = this.fields;
		if (fieldState == FieldState.INTRO)
			fields = introFields;
		else if (fieldState == FieldState.OUTRO)
			fields = outroFields;
		
		renderProgress = 0;
		if(fieldProgress < fields.length)
			return fields[fieldProgress++];
		else {
			
			if (fieldState == FieldState.INTRO) {
				fieldState = FieldState.TEXT;
				fieldProgress = 0;
				return popTextObject();
			}
			else if (fieldState != FieldState.OUTRO) {
				fieldState = FieldState.OUTRO;
				fieldProgress = 0;
				return popTextObject();
			}
			
		}
		return null;
		
	}
	
	

	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionSpeed, Transitions.EASE_IN_OUT);
		t.animate("alpha", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
}

enum FieldState {
	TEXT;
	CORRECTION_TRANSITION;
	CORRECTIONS;
	NO_ERROR_RESPONSE;
	ERROR_CORRECT_RESPONSE;
	ERROR_INCORRECT_RESPONSE;
	INTRO;
	OUTRO;
}