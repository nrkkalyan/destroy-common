/*
Copyright (c) 2011 Jonnie Hallman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package com.destroytoday.net
{
	import com.destroytoday.data.IProgress;
	import com.destroytoday.data.Progress;
	import com.destroytoday.object.IDisposable;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	public class StringLoader implements ILoader, IDisposable
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		protected var _statusChanged:Signal;
		
		public function get statusChanged():ISignal
		{
			return _statusChanged ||= new Signal(ILoader);
		}
		
		public function set statusChanged(value:ISignal):void
		{
			_statusChanged = value as Signal;
		}
		
		protected var _progressChanged:Signal;
		
		public function get progressChanged():ISignal
		{
			return _progressChanged ||= new Signal(ILoader);
		}
		
		public function set progressChanged(value:ISignal):void
		{
			_progressChanged = value as Signal;
		}
		
		protected var _completed:Signal;
		
		public function get completed():ISignal
		{
			return _completed ||= new Signal(ILoader);
		}
		
		public function set completed(value:ISignal):void
		{
			_completed = value as Signal;
		}
		
		protected var _failed:Signal;
		
		public function get failed():ISignal
		{
			return _failed ||= new Signal(ILoader);
		}
		
		public function set failed(value:ISignal):void
		{
			_failed = value as Signal;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var loader:URLLoader;
		
		protected var responseCode:int;
		
		protected var _status:LoadStatus = LoadStatus.IDLE;
		
		protected var _progress:Progress;
		
		protected var _result:LoadResult;
		
		protected var _error:LoadError;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function StringLoader()
		{
			createProperties();
			setupListeners();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get status():ILoadStatus
		{
			return _status;
		}
		
		protected function setStatus(value:LoadStatus):void
		{
			if (value == _status)
				return;
			
			_status = value;
			
			if (_statusChanged)
				_statusChanged.dispatch(this);
		}
		
		public function get progress():IProgress
		{
			return _progress;
		}
		
		public function get result():LoadResult
		{
			return _result;
		}
		
		public function get error():LoadError
		{
			return _error;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected Methods
		//
		//--------------------------------------------------------------------------
		
		protected function createProperties():void
		{
			loader = new URLLoader();
			_progress = new Progress();
		}
		
		protected function setupListeners():void
		{
			loader.addEventListener(Event.COMPLETE, loader_completeHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, loader_progressHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, loader_responseStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
		}
		
		protected function parseResult(data:*):*
		{
			return data;
		}
		
		protected function dispatchResult(code:int, data:*):void
		{
			_result = new LoadResult(code, data);
			
			setStatus(LoadStatus.COMPLETED);
			
			if (_completed)
				_completed.dispatch(this);
		}
		
		protected function dispatchProgress(bytesLoaded:int, bytesTotal:int):void
		{
			_progress.numLoaded = bytesLoaded;
			_progress.numTotal = bytesTotal;
			
			if (_progressChanged)
				_progressChanged.dispatch(this);
		}
		
		protected function dispatchError(id:int, code:int, description:String):void
		{
			_error = new LoadError(id, code, description);
			
			setStatus(LoadStatus.FAILED);
			
			if (_failed)
				_failed.dispatch(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Methods
		//
		//--------------------------------------------------------------------------
		
		public function load(request:URLRequest):void
		{
			clear();
			setStatus(LoadStatus.PENDING);
			
			loader.load(request);
		}
		
		public function cancel():void
		{
			if (_status == LoadStatus.PENDING)
			{
				loader.close();
				
				setStatus(LoadStatus.CANCELLED);
			}
		}
		
		public function clear():void
		{
			if (_status == LoadStatus.PENDING)
				loader.close();
			
			_status = LoadStatus.IDLE;
			_result = null;
			_error = null;
			responseCode = 0;

			_progress.dispose();
		}
		
		public function dispose():void
		{
			clear();
			
			if (_statusChanged)
				_statusChanged.removeAll();
			
			if (_progressChanged)
				_progressChanged.removeAll();
			
			if (_completed)
				_completed.removeAll();
			
			if (_failed)
				_failed.removeAll();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function loader_completeHandler(event:Event):void
		{
			dispatchResult(responseCode, parseResult(loader.data));
		}
		
		protected function loader_progressHandler(event:ProgressEvent):void
		{
			dispatchProgress(event.bytesLoaded, event.bytesTotal);
		}
		
		protected function loader_responseStatusHandler(event:HTTPStatusEvent):void
		{
			responseCode = event.status;
		}
		
		protected function loader_ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchError(event.errorID, responseCode, event.text);
		}
		
		protected function loader_securityErrorHandler(event:SecurityErrorEvent):void
		{
			dispatchError(event.errorID, responseCode, event.text);
		}
	}
}