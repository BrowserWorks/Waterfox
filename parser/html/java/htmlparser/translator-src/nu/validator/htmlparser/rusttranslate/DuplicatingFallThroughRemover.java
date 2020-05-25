/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is HTML Parser Rust Translator code.
 *
 * The Initial Developer of the Original Code is
 * Mozilla Foundation.
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Henri Sivonen <hsivonen@iki.fi>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

package nu.validator.htmlparser.rusttranslate;

import japa.parser.ast.stmt.BreakStmt;
import japa.parser.ast.stmt.Statement;
import japa.parser.ast.stmt.SwitchEntryStmt;
import japa.parser.ast.stmt.SwitchStmt;
import japa.parser.ast.visitor.VoidVisitorAdapter;

import java.util.LinkedList;
import java.util.List;

public class DuplicatingFallThroughRemover extends VoidVisitorAdapter<Object> {

    private static final SwitchBreakAnalyzerVisitor ANALYZER_VISITOR = new SwitchBreakAnalyzerVisitor();
    
    @Override public void visit(SwitchStmt sw, Object arg) {
        if ("state".equals(sw.getSelector().toString())) {
            super.visit(sw, arg);
            return;
        }
        
        List<Statement> tail = new LinkedList<Statement>();
        tail.add(new BreakStmt());
        
        List<SwitchEntryStmt> entries = sw.getEntries();
        for (int i = entries.size() - 1; i >= 0; i--) {
            SwitchEntryStmt stmt = entries.get(i);
            List<Statement> list = stmt.getStmts();
            if (list != null) {
                if (!(list.size() > 0
                        && list.get(list.size() - 1).accept(ANALYZER_VISITOR, true))) {
                    list.addAll(tail);
                }
                tail = list;
                for (Statement statement : list) {
                    statement.accept(this, arg);
                }
            }
        }
    }
    
}
