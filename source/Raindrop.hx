package;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

// Raindrops are effect objects that loop and animate at the end of their loop
class Raindrop extends EffectObject {

	private var speed:Float;
	public function new(X:Float=0, Y:Float=0, endX:Float=0, endY:Float=0, duration:Float=5) {
		super(X, Y, endX, endY, "", duration, "raindrop.png", 16, 16);
		animation.add("land", [0, 1, 2, 3, 4, 5], 12, false);
		speed = 1;
	}
	public override function play(animName:String=null):Void {
		reset(oldX, oldY);
		if(animName != null) {
			animation.play(animName);
		}
		FlxTween.linearMotion(this, oldX, oldY, endX, endY, duration/speed, {complete: end});
		if (sound != null) {
			this.timer.start(duration, onTimer);
			this.sound.fadeIn(0.5);
			this.sound.play();
		}
	}
	public override function end(tween:FlxTween):Void {
		animation.play("land");
		var t = new FlxTimer(0.5, replay);
	}
	private function replay(t:FlxTimer):Void {
		frame = framesData.frames[0];
		if(alive) {
			play();
		}
	}
	public function setSpeed(speed:Float):Void {
		this.speed = speed;
	}
}
