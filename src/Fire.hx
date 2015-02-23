import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;


class Fire extends Sprite
{

    private var fireArt:MovieClip;

    public function new()
    {
        super();
        this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event)
    {

        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        animate();
    }

    private function animate()
    {
        fireArt = new MovieClip(Root.assets.getTextures("Fire_"), 6);
        starling.core.Starling.juggler.add(fireArt);
        this.addChild(fireArt);

    }
}