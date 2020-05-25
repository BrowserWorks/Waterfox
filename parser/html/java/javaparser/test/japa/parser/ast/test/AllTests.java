/*
 * Created on 11/01/2009
 */
package japa.parser.ast.test;

import junit.framework.Test;
import junit.framework.TestSuite;


/**
 * @author Julio Vilmar Gesser
 */
public class AllTests {

    public static Test suite() {
        TestSuite suite = new TestSuite("Test for japa.parser.ast.test");
        //$JUnit-BEGIN$
        suite.addTestSuite(TestAdapters.class);
        suite.addTestSuite(TestNodePositions.class);
        suite.addTestSuite(TestDumper.class);
        //$JUnit-END$
        return suite;
    }

}
