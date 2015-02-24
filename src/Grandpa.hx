import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

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
		sit();
		
    }

	private function sit()
    {
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaOrig"));
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        grandpaArt.advanceTime(-5);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	private function scratch()
    {
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaScratch_"), 5);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        grandpaArt.advanceTime(-5);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	private function snore()
    {
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaBubble_"), 5);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        grandpaArt.advanceTime(-5);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
    private function fart()
    {
        grandpaArt = new MovieClip(Root.assets.getTextures("GrandpaFart_"), 5);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2 + 50);
        grandpaArt.y = Math.ceil( -grandpaArt.height / 2 + 50);
		grandpaArt.smoothing = "none";
        grandpaArt.advanceTime(-5);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);

    }
	
	
	
}