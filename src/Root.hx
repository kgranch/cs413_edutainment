import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.display.Image;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.display.Stage;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
/**
@:bitmap("assets/Sprites.png")
class GrandpaBitmap extends flash.display.BitmapData{}
@:file("assets/Sprites.xml")
class GrandpaXml extends flash.utils.ByteArray{}
**/
class Root extends Sprite {

    public static var assets:AssetManager;
    public var rootSprite:Sprite;
	public var highScore:Int;
    private var gameTextureAtlas:TextureAtlas;

	public static function init() {
		
	}
	
    public function new() {
        rootSprite = this;
        super();
    }
/**
    public function getAtlas(){
        if (gameTextureAtlas == null){
            var texture:Texture = getTexture("GrandpaBitmap");
            var xml:Xml = Xml(new GrandpaXml());
            var bitmapData = Assets.getBitmapData("Sprites.png");
            gameTextureAtlas = new TextureAtlas(texture, xml);
        }
        return gameTextureAtlas;
    }
**/
    public function start(startup:Startup) {

        assets = new AssetManager();
        assets.enqueue("assets/Sprites.png");
        assets.enqueue("assets/Sprites.xml");
        assets.enqueue("assets/Background.png");
        assets.enqueue("assets/TextBubble.png");
		assets.enqueue("assets/font/5x7.png");
		assets.enqueue("assets/font/5x7.fnt");

        // Sounds
        assets.enqueue("assets/sounds/text_sound_1.mp3");
        assets.enqueue("assets/sounds/text_sound_2.mp3");
		
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
