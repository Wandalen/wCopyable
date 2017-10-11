( function _Copyable_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../../Base.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  wTools.include( 'wProto' );
  wTools.include( 'wCloner' );

}

//

var _ = wTools;
var _hasOwnProperty = Object.hasOwnProperty;

//

/**
 * Mixin this into prototype of another object.
 * @param {object} cls - constructor of class to mixin.
 * @method _mixin
 * @memberof wCopyable#
 */

function _mixin( cls )
{

  var dstProto = cls.prototype;
  var has =
  {
    Composes : 'Composes',
    constructor : 'constructor',
  }

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( cls ),'mixin expects constructor, but got',_.strPrimitiveTypeOf( cls ) );
  _.assertMapOwnAll( dstProto,has );
  _.assert( _hasOwnProperty.call( dstProto,'constructor' ),'prototype of object should has own constructor' );

  /* */

  _.mixinApply
  ({
    dstProto : dstProto,
    descriptor : Self,
  });

  /* instance accessors */


  var readOnly = { readOnlyProduct : 0 };
  var names =
  {
    Self : readOnly,
    Parent : readOnly,
    className : readOnly,

    copyableFields : readOnly,
    allFields : readOnly,

    nickName : readOnly,
    uniqueName : readOnly,
  }

  _.accessorReadOnly
  ({
    object : dstProto,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* static accessors */

  var names =
  {
    Self : readOnly,
    Parent : readOnly,
    className : readOnly,
    copyableFields : readOnly,
    allFields : readOnly,
  }

  _.accessorReadOnly
  ({
    object : cls,
    names : names,
    preserveValues : 0,
    strict : 0,
    prime : 0,
    enumerable : 0,
  });

  /* */

  // var names =
  // {
  //   Type : 'Type',
  //   type : 'type',
  //   fields : 'fields',
  // }
  //
  // _.accessorForbid
  // ({
  //   object : dstProto,
  //   names : names,
  //   preserveValues : 0,
  //   strict : 0,
  // });

  /* */

  if( Config.debug )
  {

    if( _.routineIs( dstProto._equalAre ) )
    _.assert( dstProto._equalAre.length === 3 || dstProto._equalAre.length === 0 );

    if( _.routineIs( dstProto.equalWith ) )
    _.assert( dstProto.equalWith.length <= 2 );

    _.assert( dstProto._copyableFieldsGet !== _copyableFieldsStaticGet );
    _.assert( dstProto._allFieldsGet !== _allFieldsStaticGet );

    _.assert( dstProto.finit.name !== 'finitEventHandler', 'wEventHandler mixin should goes after wCopyable mixin.' );
    _.assert( !_.mixinHas( dstProto,'wEventHandler' ), 'wEventHandler mixin should goes after wCopyable mixin.' );

    _.assert( dstProto._allFieldsGet === _allFieldsGet );

  }

}

//

/**
 * Default instance constructor.
 * @method init
 * @memberof wCopyable#
 */

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
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

function finit()
{
  var self = this;
  _.instanceFinit( self );
}

//

/**
 * Is this instance finited.
 * @method finitedIs
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function finitedIs()
{
  var self = this;
  return _.instanceIsFinited( self );
}

//

/**
 * Copy data from another instance.
 * @param {object} src - another isntance.
 * @method copy
 * @memberof wCopyable#
 */

function copy( src )
{
  var self = this;

  // if( !( src instanceof self.Self || _.mapIs( src ) ) )
  // debugger;

  _.assert( arguments.length === 1,'expects single argument' );
  _.assert( src instanceof self.Self || _.mapIs( src ),'expects instance of Class or map as argument' );

  return ( self.copyCustom || copyCustom ).call( self,
  {

    src : src,
    technique : 'object',

  });

}

//

/**
 * Extend data from another instance.
 * @param {object} src - another isntance.
 * @method extend
 * @memberof wCopyable#
 */

function extend( src )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( src instanceof self.Self || _.mapIs( src ) );

  for( var s in src )
  {
    if( _.objectIs( self[ s ] ) )
    {
      if( _.routineIs( self[ s ].extend ) )
      self[ s ].extend( src[ s ] );
      else
      _.mapExtend( self[ s ],src[ s ] );
    }
    else
    {
      self[ s ] = src[ s ];
    }
  }

  return self;
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

var _empty = Object.create( null );
function _copyCustom( iteration,iterator )
{
  var self = this;

  /* var */

  iteration.proto = iteration.proto || Object.getPrototypeOf( self );

  var proto = iteration.proto;
  var src = iteration.src;
  var dst = iteration.dst = iteration.dst || self;
  var dropFields = iteration.dropFields || _empty;
  var Composes = proto.Composes || _empty;
  var Aggregates = proto.Aggregates || _empty;
  var Associates = proto.Associates || _empty;
  var Restricts = proto.Restricts || _empty;
  var Medials = proto.Medials || _empty;

  /* verification */

  // if( iteration.key === 'aOpacity' || iteration.key === 'aRadius' )
  // debugger;

  _.assertMapHasNoUndefine( iteration );
  _.assertMapHasNoUndefine( iterator );
  _.assert( arguments.length === 2 );
  _.assert( src );
  _.assert( dst );
  _.assert( proto );
  _.assert( _.strIs( iteration.path ) );
  _.assert( _.objectIs( proto ),'expects object ( proto ), but got',_.strTypeOf( proto ) );
  _.assert( !iteration.customFields || _.objectIs( iteration.customFields ) );
  _.assert( iteration.level >= 0 );
  _.assert( _.numberIs( iteration.copyingDegree ) );

  // if( _.mapIsPure( src ) )
  // debugger;

  if( _.instanceIsStandard( src ) )
  _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Restricts,'options( instance ) should not have fields' );
  else
  _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Medials,'options( map ) should not have fields' );

  // _.assertMapOwnOnly( src, Composes, Aggregates, Associates, Medials, Restricts );

  /* copy facets */

  function copyFacets( screen,copyingDegree )
  {

    _.assert( _.numberIs( copyingDegree ) );
    _.assert( iteration.dst === dst );
    _.assert( _.objectIs( screen ) || !copyingDegree );

    if( !copyingDegree )
    return;

    newIteration.screenFields = screen;
    newIteration.copyingDegree = Math.min( copyingDegree,iteration.copyingDegree );
    newIteration.instanceAsMap = 1;

    _.assert( iteration.copyingDegree === 3,'not tested' );
    _.assert( newIteration.copyingDegree === 1 || newIteration.copyingDegree === 3,'not tested' );

    if( copyingDegree === 1 )
    newIteration.copyingDegree += 1;

    _._cloneMap( newIteration,iterator );

  }

  /* */

  var newIteration = _.mapExtend( null,iteration );

  copyFacets( Composes,iterator.copyingComposes );
  copyFacets( Aggregates,iterator.copyingAggregates );
  copyFacets( Associates,iterator.copyingAssociates );
  copyFacets( _.mapScreen( Medials,Restricts ),iterator.copyingMedials );
  copyFacets( Restricts,iterator.copyingRestricts );
  copyFacets( iterator.customFields,iterator.copyingCustomFields );

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

function copyCustom( o )
{
  var self = this;

  // if( o.copyingMedials === undefined )
  // o.copyingMedials = !_.instanceIsStandard( o.src );
  //
  // _.assertMapHasNoUndefine( o );
  // _.routineOptions( copyCustom,o );
  // _.assert( _.objectIs( o ) );

  _.assert( arguments.length == 1 );

  var r = _._cloneOptions( copyCustom,o );

  return ( self._copyCustom || _copyCustom ).call( self,r.iteration,r.iterator );
}

copyCustom.defaults =
{
  dst : null,
  proto : null,
}

copyCustom.defaults.__proto__ = _._cloneOptions.defaults;

/*
{

  src : null,
  key : null,
  dst : null,
  proto : null,
  level : 0,
  path : '',
  customFields : null,
  dropFields : null,
  screenFields : null,
  instanceAsMap : 0,
  copyingDegree : 3,

  copyingComposes : 3,
  copyingAggregates : 1,
  copyingAssociates : 1,
  copyingMedials : 1,
  copyingRestricts : 0,
  copyingBuffers : 0,
  copyingCustomFields : 0,

  rootSrc : null,
  levels : 999,
  technique : null,

  onString : null,
  onRoutine : null,
  onBuffer : null,

}
*/

//

function copyDeserializing( o )
{
  var self = this;

  _.assertMapHasAll( o,copyDeserializing.defaults )
  _.assertMapHasNoUndefine( o );
  _.assert( arguments.length == 1 );
  _.assert( _.objectIs( o ) );

  var optionsMerging = Object.create( null );
  optionsMerging.src = o;
  optionsMerging.proto = Object.getPrototypeOf( self );
  optionsMerging.dst = self;
  optionsMerging.deserializing = 1;

  var result = _.cloneObjectMergingBuffers( optionsMerging );

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

function cloneObject( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.routineOptions( cloneObject,o );

  var r = _._cloneOptions( cloneObject,o );

  return self._cloneObject( r.iteration,r.iterator );
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
 * @method _cloneObject
 * @memberof wCopyable#
 */

function _cloneObject( iteration,iterator )
{
  var self = this;

  _.assert( arguments.length === 2 );

  if( !iteration.src )
  iteration.src = self;

  if( !iteration.proto )
  iteration.proto = Object.getPrototypeOf( iteration.src );

  /* */

  if( !iteration.dst )
  {

    var standard = 1;
    standard = standard && iterator.copyingComposes;
    standard = standard && iterator.copyingAggregates;
    standard = standard && iterator.copyingAssociates;
    // standard = standard && iterator.copyingMedials;
    standard = standard && !iterator.copyingRestricts;
    standard = standard && ( !iterator.customFields || Object.keys( iterator.customFields ) === 0 );
    standard = standard && ( !iterator.dropFields || Object.keys( iterator.dropFields ) === 0 );

    if( !standard )
    {
      debugger;
      iteration.dst = new self.constructor();
    }

  }

  /* */

  if( !iteration.dst )
  {

    iteration.dst = new self.constructor( self );
    if( iteration.dst === self )
    {
      debugger;
      iteration.dst = new self.constructor();
      iteration.dst._copyCustom( iteration,iterator );
    }

  }
  else
  {

    debugger;
    iteration.dst._copyCustom( iteration,iterator );

  }

  return iteration.dst;
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneData
 * @memberof wCopyable#
 */

function cloneData( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  // if( !o.src )
  // o.src = self;
  //
  // if( !iteration.proto )
  // iteration.proto = Object.getPrototypeOf( o.src );
  //
  // if( !o.dst )
  // o.dst = Object.create( null );
  //
  // _.routineOptions( cloneData,o );

  var r = _._cloneOptions( cloneData,o );

  return self._cloneData( r.iteration,r.iterator );
}

cloneData.defaults =
{

  dst : Object.create( null ),
  copyingAggregates : 3,
  copyingAssociates : 0,
  technique : 'data',

}

cloneData.defaults.__proto__ = copyCustom.defaults;

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method _cloneData
 * @memberof wCopyable#
 */

function _cloneData( iteration,iterator )
{
  var self = this;

  _.assert( arguments.length === 2 );

  if( !iteration.src )
  iteration.src = self;

  if( !iteration.proto )
  iteration.proto = Object.getPrototypeOf( iteration.src );

  if( !iteration.dst )
  iteration.dst = Object.create( null );

  return self._copyCustom( iteration,iterator );
}

//

/**
 * Clone only data.
 * @param {object} [options] - options.
 * @method cloneSerializing
 * @memberof wCopyable#
 */

function cloneSerializing( o )
{
  var self = this;
  var o = o || Object.create( null );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( o.src === undefined )
  o.src = self;

  // if( o.copyingMedials === undefined )
  // o.copyingMedials = 0;

  var result = _.cloneDataSeparatingBuffers( o );

  return result;
}

cloneSerializing.defaults =
{
}

cloneSerializing.defaults.__proto__ = _.cloneDataSeparatingBuffers.defaults;

//

/**
 * Clone instance.
 * @method clone
 * @param {object} [self] - optional destination
 * @memberof wCopyable#
 */

function clone()
{
  var self = this;

  _.assert( arguments.length === 0 );
  // _.assert( arguments.length <= 1 );

  // if( !dst )
  // {
    var dst = new self.constructor( self );
    _.assert( dst !== self );
    // if( dst === self )
    // {
    //   dst = new self.constructor();
    //   dst.copy( self );
    // }
  // }
  // else
  // {
  //   dst.copy( self );
  // }

  return dst;
}

//

function cloneOverriding( override )
{
  var self = this;

  _.assert( arguments.length <= 1 );

  if( !override )
  {
    debugger;
    var dst = new self.constructor( self );
    _.assert( dst !== self );
    // if( dst === self )
    // {
    //   dst = new self.constructor();
    //   dst.copy( self );
    // }
    return dst;
  }
  else
  {
    var src = _.mapScreen( self.Self.copyableFields,self );
    _.mapExtend( src,override );
    var dst = new self.constructor( src );
    _.assert( dst !== self && dst !== src );
    return dst;
  }

}

//

function cloneEmpty()
{
  var self = this;
  return self.clone();
}

// --
// etc
// --

/**
 * Generate method to get descriptive string of the object.
 * @method toStr * @memberof wCopyable#
 */

function toStr_functor( gen )
{

  _.assert( arguments.length === 1 );
  _.assertMapHasOnly( gen,toStr_functor.defaults );

  if( _.arrayIs( gen.fields ) )
  gen.fields = _.mapsFlatten({ maps : gen.fields });

  return function toStr( o )
  {
    var self = this;
    var result = '';
    var o = o || Object.create( null );

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

function toStr( o )
{
  var self = this;
  var o = o || Object.create( null );

  var result = self.toStr_functor({ fields : [ self.Composes,self.Aggregates ] }).call( self,o );

  return result;
}

//

// /**
//  * Constitutes field.
//  * @param {object} fieldName - src isntance.
//  * @method _constituteField_deprecated
//  * @memberof wCopyable#
//  */
//
// function _constituteField_deprecated( dst,fieldName )
// {
//   var self = this;
//   var Prototype = Object.getPrototypeOf( self ) || options.prototype;
//   var constitute = Prototype.Constitutes[ fieldName ];
//
//   throw _.err( 'deprecated' );
//
//   if( !constitute )
//   return;
//
//   if( dst[ fieldName ] === undefined || dst[ fieldName ] === null )
//   return;
//
//   throw _.err( 'constituting is deprecated, use getter for ' + fieldName );
//
//   //
//
//   function constituteIt( constitute,src,dstContainer,key )
//   {
//
//     if( src.Composes )
//     {
//       debugger;
//       return;
//     }
//
//     debugger;
//     _.assert( constitute.length === 1,'constitute should take single argument' );
//
//     var n = constitute( src,self );
//     if( n !== undefined )
//     dstContainer[ key ] = n;
//     else throw _.err( 'not tested' );
//
//   }
//
//   //
//
//   if( _.objectIs( constitute ) )
//   {
//     throw _.err( 'deprecated' );
//
//     for( var a in dst[ fieldName ] )
//     constituteIt( constitute[ 0 ],dst[ fieldName ][ a ],dst[ fieldName ],a );
//
//   }
//   else if( _.arrayIs( constitute ) )
//   {
//     throw _.err( 'deprecated' );
//
//     for( var a = 0 ; a < dst[ fieldName ].length ; a++ )
//     constituteIt( constitute[ 0 ],dst[ fieldName ][ a ],dst[ fieldName ],a );
//
//   }
//   else
//   {
//
//     constituteIt( constitute,dst[ fieldName ],dst,fieldName );
//
//   }
//
// }

// --
// tester
// --

function _equalAre_functor( functorOptions )
{
  _.assert( arguments.length <= 1 );

  functorOptions = _.routineOptions( _equalAre_functor,functorOptions || Object.create( null ) );

  return function _equalAre( src1,src2,o )
  {

    _.assert( arguments.length === 3 );

    if( !src1 )
    return false;

    if( !src2 )
    return false;

    if( o.strict && !o.contain )
    if( src1.constructor !== src2.constructor )
    return false;

    if( o.contain )
    {
      for( var c in src2 )
      {
        if( !_.entityEqual( src1[ c ],src2[ c ],o ) )
        return false;
      }
      return true;
    }

    /* */

    for( var f in functorOptions )
    if( functorOptions[ f ] )
    for( var c in src1[ f ] )
    {
      if( !_.entityEqual( src1[ c ],src2[ c ],o ) )
      return false;
    }

    return true;
  }

}

_equalAre_functor.defaults =
{
  Composes : 1,
  Aggregates : 1,
  Associates : 1,
  Restricts : 0,
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method equalWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

var _equalAre = _equalAre_functor();

//

function equalWith( ins,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( self._equalAre );

  var o = o || Object.create( null );
  _._entityEqualIteratorMake( o );

  return self._equalAre( self,ins,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method identicalWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function identicalWith( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || Object.create( null );
  o.strict = 1;
  _._entityEqualIteratorMake( o );

  return self.equalWith( src,o );
}

//

/**
 * Is this instance same with another one. Use relation maps to compare.
 * @method equivalentWith
 * @param {object} ins - another instance of the class
 * @memberof wCopyable#
 */

function equivalentWith( src,o )
{
  var self = this;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  var o = o || Object.create( null );
  o.strict = 0;
  _._entityEqualIteratorMake( o );

  return self.equalWith( src,o );
}

//

function instanceIs()
{
  _.assert( arguments.length === 0 );
  return _.instanceIs( this );
}

//

function prototypeIs()
{
  _.assert( arguments.length === 0 );
  return _.prototypeIs( this );
}

//

function constructorIs()
{
  _.assert( arguments.length === 0 );
  return _.constructorIs( this );
}

// --
// field
// --

/**
 * Get map of copyable fields.
 * @method _allFieldsGet
 * @memberof wCopyable
 */

function _allFieldsGet()
{
  var self = this;

  debugger;
  if( !self.instanceIs() )
  return _allFieldsStaticGet.call( self );

  _.assert( self.instanceIs() ); debugger;

  var result = _.mapScreen( self.Self.allFields,self );
  return result;
}

//

/**
 * Get map of copyable fields.
 * @method _copyableFieldsGet
 * @memberof wCopyable
 */

function _copyableFieldsGet()
{
  var self = this;

  if( !self.instanceIs() )
  return _copyableFieldsStaticGet.call( self );

  _.assert( self.instanceIs() );

  var result = _.mapScreen( self.Self.copyableFields,self );
  return result;
}

//

function fieldDescriptorGet( nameOfField )
{
  var proto = _.prototypeGet( this );
  var report = Object.create( null );

  _.assert( _.strIsNotEmpty( nameOfField ) );
  _.assert( arguments.length === 1 );

  debugger;

  for( var f in _.ClassAllowedFacility )
  {
    var facility = _.ClassAllowedFacility[ f ];
    if( proto[ facility ] )
    if( proto[ facility ][ nameOfField ] !== undefined )
    report[ facility ] = true;
  }

  return report;
}

//

/**
 * Get map of copyable fields.
 * @method _allFieldsStaticGet
 * @memberof wCopyable#
 */

function _allFieldsStaticGet()
{
  return _.prototypeAllFieldsGet( this );
}

//

/**
 * Get map of copyable fields.
 * @method _copyableFieldsGet
 * @memberof wCopyable#
 */

function _copyableFieldsStaticGet()
{
  return _.prototypeCopyableFieldsGet( this );
}

//

function hasField( fieldName )
{
  debugger;
  return _.prototypeHasField( this,fieldName );
}

// --
// class
// --

/**
 * Return own constructor.
 * @method _SelfGet
 * @memberof wCopyable#
 */

function _SelfGet()
{
  var result = _.constructorGet( this );
  return result;
}

//

/**
 * Return parent's constructor.
 * @method _ParentGet
 * @memberof wCopyable#
 */

function _ParentGet()
{
  var result = _.parentGet( this );
  return result;
}

// --
// name
// --

/**
 * Return name of class constructor.
 * @method _classNameGet
 * @memberof wCopyable#
 */

function _classNameGet()
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

function _nickNameGet()
{
  var self = this;
  var result = ( self.key || self.name || '' );
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( Object.hasOwnProperty.call( self,'id' ) )
  result += '#id' + self.id;
  return self.className + '( ' + result + ' )';
}

//

/**
 * Unique name of the object.
 * @method _uniqueNameGet
 * @memberof wCopyable#
 */

function _uniqueNameGet()
{
  var self = this;
  var result = '';
  var index = '';
  if( _.numberIs( self.instanceIndex ) )
  result += '#in' + self.instanceIndex;
  if( Object.hasOwnProperty.call( self,'id' ) )
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

var Medials =
{
}

var Statics =
{

  instanceIs : instanceIs,
  prototypeIs : prototypeIs,
  constructorIs : constructorIs,

  '_allFieldsGet' : _allFieldsStaticGet,
  '_copyableFieldsGet' : _copyableFieldsStaticGet,
  hasField : hasField,

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,
  '_classNameGet' : _classNameGet,

}

Object.freeze( Composes );
Object.freeze( Aggregates );
Object.freeze( Associates );
Object.freeze( Restricts );
Object.freeze( Medials );
Object.freeze( Statics );

// --
// proto
// --

var Supplement =
{

  init : init,
  finit : finit,
  finitedIs : finitedIs,

  _copyCustom : _copyCustom,
  copyCustom : copyCustom,
  copyDeserializing : copyDeserializing,
  copy : copy,
  extend : extend,

  cloneObject : cloneObject,
  _cloneObject : _cloneObject,

  cloneData : cloneData,
  _cloneData : _cloneData,

  cloneSerializing : cloneSerializing,
  clone : clone,
  cloneOverriding : cloneOverriding,
  cloneEmpty : cloneEmpty,


  // etc

  toStr_functor : toStr_functor, /* deprecated */
  toStr : toStr,

  /*assertInstanceDoesNotHaveReduntantFields : assertInstanceDoesNotHaveReduntantFields,*/
  /*_constituteField_deprecated : _constituteField_deprecated,*/


  // tester

  _equalAre_functor : _equalAre_functor,
  _equalAre : _equalAre,
  equalWith : equalWith,
  identicalWith : identicalWith,
  equivalentWith : equivalentWith,

  instanceIs : instanceIs,
  prototypeIs : prototypeIs,
  constructorIs : constructorIs,


  // field

  '_allFieldsGet' : _allFieldsGet,
  '_copyableFieldsGet' : _copyableFieldsGet,
  fieldDescriptorGet : fieldDescriptorGet,

/*
  '_allFieldsGet' : _allFieldsStaticGet,
  '_copyableFieldsGet' : _copyableFieldsStaticGet,
  hasField : hasField,
*/


  // class

  '_SelfGet' : _SelfGet,
  '_ParentGet' : _ParentGet,


  // name

  '_classNameGet' : _classNameGet,
  '_nickNameGet' : _nickNameGet,
  '_uniqueNameGet' : _uniqueNameGet,


  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Medials : Medials,
  Statics : Statics,

}

//

var Self = _.mixinMake
({
  supplement : Supplement,
  _mixin : _mixin,
  name : 'wCopyable',
  nameShort : 'Copyable',
});

//

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_.assert( !Self.copy );
_.assert( Self.prototype.copy );
_.assert( Self.nameShort );
_.assert( Self._mixin );
_.assert( Self.mixin );

})();