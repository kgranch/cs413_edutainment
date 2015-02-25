import starling.display.MovieClip;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import flash.media.SoundChannel;
import flash.media.Sound;


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
        boyArt.loop = true;
        boyArt.addFrameAt(7, Root.assets.getTexture("Boy_1"));    // adds the 1st frame to the end so his hand comes back down
        boyArt.setFrameDuration(0, 10);
        boyArt.setFrameDuration(7, 30);
        starling.core.Starling.juggler.add(boyArt);
        this.addChild(boyArt);
		Root.assets.playSound("boy_scratch_sound_1");
    }
}