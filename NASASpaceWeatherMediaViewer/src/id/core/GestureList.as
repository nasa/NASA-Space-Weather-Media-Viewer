package id.core
{
	public class GestureList
	{
		public static var Gestures:XML =
		
		<Gestures>
		
			<Gesture type="drag">
				<TouchPoints>
					<point>1</point>
					<point>2</point>
				</TouchPoints>
				<ratio>1</ratio>
				<calculation type="dragFunction"></calculation>
				<noiseReduction>0</noiseReduction>
				<property type="x"></property>
				<value>0</value>
				<clockOn>false</clockOn>
				<clock>0</clock>
			</Gesture>
			
			
			<Gesture type="rotate">
				<TouchPoints>
					<point>2</point>
				</TouchPoints>
				<ratio>1</ratio>
				<calculation type="rotateFunction"></calculation>
				<noiseReduction>10</noiseReduction>
				<property type="rotation"></property>
				<value>0</value>
				<clockOn>false</clockOn>
				<clock>0</clock>
			</Gesture>
			
			
			<Gesture type="scale">
				<TouchPoints>
					<point>2</point>
				</TouchPoints>
				<ratio>1</ratio>
				<calculation type="scaleFunction"></calculation>
				<noiseReduction>.05</noiseReduction>
				<property type="scaleX"></property>
				<value>0</value>
				<clockOn>false</clockOn>
				<clock>0</clock>
			</Gesture>
		
		</Gestures>;

	}

}