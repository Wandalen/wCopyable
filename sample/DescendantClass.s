( function _DescendantClass_s_(){

'use strict';

if( typeof module !== 'undefined' )
require( './BaseClass.s' );

// --
// constructor
// --

var _ = wTools;
var Parent = BaseClass;
var Self = function DescendantClass()
{
  return _.workpiece.construct( Self, this, arguments );
}

// --
// routines
// --

/* optional method to initialize instance with options */

function init( o )
{
  var self = this; /* context */

  Parent.prototype.init.call( self,o ); /* ancesotr will take care */

}

//

/* override method print */

function print()
{
  var self = this;

  /* print of ancestor */

  Parent.prototype.print.call( self );

  console.log( self.name,'descendant','b :',self.b );

}

// --
// relationships
// --

var Composes =
{
  b : 1,
}

// --
// proto
// --

var Proto =
{

  init : init,
  print : print,

  Composes : Composes,

}

/* make class */

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

/* no need mixin wCopyable again, ancestor has it */

/* make the class global */

_global_[ Self.name ] = Self;

})();
