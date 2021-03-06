package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _textIntro:FlxText;
	private var _btnPlay:FlxButton;

	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_textIntro = new FlxText(150, 150, 0, "Bringing In The Rain", 10);
		//add(_textIntro);
		_btnPlay = new FlxButton(175, 200, "Play", clickPlay);
		//add(_btnPlay);
		var tabletSprite = new LevelObject("tablet_large.png", 324, 264);
		tabletSprite.x = 36;
		tabletSprite.y = 20;
		add(tabletSprite);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		_textIntro = null;
		_btnPlay = null;
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.ANY)
			FlxG.switchState(new PlayState());
		super.update();
	}	
}
