// |reftest| skip-if(!this.hasOwnProperty("TypedObject"))
var BUGNUMBER = 578700;
var summary = 'TypedObjects ArrayType implementation';

function assertThrows(f) {
    var ok = false;
    try {
        f();
    } catch (exc) {
        ok = true;
    }
    if (!ok)
        throw new TypeError("Assertion failed: " + f + " did not throw as expected");
}

var ArrayType = TypedObject.ArrayType;
var uint8 = TypedObject.uint8;
var float32 = TypedObject.float32;
var uint32 = TypedObject.uint32;

function runTests() {
    print(BUGNUMBER + ": " + summary);

    assertEq(typeof ArrayType.prototype.prototype.forEach == "function", true);

    assertThrows(() => ArrayType(uint8, 10));
    assertThrows(() => new ArrayType());
    assertThrows(() => new ArrayType(""));
    assertThrows(() => new ArrayType(5));
    assertThrows(() => new ArrayType(uint8).dimension(-1));
    var A = new ArrayType(uint8, 10);
    //assertEq(A.__proto__.__proto__, ArrayType.prototype);
    assertEq(A.length, 10);
    assertEq(A.elementType, uint8);
    assertEq(A.byteLength, 10);
    if (Object.prototype.toSource) {
        assertEq(A.toSource(), "new ArrayType(uint8, 10)");
    }

    //assertEq(A.prototype.__proto__.__proto__, ArrayType.prototype.prototype);

    var a = new A();
    assertEq(a.__proto__, A.prototype);
    assertEq(a.length, 10);

    assertThrows(() => a.length = 2);

    for (var i = 0; i < a.length; i++)
        a[i] = i*2;

    for (var i = 0; i < a.length; i++)
        assertEq(a[i], i*2);

    a.forEach(function(val, i) {
        assertEq(val, i*2);
        assertEq(arguments[2], a);
    });

    // Range.
    assertThrows(() => a[i] = 5);

    assertEq(a[a.length], undefined);

    // constructor takes initial value
    var b = new A(a);
    for (var i = 0; i < a.length; i++)
        assertEq(b[i], i*2);


    var b = new A([0, 1, 0, 1, 0, 1, 0, 1, 0, 1]);
    for (var i = 0; i < b.length; i++)
        assertEq(b[i], i%2);

    assertThrows(() => new A(5));
    assertThrows(() => new A(/fail/));
    // Length different
    assertThrows(() => new A([0, 1, 0, 1, 0, 1, 0, 1, 0]));

    var Vec3 = new ArrayType(float32, 3);
    var Sprite = new ArrayType(Vec3, 3); // say for position, velocity, and direction
    assertEq(Sprite.elementType, Vec3);
    assertEq(Sprite.elementType.elementType, float32);


    var mario = new Sprite();
    // setting using binary data
    mario[0] = new Vec3([1, 0, 0]);
    // setting using JS array conversion
    mario[1] = [1, 1.414, 3.14];

    assertEq(mario[0].length, 3);
    assertEq(mario[0][0], 1);
    assertEq(mario[0][1], 0);
    assertEq(mario[0][2], 0);

    assertThrows(() => mario[1] = 5);
    mario[1][1] = {};
    assertEq(Number.isNaN(mario[1][1]), true);

    // ok this is just for kicks
    var AllSprites = new ArrayType(Sprite, 65536);
    var as = new AllSprites();
    assertEq(as.length, 65536);

    var indexPropDesc = Object.getOwnPropertyDescriptor(as, '0');
    assertEq(typeof indexPropDesc == "undefined", false);
    assertEq(indexPropDesc.configurable, false);
    assertEq(indexPropDesc.enumerable, true);
    assertEq(indexPropDesc.writable, true);

    var lengthPropDesc = Object.getOwnPropertyDescriptor(as, 'length');
    assertEq(typeof lengthPropDesc == "undefined", false);
    assertEq(lengthPropDesc.configurable, false);
    assertEq(lengthPropDesc.enumerable, false);
    assertEq(lengthPropDesc.writable, false);

    var counter = 0;
    for (var nm in as) {
      assertEq(+nm, counter++);
    }
    assertEq(counter, as.length);

    assertThrows(() => Object.defineProperty(o, "foo", { value: "bar" }));

    // check if a reference acts the way it should
    var AA = uint8.array(5, 5);
    var aa = new AA();
    var aa0 = aa[0];
    aa[0] = [0,1,2,3,4];
    for (var i = 0; i < aa0.length; i++)
        assertEq(aa0[i], i);

    if (typeof reportCompare === "function")
        reportCompare(true, true);
    print("Tests complete");
}

runTests();
