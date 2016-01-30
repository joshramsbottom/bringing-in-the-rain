package;
import flixel.tweens.FlxTween;

// Like a TiledLevelObject, except it has a start position and an end position. 
// Whenever it plays, it moves from the start to end in the given duration
class EffectObject extends TiledLevelObject {

	private var oldX:Float;
	private var oldY:Float;
	private var endX:Float;
	private var endY:Float;
	private var duration:Float;
	public function new(X:Float=0, Y:Float=0, endX:Float=0, endY:Float=0, duration:Float=5, fileName:String, width:Int, height:Int) {
		super(X, Y, fileName, width, height);
		this.oldX = X;
		this.oldY = Y;
		this.endX = endX;
		this.endY = endY;
		this.duration = duration;
	}
	public function play(animName:String=null):Void {
		reset(oldX, oldY);
		if(animName != null) {
			animation.play(animName);
		}
		FlxTween.linearMotion(this, oldX, oldY, endX, endY, duration, {complete: end});
	}
	public function end(tween:FlxTween):Void {
		//this.kill();
	}
}
