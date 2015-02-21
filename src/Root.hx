import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.events.EnterFrameEvent;

class Root extends Sprite {

    public static var assets:AssetManager;
    public var rootSprite:Sprite;
	public var highScore:Int;

	public static function init() {
		
	}
	
    public function new() {
        rootSprite = this;
        super();
    }
	
    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/Grandpa.png");
		assets.enqueue("assets/font/5x7.png");
		assets.enqueue("assets/font/5x7.fnt");
		
		// Levels
		assets.enqueue("assets/levels/chapter1.txt");
		
        assets.loadQueue(function onProgress(ratio:Float) {
            haxe.Log.clear();
            if (ratio == 1) {
                haxe.Log.clear();
                startup.removeChild(startup.loadingBitmap);
                var menu = new Main(rootSprite);
                menu.start();
            }

        });
		
    }
}
