;; gnus-notifications.el -- Send notification on new message in Gnus

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Julien Danjou <julien@danjou.info>
;; Keywords: news

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This implements notifications using `notifications-notify' on new
;; messages received.
;; Use (add-hook 'gnus-after-getting-new-news-hook 'gnus-notifications)
;; to get notifications just after getting the new news.

;;; Code:

(ignore-errors
  (require 'notifications))
(require 'gnus-sum)
(require 'gnus-group)
(require 'gnus-int)
(require 'gnus-art)
(require 'gnus-util)
(ignore-errors
  (require 'google-contacts))        ; Optional
(require 'gnus-fun)

(defgroup gnus-notifications nil
  "Send notifications on new message in Gnus."
  :version "24.3"
  :group 'gnus)

(defcustom gnus-notifications-use-google-contacts t
  "Use Google Contacts to retrieve photo."
  :type 'boolean
  :group 'gnus-notifications)

(defcustom gnus-notifications-use-gravatar t
  "Use Gravatar to retrieve photo."
  :type 'boolean
  :group 'gnus-notifications)

(defcustom gnus-notifications-minimum-level 1
  "Minimum group level the message should have to be notified.
Any message in a group that has a greater value than this will
not get notifications."
  :type 'integer
  :group 'gnus-notifications)

(defcustom gnus-notifications-timeout nil
  "Timeout used for notifications sent via `notifications-notify'."
  :type 'integer
  :group 'gnus-notifications)

(defvar gnus-notifications-sent nil
  "Notifications already sent.")

(defvar gnus-notifications-id-to-msg nil
  "Map notifications ids to messages.")

(defun gnus-notifications-action (id key)
  (when (string= key "read")
    (let ((group-article (assoc id gnus-notifications-id-to-msg)))
      (when group-article
        (let ((group (cadr group-article))
              (article (nth 2 group-article)))
          (gnus-fetch-group group (list article)))))))

(defun gnus-notifications-notify (from subject photo-file)
  "Send a notification about a new mail.
Return a notification id if any, or t on success."
  (if (fboundp 'notifications-notify)
      (gnus-funcall-no-warning
       'notifications-notify
       :title from
       :body subject
       :actions '("read" "Read")
       :on-action 'gnus-notifications-action
       :app-icon (gnus-funcall-no-warning
		  'image-search-load-path "gnus/gnus.png")
       :app-name "Gnus"
       :category "email.arrived"
       :timeout gnus-notifications-timeout
       :image-path photo-file)
    (message "New message from %s: %s" from subject)
    ;; Don't return an id
    t))

(defun gnus-notifications-get-photo (mail-address)
  "Get photo for mail address."
  (let ((google-photo (when (and gnus-notifications-use-google-contacts
                                 (fboundp 'google-contacts-get-photo))
                        (ignore-errors
                          (gnus-funcall-no-warning
			   'google-contacts-get-photo mail-address)))))
    (if google-photo
        google-photo
      (when gnus-notifications-use-gravatar
        (let ((gravatar (ignore-errors
                          (gravatar-retrieve-synchronously mail-address))))
          (if (eq gravatar 'error)
              nil
            (plist-get (cdr gravatar) :data)))))))

(defun gnus-notifications-get-photo-file (mail-address)
  "Get a temporary file with an image for MAIL-ADDRESS.
You have to delete the temporary image yourself using
`delete-image'.

Returns nil if no image found."
  (let ((photo (gnus-notifications-get-photo mail-address)))
    (when photo
      (let ((photo-file (make-temp-file "gnus-notifications-photo-"))
            (coding-system-for-write 'binary))
        (with-temp-file photo-file
          (insert photo))
        photo-file))))

;;;###autoload
(defun gnus-notifications ()
  "Send a notification on new message.
This check for new messages that are in group with a level lower
or equal to `gnus-notifications-minimum-level' and send a
notification using `notifications-notify' for it.

This is typically a function to add in
`gnus-after-getting-new-news-hook'"
  (dolist (entry gnus-newsrc-alist)
    (let ((group (car entry)))
      ;; Check that the group level is less than
      ;; `gnus-notifications-minimum-level' and the the group has unread
      ;; messages.
      (when (and (<= (gnus-group-level group) gnus-notifications-minimum-level)
                 (let ((unread (gnus-group-unread group)))
                   (and (numberp unread)
                        (> unread 0))))
        ;; Each group should have an entry in the `gnus-notifications-sent'
        ;; alist. If not, we add one at this time.
        (let ((group-notifications (or (assoc group gnus-notifications-sent)
                                       ;; Nothing, add one and return it.
                                       (assoc group
                                              (add-to-list
                                               'gnus-notifications-sent
                                               (cons group nil))))))
          (dolist (article (gnus-list-of-unread-articles group))
            ;; Check if the article already has been notified
            (unless (memq article (cdr group-notifications))
              (with-current-buffer nntp-server-buffer
                (gnus-request-head article group)
                (article-decode-encoded-words) ; to decode mail addresses, subjects, etc
                (let* ((address-components (mail-extract-address-components
                                            (or (mail-fetch-field "From") "")))
                       (address (cadr address-components)))
                  ;; Ignore mails from ourselves
                  (unless (and gnus-ignored-from-addresses
                               address
                               (gnus-string-match-p gnus-ignored-from-addresses
                                                    address))
                    (let* ((photo-file (gnus-notifications-get-photo-file address))
                           (notification-id (gnus-notifications-notify
                                             (or (car address-components) address)
                                             (mail-fetch-field "Subject")
                                             photo-file)))
                      (when notification-id
                        ;; Register that we did notify this message
                        (setcdr group-notifications (cons article (cdr group-notifications)))
                        (unless (eq notification-id t)
                          ;; Register the notification id for later actions
                          (add-to-list 'gnus-notifications-id-to-msg (list notification-id group article))))
                      (when photo-file
                        (delete-file photo-file)))))))))))))

(provide 'gnus-notifications)

;;; gnus-notifications.el ends here
