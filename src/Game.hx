import starling.display.Sprite;
import starling.display.Image;
import starling.animation.Juggler;
import starling.events.Event;
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.core.Starling;
import starling.text.TextField;
import starling.events.KeyboardEvent;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;

import haxe.Timer;

import flash.ui.Keyboard;

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var levelFile:String;
	
	var fieldProgress = 0; // Determines what textobject should be popped next
	var fields:Array<TextObject>; // All of the textobject fields
	
	var currentField:TextObject;
	var fieldState = FieldState.TEXT;
	var renderProgress = 0; // How far in rendering the text animation we are (in characters)
	var animating = false;
	
	var animTimer:Timer;
	
	var textBox:TextField = new TextField(512, 100, "", "5x7");
	
	var bg:Image;
	var grandpa:Image;
	var boy:Image;
	var fire: Image;

	
	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
		this.levelFile = "chapter1";
		load();
	}
	
	public function start() {
		
		var stage = Starling.current.stage;
		var stageWidth:Float = Starling.current.stage.stageWidth;
		var stageHeight:Float = Starling.current.stage.stageHeight;
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

		bg = new Image(Root.assets.getTexture("Background"));
		grandpa = new Image(Root.assets.getTexture("Grandpa1"));
		boy = new Image(Root.assets.getTexture("Boy1"));
		fire = new Image(Root.assets.getTexture("Fire1"));

		grandpa.x = 270;
		grandpa.y = 190;
		boy.x = 190;
		boy.y = 250;
		fire.x = 435;
		fire.y = 255;
		this.addChild(bg);
		this.addChild(grandpa);
		this.addChild(boy);
		this.addChild(fire);

		rootSprite.addChild(this);
		
		textBox.x = 20;
		textBox.y = stageHeight - 70;
		textBox.fontSize = 16;
		textBox.color = 0xffffff;
		textBox.hAlign = "left";
		textBox.vAlign = "top";
		this.addChild(textBox);
		
		currentField = popTextObject();
		
		startTextAnim();
		
		rootSprite.addChild(this);
		
	}
	
	public function cleanup() {
		Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		animTimer.stop();
	}
	
	function onKeyDown(event:KeyboardEvent) {
		if (event.keyCode == Keyboard.SPACE) {
			if(animating)
				skipTextAnim();
			else if (fieldState != FieldState.CORRECTIONS) {
				fieldState = FieldState.TEXT;
				advanceField();
			}
		}
		else if (event.keyCode == Keyboard.C) {
			if (fieldState == FieldState.TEXT) {
				fieldState = FieldState.CORRECTIONS;
				startTextAnim();
			}
		}
		else if (fieldState == FieldState.CORRECTIONS) {
			var n = -1;
			switch(event.keyCode) {
				case Keyboard.NUMBER_1: n = 1;
				case Keyboard.NUMBER_2: n = 2;
				case Keyboard.NUMBER_3: n = 3;
				case Keyboard.NUMBER_4: n = 4;
			}
			if (n >= 0) {
				if (currentField.correct)
					fieldState = FieldState.NO_ERROR_RESPONSE;
				else if (currentField.checkAnswer(n))
					fieldState = FieldState.ERROR_CORRECT_RESPONSE;
				else
					fieldState = FieldState.ERROR_INCORRECT_RESPONSE;
				startTextAnim();
			}
		}
	}
	
	function advanceField() {
		currentField = popTextObject();
		if (currentField == null)
		{
			// Exit
			var menu = new Main(rootSprite);
			menu.start();
			cleanup();
			//transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			//});
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
		animTimer = new Timer(10);
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
			case FieldState.CORRECTIONS: 				text = currentField.getOptionText();
			case FieldState.ERROR_CORRECT_RESPONSE:		text = "Correct!";
			case FieldState.ERROR_INCORRECT_RESPONSE:	text = "Incorrect!";
			case FieldState.NO_ERROR_RESPONSE:			text = "No Errors Here!";
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
				field.options = new Array<String>();
				field.options.push(bi.readLine().substr(3));
				field.options.push(bi.readLine().substr(3));
				field.options.push(bi.readLine().substr(3));
				field.options.push(bi.readLine().substr(3));
				fields.push(field);
			}
		} catch (e:Eof) { }
		
		bi.close();
		
		this.fields = fields;
		
	}
	
	function popTextObject():TextObject {
		renderProgress = 0;
		if(fieldProgress < this.fields.length)
			return this.fields[fieldProgress++];
		return null;
		
	}
}

enum FieldState {
	TEXT;
	CORRECTIONS;
	NO_ERROR_RESPONSE;
	ERROR_CORRECT_RESPONSE;
	ERROR_INCORRECT_RESPONSE;
}