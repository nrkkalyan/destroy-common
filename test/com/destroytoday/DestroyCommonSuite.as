package com.destroytoday
{
	import com.destroytoday.async.PromiseTest;
	import com.destroytoday.data.ArrayListTest;
	import com.destroytoday.invalidation.InvalidationManagerTest;
	import com.destroytoday.object.ObjectMapTest;
	import com.destroytoday.object.ObjectPoolTest;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class DestroyCommonSuite
	{
		public var promiseTest:PromiseTest;
		
		public var invalidationManagerTest:InvalidationManagerTest;
		
		public var objectMapTest:ObjectMapTest;
		public var objectPoolTest:ObjectPoolTest;
		
		public var arrayListTest:ArrayListTest;
	}
}