/*
 * Copyright 2017, Leanplum, Inc. All rights reserved.
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.leanplum;

import android.content.Context;
import android.content.SharedPreferences;

import com.leanplum.callbacks.InboxChangedCallback;
import com.leanplum.callbacks.VariablesChangedCallback;
import com.leanplum.internal.AESCrypt;
import com.leanplum.internal.CollectionUtil;
import com.leanplum.internal.Constants;
import com.leanplum.internal.JsonConverter;
import com.leanplum.internal.Log;
import com.leanplum.internal.OsHandler;
import com.leanplum.internal.Request;
import com.leanplum.internal.Util;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Inbox class.
 *
 * @author Aleksandar Gyorev, Anna Orlova
 */
public class LeanplumInbox {
  static boolean isInboxImagePrefetchingEnabled = true;
  /**
   * Should be like this until Newsfeed is removed for backward compatibility.
   */
  static Newsfeed instance = new Newsfeed();
  static Set<String> downloadedImageUrls;

  // Inbox properties.
  private int unreadCount;
  private Map<String, LeanplumInboxMessage> messages;
  private boolean didLoad = false;
  private List<InboxChangedCallback> changedCallbacks;
  private Object updatingLock = new Object();

  LeanplumInbox() {
    this.unreadCount = 0;
    this.messages = new HashMap<>();
    this.didLoad = false;
    this.changedCallbacks = new ArrayList<>();
    downloadedImageUrls = new HashSet<>();
  }

  /**
   * Static 'getInstance' method.
   */
  static LeanplumInbox getInstance() {
    return instance;
  }

  /**
   * Disable prefetching images.
   */
  public static void disableImagePrefetching() {
    isInboxImagePrefetchingEnabled = false;
  }

  boolean isInboxImagePrefetchingEnabled() {
    return isInboxImagePrefetchingEnabled;
  }

  void updateUnreadCount(int unreadCount) {
    this.unreadCount = unreadCount;
    save();
    triggerChanged();
  }

  void update(Map<String, LeanplumInboxMessage> messages, int unreadCount, boolean shouldSave) {
    try {
      synchronized (updatingLock) {
        this.unreadCount = unreadCount;
        if (messages != null) {
          this.messages = messages;
        }
      }
      this.didLoad = true;
      if (shouldSave) {
        save();
      }
      triggerChanged();
    } catch (Throwable t) {
      Util.handleException(t);
    }
  }

  void removeMessage(String messageId) {
    int unreadCount = this.unreadCount;
    LeanplumInboxMessage message = messageForId(messageId);
    if (message != null && !message.isRead()) {
      unreadCount--;
    }

    messages.remove(messageId);
    update(messages, unreadCount, true);

    if (Constants.isNoop()) {
      return;
    }

    Map<String, Object> params = new HashMap<>();
    params.put(Constants.Params.INBOX_MESSAGE_ID, messageId);
    Request req = Request.post(Constants.Methods.DELETE_INBOX_MESSAGE, params);
    req.send();
  }

  void triggerChanged() {
    synchronized (changedCallbacks) {
      for (InboxChangedCallback callback : changedCallbacks) {
        OsHandler.getInstance().post(callback);
      }
    }
  }

  void load() {
    if (Constants.isNoop()) {
      return;
    }
    Context context = Leanplum.getContext();
    SharedPreferences defaults = context.getSharedPreferences(
        "__leanplum__", Context.MODE_PRIVATE);
    if (Request.token() == null) {
      update(new HashMap<String, LeanplumInboxMessage>(), 0, false);
      return;
    }
    int unreadCount = 0;
    AESCrypt aesContext = new AESCrypt(Request.appId(), Request.token());
    String newsfeedString = aesContext.decodePreference(
        defaults, Constants.Defaults.INBOX_KEY, "{}");
    Map<String, Object> newsfeed = JsonConverter.fromJson(newsfeedString);

    Map<String, LeanplumInboxMessage> messages = new HashMap<>();
    if (newsfeed == null) {
      Log.e("Could not parse newsfeed string: " + newsfeedString);
    } else {
      for (Map.Entry<String, Object> entry : newsfeed.entrySet()) {
        String messageId = entry.getKey();
        Map<String, Object> data = CollectionUtil.uncheckedCast(entry.getValue());
        LeanplumInboxMessage message = LeanplumInboxMessage.createFromJsonMap(messageId, data);

        if (message != null && message.isActive()) {
          messages.put(messageId, message);
          if (!message.isRead()) {
            unreadCount++;
          }
        }
      }
    }

    update(messages, unreadCount, false);
  }

  void save() {
    if (Constants.isNoop()) {
      return;
    }
    if (Request.token() == null) {
      return;
    }
    Context context = Leanplum.getContext();
    SharedPreferences defaults = context.getSharedPreferences(
        "__leanplum__", Context.MODE_PRIVATE);
    SharedPreferences.Editor editor = defaults.edit();
    Map<String, Object> messages = new HashMap<>();
    for (Map.Entry<String, LeanplumInboxMessage> entry : this.messages.entrySet()) {
      String messageId = entry.getKey();
      NewsfeedMessage newsfeedMessage = entry.getValue();
      Map<String, Object> data = newsfeedMessage.toJsonMap();
      messages.put(messageId, data);
    }
    String messagesJson = JsonConverter.toJson(messages);
    AESCrypt aesContext = new AESCrypt(Request.appId(), Request.token());
    editor.putString(Constants.Defaults.INBOX_KEY, aesContext.encrypt(messagesJson));
    try {
      editor.apply();
    } catch (NoSuchMethodError e) {
      editor.commit();
    }
  }

  void downloadMessages() {
    if (Constants.isNoop()) {
      return;
    }

    Request req = Request.post(Constants.Methods.GET_INBOX_MESSAGES, null);
    req.onResponse(new Request.ResponseCallback() {
      @Override
      public void response(JSONObject responses) {
        try {
          JSONObject response = Request.getLastResponse(responses);
          if (response == null) {
            Log.e("No inbox response received from the server.");
            return;
          }

          JSONObject messagesDict = response.optJSONObject(Constants.Keys.INBOX_MESSAGES);
          if (messagesDict == null) {
            Log.e("No inbox messages found in the response from the server.", response);
            return;
          }
          int unreadCount = 0;
          final Map<String, LeanplumInboxMessage> messages = new HashMap<>();
          Boolean willDownladImages = false;

          for (Iterator iterator = messagesDict.keys(); iterator.hasNext(); ) {
            String messageId = (String) iterator.next();
            JSONObject messageDict = messagesDict.getJSONObject(messageId);

            Map<String, Object> actionArgs = JsonConverter.mapFromJson(
                messageDict.getJSONObject(Constants.Keys.MESSAGE_DATA).getJSONObject(Constants.Keys.VARS)
            );
            Long deliveryTimestamp = messageDict.getLong(Constants.Keys.DELIVERY_TIMESTAMP);
            Long expirationTimestamp = null;
            if (messageDict.opt(Constants.Keys.EXPIRATION_TIMESTAMP) != null) {
              expirationTimestamp = messageDict.getLong(Constants.Keys.EXPIRATION_TIMESTAMP);
            }
            boolean isRead = messageDict.getBoolean(Constants.Keys.IS_READ);
            LeanplumInboxMessage message = LeanplumInboxMessage.constructMessage(messageId,
                deliveryTimestamp, expirationTimestamp, isRead, actionArgs);
            if (message != null) {
              willDownladImages |= message.downloadImageIfPrefetchingEnabled();
              if (!isRead) {
                unreadCount++;
              }
              messages.put(messageId, message);
            }
          }

          if (!willDownladImages) {
            update(messages, unreadCount, true);
            return;
          }

          final int totalUnreadCount = unreadCount;
          Leanplum.addOnceVariablesChangedAndNoDownloadsPendingHandler(
              new VariablesChangedCallback() {
                @Override
                public void variablesChanged() {
                  update(messages, totalUnreadCount, true);
                }
              });
        } catch (Throwable t) {
          Util.handleException(t);
        }
      }
    });
    req.sendIfConnected();
  }

  /**
   * Returns the number of all inbox messages on the device.
   */
  public int count() {
    return messages.size();
  }

  /**
   * Returns the number of the unread inbox messages on the device.
   */
  public int unreadCount() {
    return unreadCount;
  }

  /**
   * Returns the identifiers of all inbox messages on the device sorted in ascending
   * chronological order, i.e. the id of the oldest message is the first one, and the most recent
   * one is the last one in the array.
   */
  public List<String> messagesIds() {
    List<String> messageIds = new ArrayList<>(messages.keySet());
    try {
      Collections.sort(messageIds, new Comparator<String>() {
        @Override
        public int compare(String firstMessage, String secondMessage) {
          Date firstDate = messageForId(firstMessage).getDeliveryTimestamp();
          Date secondDate = messageForId(secondMessage).getDeliveryTimestamp();
          return firstDate.compareTo(secondDate);
        }
      });
    } catch (Throwable t) {
      Util.handleException(t);
    }
    return messageIds;
  }

  /**
   * Have to stay as is because of backward compatibility + generics super-sub incompatibility
   * (http://www.angelikalanger.com/GenericsFAQ/FAQSections/ParameterizedTypes.html#Topic2).
   * <p>
   * Returns a List containing all of the newsfeed messages sorted chronologically ascending (i.e.
   * the oldest first and the newest last).
   */
  public List<NewsfeedMessage> allMessages() {
    return allMessages(new ArrayList<NewsfeedMessage>());
  }

  /**
   * Have to stay as is because of backward compatibility + generics super-sub incompatibility
   * (http://www.angelikalanger.com/GenericsFAQ/FAQSections/ParameterizedTypes.html#Topic2).
   * <p>
   * Returns a List containing all of the unread newsfeed messages sorted chronologically ascending
   * (i.e. the oldest first and the newest last).
   */
  public List<NewsfeedMessage> unreadMessages() {
    return unreadMessages(new ArrayList<NewsfeedMessage>());
  }

  /**
   * Suggested workaround for generics to be used with {@link LeanplumInbox#getInstance()} although
   * only LeanplumInboxMessage could be an instance of NewsfeedMessage.
   */
  private <T extends NewsfeedMessage> List<T> allMessages(List<T> messages) {
    if (messages == null) {
      messages = new ArrayList<>();
    }
    try {
      for (String messageId : messagesIds()) {
        messages.add((T) messageForId(messageId));
      }
    } catch (Throwable t) {
      Util.handleException(t);
    }
    return messages;
  }

  /**
   * Suggested workaround for generics to be used with {@link LeanplumInbox#getInstance()} although
   * only LeanplumInboxMessage could be an instance of NewsfeedMessage.
   */
  private <T extends NewsfeedMessage> List<T> unreadMessages(List<T> unreadMessages) {
    if (unreadMessages == null) {
      unreadMessages = new ArrayList<>();
    }
    List<LeanplumInboxMessage> messages = allMessages(null);
    for (LeanplumInboxMessage message : messages) {
      if (!message.isRead()) {
        unreadMessages.add((T) message);
      }
    }
    return unreadMessages;
  }

  /**
   * Returns the inbox messages associated with the given getMessageId identifier.
   */
  public LeanplumInboxMessage messageForId(String messageId) {
    return messages.get(messageId);
  }

  /**
   * Add a callback for when the inbox receives new values from the server.
   */
  public void addChangedHandler(InboxChangedCallback handler) {
    synchronized (changedCallbacks) {
      changedCallbacks.add(handler);
    }
    if (this.didLoad) {
      handler.inboxChanged();
    }
  }

  /**
   * Removes a inbox changed callback.
   */
  public void removeChangedHandler(InboxChangedCallback handler) {
    synchronized (changedCallbacks) {
      changedCallbacks.remove(handler);
    }
  }
}
