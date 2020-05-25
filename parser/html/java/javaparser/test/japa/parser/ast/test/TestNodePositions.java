/*
 * Created on 30/06/2008
 */
package japa.parser.ast.test;

import japa.parser.ast.BlockComment;
import japa.parser.ast.CompilationUnit;
import japa.parser.ast.ImportDeclaration;
import japa.parser.ast.LineComment;
import japa.parser.ast.Node;
import japa.parser.ast.PackageDeclaration;
import japa.parser.ast.TypeParameter;
import japa.parser.ast.body.AnnotationDeclaration;
import japa.parser.ast.body.AnnotationMemberDeclaration;
import japa.parser.ast.body.ClassOrInterfaceDeclaration;
import japa.parser.ast.body.ConstructorDeclaration;
import japa.parser.ast.body.EmptyMemberDeclaration;
import japa.parser.ast.body.EmptyTypeDeclaration;
import japa.parser.ast.body.EnumConstantDeclaration;
import japa.parser.ast.body.EnumDeclaration;
import japa.parser.ast.body.FieldDeclaration;
import japa.parser.ast.body.InitializerDeclaration;
import japa.parser.ast.body.JavadocComment;
import japa.parser.ast.body.MethodDeclaration;
import japa.parser.ast.body.Parameter;
import japa.parser.ast.body.VariableDeclarator;
import japa.parser.ast.body.VariableDeclaratorId;
import japa.parser.ast.expr.ArrayAccessExpr;
import japa.parser.ast.expr.ArrayCreationExpr;
import japa.parser.ast.expr.ArrayInitializerExpr;
import japa.parser.ast.expr.AssignExpr;
import japa.parser.ast.expr.BinaryExpr;
import japa.parser.ast.expr.BooleanLiteralExpr;
import japa.parser.ast.expr.CastExpr;
import japa.parser.ast.expr.CharLiteralExpr;
import japa.parser.ast.expr.ClassExpr;
import japa.parser.ast.expr.ConditionalExpr;
import japa.parser.ast.expr.DoubleLiteralExpr;
import japa.parser.ast.expr.EnclosedExpr;
import japa.parser.ast.expr.FieldAccessExpr;
import japa.parser.ast.expr.InstanceOfExpr;
import japa.parser.ast.expr.IntegerLiteralExpr;
import japa.parser.ast.expr.IntegerLiteralMinValueExpr;
import japa.parser.ast.expr.LongLiteralExpr;
import japa.parser.ast.expr.LongLiteralMinValueExpr;
import japa.parser.ast.expr.MarkerAnnotationExpr;
import japa.parser.ast.expr.MemberValuePair;
import japa.parser.ast.expr.MethodCallExpr;
import japa.parser.ast.expr.NameExpr;
import japa.parser.ast.expr.NormalAnnotationExpr;
import japa.parser.ast.expr.NullLiteralExpr;
import japa.parser.ast.expr.ObjectCreationExpr;
import japa.parser.ast.expr.QualifiedNameExpr;
import japa.parser.ast.expr.SingleMemberAnnotationExpr;
import japa.parser.ast.expr.StringLiteralExpr;
import japa.parser.ast.expr.SuperExpr;
import japa.parser.ast.expr.ThisExpr;
import japa.parser.ast.expr.UnaryExpr;
import japa.parser.ast.expr.VariableDeclarationExpr;
import japa.parser.ast.stmt.AssertStmt;
import japa.parser.ast.stmt.BlockStmt;
import japa.parser.ast.stmt.BreakStmt;
import japa.parser.ast.stmt.CatchClause;
import japa.parser.ast.stmt.ContinueStmt;
import japa.parser.ast.stmt.DoStmt;
import japa.parser.ast.stmt.EmptyStmt;
import japa.parser.ast.stmt.ExplicitConstructorInvocationStmt;
import japa.parser.ast.stmt.ExpressionStmt;
import japa.parser.ast.stmt.ForStmt;
import japa.parser.ast.stmt.ForeachStmt;
import japa.parser.ast.stmt.IfStmt;
import japa.parser.ast.stmt.LabeledStmt;
import japa.parser.ast.stmt.ReturnStmt;
import japa.parser.ast.stmt.SwitchEntryStmt;
import japa.parser.ast.stmt.SwitchStmt;
import japa.parser.ast.stmt.SynchronizedStmt;
import japa.parser.ast.stmt.ThrowStmt;
import japa.parser.ast.stmt.TryStmt;
import japa.parser.ast.stmt.TypeDeclarationStmt;
import japa.parser.ast.stmt.WhileStmt;
import japa.parser.ast.test.classes.DumperTestClass;
import japa.parser.ast.type.ClassOrInterfaceType;
import japa.parser.ast.type.PrimitiveType;
import japa.parser.ast.type.ReferenceType;
import japa.parser.ast.type.VoidType;
import japa.parser.ast.type.WildcardType;
import japa.parser.ast.visitor.VoidVisitorAdapter;
import junit.framework.TestCase;

/**
 * @author Julio Vilmar Gesser
 */
public class TestNodePositions extends TestCase {

    public void testNodePositions() throws Exception {
        String source = TestHelper.readClass("./test", DumperTestClass.class);
        CompilationUnit cu = TestHelper.parserString(source);

        cu.accept(new TestVisitor(source), null);
    }

    void doTest(String source, Node node) {
        String parsed = node.toString();

        assertTrue(node.getClass().getName() + ": " + parsed, node.getBeginLine() >= 0);
        assertTrue(node.getClass().getName() + ": " + parsed, node.getBeginColumn() >= 0);
        assertTrue(node.getClass().getName() + ": " + parsed, node.getEndLine() >= 0);
        assertTrue(node.getClass().getName() + ": " + parsed, node.getEndColumn() >= 0);

        if (node.getBeginLine() == node.getEndLine()) {
            assertTrue(node.getClass().getName() + ": " + parsed, node.getBeginColumn() <= node.getEndColumn());
        } else {
            assertTrue(node.getClass().getName() + ": " + parsed, node.getBeginLine() <= node.getEndLine());
        }

        String substr = substring(source, node.getBeginLine(), node.getBeginColumn(), node.getEndLine(), node.getEndColumn());
        assertEquals(node.getClass().getName(), trimLines(parsed), trimLines(substr));
    }

    private String trimLines(String str) {
        String[] split = str.split("\n");
        StringBuilder ret = new StringBuilder();
        for (int i = 0; i < split.length; i++) {
            ret.append(split[i].trim());
            if (i < split.length - 1) {
                ret.append("\n");
            }
        }

        return ret.toString();
    }

    private String substring(String source, int beginLine, int beginColumn, int endLine, int endColumn) {
        int pos = 0;
        while (beginLine > 1) {
            if (source.charAt(pos) == '\n') {
                beginLine--;
                endLine--;
            }
            pos++;
        }
        int start = pos + beginColumn - 1;

        while (endLine > 1) {
            if (source.charAt(pos) == '\n') {
                endLine--;
            }
            pos++;
        }
        int end = pos + endColumn;

        return source.substring(start, end);
    }

    class TestVisitor extends VoidVisitorAdapter<Object> {

        private final String source;

        public TestVisitor(String source) {
            this.source = source;
        }

        @Override
        public void visit(AnnotationDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(AnnotationMemberDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ArrayAccessExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ArrayCreationExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ArrayInitializerExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(AssertStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(AssignExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(BinaryExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(BlockComment n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(BlockStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(BooleanLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(BreakStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(CastExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(CatchClause n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(CharLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ClassExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ClassOrInterfaceDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ClassOrInterfaceType n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(CompilationUnit n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ConditionalExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ConstructorDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ContinueStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(DoStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(DoubleLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(EmptyMemberDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(EmptyStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(EmptyTypeDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(EnclosedExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(EnumConstantDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(EnumDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ExplicitConstructorInvocationStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ExpressionStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(FieldAccessExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(FieldDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ForeachStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ForStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(IfStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ImportDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(InitializerDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(InstanceOfExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(IntegerLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(IntegerLiteralMinValueExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(JavadocComment n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(LabeledStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(LineComment n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(LongLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(LongLiteralMinValueExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(MarkerAnnotationExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(MemberValuePair n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(MethodCallExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(MethodDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(NameExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(NormalAnnotationExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(NullLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ObjectCreationExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(PackageDeclaration n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(Parameter n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(PrimitiveType n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(QualifiedNameExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ReferenceType n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ReturnStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(SingleMemberAnnotationExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(StringLiteralExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(SuperExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(SwitchEntryStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(SwitchStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(SynchronizedStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ThisExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(ThrowStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(TryStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(TypeDeclarationStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(TypeParameter n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(UnaryExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(VariableDeclarationExpr n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(VariableDeclarator n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(VariableDeclaratorId n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(VoidType n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(WhileStmt n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

        @Override
        public void visit(WildcardType n, Object arg) {
            doTest(source, n);
            super.visit(n, arg);
        }

    }

}
