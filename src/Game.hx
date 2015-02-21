import starling.display.Sprite;
import starling.core.Starling;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;

import haxe.Timer;

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var levelFile:String;
	
	var fieldProgress = 0; // Determines what textobject should be popped next
	var fields:Array<TextObject>; // All of the textobject fields
	
	var currentField:TextObject;
	var renderProgress = 0; // How far in rendering the text animation we are (in characters)
	
	var animTimer:Timer;
	
	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
		this.levelFile = "chapter1";
		load();
	}
	
	public function start() {
		
		rootSprite.addChild(this);
		
		currentField = popTextObject();
		
		animTimer = new Timer(10);
		animTimer.run = animationTick;
		
	}
	
	function animationTick() {
		
		trace("\n" + currentField.text.substr(0, renderProgress));
		
		if (renderProgress < currentField.text.length)
			renderProgress++;
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
				field.options.push(bi.readLine());
				field.options.push(bi.readLine());
				field.options.push(bi.readLine());
				field.options.push(bi.readLine());
				fields.push(field);
				trace("Added field.");
			}
		} catch (e:Eof) { }
		
		trace("\n" + fields[0].text);
		
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