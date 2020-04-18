import java.util.HashSet;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.Element;

public class DomUtils {

  private static HashSet<Document> pinned_list = new HashSet<Document>();

  public static synchronized void pin(Document d) {
    pinned_list.add(d);
  }

  public static synchronized void unpin(Document d) {
    pinned_list.remove(d);
  }

  // return all the text content contained by a single element 
  public static void getElementContent(Element e, StringBuffer b) {
    for (Node n = e.getFirstChild(); n!=null; n=n.getNextSibling()) {
      if (n.getNodeType() == n.TEXT_NODE) {
        b.append(n.getNodeValue());
      } else if (n.getNodeType() == n.ELEMENT_NODE) {
        getElementContent((Element) e, b);
      }
    }
  }

  // replace all child nodes of a given element with a single text element
  public static void setElementContent(Element e, String s) {
    while (e.hasChildNodes()) {
      e.removeChild(e.getFirstChild());
    }
    e.appendChild(e.getOwnerDocument().createTextNode(s));
  }
}
