;;; gnus-icalendar.el --- reply to iCalendar meeting requests

;; Copyright (C) 2013-2014 Free Software Foundation, Inc.

;; Author: Jan Tatarik <Jan.Tatarik@gmail.com>
;; Keywords: mail, icalendar, org

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; To install:
;; (require 'gnus-icalendar)
;; (gnus-icalendar-setup)

;; to enable optional iCalendar->Org sync functionality
;; NOTE: both the capture file and the headline(s) inside must already exist
;; (setq gnus-icalendar-org-capture-file "~/org/notes.org")
;; (setq gnus-icalendar-org-capture-headline '("Calendar"))
;; (gnus-icalendar-org-setup)


;;; Code:

(require 'icalendar)
(require 'eieio)
(require 'gmm-utils)
(require 'mm-decode)
(require 'gnus-sum)

(eval-when-compile (require 'cl))

(defun gnus-icalendar-find-if (pred seq)
  (catch 'found
    (while seq
      (when (funcall pred (car seq))
        (throw 'found (car seq)))
      (pop seq))))

;;;
;;; ical-event
;;;

(defclass gnus-icalendar-event ()
  ((organizer :initarg :organizer
              :accessor gnus-icalendar-event:organizer
              :initform ""
              :type (or null string))
   (summary :initarg :summary
            :accessor gnus-icalendar-event:summary
            :initform ""
            :type (or null string))
   (description :initarg :description
                :accessor gnus-icalendar-event:description
                :initform ""
                :type (or null string))
   (location :initarg :location
             :accessor gnus-icalendar-event:location
             :initform ""
             :type (or null string))
   (start-time :initarg :start-time
          :accessor gnus-icalendar-event:start-time
          :initform ""
          :type (or null t))
   (end-time :initarg :end-time
        :accessor gnus-icalendar-event:end-time
        :initform ""
        :type (or null t))
   (recur :initarg :recur
          :accessor gnus-icalendar-event:recur
          :initform ""
          :type (or null string))
   (uid :initarg :uid
        :accessor gnus-icalendar-event:uid
        :type string)
   (method :initarg :method
           :accessor gnus-icalendar-event:method
           :initform "PUBLISH"
           :type (or null string))
   (rsvp :initarg :rsvp
         :accessor gnus-icalendar-event:rsvp
         :initform nil
         :type (or null boolean))
   (participation-type :initarg :participation-type
         :accessor gnus-icalendar-event:participation-type
         :initform 'non-participant
         :type (or null t))
   (req-participants :initarg :req-participants
         :accessor gnus-icalendar-event:req-participants
         :initform nil
         :type (or null t))
   (opt-participants :initarg :opt-participants
         :accessor gnus-icalendar-event:opt-participants
         :initform nil
         :type (or null t)))
  "generic iCalendar Event class")

(defclass gnus-icalendar-event-request (gnus-icalendar-event)
  nil
  "iCalendar class for REQUEST events")

(defclass gnus-icalendar-event-cancel (gnus-icalendar-event)
  nil
  "iCalendar class for CANCEL events")

(defclass gnus-icalendar-event-reply (gnus-icalendar-event)
  nil
  "iCalendar class for REPLY events")

(defmethod gnus-icalendar-event:recurring-p ((event gnus-icalendar-event))
  "Return t if EVENT is recurring."
  (not (null (gnus-icalendar-event:recur event))))

(defmethod gnus-icalendar-event:recurring-freq ((event gnus-icalendar-event))
  "Return recurring frequency of EVENT."
  (let ((rrule (gnus-icalendar-event:recur event)))
    (string-match "FREQ=\\([[:alpha:]]+\\)" rrule)
    (match-string 1 rrule)))

(defmethod gnus-icalendar-event:recurring-interval ((event gnus-icalendar-event))
  "Return recurring interval of EVENT."
  (let ((rrule (gnus-icalendar-event:recur event))
        (default-interval 1))

    (string-match "INTERVAL=\\([[:digit:]]+\\)" rrule)
    (or (match-string 1 rrule)
        default-interval)))

(defmethod gnus-icalendar-event:start ((event gnus-icalendar-event))
  (format-time-string "%Y-%m-%d %H:%M" (gnus-icalendar-event:start-time event)))

(defun gnus-icalendar-event--decode-datefield (ical field)
  (let* ((date (icalendar--get-event-property ical field))
         (date-props (icalendar--get-event-property-attributes ical field))
         (tz (plist-get date-props 'TZID)))

    (date-to-time (timezone-make-date-arpa-standard date nil tz))))

(defun gnus-icalendar-event--find-attendee (ical name-or-email)
  (let* ((event (car (icalendar--all-events ical)))
         (event-props (caddr event)))
    (gmm-labels ((attendee-name (att) (plist-get (cadr att) 'CN))
                 (attendee-email (att)
                   (replace-regexp-in-string "^.*MAILTO:" "" (caddr att)))
                 (attendee-prop-matches-p (prop)
                   (and (eq (car prop) 'ATTENDEE)
                        (or (member (attendee-name prop) name-or-email)
                            (let ((att-email (attendee-email prop)))
                              (gnus-icalendar-find-if (lambda (email)
                                                        (string-match email att-email))
                                                      name-or-email))))))

      (gnus-icalendar-find-if #'attendee-prop-matches-p event-props))))

(defun gnus-icalendar-event--get-attendee-names (ical)
  (let* ((event (car (icalendar--all-events ical)))
         (attendee-props (gnus-remove-if-not
                          (lambda (p) (eq (car p) 'ATTENDEE))
                          (caddr event))))

    (gmm-labels ((attendee-role (prop) (plist-get (cadr prop) 'ROLE))
                 (attendee-name (prop) (plist-get (cadr prop) 'CN))
                 (attendees-by-type (type)
                   (gnus-remove-if-not
                    (lambda (p) (string= (attendee-role p) type))
                    attendee-props))
                 (attendee-names-by-type (type)
                    (mapcar #'attendee-name (attendees-by-type type))))

      (list
       (attendee-names-by-type "REQ-PARTICIPANT")
       (attendee-names-by-type "OPT-PARTICIPANT")))))

(defun gnus-icalendar-event-from-ical (ical &optional attendee-name-or-email)
  (let* ((event (car (icalendar--all-events ical)))
         (organizer (replace-regexp-in-string
                     "^.*MAILTO:" ""
                     (or (icalendar--get-event-property event 'ORGANIZER) "")))
         (prop-map '((summary . SUMMARY)
                     (description . DESCRIPTION)
                     (location . LOCATION)
                     (recur . RRULE)
                     (uid . UID)))
         (method (caddr (assoc 'METHOD (caddr (car (nreverse ical))))))
         (attendee (when attendee-name-or-email
                     (gnus-icalendar-event--find-attendee ical attendee-name-or-email)))
         (attendee-names (gnus-icalendar-event--get-attendee-names ical))
         (role (plist-get (cadr attendee) 'ROLE))
         (participation-type (pcase role
                              ("REQ-PARTICIPANT" 'required)
                              ("OPT-PARTICIPANT" 'optional)
                              (_                 'non-participant)))
         (args (list :method method
                     :organizer organizer
                     :start-time (gnus-icalendar-event--decode-datefield event 'DTSTART)
                     :end-time (gnus-icalendar-event--decode-datefield event 'DTEND)
                     :rsvp (string= (plist-get (cadr attendee) 'RSVP) "TRUE")
                     :participation-type participation-type
                     :req-participants (car attendee-names)
                     :opt-participants (cadr attendee-names)))
         (event-class (cond
                       ((string= method "REQUEST") 'gnus-icalendar-event-request)
                       ((string= method "CANCEL") 'gnus-icalendar-event-cancel)
                       ((string= method "REPLY") 'gnus-icalendar-event-reply)
                       (t 'gnus-icalendar-event))))

    (gmm-labels ((map-property (prop)
                   (let ((value (icalendar--get-event-property event prop)))
                     (when value
                       ;; ugly, but cannot get
                       ;;replace-regexp-in-string work with "\\" as
                       ;;REP, plus we should also handle "\\;"
                       (replace-regexp-in-string
                        "\\\\," ","
                        (replace-regexp-in-string
                         "\\\\n" "\n" (substring-no-properties value))))))
                 (accumulate-args (mapping)
                   (destructuring-bind (slot . ical-property) mapping
                     (setq args (append (list
                                         (intern (concat ":" (symbol-name slot)))
                                         (map-property ical-property))
                                        args)))))

      (mapc #'accumulate-args prop-map)
      (apply 'make-instance event-class args))))

(defun gnus-icalendar-event-from-buffer (buf &optional attendee-name-or-email)
  "Parse RFC5545 iCalendar in buffer BUF and return an event object.

Return a gnus-icalendar-event object representing the first event
contained in the invitation. Return nil for calendars without an event entry.

ATTENDEE-NAME-OR-EMAIL is a list of strings that will be matched
against the event's attendee names and emails. Invitation rsvp
status will be retrieved from the first matching attendee record."
  (let ((ical (with-current-buffer (icalendar--get-unfolded-buffer (get-buffer buf))
                (goto-char (point-min))
                (icalendar--read-element nil nil))))

    (when ical
      (gnus-icalendar-event-from-ical ical attendee-name-or-email))))

;;;
;;; gnus-icalendar-event-reply
;;;

(defun gnus-icalendar-event--build-reply-event-body (ical-request status identities)
  (let ((summary-status (capitalize (symbol-name status)))
        (attendee-status (upcase (symbol-name status)))
        reply-event-lines)
    (gmm-labels ((update-summary (line)
                   (if (string-match "^[^:]+:" line)
                       (replace-match (format "\\&%s: " summary-status) t nil line)
                     line))
                 (update-dtstamp ()
                   (format-time-string "DTSTAMP:%Y%m%dT%H%M%SZ" nil t))
                 (attendee-matches-identity (line)
                   (gnus-icalendar-find-if (lambda (name) (string-match-p name line))
                                           identities))
                 (update-attendee-status (line)
                   (when (and (attendee-matches-identity line)
                              (string-match "\\(PARTSTAT=\\)[^;]+" line))
                     (replace-match (format "\\1%s" attendee-status) t nil line)))
                 (process-event-line (line)
                   (when (string-match "^\\([^;:]+\\)" line)
                     (let* ((key (match-string 0 line))
                            ;; NOTE: not all of the below fields are mandatory,
                            ;; but they are often present in other clients'
                            ;; replies. Can be helpful for debugging, too.
                            (new-line
                             (cond
                              ((string= key "ATTENDEE") (update-attendee-status line))
                              ((string= key "SUMMARY") (update-summary line))
                              ((string= key "DTSTAMP") (update-dtstamp))
                              ((member key '("ORGANIZER" "DTSTART" "DTEND"
                                             "LOCATION" "DURATION" "SEQUENCE"
                                             "RECURRENCE-ID" "UID")) line)
                              (t nil))))
                       (when new-line
                         (push new-line reply-event-lines))))))

      (mapc #'process-event-line (split-string ical-request "\n"))

      (unless (gnus-icalendar-find-if (lambda (x) (string-match "^ATTENDEE" x))
                          reply-event-lines)
        (error "Could not find an event attendee matching given identity"))

      (mapconcat #'identity `("BEGIN:VEVENT"
                              ,@(nreverse reply-event-lines)
                              "END:VEVENT")
                 "\n"))))

(defun gnus-icalendar-event-reply-from-buffer (buf status identities)
  "Build a calendar event reply for request contained in BUF.
The reply will have STATUS (`accepted', `tentative' or  `declined').
The reply will be composed for attendees matching any entry
on the IDENTITIES list."
  (gmm-labels ((extract-block (blockname)
               (save-excursion
                 (let ((block-start-re (format "^BEGIN:%s" blockname))
                       (block-end-re (format "^END:%s" blockname))
                       start)
                   (when (re-search-forward block-start-re nil t)
                     (setq start (line-beginning-position))
                     (re-search-forward block-end-re)
                     (buffer-substring-no-properties start (line-end-position)))))))

    (let (zone event)
      (with-current-buffer (icalendar--get-unfolded-buffer (get-buffer buf))
        (goto-char (point-min))
        (setq zone (extract-block "VTIMEZONE")
              event (extract-block "VEVENT")))

      (when event
        (let ((contents (list "BEGIN:VCALENDAR"
                              "METHOD:REPLY"
                              "PRODID:Gnus"
                              "VERSION:2.0"
                              zone
                              (gnus-icalendar-event--build-reply-event-body event status identities)
                              "END:VCALENDAR")))

          (mapconcat #'identity (delq nil contents) "\n"))))))

;;;
;;; gnus-icalendar-org
;;;
;;; TODO: this is an optional feature, and it's only available with org-mode
;;; 7+, so will need to properly handle emacsen with no/outdated org-mode

(require 'org)
(require 'org-capture)

(defgroup gnus-icalendar-org nil
  "Settings for Calendar Event gnus/org integration."
  :version "24.4"
  :group 'gnus-icalendar
  :prefix "gnus-icalendar-org-")

(defcustom gnus-icalendar-org-capture-file nil
  "Target Org file for storing captured calendar events."
  :type '(choice (const nil) file)
  :group 'gnus-icalendar-org)

(defcustom gnus-icalendar-org-capture-headline nil
  "Target outline in `gnus-icalendar-org-capture-file' for storing captured events."
  :type '(repeat string)
  :group 'gnus-icalendar-org)

(defcustom gnus-icalendar-org-template-name "used by gnus-icalendar-org"
  "Org-mode template name."
  :type '(string)
  :group 'gnus-icalendar-org)

(defcustom gnus-icalendar-org-template-key "#"
  "Org-mode template hotkey."
  :type '(string)
  :group 'gnus-icalendar-org)

(defvar gnus-icalendar-org-enabled-p nil)


(defmethod gnus-icalendar-event:org-repeat ((event gnus-icalendar-event))
  "Return `org-mode' timestamp repeater string for recurring EVENT.
Return nil for non-recurring EVENT."
  (when (gnus-icalendar-event:recurring-p event)
    (let* ((freq-map '(("HOURLY" . "h")
                       ("DAILY" . "d")
                       ("WEEKLY" . "w")
                       ("MONTHLY" . "m")
                       ("YEARLY" . "y")))
           (org-freq (cdr (assoc (gnus-icalendar-event:recurring-freq event) freq-map))))

      (when org-freq
        (format "+%s%s" (gnus-icalendar-event:recurring-interval event) org-freq)))))

(defmethod gnus-icalendar-event:org-timestamp ((event gnus-icalendar-event))
  "Build `org-mode' timestamp from EVENT start/end dates and recurrence info."
  (let* ((start (gnus-icalendar-event:start-time event))
         (end (gnus-icalendar-event:end-time event))
         (start-date (format-time-string "%Y-%m-%d %a" start))
         (start-time (format-time-string "%H:%M" start))
         (start-at-midnight (string= start-time "00:00"))
         (end-date (format-time-string "%Y-%m-%d %a" end))
         (end-time (format-time-string "%H:%M" end))
         (end-at-midnight (string= end-time "00:00"))
         (start-end-date-diff (/ (float-time (time-subtract
                                        (date-to-time end-date)
                                        (date-to-time start-date)))
                                 86400))
         (org-repeat (gnus-icalendar-event:org-repeat event))
         (repeat (if org-repeat (concat " " org-repeat) ""))
         (time-1-day '(0 86400)))

    ;; NOTE: special care is needed with appointments ending at midnight
    ;; (typically all-day events): the end time has to be changed to 23:59 to
    ;; prevent org agenda showing the event on one additional day
    (cond
     ;; start/end midnight
     ;; A 0:0 - A+1 0:0 -> A
     ;; A 0:0 - A+n 0:0 -> A - A+n-1
     ((and start-at-midnight end-at-midnight) (if (> start-end-date-diff 1)
                                                  (let ((end-ts (format-time-string "%Y-%m-%d %a" (time-subtract end time-1-day))))
                                                    (format "<%s>--<%s>" start-date end-ts))
                                                (format "<%s%s>" start-date repeat)))
     ;; end midnight
     ;; A .:. - A+1 0:0 -> A .:.-23:59
     ;; A .:. - A+n 0:0 -> A .:. - A_n-1
     (end-at-midnight (if (= start-end-date-diff 1)
                          (format "<%s %s-23:59%s>" start-date start-time repeat)
                        (let ((end-ts (format-time-string "%Y-%m-%d %a" (time-subtract end time-1-day))))
                          (format "<%s %s>--<%s>" start-date start-time end-ts))))
     ;; start midnight
     ;; A 0:0 - A .:. -> A 0:0-.:. (default 1)
     ;; A 0:0 - A+n .:. -> A - A+n .:.
     ((and start-at-midnight
           (plusp start-end-date-diff)) (format "<%s>--<%s %s>" start-date end-date end-time))
     ;; default
     ;; A .:. - A .:. -> A .:.-.:.
     ;; A .:. - B .:.
     ((zerop start-end-date-diff) (format "<%s %s-%s%s>" start-date start-time end-time repeat))
     (t (format "<%s %s>--<%s %s>" start-date start-time end-date end-time)))))

(defun gnus-icalendar--format-summary-line (summary &optional location)
  (if location
      (format "%s (%s)" summary location)
    (format "%s" summary)))


(defun gnus-icalendar--format-participant-list (participants)
  (mapconcat #'identity participants ", "))

;; TODO: make the template customizable
(defmethod gnus-icalendar-event->org-entry ((event gnus-icalendar-event) reply-status)
  "Return string with new `org-mode' entry describing EVENT."
  (with-temp-buffer
    (org-mode)
    (with-slots (organizer summary description location
                           recur uid) event
      (let* ((reply (if reply-status (capitalize (symbol-name reply-status))
                      "Not replied yet"))
             (props `(("ICAL_EVENT" . "t")
                      ("ID" . ,uid)
                      ("DT" . ,(gnus-icalendar-event:org-timestamp event))
                      ("ORGANIZER" . ,(gnus-icalendar-event:organizer event))
                      ("LOCATION" . ,(gnus-icalendar-event:location event))
                      ("PARTICIPATION_TYPE" . ,(symbol-name (gnus-icalendar-event:participation-type event)))
                      ("REQ_PARTICIPANTS" . ,(gnus-icalendar--format-participant-list (gnus-icalendar-event:req-participants event)))
                      ("OPT_PARTICIPANTS" . ,(gnus-icalendar--format-participant-list (gnus-icalendar-event:opt-participants event)))
                      ("RRULE" . ,(gnus-icalendar-event:recur event))
                      ("REPLY" . ,reply))))

        (insert (format "* %s\n\n"
                        (gnus-icalendar--format-summary-line summary location)))
        (mapc (lambda (prop)
                (org-entry-put (point) (car prop) (cdr prop)))
              props))

      (when description
        (save-restriction
          (narrow-to-region (point) (point))
          (insert description)
          (indent-region (point-min) (point-max) 2)
          (fill-region (point-min) (point-max))))

      (buffer-string))))

(defun gnus-icalendar--deactivate-org-timestamp (ts)
  (replace-regexp-in-string "[<>]"
                            (lambda (m) (cond ((string= m "<") "[")
                                              ((string= m ">") "]")))
                            ts))

(defun gnus-icalendar-find-org-event-file (event &optional org-file)
  "Return the name of the file containing EVENT org entry.
Return nil when not found.

All org agenda files are searched for the EVENT entry.  When
the optional ORG-FILE argument is specified, only that one file
is searched."
  (let ((uid (gnus-icalendar-event:uid event))
        (files (or org-file (org-agenda-files t 'ifmode))))
    (gmm-labels
        ((find-event-in (file)
           (org-check-agenda-file file)
           (with-current-buffer (find-file-noselect file)
             (let ((event-pos (org-find-entry-with-id uid)))
               (when (and event-pos
                          (string= (cdr (assoc "ICAL_EVENT" (org-entry-properties event-pos)))
                                   "t"))
                 (throw 'found file))))))

      (gnus-icalendar-find-if #'find-event-in files))))


(defun gnus-icalendar--show-org-event (event &optional org-file)
  (let ((file (gnus-icalendar-find-org-event-file event org-file)))
    (when file
      (switch-to-buffer (find-file file))
      (goto-char (org-find-entry-with-id (gnus-icalendar-event:uid event)))
      (org-show-entry))))


(defun gnus-icalendar--update-org-event (event reply-status &optional org-file)
  (let ((file (gnus-icalendar-find-org-event-file event org-file)))
    (when file
      (with-current-buffer (find-file-noselect file)
        (with-slots (uid summary description organizer location recur
                         participation-type req-participants opt-participants) event
          (let ((event-pos (org-find-entry-with-id uid)))
            (when event-pos
              (goto-char event-pos)

              ;; update the headline, keep todo, priority and tags, if any
              (save-excursion
                (let* ((priority (org-entry-get (point) "PRIORITY"))
                       (headline (delq nil (list
                                            (org-entry-get (point) "TODO")
                                            (when priority (format "[#%s]" priority))
                                            (gnus-icalendar--format-summary-line summary location)
                                            (org-entry-get (point) "TAGS")))))

                  (re-search-forward "^\\*+ " (line-end-position))
                  (delete-region (point) (line-end-position))
                  (insert (mapconcat #'identity headline " "))))

              ;; update props and description
              (let ((entry-end (org-entry-end-position))
                    (entry-outline-level (org-outline-level)))

                ;; delete body of the entry, leave org drawers intact
                (save-restriction
                  (org-narrow-to-element)
                  (goto-char entry-end)
                  (re-search-backward "^[\t ]*:END:")
                  (forward-line)
                  (delete-region (point) entry-end))

                ;; put new event description in the entry body
                (when description
                  (save-restriction
                    (narrow-to-region (point) (point))
                    (insert "\n" (replace-regexp-in-string "[\n]+$" "\n" description) "\n")
                    (indent-region (point-min) (point-max) (1+ entry-outline-level))
                    (fill-region (point-min) (point-max))))

                ;; update entry properties
                (org-entry-put event-pos "DT" (gnus-icalendar-event:org-timestamp event))
                (org-entry-put event-pos "ORGANIZER" organizer)
                (org-entry-put event-pos "LOCATION" location)
                (org-entry-put event-pos "PARTICIPATION_TYPE" (symbol-name participation-type))
                (org-entry-put event-pos "REQ_PARTICIPANTS" (gnus-icalendar--format-participant-list req-participants))
                (org-entry-put event-pos "OPT_PARTICIPANTS" (gnus-icalendar--format-participant-list opt-participants))
                (org-entry-put event-pos "RRULE" recur)
                (when reply-status (org-entry-put event-pos "REPLY"
                                                  (capitalize (symbol-name reply-status))))
                (save-buffer)))))))))


(defun gnus-icalendar--cancel-org-event (event &optional org-file)
  (let ((file (gnus-icalendar-find-org-event-file event org-file)))
    (when file
      (with-current-buffer (find-file-noselect file)
        (let ((event-pos (org-find-entry-with-id (gnus-icalendar-event:uid event))))
          (when event-pos
            (let ((ts (org-entry-get event-pos "DT")))
              (when ts
                (org-entry-put event-pos "DT" (gnus-icalendar--deactivate-org-timestamp ts))
                (save-buffer)))))))))


(defun gnus-icalendar--get-org-event-reply-status (event &optional org-file)
  (let ((file (gnus-icalendar-find-org-event-file event org-file)))
    (when file
      (save-excursion
        (with-current-buffer (find-file-noselect file)
          (let ((event-pos (org-find-entry-with-id (gnus-icalendar-event:uid event))))
            (org-entry-get event-pos "REPLY")))))))


(defun gnus-icalendar-insinuate-org-templates ()
  (unless (gnus-icalendar-find-if (lambda (x) (string= (cadr x) gnus-icalendar-org-template-name))
                      org-capture-templates)
    (setq org-capture-templates
          (append `((,gnus-icalendar-org-template-key
                     ,gnus-icalendar-org-template-name
                     entry
                     (file+olp ,gnus-icalendar-org-capture-file ,@gnus-icalendar-org-capture-headline)
                     "%i"
                     :immediate-finish t))
                  org-capture-templates))

    ;; hide the template from interactive template selection list
    ;; (org-capture)
    ;; NOTE: doesn't work when capturing from string
    ;; (when (boundp 'org-capture-templates-contexts)
    ;;   (push `(,gnus-icalendar-org-template-key "" ((in-mode . "gnus-article-mode")))
    ;;         org-capture-templates-contexts))
    ))

(defun gnus-icalendar:org-event-save (event reply-status)
  (with-temp-buffer
    (org-capture-string (gnus-icalendar-event->org-entry event reply-status)
                        gnus-icalendar-org-template-key)))

(defun gnus-icalendar-show-org-agenda (event)
  (let* ((time-delta (time-subtract (gnus-icalendar-event:end-time event)
                                    (gnus-icalendar-event:start-time event)))
         (duration-days (1+ (/ (+ (* (car time-delta) (expt 2 16))
                                  (cadr time-delta))
                               86400))))

    (org-agenda-list nil (gnus-icalendar-event:start event) duration-days)))

(defmethod gnus-icalendar-event:sync-to-org ((event gnus-icalendar-event-request) reply-status)
  (if (gnus-icalendar-find-org-event-file event)
      (gnus-icalendar--update-org-event event reply-status)
    (gnus-icalendar:org-event-save event reply-status)))

(defmethod gnus-icalendar-event:sync-to-org ((event gnus-icalendar-event-cancel) reply-status)
  (when (gnus-icalendar-find-org-event-file event)
    (gnus-icalendar--cancel-org-event event)))

(defun gnus-icalendar-org-setup ()
  (if (and gnus-icalendar-org-capture-file gnus-icalendar-org-capture-headline)
      (progn
        (gnus-icalendar-insinuate-org-templates)
        (setq gnus-icalendar-org-enabled-p t))
    (message "Cannot enable Calendar->Org: missing capture file, headline")))

;;;
;;; gnus-icalendar
;;;

(defgroup gnus-icalendar nil
  "Settings for inline display of iCalendar invitations."
  :version "24.4"
  :group 'gnus-article
  :prefix "gnus-icalendar-")

(defcustom gnus-icalendar-reply-bufname "*CAL*"
  "Buffer used for building iCalendar invitation reply."
  :type '(string)
  :group 'gnus-icalendar)

(defcustom gnus-icalendar-additional-identities nil
  "We need to know your identity to make replies to calendar requests work.

Gnus will only offer you the Accept/Tentative/Decline buttons for
calendar events if any of your identities matches at least one
RSVP participant.

Your identity is guessed automatically from the variables `user-full-name',
`user-mail-address', and `gnus-ignored-from-addresses'.

If you need even more aliases you can define them here.  It really
only makes sense to define names or email addresses."

  :type '(repeat string)
  :group 'gnus-icalendar)

(make-variable-buffer-local
 (defvar gnus-icalendar-reply-status nil))

(make-variable-buffer-local
 (defvar gnus-icalendar-event nil))

(make-variable-buffer-local
 (defvar gnus-icalendar-handle nil))

(defun gnus-icalendar-identities ()
  "Return list of regexp-quoted names and email addresses belonging to the user.

These will be used to retrieve the RSVP information from ical events."
  (apply #'append
         (mapcar (lambda (x) (if (listp x) x (list x)))
                 (list user-full-name (regexp-quote user-mail-address)
                       ; NOTE: these can be lists
                       gnus-ignored-from-addresses ; already regexp-quoted
                       (mapcar #'regexp-quote gnus-icalendar-additional-identities)))))

;; TODO: make the template customizable
(defmethod gnus-icalendar-event->gnus-calendar ((event gnus-icalendar-event) &optional reply-status)
  "Format an overview of EVENT details."
  (gmm-labels ((format-header (x)
            (format "%-12s%s"
                    (propertize (concat (car x) ":") 'face 'bold)
                    (cadr x))))

    (with-slots (organizer summary description location recur uid
                           method rsvp participation-type) event
      (let ((headers `(("Summary" ,summary)
                      ("Location" ,(or location ""))
                      ("Time" ,(gnus-icalendar-event:org-timestamp event))
                      ("Organizer" ,organizer)
                      ("Attendance" ,(if (eq participation-type 'non-participant)
                                         "You are not listed as an attendee"
                                       (capitalize (symbol-name participation-type))))
                      ("Method" ,method))))

       (when (and (not (gnus-icalendar-event-reply-p event)) rsvp)
         (setq headers (append headers
                               `(("Status" ,(or reply-status "Not replied yet"))))))

       (concat
        (mapconcat #'format-header headers "\n")
        "\n\n"
        description)))))

(defmacro gnus-icalendar-with-decoded-handle (handle &rest body)
  "Execute BODY in buffer containing the decoded contents of HANDLE."
  (let ((charset (make-symbol "charset")))
    `(let ((,charset (cdr (assoc 'charset (mm-handle-type ,handle)))))
       (with-temp-buffer
         (mm-insert-part ,handle)
         (when (string= ,charset "utf-8")
           (mm-decode-coding-region (point-min) (point-max) 'utf-8))

         ,@body))))


(defun gnus-icalendar-event-from-handle (handle &optional attendee-name-or-email)
  (gnus-icalendar-with-decoded-handle handle
                       (gnus-icalendar-event-from-buffer (current-buffer) attendee-name-or-email)))

(defun gnus-icalendar-insert-button (text callback data)
  ;; FIXME: the gnus-mime-button-map keymap does not make sense for this kind
  ;; of button.
  (let ((start (point)))
    (gnus-add-text-properties
     start
     (progn
       (insert "[ " text " ]")
       (point))
     `(gnus-callback
       ,callback
       keymap ,gnus-mime-button-map
       face ,gnus-article-button-face
       gnus-data ,data))
    (widget-convert-button 'link start (point)
                           :action 'gnus-widget-press-button
                           :button-keymap gnus-widget-button-keymap)))

(defun gnus-icalendar-send-buffer-by-mail (buffer-name subject)
  (let ((message-signature nil))
    (with-current-buffer gnus-summary-buffer
      (gnus-summary-reply)
      (message-goto-body)
      (mml-insert-multipart "alternative")
      (mml-insert-empty-tag 'part 'type "text/plain")
      (mml-attach-buffer buffer-name "text/calendar; method=REPLY; charset=UTF-8")
      (message-goto-subject)
      (delete-region (line-beginning-position) (line-end-position))
      (insert "Subject: " subject)
      (message-send-and-exit))))

(defun gnus-icalendar-reply (data)
  (let* ((handle (car data))
         (status (cadr data))
         (event (caddr data))
         (reply (gnus-icalendar-with-decoded-handle handle
                  (gnus-icalendar-event-reply-from-buffer
                   (current-buffer) status (gnus-icalendar-identities)))))

    (when reply
      (gmm-labels ((fold-icalendar-buffer ()
               (goto-char (point-min))
               (while (re-search-forward "^\\(.\\{72\\}\\)\\(.+\\)$" nil t)
                 (replace-match "\\1\n \\2")
                 (goto-char (line-beginning-position)))))
        (let ((subject (concat (capitalize (symbol-name status))
                               ": " (gnus-icalendar-event:summary event))))

          (with-current-buffer (get-buffer-create gnus-icalendar-reply-bufname)
            (delete-region (point-min) (point-max))
            (insert reply)
            (fold-icalendar-buffer)
            (gnus-icalendar-send-buffer-by-mail (buffer-name) subject))

          ;; Back in article buffer
          (setq-local gnus-icalendar-reply-status status)
          (when gnus-icalendar-org-enabled-p
            (gnus-icalendar--update-org-event event status)
            ;; refresh article buffer to update the reply status
            (with-current-buffer gnus-summary-buffer
              (gnus-summary-show-article))))))))

(defun gnus-icalendar-sync-event-to-org (event)
  (gnus-icalendar-event:sync-to-org event gnus-icalendar-reply-status))

(defmethod gnus-icalendar-event:inline-reply-buttons ((event gnus-icalendar-event) handle)
  (when (gnus-icalendar-event:rsvp event)
    `(("Accept" gnus-icalendar-reply (,handle accepted ,event))
      ("Tentative" gnus-icalendar-reply (,handle tentative ,event))
      ("Decline" gnus-icalendar-reply (,handle declined ,event)))))

(defmethod gnus-icalendar-event:inline-reply-buttons ((event gnus-icalendar-event-reply) handle)
  "No buttons for REPLY events."
  nil)

(defmethod gnus-icalendar-event:inline-reply-status ((event gnus-icalendar-event))
  (or (when gnus-icalendar-org-enabled-p
        (gnus-icalendar--get-org-event-reply-status event))
      "Not replied yet"))

(defmethod gnus-icalendar-event:inline-reply-status ((event gnus-icalendar-event-reply))
  "No reply status for REPLY events."
  nil)


(defmethod gnus-icalendar-event:inline-org-buttons ((event gnus-icalendar-event))
  (let* ((org-entry-exists-p (gnus-icalendar-find-org-event-file event))
         (export-button-text (if org-entry-exists-p "Update Org Entry" "Export to Org")))

    (delq nil (list
               `("Show Agenda" gnus-icalendar-show-org-agenda ,event)
               (when (gnus-icalendar-event-request-p event)
                 `(,export-button-text gnus-icalendar-sync-event-to-org ,event))
               (when org-entry-exists-p
                 `("Show Org Entry" gnus-icalendar--show-org-event ,event))))))


(defmethod gnus-icalendar-event:inline-org-buttons ((event gnus-icalendar-event-cancel))
  (let ((org-entry-exists-p (gnus-icalendar-find-org-event-file event)))

    (delq nil (list
               `("Show Agenda" gnus-icalendar-show-org-agenda ,event)
               (when org-entry-exists-p
                 `("Update Org Entry" gnus-icalendar-sync-event-to-org ,event))
               (when org-entry-exists-p
                 `("Show Org Entry" gnus-icalendar--show-org-event ,event))))))


(defun gnus-icalendar-mm-inline (handle)
  (let ((event (gnus-icalendar-event-from-handle handle (gnus-icalendar-identities))))

    (setq gnus-icalendar-reply-status nil)

    (when event
      (gmm-labels ((insert-button-group (buttons)
                (when buttons
                  (mapc (lambda (x)
                          (apply 'gnus-icalendar-insert-button x)
                          (insert "    "))
                        buttons)
                  (insert "\n\n"))))

        (insert-button-group
	 (gnus-icalendar-event:inline-reply-buttons event handle))

        (when gnus-icalendar-org-enabled-p
          (insert-button-group (gnus-icalendar-event:inline-org-buttons event)))

        (setq gnus-icalendar-event event
              gnus-icalendar-handle handle)

        (insert (gnus-icalendar-event->gnus-calendar
                 event
                 (gnus-icalendar-event:inline-reply-status event)))))))

(defun gnus-icalendar-save-part (handle)
  (let (event)
    (when (and (equal (car (mm-handle-type handle)) "text/calendar")
               (setq event (gnus-icalendar-event-from-handle handle (gnus-icalendar-identities))))

      (gnus-icalendar-event:sync-to-org event))))


(defun gnus-icalendar-save-event ()
  "Save the Calendar event in the text/calendar part under point."
  (interactive)
  (gnus-article-check-buffer)
  (let ((data (get-text-property (point) 'gnus-data)))
    (when data
      (gnus-icalendar-save-part data))))

(defun gnus-icalendar-reply-accept ()
  "Accept invitation in the current article."
  (interactive)
  (with-current-buffer gnus-article-buffer
    (gnus-icalendar-reply (list gnus-icalendar-handle 'accepted gnus-icalendar-event))
    (setq-local gnus-icalendar-reply-status 'accepted)))

(defun gnus-icalendar-reply-tentative ()
  "Send tentative response to invitation in the current article."
  (interactive)
  (with-current-buffer gnus-article-buffer
    (gnus-icalendar-reply (list gnus-icalendar-handle 'tentative gnus-icalendar-event))
    (setq-local gnus-icalendar-reply-status 'tentative)))

(defun gnus-icalendar-reply-decline ()
  "Decline invitation in the current article."
  (interactive)
  (with-current-buffer gnus-article-buffer
    (gnus-icalendar-reply (list gnus-icalendar-handle 'declined gnus-icalendar-event))
    (setq-local gnus-icalendar-reply-status 'declined)))

(defun gnus-icalendar-event-export ()
  "Export calendar event to `org-mode', or update existing agenda entry."
  (interactive)
  (with-current-buffer gnus-article-buffer
    (gnus-icalendar-sync-event-to-org gnus-icalendar-event))
  ;; refresh article buffer in case the reply had been sent before initial org
  ;; export
  (with-current-buffer gnus-summary-buffer
    (gnus-summary-show-article)))

(defun gnus-icalendar-event-show ()
  "Display `org-mode' agenda entry related to the calendar event."
  (interactive)
  (gnus-icalendar--show-org-event
   (with-current-buffer gnus-article-buffer
     gnus-icalendar-event)))

(defun gnus-icalendar-event-check-agenda ()
  "Display `org-mode' agenda for days between event start and end dates."
  (interactive)
  (gnus-icalendar-show-org-agenda
   (with-current-buffer gnus-article-buffer gnus-icalendar-event)))

(defvar gnus-mime-action-alist)         ; gnus-art

(defun gnus-icalendar-setup ()
  (add-to-list 'mm-inlined-types "text/calendar")
  (add-to-list 'mm-automatic-display "text/calendar")
  (add-to-list 'mm-inline-media-tests '("text/calendar" gnus-icalendar-mm-inline identity))

  (gnus-define-keys (gnus-summary-calendar-map "i" gnus-summary-mode-map)
    "a" gnus-icalendar-reply-accept
    "t" gnus-icalendar-reply-tentative
    "d" gnus-icalendar-reply-decline
    "c" gnus-icalendar-event-check-agenda
    "e" gnus-icalendar-event-export
    "s" gnus-icalendar-event-show)

  (require 'gnus-art)
  (add-to-list 'gnus-mime-action-alist
               (cons "save calendar event" 'gnus-icalendar-save-event)
               t))

(provide 'gnus-icalendar)

;;; gnus-icalendar.el ends here
