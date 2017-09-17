( function _BaseClass_s_(){

'use strict';

if( typeof module !== 'undefined' )
require( 'wCopyable' );

// --
// constructor
// --

var _ = wTools;
var Parent = null;
var Self = function BaseClass()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

// --
// routines
// --

/* optional method to initialize instance with options */

function init( o )
{
  var self = this; /* context */

  _.instanceInit( self );/* extends object by fields from relationships */

  Object.preventExtensions( self ); /* disables object extending */

  if( o ) /* copy fields from options */
  self.copy( o );

}

//

/* optional method to finalize instance if it is intended to be recycled */

function finit()
{
  var self = this;

  Object.freeze( self );

}

//

function print()
{
  var self = this;

  console.log( self.name,'a :',self.a );

}

//

function staticFunction()
{
  var self = this;

  if( self === Self )
  console.log( self.name,'static function called as static' );
  else
  console.log( self.name,'static function called as method' );

}

// --
// relationships
// --

var Composes =
{
  name : '',
  a : 1,
}

var Statics =
{
  staticFunction : staticFunction,
}

// --
// proto
// --

var Proto =
{

  init : init,
  finit : finit,

  print : print,

  constructor : Self,
  Composes : Composes,
  Statics : Statics,

}

/* make class */

_.classMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

/* mixin copy/clone functionality */

wCopyable.mixin( Self );

/* make the class global */

_global_[ Self.name ] = Self;

})();
