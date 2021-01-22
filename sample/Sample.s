
if( typeof module !== 'undefined' )
require( 'wCopyable' );
const _ = wTools;

/* declare classes */

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

/* test instance */

var sample = new SampleClass();

console.log( 'Check new instance.' );
console.log( 'Instance has field "field0" : ', sample.hasField( 'field0' ) );
/* log : Instance has field "field0" : true */
console.log( 'Instance field Self has field "field0" : ', sample.Self.hasField( 'field0' ) );
/* log : Instance field Self has field "field0" : true */
console.log( 'Instance has field "field1" : ', sample.hasField( 'field1' ) );
/* log : Instance has field "field1" : false */

console.log( '\nAfter assigning to field0.' );
sample.field0 = 1;
console.log( 'Instance has field "field0" : ', sample.hasField( 'field0' ) );
/* log : Instance has field "field0" : true */
console.log( 'Instance field Self has field "field0" : ', sample.Self.hasField( 'field0' ) );
/* log : Instance field Self has field "field0" : true */
console.log( 'Instance has field "field1" : ', sample.hasField( 'field1' ) );
/* log : Instance has field "field1" : false */

console.log( '\nAfter assigning to field1' );
sample.field1 = 1;
console.log( 'Instance has field "field0" : ', sample.hasField( 'field0' ) );
/* log : Instance has field "field0" : true */
console.log( 'Instance field Self has field "field0" : ', sample.Self.hasField( 'field0' ) );
/* log : Instance field Self has field "field0" : true */
console.log( 'Instance has field "field1" : ', sample.hasField( 'field1' ) );
/* log : Instance has field "field1" : false */


