<!-- WebRTC peer connection -->
<groupbox id="webrtc" data-category="panePrivacy" hidden="true">
  <label><html:h2 data-l10n-id="webrtc-header"/></label>
  <hbox align="center">
    <checkbox id="enableWebRTCP2P"
              class="tail-with-learn-more"
              data-l10n-id="enable-webrtc-p2p"
              preference="media.peerconnection.enabled"/>
    <label class="learnMore" is="text-link" href="https://bugzilla.mozilla.org/show_bug.cgi?id=959893"
           data-l10n-id="content-blocking-learn-more"/>
  </hbox>
</groupbox>

<!-- HTTP Referrer Header-->
<groupbox id="refheader" data-category="panePrivacy" hidden="true">
   <label><html:h2 data-l10n-id="ref-header"/></label>

  <hbox align="center">
    <label id="historyModeLabel"
           control="doNotsendSecureXSiteReferrer"
           data-l10n-id="history-remember-label"/>
    <!-- Please don't remove the wrapping hbox/vbox/box for these elements. It's used to properly compute the search tooltip position. -->
    <hbox>
      <menulist id="doNotsendSecureXSiteReferrer" preference="network.http.sendRefererHeader">
        <menupopup>
          <menuitem data-l10n-id="send-referrer-header-0"
                    value="0"/>
          <menuitem data-l10n-id="send-referrer-header-1"
                    value="1"/>
          <menuitem data-l10n-id="send-referrer-header-2"
                    value="2"/>
        </menupopup>
      </menulist>
    </hbox>
  </hbox>
</groupbox>