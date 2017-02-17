( function _Simple_s_(){

'use strict';

if( typeof module !== 'undefined' )
require( 'wCopyable' );

//

var _ = wTools;
var Parent = function Alpha(){}
Parent.prototype.init = function(){}
Parent.prototype.methodOfAlpha = function(){ console.log( 'method of alpha' ); }

var Self = function Betta()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( this );

  _.mapExtendFiltering( _.filter.own(),self,Composes );

  if( o )
  self.copy( o );

}

//

function finit()
{
  var self = this;

  Object.freeze( self );

}

//

function methodOfBetta()
{
  var self = this;

  console.log( 'method of betta' );

}

//

function staticFunction()
{

  if( this === Self )
  console.log( 'static function called as static' );
  else
  console.log( 'static function called as method' );

}

//

var Composes =
{
  a : 1,
  b : 2,
}

var Statics =
{

  staticFunction : staticFunction,

}

//

var Proto =
{

  init: init,
  finit: finit,

  methodOfBetta: methodOfBetta,

  constructor: Self,
  Composes: Composes,
  Statics : Statics,

}

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );

_global_.Alpha = Parent;
_global_.Betta = Self;

//

var betta = new Betta({ a : 11 });

betta.methodOfAlpha();
betta.methodOfBetta();

betta.staticFunction();
Betta.staticFunction();

console.log( 'betta.a : ' + betta.a );
console.log( 'betta.b : ' + betta.b );

var betta2 = betta.clone();

console.log( 'betta2.a : ' + betta2.a );
console.log( 'betta2.b : ' + betta2.b );

})();
