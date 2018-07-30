( function _Copyable_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wProto' );
  _.include( 'wCopyable' );
  _.include( 'wTesting' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// test
// --

function fields( test )
{
  var self = this;

  test.case = 'fieldsOfRelationshipsGroups and fieldsOfCopyableGroups should act differently with instance and prototype/constructor context';

  function BasicConstructor( o )
  {
    _.instanceInit( this );
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
  }

  var Medials =
  {
    re : 10,
  }

  var Statics =
  {
    st : 1,
  }

  var extend =
  {
    constructor : BasicConstructor,
    Composes : Composes,
    Aggregates : Aggregates,
    Associates : Associates,
    Medials : Medials,
    Restricts : Restricts,
    Statics : Statics,
  }

  _.classMake
  ({
    cls : BasicConstructor,
    extend : extend,
  });

  _.Copyable.mixin( BasicConstructor );

  var fieldsOfRelationshipsGroups =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 1,
  }

  var fieldsOfCopyableGroups =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  test.identical( BasicConstructor.fieldsOfRelationshipsGroups,fieldsOfRelationshipsGroups );
  test.identical( BasicConstructor.prototype.fieldsOfRelationshipsGroups,fieldsOfRelationshipsGroups );

  test.identical( BasicConstructor.fieldsOfCopyableGroups,fieldsOfCopyableGroups );
  test.identical( BasicConstructor.prototype.fieldsOfCopyableGroups,fieldsOfCopyableGroups );

  /* */

  var fieldsOfRelationshipsGroups =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 3,
  }

  var fieldsOfCopyableGroups =
  {
    co : 3,
    as : 3,
    ag : 3,
  }

  var instance = new BasicConstructor( fieldsOfRelationshipsGroups );

  var fieldsOfRelationshipsGroups =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 3,
  }

  test.identical( instance.fieldsOfRelationshipsGroups,fieldsOfRelationshipsGroups );
  test.identical( instance.fieldsOfCopyableGroups,fieldsOfCopyableGroups );

}

//

function equal( test )
{
  var self = this;

  test.case = 'fieldsOfRelationshipsGroups and fieldsOfCopyableGroups should act differently with instance and prototype/constructor context';

  function BasicConstructor( o )
  {
    _.instanceInit( this );
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
    constructor : BasicConstructor,
    Composes : Composes,
    Aggregates : Aggregates,
    Associates : Associates,
    Medials : Medials,
    Restricts : Restricts,
    Statics : Statics,
  }

  _.classMake
  ({
    cls : BasicConstructor,
    extend : extend,
  });

  _.Copyable.mixin( BasicConstructor );

  var fieldsOfRelationshipsGroups =
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

  var all1 = new BasicConstructor( fieldsOfRelationshipsGroups );
  var all2 = new BasicConstructor( fieldsOfRelationshipsGroups );
  var copyable1 = new BasicConstructor( fieldsOfCopyableGroups );
  var none1 = new BasicConstructor();

  test.case = 'identicalWith itself'; /* */

  var expected = true;
  var got = all1.identicalWith( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.identicalWith( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.identicalWith( none1 );
  test.identical( got, expected );

  test.case = 'equivalentWith itself'; /* */

  var expected = true;
  var got = all1.equivalentWith( all1 );
  test.identical( got, expected );

  var expected = true;
  var got = copyable1.equivalentWith( copyable1 );
  test.identical( got, expected );

  var expected = true;
  var got = none1.equivalentWith( none1 );
  test.identical( got, expected );

  test.case = 'contains itself'; /* */

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
  var got = all1.identicalWith( map,{ strictTyping : 0 } );
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
  var got = all1.identicalWith( map,{ strictTyping : 0 } );
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

// --
// define class
// --

var Self =
{

  name : 'Tools/base/CopyableMixin',
  silencing : 1,

  tests :
  {

    fields : fields,
    equal : equal,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
