/*
 * Copyright (c) 2009-2010 Mozilla Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a 
 * copy of this software and associated documentation files (the "Software"), 
 * to deal in the Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the 
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
 * DEALINGS IN THE SOFTWARE.
 */

package nu.validator.htmlparser.impl;

/**
 * Interface for exposing the state of the HTML5 tree builder so that the
 * interface can be implemented by the tree builder itself and by snapshots.
 * 
 * @version $Id$
 * @author hsivonen
 */
public interface TreeBuilderState<T> {

    /**
     * Returns the stack.
     * 
     * @return the stack
     */
    public StackNode<T>[] getStack();

    /**
     * Returns the listOfActiveFormattingElements.
     *
     * @return the listOfActiveFormattingElements
     */
    public StackNode<T>[] getListOfActiveFormattingElements();

    /**
     * Returns the stack of template insertion modes.
     *
     * @return the stack of template insertion modes
     */
    public int[] getTemplateModeStack();

    /**
     * Returns the formPointer.
     * 
     * @return the formPointer
     */
    public T getFormPointer();

    /**
     * Returns the headPointer.
     * 
     * @return the headPointer
     */
    public T getHeadPointer();
    
    /**
     * Returns the deepTreeSurrogateParent.
     * 
     * @return the deepTreeSurrogateParent
     */
    public T getDeepTreeSurrogateParent();

    /**
     * Returns the mode.
     * 
     * @return the mode
     */
    public int getMode();

    /**
     * Returns the originalMode.
     * 
     * @return the originalMode
     */
    public int getOriginalMode();

    /**
     * Returns the framesetOk.
     * 
     * @return the framesetOk
     */
    public boolean isFramesetOk();
    
    /**
     * Returns the needToDropLF.
     * 
     * @return the needToDropLF
     */
    public boolean isNeedToDropLF();

    /**
     * Returns the quirks.
     * 
     * @return the quirks
     */
    public boolean isQuirks();

    /**
     * Return the length of the stack.
     * @return the length of the stack.
     */
    public int getStackLength();

    /**
     * Return the length of the list of active formatting elements.
     * @return the length of the list of active formatting elements.
     */
    public int getListOfActiveFormattingElementsLength();

    /**
     * Return the length of the stack of template insertion modes.
     *
     * @return the length of the stack of template insertion modes.
     */
    int getTemplateModeStackLength();
}