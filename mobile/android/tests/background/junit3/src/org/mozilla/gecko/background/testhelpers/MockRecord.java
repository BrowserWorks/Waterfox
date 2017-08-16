/* Any copyright is dedicated to the Public Domain.
   http://creativecommons.org/publicdomain/zero/1.0/ */

package org.mozilla.gecko.background.testhelpers;

import org.json.simple.JSONObject;
import org.mozilla.gecko.sync.ExtendedJSONObject;
import org.mozilla.gecko.sync.repositories.domain.Record;

public class MockRecord extends Record {

  public MockRecord(String guid, String collection, long lastModified, boolean deleted) {
    super(guid, collection, lastModified, deleted);
  }

  @Override
  protected void populatePayload(ExtendedJSONObject payload) {
  }

  @Override
  protected void initFromPayload(ExtendedJSONObject payload) {
  }

  @Override
  public Record copyWithIDs(String guid, long androidID) {
    MockRecord r = new MockRecord(guid, this.collection, this.lastModified, this.deleted);
    r.androidID = androidID;
    return r;
  }

  @Override
  public String toJSONString() {
    return toJSONObject().toJSONString();
  }

  @Override
  public JSONObject toJSONObject() {
    final ExtendedJSONObject o = new ExtendedJSONObject();
    o.put("payload", "foo");
    o.put("id", guid);
    o.put("ttl", 60);
    return o.object;
  }
}