( function(){

'use strict';

var _ = wTools;
var _hasOwnProperty = Object.hasOwnProperty;

if( typeof module !== 'undefined' )
{
  try
  {
    require( 'wProto' );
  }
  catch( err )
  {
    require( '../component/Proto.s' );
  }
}

//

/**
 * Mixin this into prototype of another object.
 * @param {object} dst - prototype of another object.
 * @method mixin
 * @memberof wCopyable#
 */

var mixin = function( dst )
{

  var has =
  {
    constructor : 'constructor',
  }

  _.assertMapOwnAll( dst,has );
  _.assert( _hasOwnProperty.call( dst,'constructor' ),'prototype of object should has own constructor' );

  //

  _.mixin
  ({
    name : 'Copyable',
    dst : dst,
    proto : Proto,
  });

  //

  var accessor =
  {
    className : 'className',
    classIs : 'classIs',
    nickName : 'nickName',
    Parent : 'Parent',
    Self : 'Self',
  }

  var forbid =
  {
    nickname : 'nickname',
    Type : 'Type',
    type : 'type',
  }

  _.accessorReadOnly
  ({
    object : dst,
    names : accessor,
    preserveValues : 0,
    strict : 0,
  });

  _.accessorForbid
  ({
    object : dst,
    names : forbid,
    preserveValues : 0,
    strict : 0,
  });

  if( Config.debug )
  {
    if( _.routineIs( dst.isSame ) )
    _.assert( dst.isSame.length === 3 );
  }

  if( dst.finit.name === 'finitEventHandler' )
  throw _.err( 'EventHandler mixin should goes after Copyable mixin.' );

}

//

/**
 * Init functor.
 * @param {object} options - options.
 * @method init
 * @memberof wCopyable#
 */

var init = function( Prototype )
{

  var originalInit = Prototype.init;

  return function init( options )
  {
    var self = this;

/*
    _.mapExtendFiltering( _.filter.cloningSrcOwn(),self,Composes );
    _.mapExtendFiltering( _.filter.cloningSrcOwn(),self,Associates );

    if( options )
    self.copy( options );
*/

    throw _.err( 'Not implemented' );

    _.assert( _.objectIs( dst ) );

    return originalInit.apply( self,arguments );
  }

}

//
/*
var init = function( options )
{
  var self = this;

  _.mapExtendFiltering( _.filter.cloningSrcOwn(),self,Composes );
  _.mapExtendFiltering( _.filter.cloningSrcOwn(),self,Associates );

  if( options )
  self.copy( options );

}

//

var init = function( options )
{
  var self = this;

  _.mapExtendFiltering( _.filter.notAtomicCloningSrcOwn(),self,Composes );
  _.mapExtendFiltering( _.filter.notAtomicCloningSrcOwn(),self,Associates );

  if( options )
  self.copy( options );

}
*/

//

  /**
   * Object descturctor.
   * @method finit
   * @memberof wCopyable#
   */

  var finit = function()
  {
    var self = this;
    _.assert( !Object.isFrozen( self ) );
    Object.freeze( self );
  }

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @memberof wCopyable#
 */

var copy = function( src )
{
  var self = this;

  return self.copyCustom
  ({

    src : src,
    technique : 'object',

  });

}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method _copyCustom
 * @memberof wCopyable#
 */

var _empty = {};
var _copyCustom = function( o )
{
  var self = this;

  _.assert( _.objectIs( o ) );

  /* var */

  var src = o.src;
  var dst = o.dst || self;
  var dropFields = o.dropFields || _empty;

  o.proto = o.proto || Object.getPrototypeOf( self ) || dst;

  var proto = o.proto;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;

  /* verification */

  _.assertMapNoUndefine( o );
  _.assert( arguments.length == 1 );
  _.assert( src );
  _.assert( dst );
  _.assert( _.objectIs( proto ) );
  _.assert( dropFields );
  _.assert( !o.copyCustomFields || _.objectIs( o.copyCustomFields ) );
  _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Restricts );

  /* copy facets */

  var copyFacets = function( screen,cloning )
  {

    var filter;

    var filter = function( dstContainer,srcContainer,key )
    {

      if( o.dropFields )
      if( o.dropFields[ key ] !== undefined )
      return;

      var srcElement;
      if( cloning )
      {
        var cloneOptions = _.mapExtend( {},o );
        cloneOptions.src = srcContainer[ key ];
        cloneOptions.path = cloneOptions.path + '.' + key;

        delete cloneOptions.dst;
        delete cloneOptions.proto;
        delete cloneOptions.copyCustomFields;
        delete cloneOptions.dropFields;

        srcElement = _._entityClone( cloneOptions );
      }
      else
      {

        srcElement = srcContainer[ key ];

        if( o.onString && _.strIs( srcElement ) )
        srcElement = o.onString( srcElement );

        if( o.onRoutine && _.routineIs( srcElement ) )
        srcElement = o.onRoutine( srcElement );

        if( o.onBuffer && _.bufferSomeIs( srcElement ) )
        srcElement = o.onBuffer( srcElement );

      }

      dstContainer[ key ] = srcElement;

    }

    filter.functionKind = 'field-mapper';

    _._mapScreen
    ({
      filter : filter,
      screenObjects : screen,
      dstObject : dst,
      srcObjects : src,
    });

  }

  /* copy composes */

  if( o.copyComposes || o.copyConstitutes || o.copyCustomFields )
  {

    var copySource = {};
    if( o.copyCustomFields )
    _.mapExtend( copySource,o.copyCustomFields )
    if( o.copyComposes )
    _.mapExtend( copySource,Composes )

    copyFacets( copySource,true );

  }

  /* copy aggregates */

  if( o.copyAggregates )
  {

    copyFacets( Aggregates,false );

  }

  /* copy associates */

  if( o.copyAssociates )
  {

    copyFacets( Associates,false );

  }

  /* copy restricts */

  if( o.copyRestricts )
  {

    copyFacets( Restricts,false );
    throw _.err( 'not tested' );

  }

  return dst;
}

//

/**
 * Copy data from one instance to another. Customizable static function.
 * @param {object} o - options.
 * @param {object} o.Prototype - prototype of the class.
 * @param {object} o.src - src isntance.
 * @param {object} o.dst - dst isntance.
 * @param {object} o.constitutes - to constitute or not fields, should be off for serializing and on for deserializing.
 * @method copyCustom
 * @memberof wCopyable#
 */

var copyCustom = function( o )
{
  var self = this;

  _.assertMapNoUndefine( o );
  _.assertMapOnly( o,copyCustom.defaults );
  _.mapSupplement( o,copyCustom.defaults );
  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( o ) );

  return self._copyCustom( o );
}

copyCustom.defaults =
{

  dst : null,
  proto : null,

}

copyCustom.defaults.__proto__ = _._entityClone.defaults;

//

var copyDeserializing = function( o )
{
  var self = this;

/*
  if( o.src === undefined )
  o.src = self;

  if( o.proto === undefined )
  o.proto = self.prototype;
*/

  _.assertMapOnly( o,copyDeserializing.defaults )
  _.assertMapNoUndefine( o );
  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( o ) );

  var optionsMerging = {};
  optionsMerging.src = o;
  optionsMerging.proto = Object.getPrototypeOf( self );
  optionsMerging.dst = self;

  debugger;
  var result = _.entityCloneObjectMergingBuffers( optionsMerging );
  debugger;

  return result;
}

copyDeserializing.defaults =
{
  descriptorsMap : null,
  buffer : null,
  data : null,
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneObject
 * @memberof wCopyable#
 */

var cloneObject = function( o )
{
  var self = this;
  var o = o || {};

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.mapComplement( o,cloneObject.defaults );
  _.assertMapOnly( o,cloneObject.defaults );

  if( o.src === undefined )
  o.src = self;

  if( o.proto === undefined )
  o.proto = Object.getPrototypeOf( o.src );

  /**/

  if( !o.dst )
  {

    var standard = 1;
    standard &= o.copyComposes;
    standard &= o.copyAggregates;
    standard &= o.copyAssociates;
    standard &= !o.copyRestricts;
    standard &= !o.copyCustomFields || Object.keys( o.copyCustomFields ) === 0;
    standard &= !o.dropFields || Object.keys( o.dropFields ) === 0;

    if( !standard )
    {
      debugger;
      o.dst = new self.constructor();
    }

  }

  /**/

  if( o.proto === undefined )
  o.proto = Object.getPrototypeOf( self );

  if( !o.dst )
  {

    o.dst = new self.constructor( self );
    if( o.dst === self )
    {
      o.dst = new self.constructor();
      o.dst._copyCustom( o );
    }

  }
  else
  {

    o.dst._copyCustom( o );

  }

  return self._copyCustom( o );
}

cloneObject.defaults =
{
  technique : 'object',
}

cloneObject.defaults.__proto__ = copyCustom.defaults;

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneData
 * @memberof wCopyable#
 */

var cloneData = function( o )
{
  var self = this;
  var o = o || {};

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  if( o.proto === undefined )
  o.proto = Object.getPrototypeOf( o.src );

  _.mapComplement( o,cloneData.defaults );
  _.assertMapOnly( o,cloneData.defaults );

  return self._copyCustom( o );
}

cloneData.defaults =
{

  dst : {},
  copyAssociates : false,
  technique : 'data',

}

cloneData.defaults.__proto__ = copyCustom.defaults;

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneSerializing
 * @memberof wCopyable#
 */

var cloneSerializing = function( o )
{
  var self = this;
  var o = o || {};

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  //debugger;
  var result = _.entityCloneDataSeparatingBuffers( o );
  //debugger;

  return result;
}

cloneSerializing.defaults =
{
}

cloneSerializing.defaults.__proto__ = _.entityCloneDataSeparatingBuffers.defaults;

//

/**
 * Clone instance.
 * @method clone
 * @param {object} [self] - optional destination
 * @memberof wCopyable#
 */

var clone = function( dst )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  if( !dst )
  {
    dst = new self.constructor( self );
    if( dst === self )
    {
      dst = new self.constructor();
      dst.copy( self );
    }
  }
  else
  {
    dst.copy( self );
  }

  return dst;
}

//

/**
 * Gives descriptive string of the object.
 * @method toStr
 * @memberof wCopyable#
 */
/*
var toStr = function()
{
  var self = this;
  var result = '';

  _.assert( arguments.length === 0 );

  result += self.nickName + '\n';

  var fields = _.mapScreens( self,self.Composes || {},self.Associates || {},self.Restricts || {} );
  result += _.toStr( fields );

}
*/
//

/**
 * Make sure src does not have redundant fields.
 * @param {object} src - source object of the class.
 * @method doesNotHaveRedundantFields
 * @memberof wCopyable#
 */

var doesNotHaveRedundantFields = function( src )
{
  var self = this;

  var Composes = self.Composes || {};
  var Aggregates = self.Aggregates || {};
  var Associates = self.Associates || {};
  var Restricts = self.Restricts || {};

  _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Restricts );

  return dst;
}

//

/**
 * Constitutes field.
 * @param {object} fieldName - src isntance.
 * @method _constituteField
 * @memberof wCopyable#
 */

var _constituteField = function( dst,fieldName )
{
  var self = this;
  var Prototype = Object.getPrototypeOf( self ) || options.prototype;
  var constitute = Prototype.Constitutes[ fieldName ];

  if( !constitute )
  return;

  if( dst[ fieldName ] === undefined || dst[ fieldName ] === null )
  return;

  throw _.err( 'constituting is deprecated, use getter for ' + fieldName );

  //

  var constituteIt = function( constitute,src,dstContainer,key )
  {

    if( src.Composes )
    {
      debugger;
      return;
    }

    debugger;
    _.assert( constitute.length === 1,'constitute should take single argument' );

    var n = constitute( src,self );
    if( n !== undefined )
    dstContainer[ key ] = n;
    else throw _.err( 'not tested' );

  }

  //

  if( _.objectIs( constitute ) )
  {
    throw _.err( 'deprecated' );

    for( var a in dst[ fieldName ] )
    constituteIt( constitute[ 0 ],dst[ fieldName ][ a ],dst[ fieldName ],a );

  }
  else if( _.arrayIs( constitute ) )
  {
    throw _.err( 'deprecated' );

    for( var a = 0 ; a < dst[ fieldName ].length ; a++ )
    constituteIt( constitute[ 0 ],dst[ fieldName ][ a ],dst[ fieldName ],a );

  }
  else
  {

    constituteIt( constitute,dst[ fieldName ],dst,fieldName );

  }

}

//

/**
 * Iterate through classes.
 * @param {object} classObject - class object
 * @method classEachParent
 * @memberof wCopyable#
 */

var classEachParent = function( classObject,onEach )
{

  _.assert( arguments.length === 2 );

  do
  {

    onEach.call( this,classObject );

    classObject = classObject.Parent ? classObject.Parent.prototype : null;

    if( classObject.constructor === Object )
    classObject = null;

  }
  while( classObject );

}

//

/**
 * Is this instance finited.
 * @method isFinited
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isFinited = function()
{
  var self = this;

  return Object.isFrozen( self );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method isSame
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isSame = function( src1,src2,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 3 );

  if( arguments.length === 1 )
  {
    src2 = self;
    o = {};
  }

  if( !src1 )
  return false;

  if( !src2 )
  return false;

  if( src1.constructor !== src2.constructor )
  return false;

  for( var c in src1.Composes )
  {
    if( !_.entitySame( src1[ c ],src2[ c ],o ) )
    return false;
  }

  for( var c in src1.Aggregates )
  {
    if( !_.entitySame( src1[ c ],src2[ c ],o ) )
    return false;
  }

  return true;
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method isIdentical
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isIdentical = function( src1,src2,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 3 );

  if( arguments.length === 1 )
  {
    src2 = self;
    o = {};
  }

  o.strict = 1;

  return self.isSame( src1,src2,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method isEquivalent
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isEquivalent = function( src1,src2,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 3 );

  if( arguments.length === 1 )
  {
    src2 = self;
    o = {};
  }

  o.strict = 0;

  return self.isSame( src1,src2,o );
}

//

/**
 * Nickname of the object.
 * @method _nickNameGet
 * @memberof wCopyable#
 */

var _nickNameGet = function()
{
  var self = this;
  return self.className + '( ' + ( self.key || self.name || self.id || 0 ) + ' )';
}

//

/**
 * Return own constructor.
 * @method _SelfGet
 * @memberof wCopyable#
 */

var _SelfGet = function _SelfGet()
{
  var proto = Object.getPrototypeOf( this );
  _.assert( !proto || _hasOwnProperty.call( proto, 'constructor' ) );
  return this.constructor;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @memberof wCopyable#
 */

var _ParentGet = function _ParentGet()
{
  var proto = Object.getPrototypeOf( this );
  _.assert( !proto || _hasOwnProperty.call( proto, 'constructor' ) );
  var parentProto = Object.getPrototypeOf( this.constructor.prototype );
  return parentProto ? parentProto.constructor : null;
}

//

/**
 * Return name of class constructor.
 * @method _classNameGet
 * @memberof wCopyable#
 */

var _classNameGet = function _classNameGet()
{
  _.assert( this.constructor === null || this.constructor.name || this.constructor._name );
  return this.constructor ? this.constructor.name || this.constructor._name : '';
}

//

/**
 * Is this class prototype or instance.
 * @method _classIsGet
 * @memberof wCopyable#
 */

var _classIsGet = function _classIsGet()
{
  return _hasOwnProperty.call( this, 'constructor' );
}

// --
// relationships
// --

var Composes =
{
}

var Associates =
{
}

var Restricts =
{
}

// --
// proto
// --

var Proto =
{

  finit : finit,

  _copyCustom : _copyCustom,
  copyCustom : copyCustom,
  copyDeserializing : copyDeserializing,
  copy : copy,

  cloneObject : cloneObject,
  cloneData : cloneData,
  cloneSerializing : cloneSerializing,
  clone : clone,

  // _copyFieldConstituting : _copyFieldConstituting,
  // _copyFieldNotConstituting : _copyFieldNotConstituting,

  //toStr : toStr,

  doesNotHaveRedundantFields : doesNotHaveRedundantFields,
  _constituteField : _constituteField,
  classEachParent : classEachParent,

  isFinited : isFinited,

  isSame : isSame,
  isIdentical : isIdentical,
  isEquivalent : isEquivalent,

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,
  '_classNameGet' : _classNameGet,
  '_classIsGet' : _classIsGet,
  '_nickNameGet' : _nickNameGet,

  Composes : Composes,
  Associates : Associates,
  Restricts : Restricts,

}

var Self =
{

  mixin : mixin,
  Proto : Proto,

}

_.mapExtend( Self,Proto );

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_.wCopyable = wTools.Copyable = Self;

return Self;

})();
