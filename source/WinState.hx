package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState for the win condition
 */
class WinState extends FlxState
{
	private var _winText:FlxText;
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
		_winText = new FlxText(150, 150, 150, "The Gods are happy with your sacrifice. You get double rainbows and your crops prosper. You win.", 10);
		add(_winText);
		_btnPlay = new FlxButton(175, 250, "Play again", clickPlay);
		add(_btnPlay);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		_winText = null;
		_btnPlay = null;
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}

