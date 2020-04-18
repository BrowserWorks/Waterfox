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

import java.util.LinkedList;
import java.util.List;

import japa.parser.ast.body.MethodDeclaration;
import japa.parser.ast.expr.BinaryExpr;
import japa.parser.ast.expr.BinaryExpr.Operator;
import japa.parser.ast.expr.Expression;
import japa.parser.ast.stmt.BlockStmt;
import japa.parser.ast.stmt.BreakStmt;
import japa.parser.ast.stmt.IfStmt;
import japa.parser.ast.stmt.Statement;
import japa.parser.ast.stmt.SwitchEntryStmt;
import japa.parser.ast.stmt.SwitchStmt;
import japa.parser.ast.visitor.VoidVisitorAdapter;

/**
 * @author Julio Vilmar Gesser
 * @author Henri Sivonen
 */
public class ModeFallThroughRemover extends VoidVisitorAdapter<Object> {

    private String method;
    
    public void visit(BlockStmt n, Object arg) {
        if (!("startTag".equals(method) || "endTag".equals(method))) {
            super.visit(n, arg);
            return;
        }
        List<Statement> list = n.getStmts();
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                Statement s = list.get(i);
                if (s instanceof SwitchStmt) {
                    SwitchStmt sw = (SwitchStmt) s;
                    if ("mode".equals(sw.getSelector().toString())) {
                        list.remove(i);
                        int j = 0;
                        for (SwitchEntryStmt entry : sw.getEntries()) {
                            List<Statement> statements = entry.getStmts();
                            if (statements == null) {
                                continue;
                            }
                            Statement last = statements.get(statements.size() - 1);
                            if (last instanceof BreakStmt) {
                                BreakStmt brk = (BreakStmt) last;
                                if (brk.getId() == null) {
                                    statements.remove(last);
                                }
                            }
                            Statement stm;
                            Expression label = entry.getLabel();
                            if (label == null) {
                                stm = new BlockStmt(statements);
                            } else {
                                Expression lte = new BinaryExpr(
                                        sw.getSelector(), label,
                                        Operator.lessEquals);
                                stm = new IfStmt(lte,
                                        new BlockStmt(statements), null);
                            }
                            list.add(i + j, stm);
                            j++;
                        }
                    } else {
                        s.accept(this, arg);
                    }
                } else {
                    s.accept(this, arg);
                }
            }
        }
    }

    /**
     * @see japa.parser.ast.visitor.VoidVisitorAdapter#visit(japa.parser.ast.body.MethodDeclaration, java.lang.Object)
     */
    @Override public void visit(MethodDeclaration md, Object arg) {
        method = md.getName();
        super.visit(md, arg);
    }

}