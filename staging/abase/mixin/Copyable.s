( function _Copyable_s_() {

'use strict';

var _ = wTools;
var _hasOwnProperty = Object.hasOwnProperty;

if( typeof module !== 'undefined' )
{

  if( typeof wTools === 'undefined' || !wTools.mixin )
  try
  {
    require( '../component/Proto.s' );
  }
  catch( err )
  {
    require( 'wProto' );
  }

}

//

/**
 * Mixin this into prototype of another object.
 * @param {object} constructor - constructor of class to mixin.
 * @method mixin
 * @memberof wCopyable#
 */

var mixin = function mixin( constructor )
{

  var dst = constructor.prototype;
  var has =
  {
    Composes : 'Composes',
    constructor : 'constructor',
  }

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( constructor ),'mixin expects constructor, but got',_.strPrimitiveTypeOf( constructor ) );
  _.assertMapOwnAll( dst,has );
  _.assert( _hasOwnProperty.call( dst,'constructor' ),'prototype of object should has own constructor' );

  /* */

  _.mixin
  ({
    dst : dst,
    mixin : Self,
  });

  /* instance accessors */

  var names =
  {
    Self : 'Self',
    Parent : 'Parent',
    className : 'className',
    copyableFields : 'copyableFields',

    nickName : 'nickName',
    uniqueName : 'uniqueName',
  }

  _.accessorReadOnly
  ({
    object : dst,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 1,
  });

  /* static accessors */

  var names =
  {
    Self : 'Self',
    Parent : 'Parent',
    className : 'className',
    copyableFields : 'copyableFields',
  }

  _.accessorReadOnly
  ({
    object : constructor,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
  });

  /* */

  var names =
  {
    //nickname : 'nickname',
    Type : 'Type',
    type : 'type',
  }

  _.accessorForbid
  ({
    object : dst,
    names : names,
    preserveValues : 0,
    strict : 0,
  });

  /* */

  if( Config.debug )
  {
    if( _.routineIs( dst.isSame ) )
    _.assert( dst.isSame.length === 2 || dst.isSame.length === 0 );
    if( _.routineIs( dst._isSame ) )
    _.assert( dst._isSame.length === 3 || dst.isSame.length === 0 );
  }

  /* */

  if( dst.finit.name === 'finitEventHandler' )
  throw _.err( 'EventHandler mixin should goes after Copyable mixin.' );

  if( dst._mixins[ 'EventHandler' ] )
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

    throw _.err( 'not implemented' );

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
 * Instance constructor.
 * @method init
 * @memberof wCopyable#
 */

var init = function init()
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );
}

//

/**
 * Instance descturctor.
 * @method finit
 * @memberof wCopyable#
 */

var finit = function finit()
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

  o.proto = o.proto || Object.getPrototypeOf( self );

  var proto = o.proto;
  var src = o.src;
  var dst = o.dst || self;
  var dropFields = o.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;

  /* verification */

  _.assertMapHasNoUndefine( o );
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

  if( o.copyComposes || o.copyCustomFields )
  {

    copyFacets( Composes,true );

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

  /* copyCustomFields */

  if( o.copyCustomFields )
  {

    copyFacets( o.copyCustomFields,true );

  }

  /* done */

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

  // if( o.dst === undefined )
  // o.dst = null;

  _.assertMapHasNoUndefine( o );
  _.assertMapHasOnly( o,copyCustom.defaults );
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

  _.assertMapHasAll( o,copyDeserializing.defaults )
  _.assertMapHasNoUndefine( o );
  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( o ) );

  var optionsMerging = {};
  optionsMerging.src = o;
  optionsMerging.proto = Object.getPrototypeOf( self );
  optionsMerging.dst = self;

  var result = _.entityCloneObjectMergingBuffers( optionsMerging );

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
  _.assertMapHasOnly( o,cloneObject.defaults );

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

  if( !o.src )
  o.src = self;

  if( !o.proto )
  o.proto = Object.getPrototypeOf( o.src );

  if( !o.dst )
  o.dst = {};

  _.mapComplement( o,cloneData.defaults );
  _.assertMapHasOnly( o,cloneData.defaults );

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

// --
// etc
// --

/**
 * Generate method to get descriptive string of the object.
 * @method toStr * @memberof wCopyable#
 */

var toStr_functor = function toStr_functor( gen )
{

  _.assert( arguments.length === 1 );
  _.assertMapHasOnly( gen,toStr_functor.defaults );

  if( _.arrayIs( gen.fields ) )
  gen.fields = _.mapsFlatten({ maps : gen.fields });

  return function toStr( o )
  {
    var self = this;
    var result = '';
    var o = o || {};

    _.assert( arguments.length === 0 || arguments.length === 1 );

    result += self.nickName + '\n';

    var fields = _.mapScreen( gen.fields,self );
    result += _.toStr( fields,o );

    return result;
  }

}

toStr_functor.defaults =
{
  fields : null,
}

//

/**
 * Gives descriptive string of the object.
 * @method toStr
 * @memberof wCopyable#
 */

var toStr = function( o )
{
  var self = this;
  var o = o || {};

  var result = self.toStr_functor({ fields : [ self.Composes,self.Aggregates ] }).call( self,o );

  return result;
}

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
 * @method _constituteField_deprecated
 * @memberof wCopyable#
 */

var _constituteField_deprecated = function( dst,fieldName )
{
  var self = this;
  var Prototype = Object.getPrototypeOf( self ) || options.prototype;
  var constitute = Prototype.Constitutes[ fieldName ];

  throw _.err( 'deprecated' );

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

// --
// tester
// --

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

var _isSame = function _isSame( src1,src2,o )
{

  _.assert( arguments.length === 3 );

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

var isSame = function isSame( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || {};
  _._entitySameOptions( o );

  return self._isSame( self,src,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method isIdentical
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isIdentical = function isIdentical( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || {};
  o.strict = 1;
  _._entitySameOptions( o );

  return self.isSame( src,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method isEquivalent
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isEquivalent = function isEquivalent( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || {};
  o.strict = 0;
  _._entitySameOptions( o );

  return self.isSame( src,o );
}

//

/**
 * Is context instance.
 * @method isInstance
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var isInstance = function isInstance()
{
  var self = this;

  _.assert( arguments.length === 0 );

  if( _hasOwnProperty.call( this,'constructor' ) )
  return false;
  else if( _hasOwnProperty.call( this,'prototype' ) && this.prototype )
  return false;

  return true;
}

//

/**
 * Is context prototype.
 * @method isPrototype
 * @memberof wCopyable#
 */

var isPrototype = function isPrototype()
{
  return _hasOwnProperty.call( this, 'constructor' );
}

// --
// accessor
// --

/**
 * Get map of copyable fields.
 * @method _copyableFieldsGet
 * @memberof wCopyable#
 */

var _copyableFieldsGet = function _copyableFieldsGet()
{
  var self = this;
  var result = {};

  if( self.Composes )
  _.mapExtend( result,self.Composes );
  if( self.Aggregates )
  _.mapExtend( result,self.Aggregates );
  if( self.Associates )
  _.mapExtend( result,self.Associates );

  return result;
}

//

/**
 * Return own constructor.
 * @method _SelfGet
 * @memberof wCopyable#
 */

var _SelfGet = function _SelfGet()
{
  // var isInstance = this.isInstance();
  var proto;

  if( _hasOwnProperty.call( this,'constructor' ) )
  {
    proto = this; /* proto */
  }
  else if( _hasOwnProperty.call( this,'prototype' )  )
  {
    if( this.prototype )
    proto = this.prototype; /* constructor */
    else
    proto = Object.getPrototypeOf( Object.getPrototypeOf( this ) ); /* instance behind ruotine */
  }
  else
  {
    proto = Object.getPrototypeOf( this ); /* instance */
  }

  // if( isInstance )
  // {
  //   proto = Object.getPrototypeOf( this );
  // }
  // else if( _.routineIs( this ) )
  // {
  //   proto = this.prototype;
  // }
  // else
  // {
  //   proto = this;
  // }

  _.assert( _hasOwnProperty.call( proto, 'constructor' ) );
  _.assert( _hasOwnProperty.call( proto, 'Composes' ) );
  _.assert( _hasOwnProperty.call( proto, 'Aggregates' ) );
  _.assert( _hasOwnProperty.call( proto, 'Associates' ) );
  _.assert( _hasOwnProperty.call( proto, 'Restricts' ) );

  // _.assert
  // (
  //   !proto ||
  //   _hasOwnProperty.call( proto, 'constructor' )
  //   ||
  //   (
  //     !_hasOwnProperty.call( proto, 'Composes' ) &&
  //     !_hasOwnProperty.call( proto, 'Aggregates' ) &&
  //     !_hasOwnProperty.call( proto, 'Associsates' )
  //   )
  // );

  return proto.constructor;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @memberof wCopyable#
 */

var _ParentGet = function _ParentGet()
{
  var c = _SelfGet.call( this );

  var proto = Object.getPrototypeOf( c.prototype );
  var result = proto ? proto.constructor : null;

  return result;
  // var proto = Object.getPrototypeOf( this );
  //
  // _.assert
  // (
  //   !proto ||
  //   _hasOwnProperty.call( proto, 'constructor' ) ||
  //   (
  //     !_hasOwnProperty.call( proto, 'Composes' ) &&
  //     !_hasOwnProperty.call( proto, 'Aggregates' ) &&
  //     !_hasOwnProperty.call( proto, 'Associsates' )
  //   )
  // );
  //
  // var parentProto = Object.getPrototypeOf( this.constructor.prototype );
  // return parentProto ? parentProto.constructor : null;
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
 * Nick name of the object.
 * @method _nickNameGet
 * @memberof wCopyable#
 */

var _nickNameGet = function()
{
  var self = this;
  var result = ( self.key || self.name || '' );
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( _.numberIs( self.id ) )
  result += '#id' + self.id;
  return self.className + '( ' + result + ' )';
}

//

/**
 * Unique name of the object.
 * @method _uniqueNameGet
 * @memberof wCopyable#
 */

var _uniqueNameGet = function()
{
  var self = this;
  var result = '';
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( _.numberIs( self.id ) )
  result += '#id' + self.id;
  return self.className + '( ' + result + ' )';
}

// --
// relationships
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

var Statics =
{

  isInstance : isInstance,
  isPrototype : isPrototype,

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,
  '_classNameGet' : _classNameGet,
  '_copyableFieldsGet' : _copyableFieldsGet,

}

Object.freeze( Composes );
Object.freeze( Aggregates );
Object.freeze( Associates );
Object.freeze( Restricts );

// --
// proto
// --

var Supplement =
{

  init : init,
  finit : finit,

  _copyCustom : _copyCustom,
  copyCustom : copyCustom,
  copyDeserializing : copyDeserializing,
  copy : copy,

  cloneObject : cloneObject,
  cloneData : cloneData,
  cloneSerializing : cloneSerializing,
  clone : clone,


  // etc

  toStr_functor : toStr_functor,
  toStr : toStr,
  doesNotHaveRedundantFields : doesNotHaveRedundantFields,
  _constituteField_deprecated : _constituteField_deprecated,
  classEachParent : classEachParent,


  // tester

  isFinited : isFinited,

  _isSame : _isSame,
  isSame : isSame,
  isIdentical : isIdentical,
  isEquivalent : isEquivalent,


  // accessor

  // '_copyableFieldsGet' : _copyableFieldsGet,
  // '_SelfGet' : _SelfGet,
  // '_ParentGet' : _ParentGet,
  // '_classNameGet' : _classNameGet,

  '_nickNameGet' : _nickNameGet,
  '_uniqueNameGet' : _uniqueNameGet,


  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

var Self =
{

  Supplement : Supplement,

  mixin : mixin,
  name : 'Copyable',

}

Object.setPrototypeOf( Self, Supplement );

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_.wCopyable = wTools.Copyable = Self;

return Self;

})();
