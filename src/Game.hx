import starling.display.Sprite;
import starling.core.Starling;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Eof;

class Game extends Sprite
{
	
	var rootSprite:Sprite;
	var levelFile:String;
	
	public function new(root:Sprite) {
		super();
		this.rootSprite = root;
		this.levelFile = "chapter1";
		load();
	}
	
	public function start() {
		
		rootSprite.addChild(this);
		
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
		
	}
}