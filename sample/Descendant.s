
if( typeof module !== 'undefined' )
require( './DescendantClass.s' );

var descendant1 = new DescendantClass({ name : 'descendant1', a : 11 });

descendant1.print();
// descendant1 a : 11
descendant1.staticFunction();
// descendant1 static function called as method
DescendantClass.staticFunction();
// DescendantClass static function called as method
console.log();

var descendant2 = descendant1.clone();
descendant2.name = 'descendant2';
descendant1.a = 13;

descendant1.print();
// descendant1 a : 13
descendant2.print();
// descendant2 a : 11
console.log();

descendant2.copy( descendant1 );

descendant1.print();
// descendant1 a : 13
descendant2.print();
// descendant1 a : 13
console.log();
