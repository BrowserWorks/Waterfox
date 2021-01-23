/* global $:false, Handlebars:false, PKT_SENDTOMOBILE:false, */
/* import-globals-from messages.js */

/*
PKT_SAVED_OVERLAY is the view itself and contains all of the methods to manipute the overlay and messaging.
It does not contain any logic for saving or communication with the extension or server.
*/
var PKT_SAVED_OVERLAY = function(options) {
  var myself = this;
  this.inited = false;
  this.active = false;
  this.wrapper = null;
  this.pockethost = "getpocket.com";
  this.savedItemId = 0;
  this.savedUrl = "";
  this.premiumStatus = false;
  this.preventCloseTimerCancel = false;
  this.closeValid = true;
  this.mouseInside = false;
  this.autocloseTimer = null;
  this.inoverflowmenu = false;
  this.dictJSON = {};
  this.autocloseTiming = 3500;
  this.autocloseTimingFinalState = 2000;
  this.mouseInside = false;
  this.userTags = [];
  this.cxt_suggested_available = 0;
  this.cxt_entered = 0;
  this.cxt_suggested = 0;
  this.cxt_removed = 0;
  this.justaddedsuggested = false;
  this.fxasignedin = false;
  this.premiumDetailsAdded = false;
  this.ho2 = false;
  this.fillTagContainer = function(tags, container, tagclass) {
    container.children().remove();
    for (var i = 0; i < tags.length; i++) {
      var newtag = $('<li><a href="#" class="token_tag"></a></li>');
      newtag.find("a").text(tags[i]);
      newtag.addClass(tagclass);
      container.append(newtag);
      this.cxt_suggested_available++;
    }
  };
  this.fillUserTags = function() {
    thePKT_SAVED.sendMessage("getTags", {}, function(resp) {
      if (typeof resp == "object" && typeof resp.tags == "object") {
        myself.userTags = resp.tags;
      }
    });
  };
  this.fillSuggestedTags = function() {
    if (!$(".pkt_ext_suggestedtag_detail").length) {
      myself.suggestedTagsLoaded = true;
      myself.startCloseTimer();
      return;
    }

    thePKT_SAVED.sendMessage(
      "getSuggestedTags",
      {
        url: myself.savedUrl,
      },
      function(resp) {
        $(".pkt_ext_suggestedtag_detail").removeClass(
          "pkt_ext_suggestedtag_detail_loading"
        );
        if (resp.status == "success") {
          var newtags = [];
          for (var i = 0; i < resp.value.suggestedTags.length; i++) {
            newtags.push(resp.value.suggestedTags[i].tag);
          }
          myself.suggestedTagsLoaded = true;
          if (!myself.mouseInside) {
            myself.startCloseTimer();
          }
          myself.fillTagContainer(
            newtags,
            $(".pkt_ext_suggestedtag_detail ul"),
            "token_suggestedtag"
          );
        } else if (resp.status == "error") {
          var msg = $('<p class="suggestedtag_msg">');
          msg.text(resp.error.message);
          $(".pkt_ext_suggestedtag_detail").append(msg);
          this.suggestedTagsLoaded = true;
          if (!myself.mouseInside) {
            myself.startCloseTimer();
          }
        }
      }
    );
  };
  this.initAutoCloseEvents = function() {
    this.wrapper.on("mouseenter", function() {
      myself.mouseInside = true;
      myself.stopCloseTimer();
    });
    this.wrapper.on("mouseleave", function() {
      myself.mouseInside = false;
      myself.startCloseTimer();
    });
    this.wrapper.on("click", function(e) {
      myself.closeValid = false;
    });
  };
  this.startCloseTimer = function(manualtime) {
    var settime = manualtime ? manualtime : myself.autocloseTiming;
    if (typeof myself.autocloseTimer == "number") {
      clearTimeout(myself.autocloseTimer);
    }
    myself.autocloseTimer = setTimeout(function() {
      if (myself.closeValid || myself.preventCloseTimerCancel) {
        myself.preventCloseTimerCancel = false;
        myself.closePopup();
      }
    }, settime);
  };
  this.stopCloseTimer = function() {
    if (myself.preventCloseTimerCancel) {
      return;
    }
    clearTimeout(myself.autocloseTimer);
  };
  this.closePopup = function() {
    myself.stopCloseTimer();
    thePKT_SAVED.sendMessage("close");
  };
  this.checkValidTagSubmit = function() {
    var inputlength = $.trim(
      $(".pkt_ext_tag_input_wrapper")
        .find(".token-input-input-token")
        .children("input")
        .val()
    ).length;
    if (
      $(".pkt_ext_containersaved").find(".token-input-token").length ||
      (inputlength > 0 && inputlength < 26)
    ) {
      $(".pkt_ext_containersaved")
        .find(".pkt_ext_btn")
        .removeClass("pkt_ext_btn_disabled");
    } else {
      $(".pkt_ext_containersaved")
        .find(".pkt_ext_btn")
        .addClass("pkt_ext_btn_disabled");
    }
    myself.updateSlidingTagList();
  };
  this.updateSlidingTagList = function() {
    var cssDir;
    if (document.dir == "ltr") {
      cssDir = "left";
    } else {
      cssDir = "right";
    }
    var inputleft = $(".token-input-input-token input").position()[cssDir];
    var listleft = $(".token-input-list").position()[cssDir];
    var listleftmanual = parseInt($(".token-input-list").css(cssDir));
    var listleftnatural = listleft - listleftmanual;
    var leftwidth = $(".pkt_ext_tag_input_wrapper").outerWidth();

    if (inputleft + listleft + 20 > leftwidth) {
      $(".token-input-list").css(
        cssDir,
        Math.min((inputleft + listleftnatural - leftwidth + 20) * -1, 0) + "px"
      );
    } else {
      $(".token-input-list").css(cssDir, "0");
    }
  };
  this.checkPlaceholderStatus = function() {
    if (
      this.wrapper.find(".pkt_ext_tag_input_wrapper").find(".token-input-token")
        .length
    ) {
      this.wrapper
        .find(".token-input-input-token input")
        .attr("placeholder", "");
    } else {
      this.wrapper
        .find(".token-input-input-token input")
        .attr("placeholder", $(".pkt_ext_tag_input").attr("placeholder"))
        .css("width", "200px");
    }
  };
  this.initTagInput = function() {
    var inputwrapper = $(".pkt_ext_tag_input_wrapper");
    inputwrapper.find(".pkt_ext_tag_input").tokenInput([], {
      searchDelay: 200,
      minChars: 1,
      animateDropdown: false,
      noResultsHideDropdown: true,
      scrollKeyboard: true,
      emptyInputLength: 200,
      search_function(term, cb) {
        var returnlist = [];
        if (term.length) {
          var limit = 15;
          var r = new RegExp("^" + term);
          for (var i = 0; i < myself.userTags.length; i++) {
            if (r.test(myself.userTags[i]) && limit > 0) {
              returnlist.push({ name: myself.userTags[i] });
              limit--;
            }
          }
        }
        if (!$(".token-input-dropdown-tag").data("init")) {
          $(".token-input-dropdown-tag")
            .css("width", inputwrapper.outerWidth())
            .data("init");
          inputwrapper.append($(".token-input-dropdown-tag"));
        }
        cb(returnlist);
      },
      textToData(text) {
        if ($.trim(text).length > 25 || !$.trim(text).length) {
          if (text.length > 25) {
            myself.showTagsError(myself.dictJSON.maxtaglength);
            this.changestamp = Date.now();
            setTimeout(function() {
              $(".token-input-input-token input")
                .val(text)
                .focus();
            }, 10);
          }
          return null;
        }
        myself.hideTagsError();
        return { name: myself.sanitizeText(text.toLowerCase()) };
      },
      onReady() {
        $(".token-input-dropdown").addClass("token-input-dropdown-tag");
        inputwrapper
          .find(".token-input-input-token input")
          .attr("placeholder", $(".tag-input").attr("placeholder"))
          .css("width", "200px");
        if ($(".pkt_ext_suggestedtag_detail").length) {
          myself.wrapper
            .find(".pkt_ext_suggestedtag_detail")
            .on("click", ".token_tag", function(e) {
              e.preventDefault();
              var tag = $(e.target);
              if (
                $(this).parents(".pkt_ext_suggestedtag_detail_disabled").length
              ) {
                return;
              }
              myself.justaddedsuggested = true;
              inputwrapper.find(".pkt_ext_tag_input").tokenInput("add", {
                id: inputwrapper.find(".token-input-token").length,
                name: tag.text(),
              });
              tag.addClass("token-suggestedtag-inactive");
              $(".token-input-input-token input").focus();
            });
        }
        $(".token-input-list")
          .on("keydown", "input", function(e) {
            if (e.which == 37) {
              myself.updateSlidingTagList();
            }
          })
          .on("keypress", "input", function(e) {
            if (e.which == 13) {
              if (
                typeof this.changestamp == "undefined" ||
                Date.now() - this.changestamp > 250
              ) {
                e.preventDefault();
                myself.wrapper.find(".pkt_ext_btn").trigger("click");
              }
            }
          })
          .on("keyup", "input", function(e) {
            myself.checkValidTagSubmit();
          });
        myself.checkPlaceholderStatus();
      },
      onAdd() {
        myself.checkValidTagSubmit();
        this.changestamp = Date.now();
        myself.hideInactiveTags();
        myself.checkPlaceholderStatus();
      },
      onDelete() {
        myself.checkValidTagSubmit();
        this.changestamp = Date.now();
        myself.showActiveTags();
        myself.checkPlaceholderStatus();
      },
      onShowDropdown() {
        if (myself.ho2 !== "show_prompt_preview") {
          thePKT_SAVED.sendMessage("expandSavePanel");
        }
      },
      onHideDropdown() {
        if (!myself.ho2) {
          thePKT_SAVED.sendMessage("collapseSavePanel");
        } else if (myself.ho2 !== "show_prompt_preview") {
          thePKT_SAVED.sendMessage("resizePanel", { width: 350, height: 200 });
        }
      },
    });
    $("body").on("keydown", function(e) {
      var key = e.keyCode || e.which;
      if (key == 8) {
        var selected = $(".token-input-selected-token");
        if (selected.length) {
          e.preventDefault();
          e.stopImmediatePropagation();
          inputwrapper
            .find(".pkt_ext_tag_input")
            .tokenInput("remove", { name: selected.find("p").text() });
        }
      } else if (
        $(e.target)
          .parent()
          .hasClass("token-input-input-token")
      ) {
        e.stopImmediatePropagation();
      }
    });
  };
  this.disableInput = function() {
    this.wrapper
      .find(".pkt_ext_item_actions")
      .addClass("pkt_ext_item_actions_disabled");
    this.wrapper.find(".pkt_ext_btn").addClass("pkt_ext_btn_disabled");
    this.wrapper
      .find(".pkt_ext_tag_input_wrapper")
      .addClass("pkt_ext_tag_input_wrapper_disabled");
    if (this.wrapper.find(".pkt_ext_suggestedtag_detail").length) {
      this.wrapper
        .find(".pkt_ext_suggestedtag_detail")
        .addClass("pkt_ext_suggestedtag_detail_disabled");
    }
  };
  this.enableInput = function() {
    this.wrapper
      .find(".pkt_ext_item_actions")
      .removeClass("pkt_ext_item_actions_disabled");
    this.checkValidTagSubmit();
    this.wrapper
      .find(".pkt_ext_tag_input_wrapper")
      .removeClass("pkt_ext_tag_input_wrapper_disabled");
    if (this.wrapper.find(".pkt_ext_suggestedtag_detail").length) {
      this.wrapper
        .find(".pkt_ext_suggestedtag_detail")
        .removeClass("pkt_ext_suggestedtag_detail_disabled");
    }
  };
  this.initAddTagInput = function() {
    $(".pkt_ext_btn").click(function(e) {
      e.preventDefault();
      if (
        $(this).hasClass("pkt_ext_btn_disabled") ||
        $(".pkt_ext_edit_msg_active").filter(".pkt_ext_edit_msg_error").length
      ) {
        return;
      }
      myself.disableInput();
      $(".pkt_ext_containersaved")
        .find(".pkt_ext_detail h2")
        .text(myself.dictJSON.processingtags);
      var originaltags = [];
      $(".token-input-token").each(function() {
        var text = $.trim(
          $(this)
            .find("p")
            .text()
        );
        if (text.length) {
          originaltags.push(text);
        }
      });

      thePKT_SAVED.sendMessage(
        "addTags",
        {
          url: myself.savedUrl,
          tags: originaltags,
        },
        function(resp) {
          if (resp.status == "success") {
            myself.showStateFinalMsg(myself.dictJSON.tagssaved);
          } else if (resp.status == "error") {
            $(".pkt_ext_edit_msg")
              .addClass("pkt_ext_edit_msg_error pkt_ext_edit_msg_active")
              .text(resp.error.message);
          }
        }
      );
    });
  };
  this.initRemovePageInput = function() {
    $(".pkt_ext_removeitem").click(function(e) {
      if ($(this).parents(".pkt_ext_item_actions_disabled").length) {
        e.preventDefault();
        return;
      }
      if ($(this).hasClass("pkt_ext_removeitem")) {
        e.preventDefault();
        myself.disableInput();
        $(".pkt_ext_containersaved")
          .find(".pkt_ext_detail h2")
          .text(myself.dictJSON.processingremove);

        thePKT_SAVED.sendMessage(
          "deleteItem",
          {
            itemId: myself.savedItemId,
          },
          function(resp) {
            if (resp.status == "success") {
              myself.showStateFinalMsg(myself.dictJSON.pageremoved);
            } else if (resp.status == "error") {
              $(".pkt_ext_edit_msg")
                .addClass("pkt_ext_edit_msg_error pkt_ext_edit_msg_active")
                .text(resp.error.message);
            }
          }
        );
      }
    });
  };
  this.initOpenListInput = function() {
    $(".pkt_ext_openpocket").click(function(e) {
      e.preventDefault();
      thePKT_SAVED.sendMessage("openTabWithUrl", {
        url: $(this).attr("href"),
        activate: true,
      });
      myself.closePopup();
    });
  };
  this.showTagsError = function(msg) {
    $(".pkt_ext_edit_msg")
      .addClass("pkt_ext_edit_msg_error pkt_ext_edit_msg_active")
      .text(msg);
    $(".pkt_ext_tag_detail").addClass("pkt_ext_tag_error");
  };
  this.hideTagsError = function(msg) {
    $(".pkt_ext_edit_msg")
      .removeClass("pkt_ext_edit_msg_error pkt_ext_edit_msg_active")
      .text("");
    $(".pkt_ext_tag_detail").removeClass("pkt_ext_tag_error");
  };
  this.showActiveTags = function() {
    if (!$(".pkt_ext_suggestedtag_detail").length) {
      return;
    }
    var activetokenstext = "|";
    $(".token-input-token").each(function(index, element) {
      activetokenstext +=
        $(element)
          .find("p")
          .text() + "|";
    });

    var inactivetags = $(".pkt_ext_suggestedtag_detail").find(
      ".token_tag_inactive"
    );
    inactivetags.each(function(index, element) {
      if (!activetokenstext.includes("|" + $(element).text() + "|")) {
        $(element).removeClass("token_tag_inactive");
      }
    });
  };
  this.hideInactiveTags = function() {
    if (!$(".pkt_ext_suggestedtag_detail").length) {
      return;
    }
    var activetokenstext = "|";
    $(".token-input-token").each(function(index, element) {
      activetokenstext +=
        $(element)
          .find("p")
          .text() + "|";
    });
    var activesuggestedtags = $(".token_tag").not(".token_tag_inactive");
    activesuggestedtags.each(function(index, element) {
      if (activetokenstext.indexOf("|" + $(element).text() + "|") > -1) {
        $(element).addClass("token_tag_inactive");
      }
    });
  };
  this.showStateSaved = function(initobj) {
    this.wrapper.find(".pkt_ext_detail h2").text(this.dictJSON.pagesaved);
    this.wrapper.find(".pkt_ext_btn").addClass("pkt_ext_btn_disabled");
    if (typeof initobj.item == "object") {
      this.savedItemId = initobj.item.item_id;
      this.savedUrl = initobj.item.given_url;
    }
    $(".pkt_ext_containersaved")
      .addClass("pkt_ext_container_detailactive")
      .removeClass("pkt_ext_container_finalstate");

    if (
      initobj.ho2 &&
      initobj.ho2 != "control" &&
      !initobj.accountState.has_mobile &&
      !myself.savedUrl.includes("getpocket.com")
    ) {
      myself.createSendToMobilePanel(initobj.ho2, initobj.displayName);
      myself.ho2 = initobj.ho2;
    }

    myself.fillUserTags();
    if (myself.suggestedTagsLoaded) {
      myself.startCloseTimer();
    } else {
      myself.fillSuggestedTags();
    }
  };
  this.createSendToMobilePanel = function(ho2, displayName) {
    PKT_SENDTOMOBILE.create(ho2, displayName, myself.premiumDetailsAdded);
  };
  this.sanitizeText = function(s) {
    var sanitizeMap = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#39;",
    };
    if (typeof s !== "string") {
      return "";
    }
    return String(s).replace(/[&<>"']/g, function(str) {
      return sanitizeMap[str];
    });
  };
  this.showStateFinalMsg = function(msg) {
    this.wrapper
      .find(".pkt_ext_tag_detail")
      .one(
        "webkitTransitionEnd transitionend msTransitionEnd oTransitionEnd",
        function(e) {
          $(this).off(
            "webkitTransitionEnd transitionend msTransitionEnd oTransitionEnd"
          );
          myself.preventCloseTimerCancel = true;
          myself.startCloseTimer(myself.autocloseTimingFinalState);
          myself.wrapper.find(".pkt_ext_detail h2").text(msg);
        }
      );
    this.wrapper.addClass("pkt_ext_container_finalstate");
  };
  this.showStateError = function(headline, detail) {
    this.wrapper.find(".pkt_ext_detail h2").text(headline);
    this.wrapper.find(".pkt_ext_detail h3").text(detail);
    this.wrapper.addClass(
      "pkt_ext_container_detailactive pkt_ext_container_finalstate pkt_ext_container_finalerrorstate"
    );
    this.preventCloseTimerCancel = true;
    this.startCloseTimer(myself.autocloseTimingFinalState);
  };
  this.getTranslations = function() {
    this.dictJSON = window.pocketStrings;
  };
};

PKT_SAVED_OVERLAY.prototype = {
  create() {
    if (this.active) {
      return;
    }
    this.active = true;

    // set translations
    this.getTranslations();

    // set host
    this.dictJSON.pockethost = this.pockethost;

    // extra modifier class for collapsed state
    if (this.inoverflowmenu) {
      $("body").addClass("pkt_ext_saved_overflow");
    }

    // extra modifier class for language
    if (this.locale) {
      $("body").addClass("pkt_ext_saved_" + this.locale);
    }

    // Create actual content
    $("body").append(Handlebars.templates.saved_shell(this.dictJSON));

    // Add in premium content (if applicable based on premium status)
    this.createPremiumFunctionality();

    // Initialize functionality for overlay
    this.wrapper = $(".pkt_ext_containersaved");
    this.initTagInput();
    this.initAddTagInput();
    this.initRemovePageInput();
    this.initOpenListInput();
    this.initAutoCloseEvents();
  },
  createPremiumFunctionality() {
    if (this.premiumStatus && !$(".pkt_ext_suggestedtag_detail").length) {
      this.premiumDetailsAdded = true;
      $("body").append(Handlebars.templates.saved_premiumshell(this.dictJSON));
      $(".pkt_ext_initload").append(
        Handlebars.templates.saved_premiumextras(this.dictJSON)
      );
    }
  },
};

// Layer between Bookmarklet and Extensions
var PKT_SAVED = function() {};

PKT_SAVED.prototype = {
  init() {
    if (this.inited) {
      return;
    }
    this.panelId = pktPanelMessaging.panelIdFromURL(window.location.href);
    this.overlay = new PKT_SAVED_OVERLAY();

    this.inited = true;
  },

  addMessageListener(messageId, callback) {
    pktPanelMessaging.addMessageListener(this.panelId, messageId, callback);
  },

  sendMessage(messageId, payload, callback) {
    pktPanelMessaging.sendMessage(this.panelId, messageId, payload, callback);
  },

  create() {
    var myself = this;
    var url = window.location.href.match(/premiumStatus=([\w|\d|\.]*)&?/);
    if (url && url.length > 1) {
      myself.overlay.premiumStatus = url[1] == "1";
    }
    var fxasignedin = window.location.href.match(/fxasignedin=([\w|\d|\.]*)&?/);
    if (fxasignedin && fxasignedin.length > 1) {
      myself.overlay.fxasignedin = fxasignedin[1] == "1";
    }
    var host = window.location.href.match(/pockethost=([\w|\.]*)&?/);
    if (host && host.length > 1) {
      myself.overlay.pockethost = host[1];
    }
    var inoverflowmenu = window.location.href.match(
      /inoverflowmenu=([\w|\.]*)&?/
    );
    if (inoverflowmenu && inoverflowmenu.length > 1) {
      myself.overlay.inoverflowmenu = inoverflowmenu[1] == "true";
    }
    var locale = window.location.href.match(/locale=([\w|\.]*)&?/);
    if (locale && locale.length > 1) {
      myself.overlay.locale = locale[1].toLowerCase();
    }

    myself.overlay.create();

    // tell back end we're ready
    thePKT_SAVED.sendMessage("show");

    // wait confirmation of save before flipping to final saved state
    thePKT_SAVED.addMessageListener("saveLink", function(resp) {
      if (resp.status == "error") {
        if (typeof resp.error == "object") {
          if (resp.error.localizedKey) {
            myself.overlay.showStateError(
              myself.overlay.dictJSON.pagenotsaved,
              myself.overlay.dictJSON[resp.error.localizedKey]
            );
          } else {
            myself.overlay.showStateError(
              myself.overlay.dictJSON.pagenotsaved,
              resp.error.message
            );
          }
        } else {
          myself.overlay.showStateError(
            myself.overlay.dictJSON.pagenotsaved,
            myself.overlay.dictJSON.errorgeneric
          );
        }
        return;
      }

      myself.overlay.showStateSaved(resp);
    });
  },
};

$(function() {
  if (!window.thePKT_SAVED) {
    var thePKT_SAVED = new PKT_SAVED();
    /* global thePKT_SAVED */
    window.thePKT_SAVED = thePKT_SAVED;
    thePKT_SAVED.init();
  }

  var pocketHost = thePKT_SAVED.overlay.pockethost;
  // send an async message to get string data
  thePKT_SAVED.sendMessage(
    "initL10N",
    {
      tos: [
        "https://" + pocketHost + "/tos?s=ffi&t=tos&tv=panel_tryit",
        "https://" +
          pocketHost +
          "/privacy?s=ffi&t=privacypolicy&tv=panel_tryit",
      ],
    },
    function(resp) {
      window.pocketStrings = resp.strings;
      // Set the writing system direction
      document.documentElement.setAttribute("dir", resp.dir);
      window.thePKT_SAVED.create();
    }
  );
});
