import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

class Boy extends Sprite
{

    private var boyArt:MovieClip;

    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event)
    {

        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        scratch();
    }

    private function scratch()
    {
        boyArt = new MovieClip(Root.assets.getTextures("Boy_"), 6);
		boyArt.smoothing = "none";
        starling.core.Starling.juggler.add(boyArt);
        this.addChild(boyArt);

    }
}