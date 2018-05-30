
if( typeof module !== 'undefined' )
require( './BaseClass.s' );

var base1 = new BaseClass({ name : 'base1', a : 11 });

base1.print();
// base1 a : 11
base1.staticFunction();
// base1 static function called as method
BaseClass.staticFunction();
// BaseClass static function called as static
console.log();

var base2 = base1.clone();
base2.name = 'base2';
base1.a = 13;

base1.print();
// base1 a : 13
base2.print();
// base2 a : 11
console.log();

base2.copy( base1 );

base1.print();
// base1 a : 13
base2.print();
// base1 a : 13
console.log();
