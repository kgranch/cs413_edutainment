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
        createGrandpaArt();
    }

    private function createGrandpaArt()
    {/**
        grandpaArt = new MovieClip(Assets.getAtlas().getTextures("Grandpa"), 20);
        grandpaArt.x = Math.ceil(-grandpaArt.width/2);
        grandpaArt.y = Math.ceil(-grandpaArt.height/2);
        starling.core.Starling.juggler.add(grandpaArt);
        this.addChild(grandpaArt);
        **/
    }
}