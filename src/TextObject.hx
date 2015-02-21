import starling.display.Sprite;
import starling.core.Starling;

import Sys;

class TextObject extends Sprite
{
	public var text:String;
	public var correct:Bool;
	public var options:Array<String>;
	
	var order:Array<Int>;
	
	public function new() {
		super();
	}
	
	public function getOrder():Array<Int> {
		if (order == null) {
			order = new Array<Int>();
			for (i in 0...options.length)
				order.push(i);
			
			trace(order);
			
			for (i in 0...order.length) {
				var j = Math.floor(order.length * Math.random());
				var a = order[i];
				var b = order[j];
				order[i] = b;
				order[j] = a;
			}
			
			trace(order);
		}
		
		return order;
	}
	
	public function getOptionText() {
		getOrder();
		var out = "";
		var num = 1;
		for (i in order) {
			out += num++ + ". " + options[i] + "\n";
		}
		return out;
	}
	
	public function checkAnswer(num:Int):Bool {
		return order[num - 1] == 0;
	}
}