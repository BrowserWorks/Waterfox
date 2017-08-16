from pyasn1.type import constraint, error
from pyasn1.error import PyAsn1Error
from sys import version_info
if version_info[0:2] < (2, 7) or \
   version_info[0:2] in ( (3, 0), (3, 1) ):
    try:
        import unittest2 as unittest
    except ImportError:
        import unittest
else:
    import unittest

class SingleValueConstraintTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.SingleValueConstraint(1,2)
        self.c2 = constraint.SingleValueConstraint(3,4)

    def testCmp(self): assert self.c1 == self.c1, 'comparation fails'
    def testHash(self): assert hash(self.c1) != hash(self.c2), 'hash() fails'
    def testGoodVal(self):
        try:
            self.c1(1)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(4)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class ContainedSubtypeConstraintTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ContainedSubtypeConstraint(
            constraint.SingleValueConstraint(12)
            )

    def testGoodVal(self):
        try:
            self.c1(12)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(4)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class ValueRangeConstraintTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ValueRangeConstraint(1,4)

    def testGoodVal(self):
        try:
            self.c1(1)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(-5)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class ValueSizeConstraintTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ValueSizeConstraint(1,2)

    def testGoodVal(self):
        try:
            self.c1('a')
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1('abc')
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class PermittedAlphabetConstraintTestCase(SingleValueConstraintTestCase):
    def setUp(self):
        self.c1 = constraint.PermittedAlphabetConstraint('A', 'B', 'C')
        self.c2 = constraint.PermittedAlphabetConstraint('DEF')

    def testGoodVal(self):
        try:
            self.c1('A')
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1('E')
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class ConstraintsIntersectionTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ConstraintsIntersection(
            constraint.SingleValueConstraint(4),
            constraint.ValueRangeConstraint(2, 4)
            )

    def testCmp1(self):
        assert constraint.SingleValueConstraint(4) in self.c1, '__cmp__() fails'

    def testCmp2(self):
        assert constraint.SingleValueConstraint(5) not in self.c1, \
               '__cmp__() fails'

    def testCmp3(self):
        c = constraint.ConstraintsUnion(constraint.ConstraintsIntersection(
            constraint.SingleValueConstraint(4),
            constraint.ValueRangeConstraint(2, 4)
            ))
        assert self.c1 in c, '__cmp__() fails'
    def testCmp4(self):
        c = constraint.ConstraintsUnion(
            constraint.ConstraintsIntersection(constraint.SingleValueConstraint(5))
            )
        assert self.c1 not in c, '__cmp__() fails'
        
    def testGoodVal(self):
        try:
            self.c1(4)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(-5)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class InnerTypeConstraintTestCase(unittest.TestCase):
    def testConst1(self):
        c = constraint.InnerTypeConstraint(
            constraint.SingleValueConstraint(4)
            )
        try:
            c(4, 32)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
        try:
            c(5, 32)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'
    def testConst2(self):
        c = constraint.InnerTypeConstraint(
            (0, constraint.SingleValueConstraint(4), 'PRESENT'),
            (1, constraint.SingleValueConstraint(4), 'ABSENT')
            )
        try:
            c(4, 0)
        except error.ValueConstraintError:
            raise
            assert 0, 'constraint check fails'            
        try:
            c(4, 1)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'            
        try:
            c(3, 0)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'            

# Constraints compositions

class ConstraintsIntersectionTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ConstraintsIntersection(
            constraint.ValueRangeConstraint(1, 9),
            constraint.ValueRangeConstraint(2, 5)
            )

    def testGoodVal(self):
        try:
            self.c1(3)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(0)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class ConstraintsUnionTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ConstraintsUnion(
            constraint.SingleValueConstraint(5),
            constraint.ValueRangeConstraint(1, 3)
            )

    def testGoodVal(self):
        try:
            self.c1(2)
            self.c1(5)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(-5)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

class ConstraintsExclusionTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ConstraintsExclusion(
            constraint.ValueRangeConstraint(2, 4)
            )

    def testGoodVal(self):
        try:
            self.c1(6)
        except error.ValueConstraintError:
            assert 0, 'constraint check fails'
    def testBadVal(self):
        try:
            self.c1(2)
        except error.ValueConstraintError:
            pass
        else:
            assert 0, 'constraint check fails'

# Constraints derivations

class DirectDerivationTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.SingleValueConstraint(5)
        self.c2 = constraint.ConstraintsUnion(
            self.c1, constraint.ValueRangeConstraint(1, 3)
            )

    def testGoodVal(self):
        assert self.c1.isSuperTypeOf(self.c2), 'isSuperTypeOf failed'
        assert not self.c1.isSubTypeOf(self.c2) , 'isSubTypeOf failed'
    def testBadVal(self):
        assert not self.c2.isSuperTypeOf(self.c1) , 'isSuperTypeOf failed'
        assert self.c2.isSubTypeOf(self.c1) , 'isSubTypeOf failed'

class IndirectDerivationTestCase(unittest.TestCase):
    def setUp(self):
        self.c1 = constraint.ConstraintsIntersection(
            constraint.ValueRangeConstraint(1, 30)
            )
        self.c2 = constraint.ConstraintsIntersection(
            self.c1, constraint.ValueRangeConstraint(1, 20)
            )
        self.c2 = constraint.ConstraintsIntersection(
            self.c2, constraint.ValueRangeConstraint(1, 10)
            )

    def testGoodVal(self):
        assert self.c1.isSuperTypeOf(self.c2), 'isSuperTypeOf failed'
        assert not self.c1.isSubTypeOf(self.c2) , 'isSubTypeOf failed'
    def testBadVal(self):
        assert not self.c2.isSuperTypeOf(self.c1) , 'isSuperTypeOf failed'
        assert self.c2.isSubTypeOf(self.c1) , 'isSubTypeOf failed'
        
if __name__ == '__main__': unittest.main()

# how to apply size constriants to constructed types?
