import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.ui.Keyboard;
import flash.geom.Vector3D;
import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.display.Image;
import starling.text.TextField;
import starling.text.BitmapFont;
import starling.utils.Color;
import starling.events.KeyboardEvent;
import Std;

class GameOver extends Sprite {
	
	public var rootSprite:Sprite;
	private var selection:Int;
	private var buttons:Array<TextField>;
	private var title:Image;
	private var transitionInSpeed = 2.0;
	private var transitionOutSpeed = 0.5;
	private var tween:Tween;
	public var bgcolor = 255;
	public var center = new Vector3D(Starling.current.stage.stageWidth / 2.5, Starling.current.stage.stageHeight / 2.5);
	
	var progress:Int;
	var numFields:Int;
	var errors:Int;
	var strikes:Int;
	
	var paper:Image;
	var paperHands:Image;
	var textBubble:Image;
	var gradeLetter:Image;
	
	var paperHeading:TextField;
	var paperTitle:TextField;
	var paperBody:TextField;

	public function new(rootSprite:Sprite, progress:Int, numFields:Int, errors:Int, strikes:Int) {
		this.rootSprite = rootSprite;
		this.progress = progress;
		this.numFields = numFields;
		this.errors = errors;
		this.strikes = strikes;
		super();
	}
	
	public function start() {
		
		var stageHeight = Starling.current.stage.stageHeight;
		
		this.x = 0;
		this.y = stageHeight + 20;
		
		paper = new Image(Root.assets.getTexture("GameOver"));
		this.addChild(paper);
		
		var date = Date.now();
		var headingTxt = "L. Timmy\n" +
						DateTools.format(date, "%D") + "\n" +
						"Great Depression 101";
		
		paperHeading = new TextField(200, 50, headingTxt, "5x7", 16, 0x0);
		paperHeading.vAlign = "top";
		paperHeading.hAlign = "right";
		paperHeading.x = 150;
		paperHeading.y = 40;
		this.addChild(paperHeading);
		
		paperTitle = new TextField(180, 50, "The Depression According To Gramps", "5x7", 16, 0x0);
		paperTitle.vAlign = "top";
		paperTitle.hAlign = "center";
		paperTitle.x = 175;
		paperTitle.y = 100;
		this.addChild(paperTitle);
		
		var bodyText = "    Think back to the first time you ever heard of the Great Depression. At " +
					   "first glance, the Great Depression may seem unenchanting. However, it's study " +
					   "is a necessity for any one wishing to intellectually advance beyond their childhood. " +
					   "While much has been written on its influence on contemporary living, it is impossible " +
					   "to overestimate its impact on modern thought. \n" +
					   "    Society is a simple word with a very complex definition. When blues legend 'Bare " +
					   "Foot D' remarked 'awooooh eeee only my";
		
		paperBody = new TextField(180, 200, bodyText, "5x7", 16, 0x0);
		paperBody.vAlign = "top";
		paperBody.hAlign = "left";
		paperBody.x = 175;
		paperBody.y = 130;
		this.addChild(paperBody);
		
		var score = 85;
		var gradeLookup = [
			{ g: 95, a: "A_Plus" },
			{ g: 90, a: "A" },
			{ g: 85, a: "B_Plus" },
			{ g: 80, a: "B" },
			{ g: 75, a: "C_Plus" },
			{ g: 70, a: "C" },
			{ g: 65, a: "D_Plus" },
			{ g: 60, a: "D" },
			{ g: 55, a: "F" },
			{ g: 00, a: "F_Minus" },
		];
		var texAsset = "F_Minus";
		for (i in 0...gradeLookup.length) {
			var grade = gradeLookup[i];
			if (score >= grade.g) {
				texAsset = grade.a;
				break;
			}
		}
		
		gradeLetter = new Image(Root.assets.getTexture("Letter_" + texAsset));
		gradeLetter.x = 177;
		gradeLetter.y = 35;
		this.addChild(gradeLetter);
		
		paperHands = new Image(Root.assets.getTexture("GameOverHands"));
		this.addChild(paperHands);
		
		textBubble = new Image(Root.assets.getTexture("TextBubble"));
		textBubble.x = 13;
		textBubble.y = stageHeight - 80;
		this.addChild(textBubble);
		
		Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		
		rootSprite.addChild(this);
		transitionIn();

	}
	
	private function handleInput(event:KeyboardEvent){
		
		if (event.keyCode == Keyboard.SPACE) {
			
			var menu = new Main(rootSprite);
			menu.start();
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
			transitionOut(function() {
				this.removeFromParent();
				this.dispose();
			});
		}
	}

	private function transitionOut(?callBack:Void->Void) {

		var t = new Tween(this, transitionOutSpeed, Transitions.EASE_IN_OUT);
		t.animate("y", Starling.current.stage.stageHeight + 10);
		t.onComplete = callBack;
		Starling.juggler.add(t);

	}
	
	private function transitionIn(?callBack:Void->Void) {
		
		var t = new Tween(this, transitionInSpeed, Transitions.EASE_IN_OUT);
		t.animate("y", 0);
		t.onComplete = callBack;
		Starling.juggler.add(t);
	}

    public static function deg2rad(deg:Int)
    {
        return deg / 180.0 * Math.PI;
    }
	
	public static function arithMod(n:Int, d:Int) : Int {
		
		var r = n % d;
		if (r < 0)
			r += d;
		return r;
		
	}
	
}
