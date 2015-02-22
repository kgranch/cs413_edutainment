
package starling.filters
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import starling.textures.Texture;
	
	public class SelectorFilter extends FragmentFilter {
		
		private static const FRAGMENT_SHADER:String =
		<![CDATA[
		// Move the coordinates into a temporary register
		mov ft0, v0
		
		// Calculate Wave Effect
		// Coordinate into ft0
		add ft1.y, fc0.z, ft0.x		// Clk + Coord.X
		mul ft1.y, ft1.y, fc0.y		// Result * Frequency
		add ft1.y, ft1.y, ft0.y		// Result + Coord.Y
		sin ft1.y, ft1.y			// Sin(Result)
		mul ft1.y, ft1.y, fc0.x		// Result * Amplitude
		sub ft1.y, ft1.y, fc0.x		// Result - Amplitude
		add ft1.y, ft0.y, ft1.y		// Result + Coord.Y
		mov ft0.y, ft1.y			// Move Result to Coord.Y
		
		// Calculate Shadow Effect Coordinate
		mov ft1, ft0
		sub ft1.xy, ft1.xy, fc1.xy
		
		// Get textures at the texture coordinate and shadow coordinate
		tex ft2, ft0, fs0<2d, clamp, linear, nomip>
		tex ft3, ft1, fs0<2d, clamp, linear, nomip>
		
		// Multiply rgb of shadow by shadow.w
		mul ft3.rgba, ft3.rgba, fc1.wwwz
		
		// Add shadow
		add ft2, ft2, ft3
		
		// Move the updated texture to the output channel
		mov oc, ft2
		]]>
		
		private var parameters:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 0.005];
		private var shadow:Vector.<Number> = new <Number>[1.0, 1.0, 0.75, 0.0];
		private var shaderProgram:Program3D;
		
		private var mAmplitude:Number;
		private var mFrequency:Number;
		private var mClk:Number;
		
		public function SelectorFilter(amplitude:Number, frequency:Number, clk:Number=0.0) {
			mAmplitude = amplitude;
			mFrequency = frequency;
			mClk = clk;
			super();
		}
		
		public override function dispose():void {
			if (shaderProgram) shaderProgram.dispose();
			super.dispose();
		}
		
		protected override function createPrograms():void {
				
			shaderProgram = assembleAgal(FRAGMENT_SHADER);
		}
 
		protected override function activate(pass:int, context:Context3D, texture:Texture):void
		{
			// already set by super class:
			// 
			// vertex constants 0-3: mvpMatrix (3D)
			// vertex attribute 0:   vertex position (FLOAT_2)
			// vertex attribute 1:   texture coordinates (FLOAT_2)
			// texture 0:            input texture
			
			parameters[0] = mAmplitude / texture.height;
			parameters[1] = mFrequency;
			parameters[2] = mClk;
			
			shadow[0] = 1.0 / texture.width;
			shadow[1] = 1.0 / texture.height;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, parameters, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, shadow, 1);
			context.setProgram(shaderProgram);
		}
 
		public function get amplitude():Number { return mAmplitude; }
		public function set amplitude(value:Number):void { mAmplitude = value; }
	 
		public function get frequency():Number { return mFrequency; }
		public function set frequency(value:Number):void { mFrequency = value; }
	 
		public function get clk():Number { return mClk; }
		public function set clk(value:Number):void { mClk = value; }
	}
}