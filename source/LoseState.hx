package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState for the lose condition
 */
class LoseState extends FlxState
{
	private var _loseText:FlxText;
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
		_loseText = new FlxText(150, 150, 150, "The Gods are angry with your sacrifice. Your village burns to the ground. Blood rains from the skies and the sharknado destroys your crops. You die.", 10);
		add(_loseText);
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
		_loseText = null;
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

