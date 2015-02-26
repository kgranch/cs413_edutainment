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

    public var grandpaArt:MovieClip;
	
    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function onAddedToStage(event:Event)
    {
		
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
    }

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
    /*
	public function transitionF(game:Game){
		game.removeChild(grandpaArt);
		fart();
	}
    */
	public function sit()
    {

        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaOrig"));
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	public function scratch()
    {
        var scratch:Sound = Root.assets.getSound("scratch_sound_3");
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaScratch_"), 5);
		grandpaArt.smoothing = "none";
        grandpaArt.loop = true;
        grandpaArt.addFrameAt(7,Root.assets.getTexture("GrandpaScratch_01"));    // adds the 1st frame to the end so his hand comes back down
        grandpaArt.setFrameDuration(7, 40);                                     // sets this last frame to last 60 seconds, then loops from the start
        grandpaArt.setFrameDuration(0,30);
        grandpaArt.setFrameSound(2, scratch);
        grandpaArt.setFrameSound(3, scratch);
        grandpaArt.setFrameSound(4, scratch);
        grandpaArt.setFrameSound(5, scratch);
        grandpaArt.setFrameSound(6, scratch);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	public function snore()
    {

        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaBubble_"), 5);
		grandpaArt.smoothing = "none";
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
		Root.assets.playSound("snore_sound_2");

    }
    public function fart()
    {
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaFart_"), 15);
		grandpaArt.smoothing = "none";
        grandpaArt.addFrameAt(9, Root.assets.getTexture("GrandpaMad"));
        grandpaArt.setFrameDuration(9, 1);
        grandpaArt.addFrameAt(10, Root.assets.getTexture("GrandpaOrig"));
        grandpaArt.loop = false;
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
		Root.assets.playSound("fart_sound_1");
    }
}