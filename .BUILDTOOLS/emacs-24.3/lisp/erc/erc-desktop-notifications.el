;; erc-desktop-notifications.el -- Send notification on PRIVMSG or mentions

;; Copyright (C) 2012-2013 Free Software Foundation, Inc.

;; Author: Julien Danjou <julien@danjou.info>
;; Keywords: comm

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

;; This implements notifications using `notifications-notify' on
;; PRIVMSG received and on public nickname mentions.

;;; Code:

(require 'erc)
(require 'xml)
(require 'notifications)
(require 'erc-match)
(require 'dbus)

(defgroup erc-notifications nil
  "Send notifications on PRIVMSG or mentions."
  :version "24.3"
  :group 'erc)

(defvar erc-notifications-last-notification nil
  "Last notification id.")

(defcustom erc-notifications-icon nil
  "Icon to use for notification."
  :group 'erc-notifications
  :type 'file)

(defun erc-notifications-notify (nick msg)
  "Notify that NICK send some MSG.
This will replace the last notification sent with this function."
  (dbus-ignore-errors
    (setq erc-notifications-last-notification
          (notifications-notify :title (xml-escape-string nick)
                                :body (xml-escape-string msg)
                                :replaces-id erc-notifications-last-notification
                                :app-icon erc-notifications-icon))))

(defun erc-notifications-PRIVMSG (proc parsed)
  (let ((nick (car (erc-parse-user (erc-response.sender parsed))))
        (target (car (erc-response.command-args parsed)))
        (msg (erc-response.contents parsed)))
    (when (and (erc-current-nick-p target)
               (not (and (boundp 'erc-track-exclude)
                         (member nick erc-track-exclude)))
               (not (erc-is-message-ctcp-and-not-action-p msg)))
      (erc-notifications-notify nick msg)))
  ;; Return nil to continue processing by ERC
  nil)

(defun erc-notifications-notify-on-match (match-type nickuserhost msg)
  (when (eq match-type 'current-nick)
    (let ((nick (nth 0 (erc-parse-user nickuserhost))))
      (unless (or (string-match-p "^Server:" nick)
                  (when (boundp 'erc-track-exclude)
                    (member nick erc-track-exclude)))
        (erc-notifications-notify nick msg)))))

;;;###autoload(autoload 'erc-notifications-mode "erc-desktop-notifications" "" t)
(define-erc-module notifications nil
  "Send notifications on private message reception and mentions."
  ;; Enable
  ((add-hook 'erc-server-PRIVMSG-functions 'erc-notifications-PRIVMSG)
   (add-hook 'erc-text-matched-hook 'erc-notifications-notify-on-match))
  ;; Disable
  ((remove-hook 'erc-server-PRIVMSG-functions 'erc-notifications-PRIVMSG)
   (remove-hook 'erc-text-matched-hook 'erc-notifications-notify-on-match)))

(provide 'erc-desktop-notifications)

;;; erc-desktop-notifications.el ends here
