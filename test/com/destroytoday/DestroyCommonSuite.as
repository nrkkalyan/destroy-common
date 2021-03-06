package com.destroytoday
{
	import com.destroytoday.async.PromiseTest;
	import com.destroytoday.data.ArrayListTest;
	import com.destroytoday.data.ProgressTest;
	import com.destroytoday.display.MeasuredSpriteTest;
	import com.destroytoday.error.LoadErrorTest;
	import com.destroytoday.error.LocalErrorTest;
	import com.destroytoday.invalidation.InvalidatingSpriteTest;
	import com.destroytoday.invalidation.InvalidationFlagManagerTest;
	import com.destroytoday.invalidation.InvalidationManagerTest;
	import com.destroytoday.net.StringLoaderTest;
	import com.destroytoday.net.XMLLoaderTest;
	import com.destroytoday.object.ObjectMapTest;
	import com.destroytoday.object.ObjectPoolTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class DestroyCommonSuite
	{
		public var promiseTest:PromiseTest;
		
		public var invalidationManagerTest:InvalidationManagerTest;
		public var invalidatingSpriteTest:InvalidatingSpriteTest;
		public var invalidationFlagManagerTest:InvalidationFlagManagerTest;
		
		public var objectMapTest:ObjectMapTest;
		public var objectPoolTest:ObjectPoolTest;
		
		public var arrayListTest:ArrayListTest;
		public var progressTest:ProgressTest;
		
		public var localErrorTest:LocalErrorTest;
		public var loadErrorTest:LoadErrorTest;
		
		public var measuredSprite:MeasuredSpriteTest;
		
		public var stringLoaderTest:StringLoaderTest;
		public var xmlLoaderTest:XMLLoaderTest;
	}
}