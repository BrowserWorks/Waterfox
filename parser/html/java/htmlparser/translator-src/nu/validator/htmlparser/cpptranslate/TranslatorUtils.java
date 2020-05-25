package nu.validator.htmlparser.cpptranslate;

import japa.parser.ast.expr.BinaryExpr;
import japa.parser.ast.expr.BinaryExpr.Operator;
import japa.parser.ast.expr.Expression;
import japa.parser.ast.expr.MethodCallExpr;
import japa.parser.ast.expr.NameExpr;
import japa.parser.ast.expr.NullLiteralExpr;
import japa.parser.ast.stmt.BlockStmt;
import japa.parser.ast.stmt.ExpressionStmt;
import japa.parser.ast.stmt.Statement;

import java.util.List;

public class TranslatorUtils {
    public static boolean isErrorOnlyBlock(Statement elseStmt, boolean supportErrorReporting) {
        if (supportErrorReporting) {
            return false;
        }
        if (elseStmt instanceof BlockStmt) {
            BlockStmt block = (BlockStmt) elseStmt;
            List<Statement> statements = block.getStmts();
            if (statements == null) {
                return false;
            }
            if (statements.size() != 1) {
                return false;
            }
            Statement statement = statements.get(0);
            if (statement instanceof ExpressionStmt) {
                ExpressionStmt exprStmt = (ExpressionStmt) statement;
                Expression expr = exprStmt.getExpression();
                if (expr instanceof MethodCallExpr) {
                    MethodCallExpr call = (MethodCallExpr) expr;
                    if (call.getName().startsWith("err")) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static boolean isErrorHandlerIf(Expression condition, boolean supportErrorReporting) {
        if (supportErrorReporting) {
            return false;
        }
        while (condition instanceof BinaryExpr) {
            BinaryExpr binex = (BinaryExpr) condition;
            condition = binex.getLeft();
            if (condition instanceof NameExpr) {
                NameExpr name = (NameExpr) condition;
                if ("errorHandler".equals(name.getName())) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean isDocumentModeHandlerNullCheck(Expression condition) {
        if (condition instanceof BinaryExpr) {
            BinaryExpr binex = (BinaryExpr) condition;
            if (binex.getOperator() != Operator.notEquals) {
                return false;
            }
            if (!(binex.getRight() instanceof NullLiteralExpr)) {
                return false;
            }
            Expression left = binex.getLeft();
            if (left instanceof NameExpr) {
                NameExpr name = (NameExpr) left;
                if ("documentModeHandler".equals(name.getName())) {
                    return true;
                }
            }
        }
        return false;
    }

}
