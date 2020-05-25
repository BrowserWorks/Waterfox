package ignore;

import japa.parser.JavaParser;
import japa.parser.ParseException;

import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;

/*
 * Created on 14/10/2007
 */

/**
 * @author Julio Vilmar Gesser
 */
public class TestRunner {

    private static final File ROOT = // 
    new File("D:/Downloads/openjdk-7-ea-src-b27-22_may_2008/openjdk/langtools/test/tools/javac" //
    //"C:/Documents and Settings/jgesser/Desktop/openjdk-7-ea-src-b27-22_may_2008/openjdk" //
    //"C:/Documents and Settings/jgesser/Desktop/openjdk-6-src-b09-11_apr_2008/jdk" //
    );

    public static void main(String[] args) {
        new TestRunner().run();
    }

    private void visitAllJavaFiles(FileFilter callback, File dir) {
        File[] listFiles = dir.listFiles(new FileFilter() {

            public boolean accept(File file) {
                return file.isDirectory() || file.getName().endsWith(".java");
            }

        });
        if (listFiles != null) {
            for (File element : listFiles) {
                if (element.isDirectory()) {
                    visitAllJavaFiles(callback, element);
                } else {
                    callback.accept(element);
                }
            }
        }
    }

    int runCount = 0;

    long runTime = 0;

    public void run() {
        visitAllJavaFiles(new FileFilter() {

            public boolean accept(File javaFile) {
                //System.out.println("Visiting file: " + javaFile.getPath());
                try {
                    runTest(javaFile);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
                return false;
            }

        }, ROOT);

        System.out.println("Compiled " + runCount + " in " + runTime + " ms, avarage of " + (((double) runTime) / runCount));
    }

    private void runTest(File javaFile) throws IOException {

        //        try {
        //            JavaParser.parse(javaFile);
        //        } catch (ParseException e) {
        //            System.out.println("<<error>> " + e.getMessage());
        //        }

        StringBuilder buf = new StringBuilder();
        try {
            FileInputStream in = new FileInputStream(javaFile);
            try {
                int i;
                while ((i = in.read()) >= 0) {
                    buf.append((char) i);
                }
            } finally {
                in.close();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        if (buf.indexOf("@test") < 0) {
            return;
            //            System.out.println("Skiping file: " + javaFile.getPath());
        }
        boolean fail = false;
        //        if (buf.indexOf("@compile ") == -1) {
        //            fail = buf.indexOf("compile/fail") >= 0;
        //        }
        if (!(buf.indexOf("@compile ") >= 0 && buf.indexOf("compile/fail") < 0)) {
            return;
        }

        try {
            //System.out.println("Parsing file: " + javaFile.getPath());

            runCount++;
            long time = System.currentTimeMillis();
            JavaParser.parse(javaFile);
            runTime += System.currentTimeMillis() - time;
            if (fail) {
                System.out.println("Testing file: " + javaFile.getPath());
                System.out.println("  >>Parser error expected but not ocurred");
            }
        } catch (ParseException e) {
            if (!fail) {
                System.out.println("Testing file: " + javaFile.getPath());
                System.out.println("  >>Parser error not expected: " + e.getMessage());
            }
        } catch (Error e) {
            System.out.println("Testing file: " + javaFile.getPath());
            System.out.println("  >>Unknow error: " + e.getMessage());
        }
    }
}