# This Source Code Form is subject to the terms of the Waterfox Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

videocontrols-scrubber =
    .aria-label = Θέση
# This label is used by screenreaders and other assistive technology to indicate
# to users how much of the video has been loaded from the network. It will be
# followed by the percentage of the video that has loaded (e.g. "Loading: 13%").
videocontrols-buffer-bar-label = Φόρτωση:
videocontrols-volume-control =
    .aria-label = Ένταση
videocontrols-closed-caption-button =
    .aria-label = Υπότιτλοι
videocontrols-play-button =
    .aria-label = Αναπαραγωγή
videocontrols-pause-button =
    .aria-label = Παύση
videocontrols-mute-button =
    .aria-label = Σίγαση
videocontrols-unmute-button =
    .aria-label = Άρση σίγασης
videocontrols-enterfullscreen-button =
    .aria-label = Πλήρης οθόνη
videocontrols-exitfullscreen-button =
    .aria-label = Έξοδος από την πλήρη οθόνη
videocontrols-casting-button-label =
    .aria-label = Μετάδοση σε οθόνη
videocontrols-closed-caption-off =
    .offlabel = Ανενεργό
# This string is used as part of the Picture-in-Picture video toggle button when
# the mouse is hovering it.
videocontrols-picture-in-picture-label = Εικόνα εντός εικόνας
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label = Προβολή σε «Εικόνα εντός εικόνας»
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer = Κάντε αναπαραγωγή βίντεο στο προσκήνιο ενώ κάνετε άλλα πράγματα στο { -brand-short-name }
# This string is used as the label for a variation of the Picture-in-Picture video
# toggle button when the mouse is hovering over the video.
videocontrols-picture-in-picture-toggle-label2 = Απόσπαση βίντεο
# This string is used as part of a variation of the Picture-in-Picture video toggle
# button. When using this variation, this string appears below the toggle when the
# mouse hovers the toggle.
videocontrols-picture-in-picture-explainer2 = Περισσότερες οθόνες, περισσότερη διασκέδαση. Δείτε αυτό το βίντεο σε λειτουργία «Εικόνα εντός εικόνας» κατά την περιήγησή σας.
videocontrols-error-aborted = Η φόρτωση του βίντεο διακόπηκε.
videocontrols-error-network = Η αναπαραγωγή του βίντεο εγκαταλείφθηκε λόγω σφάλματος δικτύου.
videocontrols-error-decode = Αδυναμία αναπαραγωγής βίντεο επειδή το αρχείο είναι κατεστραμμένο.
videocontrols-error-src-not-supported = Η μορφή του βίντεο ή ο τύπος MIME δεν υποστηρίζονται.
videocontrols-error-no-source = Δεν βρέθηκε βίντεο με υποστηριζόμενη μορφή και τύπο MIME.
videocontrols-error-generic = Η αναπαραγωγή του βίντεο εγκαταλείφθηκε λόγω άγνωστου σφάλματος.
videocontrols-status-picture-in-picture = Tο βίντεο αναπαράγεται σε λειτουργία «Εικόνα εντός εικόνας».
# This message shows the current position and total video duration
#
# Variables:
#   $position (String): The current media position
#   $duration (String): The total video duration
#
# For example, when at the 5 minute mark in a 6 hour long video,
# $position would be "5:00" and $duration would be "6:00:00", result
# string would be "5:00 / 6:00:00". Note that $duration is not always
# available. For example, when at the 5 minute mark in an unknown
# duration video, $position would be "5:00" and the string which is
# surrounded by <span> would be deleted, result string would be "5:00".
videocontrols-position-and-duration-labels = { $position }<span data-l10n-name="position-duration-format"> / { $duration }</span>
