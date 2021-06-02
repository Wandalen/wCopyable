( function _Copyable_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );

  require( '../l7_mixin/Copyable.s' );

}

const _global = _global_;
const _ = _global_.wTools;

/* qqq :

  - split cases by delimeter / * * /

*/

// --
// test
// --

function fields( test )
{
  var self = this;

  test.case = 'fieldsOfRelationsGroups and fieldsOfCopyableGroups should act differently with instance and prototype/constructor context';

  function BasicConstructor( o )
  {
    _.workpiece.initFields( this );
    this.copy( o || {} );
  }

  var Composes =
  {
    co : 1,
  }

  var Associates =
  {
    as : 1,
  }

  var Aggregates =
  {
    ag : 1,
  }

  var Restricts =
  {
    re : 1,
    mr : 1,
  }

  var Medials =
  {
    me : 1,
    mr : 10,
  }

  var Statics =
  {
    st : 1,
  }

  var extend =
  {
    Composes,
    Aggregates,
    Associates,
    Medials,
    Restricts,
    Statics,
  }

  _.classDeclare
  ({
    cls : BasicConstructor,
    extend,
  });

  _.Copyable.mixin( BasicConstructor );

  var FieldsOfRelationsGroups =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 1,
    mr : 1,
  }

  var FieldsOfCopyableGroups =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  var FieldsOfTightGroups =
  {
    co : 1,
    ag : 1,
  }

  var FieldsOfInputGroups =
  {
    co : 1,
    ag : 1,
    as : 1,
    me : 1,
    mr : 10,
  }

  /* */

  var opts =
  {
    co : 3,
    as : 3,
    ag : 3,
    mr : 3,
    me : 3,
  }

  var fieldsOfRelationsGroups =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 1,
    mr : 1,
  }

  var fieldsOfCopyableGroups =
  {
    co : 3,
    as : 3,
    ag : 3,
  }

  var fieldsOfTightGroups =
  {
    co : 3,
    ag : 3
  }

  var fieldsOfInputGroups =
  {
    co : 3,
    as : 3,
    ag : 3,
    // me : 3,
    mr : 1,
  }

  var instance = new BasicConstructor( opts );

  test.identical( BasicConstructor.FieldsOfRelationsGroups, FieldsOfRelationsGroups );
  test.identical( BasicConstructor.prototype.FieldsOfRelationsGroups, FieldsOfRelationsGroups );
  test.identical( BasicConstructor.fieldsOfRelationsGroups, FieldsOfRelationsGroups );
  test.identical( BasicConstructor.prototype.fieldsOfRelationsGroups, FieldsOfRelationsGroups );
  test.identical( instance.fieldsOfRelationsGroups, fieldsOfRelationsGroups );

  test.identical( BasicConstructor.FieldsOfCopyableGroups, FieldsOfCopyableGroups );
  test.identical( BasicConstructor.prototype.FieldsOfCopyableGroups, FieldsOfCopyableGroups );
  test.identical( BasicConstructor.fieldsOfCopyableGroups, FieldsOfCopyableGroups );
  test.identical( BasicConstructor.prototype.fieldsOfCopyableGroups, FieldsOfCopyableGroups );
  test.identical( instance.fieldsOfCopyableGroups, fieldsOfCopyableGroups );

  test.identical( BasicConstructor.FieldsOfTightGroups, FieldsOfTightGroups );
  test.identical( BasicConstructor.prototype.FieldsOfTightGroups, FieldsOfTightGroups );
  test.identical( BasicConstructor.fieldsOfTightGroups, FieldsOfTightGroups );
  test.identical( BasicConstructor.prototype.fieldsOfTightGroups, FieldsOfTightGroups );
  test.identical( instance.fieldsOfTightGroups, fieldsOfTightGroups );

  test.identical( BasicConstructor.FieldsOfInputGroups, FieldsOfInputGroups );
  test.identical( BasicConstructor.prototype.FieldsOfInputGroups, FieldsOfInputGroups );
  test.identical( BasicConstructor.fieldsOfInputGroups, FieldsOfInputGroups );
  test.identical( BasicConstructor.prototype.fieldsOfInputGroups, FieldsOfInputGroups );
  test.identical( instance.fieldsOfInputGroups, fieldsOfInputGroups );

}

//

function equal( test )
{
  var self = this;

  /* */

  test.case = 'fieldsOfRelationsGroups and fieldsOfCopyableGroups should act differently with instance and prototype/constructor context';

  function BasicConstructor( o )
  {
    _.workpiece.initFields( this );
    this.copy( o || {} );
  }

  var Composes =
  {
    co : 0,
  }

  var Associates =
  {
    as : 0,
  }

  var Aggregates =
  {
    ag : 0,
  }

  var Restricts =
  {
    re : 0,
  }

  var Medials =
  {
    re : 10,
    me : 0,
  }

  var Statics =
  {
    st : 0,
  }

  var extend =
  {
    Composes,
    Aggregates,
    Associates,
    Medials,
    Restricts,
    Statics,
  }

  _.classDeclare
  ({
    cls : BasicConstructor,
    extend,
  });

  _.Copyable.mixin( BasicConstructor );

  var fieldsOfRelationsGroups =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 1,
    me : 1,
  }

  var fieldsOfCopyableGroups =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  var all1 = new BasicConstructor( fieldsOfRelationsGroups );
  var all2 = new BasicConstructor( fieldsOfRelationsGroups );
  var copyable1 = new BasicConstructor( fieldsOfCopyableGroups );
  var none1 = new BasicConstructor();

  /* */

  test.case = 'identicalWith itself';

  var expected = true;
  var got = all1.identicalWith( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.identicalWith( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.identicalWith( none1 );
  test.identical( got, expected );

  /* */

  test.case = 'equivalentWith itself';

  var expected = true;
  var got = all1.equivalentWith( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.equivalentWith( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.equivalentWith( none1 );
  test.identical( got, expected );

  /* */

  test.case = 'contains itself';

  var expected = true;
  var got = all1.contains( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.contains( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.contains( none1 );
  test.identical( got, expected );

  test.case = 'identicalWith trivial';

  var expected = true;
  var got = all1.identicalWith( all2 );
  test.identical( got, expected );

  var expected = true;
  var got = all2.identicalWith( all1 );
  test.identical( got, expected );

  test.case = 'equivalentWith trivial';

  var expected = true;
  var got = all1.equivalentWith( all2 );
  test.identical( got, expected );

  var expected = true;
  var got = all2.equivalentWith( all1 );
  test.identical( got, expected );

  test.case = 'contains trivial';

  var expected = true;
  var got = all1.contains( all2 );
  test.identical( got, expected );

  var expected = true;
  var got = all2.contains( all1 );
  test.identical( got, expected );

  test.case = 'identicalWith copyable';

  var expected = true;
  var got = all1.identicalWith( copyable1 );
  test.identical( got, expected );

  test.case = 'equivalentWith copyable';

  var expected = true;
  var got = all1.equivalentWith( copyable1 );
  test.identical( got, expected );

  test.case = 'contains copyable';

  var expected = true;
  var got = all1.contains( copyable1 );
  test.identical( got, expected );

  test.case = 'identicalWith map';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = true ;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.case = 'not identicalWith map';

  var map =
  {
    co : 1,
    as : 1,
    ag : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.case = 'not identicalWith map having redundant fields';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    x : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.case = 'not equivalentWith map having redundant fields';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    x : 5,
  }

  var expected = false;
  var got = all1.equivalentWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.equivalentWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.case = 'not contains map having redundant fields';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    x : 5,
  }

  var expected = false;
  var got = all1.contains( map );
  test.identical( got, expected );

  test.case = 'not identicalWith map having restricts';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.case = 'not contains map having restricts';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 5,
  }

  var expected = false;
  var got = all1.contains( map );
  test.identical( got, expected );

  test.case = 'identicalWith map having medials';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    me : 5,
  }

  var expected = false;
  var got = all1.identicalWith( map );
  test.identical( got, expected );

  var expected = false;
  var got = all1.identicalWith( map, { strictTyping : 0 } );
  test.identical( got, expected );

  test.case = 'contains map having medials';

  var map =
  {
    co : 1,
    as : 1,
    ag : 1,
    me : 5,
  }

  var expected = false;
  var got = all1.contains( map );
  test.identical( got, expected );

  test.case = 'contains copyable';

  var expected = true;
  var got = all1.contains( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.contains( all1 );
  test.identical( got, expected );

}

//

function identicalWithEntityIsFileProvider( test )
{
  test.case = 'two instances of provider Extract, not identical';
  var provider1 = _globals_.testing.wTools.FileProvider.Extract();
  var provider2 = _globals_.testing.wTools.FileProvider.Extract();
  var got = provider1.identicalWith( provider2 );
  test.identical( got, false );
  test.notIdentical( provider1, provider2 );

  test.case = 'instance of provider Extract, identical';
  var provider1 = _globals_.testing.wTools.FileProvider.Extract();
  var got = provider1.identicalWith( provider1 );
  test.identical( got, true );
  test.identical( provider1, provider1 );
}

//

function hasField( test )
{

  test.case = 'trivial';

  function SampleClass( o )
  {
    return _.workpiece.construct( SampleClass, this, arguments );
  }

  function init( o )
  {
    _.workpiece.initFields( this );
  }

  let Associates =
  {
    field0 : null,
  }

  let Extension =
  {
    init,
    Associates,
  }

  _.classDeclare
  ({
    cls : SampleClass,
    extend : Extension,
  });

  _.Copyable.mixin( SampleClass );

  /* */

  var sample = new SampleClass();

  test.identical( sample.hasField( 'field0' ), true );
  test.identical( sample.Self.hasField( 'field0' ), true );
  test.identical( sample.hasField( 'field1' ), false );

  sample.field0 = 1;

  test.identical( sample.hasField( 'field0' ), true );
  test.identical( sample.Self.hasField( 'field0' ), true );
  test.identical( sample.hasField( 'field1' ), false );

  sample.field1 = 1;

  test.identical( sample.hasField( 'field0' ), true );
  test.identical( sample.Self.hasField( 'field0' ), true );
  test.identical( sample.hasField( 'field1' ), false );

}

//

function constructUsingSetter( test )
{
  let _ = _globals_.testing.wTools;

  let Self = testClass;

  let State = _.Blueprint
  ({
    property1 : _.define.shallow( [ 1, 1, 1 ] ),
    property2 : null
  })

  let Composes =
  {
    state : null
  }

  let Accessors =
  {
    state : 'state',
  }

  let Extension =
  {
    init,
    // '_stateSet' : _.accessor.setter.copyable({ name : 'state', maker : State.construct }),
    '_stateSet' : _.accessor.setter.copyable({ name : 'state', maker : State.make }),
    Composes,
    Accessors
  }

  _.classDeclare
  ({
    cls : Self,
    parent : null,
    extend : Extension,
  });
  _.Copyable.mixin( Self );

  let instance = new Self({ state : { property2 : 123 } });
  let expectedState = { property1 : [ 1, 1, 1 ], property2 : 123 }
  test.identical( instance.state, expectedState )

  test.identical( _.blueprint.isDefinitive( State ), true );
  test.identical( _.construction.isTyped( instance.state ), false );
  // test.identical( _.construction.isInstanceOf( instance.state, State ), false );
  // test.identical( _.blueprint.isBlueprintOf( State, instance.state ), false );
  test.identical( _.construction.isInstanceOf( instance.state, State ), _.maybe );
  test.identical( _.blueprint.isBlueprintOf( State, instance.state ), _.maybe );

  // test.identical( instance.state instanceof State.construct, false );
  // test.identical( instance.state instanceof State.Make, false ); /* Error if a prototype of the object to be checked is not an object : "Function has non-object prototype 'null' in instanceof check" */
  test.identical( Object.getPrototypeOf( instance.state ), null );
  test.identical( instance.state.constructor, undefined );
  var prototypes = _.prototype.each( instance.state );
  test.identical( prototypes.length, 1 );
  test.true( prototypes[ 0 ] === instance.state );
  test.true( !/*_.prototype.hasPrototype*/_.prototype.has( instance.state, State ) );
  test.true( _.object.isBasic( instance.state ) );
  test.true( _.mapIs( instance.state ) );
  test.true( _.aux.is( instance.state ) );
  test.true( !_.instanceIs( instance.state ) );
  test.identical( _.props.keys( instance.state ), [ 'property2', 'property1' ] );
  test.identical( _.props.allKeys( instance.state ), [ 'property2', 'property1' ] );

  function testClass( o )
  {
    return _.workpiece.construct( Self, this, arguments );
  }

  function init( o )
  {
    let self = this;
    _.workpiece.initFields( self );
    Object.preventExtensions( self );
    if( o )
    self.copy( o );
    if( !self.state )
    self.state = State.construct();
  }

}

// --
// declare
// --

const Proto =
{

  name : 'Tools.CopyableMixin',
  silencing : 1,

  tests :
  {

    fields,
    equal,
    identicalWithEntityIsFileProvider,

    hasField,

    constructUsingSetter
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
