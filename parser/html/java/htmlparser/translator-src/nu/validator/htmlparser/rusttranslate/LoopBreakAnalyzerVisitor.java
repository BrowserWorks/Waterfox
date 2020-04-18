/*
 * Copyright (C) 2008 Júlio Vilmar Gesser.
 * Copyright (C) 2012 Mozilla Foundation
 * 
 * This file is part of Java 1.5 parser and Abstract Syntax Tree.
 *
 * Java 1.5 parser and Abstract Syntax Tree is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Java 1.5 parser and Abstract Syntax Tree is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Java 1.5 parser and Abstract Syntax Tree.  If not, see <http://www.gnu.org/licenses/>.
 */
/*
 * Created on 09/06/2008
 */
package nu.validator.htmlparser.rusttranslate;

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
import japa.parser.ast.stmt.Statement;
import japa.parser.ast.stmt.SwitchEntryStmt;
import japa.parser.ast.stmt.SwitchStmt;
import japa.parser.ast.stmt.SynchronizedStmt;
import japa.parser.ast.stmt.ThrowStmt;
import japa.parser.ast.stmt.TryStmt;
import japa.parser.ast.stmt.TypeDeclarationStmt;
import japa.parser.ast.stmt.WhileStmt;
import japa.parser.ast.type.WildcardType;
import japa.parser.ast.visitor.GenericVisitorAdapter;

import java.util.List;

/**
 * @author Julio Vilmar Gesser
 * @author Henri Sivonen
 */
public class LoopBreakAnalyzerVisitor extends GenericVisitorAdapter<Boolean, Boolean> {

    public Boolean visit(AssertStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(BlockStmt n, Boolean arg) {
        for (Statement stmt : n.getStmts()) {
            if (stmt.accept(this, arg)) {
                return true;
            }
        }
        return false;
    }

    public Boolean visit(BreakStmt n, Boolean arg) {
        return n.getId() != null;
    }

    public Boolean visit(CatchClause n, Boolean arg) {
        return n.getCatchBlock().accept(this, arg);
    }

    public Boolean visit(ContinueStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(DoStmt n, Boolean arg) {
        return n.getBody().accept(this, arg);
    }

    public Boolean visit(EmptyStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(ExplicitConstructorInvocationStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(ExpressionStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(ForeachStmt n, Boolean arg) {
        return n.getBody().accept(this, arg);
    }

    public Boolean visit(ForStmt n, Boolean arg) {
        //bogus
        return false;
    }

    public Boolean visit(IfStmt n, Boolean arg) {
        if (n.getElseStmt() != null) {
            if (n.getElseStmt().accept(this, arg)) {
                return true;
            }
        }
        if (n.getThenStmt().accept(this, arg)) {
            return true;
        }
        return false;
    }

    public Boolean visit(LabeledStmt n, Boolean arg) {
        return n.getStmt().accept(this, arg);
    }

    public Boolean visit(ReturnStmt n, Boolean arg) {
        return true;
    }

    public Boolean visit(SwitchEntryStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(SwitchStmt n, Boolean arg) {
        /*
        List<SwitchEntryStmt> entries = n.getEntries();
        for (int i = 0; i < array.length; i++) {
            array_type array_element = array[i];
            
        }
        */
        return true;
    }

    public Boolean visit(SynchronizedStmt n, Boolean arg) {
        return n.getBlock().accept(this, arg);
    }

    public Boolean visit(ThrowStmt n, Boolean arg) {
        return true;
    }

    public Boolean visit(TryStmt n, Boolean arg) {
        if (n.getFinallyBlock() != null) {
            return n.getFinallyBlock().accept(this, arg);
        }
        if (n.getCatchs() != null) {   
            for (CatchClause c : n.getCatchs()) {
                boolean brk = c.accept(this, arg);
                if (!brk) {
                    return false;
                }
            }
        }
        return n.getTryBlock().accept(this, arg);
    }

    public Boolean visit(TypeDeclarationStmt n, Boolean arg) {
        return false;
    }

    public Boolean visit(WhileStmt n, Boolean arg) {
        return n.getBody().accept(this, arg);
    }

    public Boolean visit(WildcardType n, Boolean arg) {
        if (n.getExtends() != null) {
            n.getExtends().accept(this, arg);
        }
        if (n.getSuper() != null) {
            n.getSuper().accept(this, arg);
        }
        return null;
    }
}