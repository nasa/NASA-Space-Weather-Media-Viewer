////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2010 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     IDSprite.as
//  Author:   Chris Gerber (chris(at)ideum(dot)com)
//
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package id.core
{

import id.utils.NameUtil;

import flash.display.Sprite;
import flash.utils.getQualifiedClassName;

import spark.core.SpriteVisualElement;

use namespace id_internal;

/**
 * @private
 */
public class IDSprite extends SpriteVisualElement implements IDisposable
{
	
	//include "../core/Version.as";
	
	////////////////////////////////////////////////////////////
	// Variables
	////////////////////////////////////////////////////////////
	protected var _params:Object = { };
	
	////////////////////////////////////////////////////////////
	// Constructors, Destructors, and Initializers
	////////////////////////////////////////////////////////////
	public function IDSprite() {
		super();
		
	}
	
	public function Dispose():void
	{
		for(var idx:uint=0; idx<numChildren; idx++)
		{
			var child:IDisposable = getChildAt(idx) as IDisposable;
			if (child)
			{
				child.Dispose();
			}
		}
		
		var superClass:IDisposable = super as IDisposable;
		if (superClass)
		{
			superClass.Dispose();
		}
	}

	////////////////////////////////////////////////////////////
	// Properties: Public
	////////////////////////////////////////////////////////////
	id_internal function get shortName():String { return getQualifiedClassName(this); }

	////////////////////////////////////////////////////////////
	// Methods: Public
	////////////////////////////////////////////////////////////
	id_internal function setParam(k:String, value:*):void
	{
		_params[k] = value;
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Protected
	////////////////////////////////////////////////////////////
	id_internal final function setParams(initials:Object, defaults:Object, params:Object = null):void
	{

		params ||= _params;
		for(var k:String in defaults)
		{
			
			var k_initials:* = initials && initials[k] != undefined ? initials[k] : null ;
			var value:* = k_initials || defaults[k];

			if(typeof(defaults[k]) == "object" && defaults[k].toString() == "[object Object]")
			{
				params[k] ||= new Object();
				setParams(k_initials, defaults[k], params[k]);				
			}
			else
			if(initials as XMLList)
			{
				params[k] = value == "false" ? false : value ;
			}
			else
			{
				params[k] = value;
			}
			
		}
	}
	
	////////////////////////////////////////////////////////////
	// Methods: Override
	////////////////////////////////////////////////////////////
	
	override public function toString():String
	{
		if(name.indexOf("root") != -1)
		{
			return super.toString();
		}
		else
		{
			return NameUtil.displayObjectToString(this);
		}
	}

	
}

}