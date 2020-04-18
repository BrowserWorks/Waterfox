package japa.parser.ast.test.classes;

/**
 * Javadoc 1
 * @author Julio Vilmar Gesser
 */
public abstract class JavadocTestClass {

    ;

    /**
     * 1.1
     */
    ;

    private static int x;

    /**
     * 1.2
     */
    private int y[];

    /**
     * 1.3
     */
    @Annotation(x = 10)
    private int z;

    private static final int m(int x) {
        return 0;
    }

    /**
     * 1.4
     * @param x
     * @return
     */
    private static final int m2(int x) {
        x = 10;
        /**
         * 1.4.1
         * @author jgesser
         */
        class Teste {

            /**
             * 1.4.1.1
             */
            int x;
        }
        return 0;
    }

    /**
     * 1.5 
     */
    public JavadocTestClass() {
    }

    /**
     * 1.5 
     */
    public <O> JavadocTestClass(int x) {
    }

    /**
     * 1.6
     * init 
     */
    {
        z = 10;
    }

    /**
     * 1.6
     * init 
     */
    static {
        x = 10;
    }
}

/**
 * Javadoc 2
 */
@Deprecated
@SuppressWarnings(value = "")
abstract class Class2 {
}

/**
 * Javadoc 3
 */
;

/**
 * Javadoc 4
 */
enum Enum {

    /**
     * 4.1
     */
    item1, item2, item3, /**
     * 4.2
     */
    item4
}

/**
 * Javadoc 5
 */
@interface Annotation {

    ;

    /**
     * Javadoc 5.1
     * @return
     */
    int x();

    /**
     * Javadoc 5.2
     */
    ;
}