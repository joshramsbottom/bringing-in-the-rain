// Sound manager for playing sounds
package;

import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;

class SoundManager
{
	private var rainSeverity:Int = -1;
	private var rainSounds:Array<FlxSound> = new Array<FlxSound>();
	private var rainSound:FlxSound = new FlxSound();

	public function new() {
	}	

	public function playRain(severity:Int) {
		if (rainSeverity >= 0) 
			rainSounds[rainSeverity].fadeOut();
		if (severity >= 0) {
			rainSound.fadeIn();
			rainSound.play();
		}
		if (severity == -1)
			rainSounds[rainSeverity].fadeOut();
		rainSeverity = severity;
	}
}
