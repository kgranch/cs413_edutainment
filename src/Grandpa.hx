import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundChannel;
import flash.media.Sound;

class Grandpa extends Sprite
{

    private var grandpaArt:MovieClip;
	
    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event)
    {
		
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		startAnim();
		
		
    }
    /*
	public function transitionS(game:Game){
		var x =  Std.random(100);
		if(x <60 ){
			game.removeChild(grandpaArt);
			scratch();
		}
		else{
			game.removeChild(grandpaArt);
			snore();
		}
	}
	public function transitionF(game:Game){
		game.removeChild(grandpaArt);
		fart();
	}
	*/
	private function sit()
    {
    /*
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaOrig"));
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
    */
    }
	private function startAnim()
    {

        var scratch:Sound = Root.assets.getSound("scratch_sound_3");
        grandpaArt = new MovieClip(Root.assets.getTextures("Grandpa"), 5);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        grandpaArt.loop = true;
        grandpaArt.addFrameAt(7,Root.assets.getTexture("Grandpa01"));    // adds the 1st frame to the end so his hand comes back down
        grandpaArt.setFrameDuration(7, 60);                                     // sets this last frame to last 60 seconds, then loops from the start
        grandpaArt.setFrameSound(2, scratch);
        grandpaArt.setFrameSound(3, scratch);
        grandpaArt.setFrameSound(4, scratch);
        grandpaArt.setFrameSound(5, scratch);
        grandpaArt.setFrameSound(6, scratch);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	private function snore()
    {
    /*
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaBubble_"), 5);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
    */
    }
    private function fart()
    {
    /*
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaFart_"), 5);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
		Root.assets.playSound("fart_sound_1");
    */
    }
}