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
      require.resolve( toolsPath );
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

var _ = _global_.wTools;

// --
// test
// --

function fields( test )
{
  var self = this;

  test.description = 'allFields and copyableFields should act differently with instance and prototype/constructor context';

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

  var allFields =
  {
    co : 1,
    as : 1,
    ag : 1,
    re : 1,
  }

  var copyableFields =
  {
    co : 1,
    as : 1,
    ag : 1,
  }

  test.identical( BasicConstructor.allFields,allFields );
  test.identical( BasicConstructor.prototype.allFields,allFields );

  test.identical( BasicConstructor.copyableFields,copyableFields );
  test.identical( BasicConstructor.prototype.copyableFields,copyableFields );

  /* */

  var allFields =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 3,
  }

  var copyableFields =
  {
    co : 3,
    as : 3,
    ag : 3,
  }

  var instance = new BasicConstructor( allFields );

  var allFields =
  {
    co : 3,
    as : 3,
    ag : 3,
    re : 3,
  }

  test.identical( instance.allFields,allFields );
  test.identical( instance.copyableFields,copyableFields );

}

// --
// proto
// --

var Self =
{

  name : 'Copyable',
  silencing : 1,

  tests :
  {

    fields : fields,

  },

}

//

Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
