;;; gnus-sync.el --- synchronization facility for Gnus

;; Copyright (C) 2010-2013 Free Software Foundation, Inc.

;; Author: Ted Zlatanov <tzz@lifelogs.com>
;; Keywords: news synchronization nntp nnrss

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

;; This is the gnus-sync.el package.

;; Put this in your startup file (~/.gnus.el for instance)

;; possibilities for gnus-sync-backend:
;; Tramp over SSH: /ssh:user@host:/path/to/filename
;; ...or any other file Tramp and Emacs can handle...

;; (setq gnus-sync-backend "/remote:/path.gpg" ; will use Tramp+EPA if loaded
;;       gnus-sync-global-vars '(gnus-newsrc-last-checked-date)
;;       gnus-sync-newsrc-groups '("nntp" "nnrss"))
;;       gnus-sync-newsrc-offsets '(2 3))
;; against a LeSync server (beware the vampire LeSync, who knows your newsrc)

;; (setq gnus-sync-backend '(lesync "http://lesync.info:5984/tzz")
;;       gnus-sync-newsrc-groups '("nntp" "nnrss"))

;; What's a LeSync server?

;; 1. install CouchDB, set up a real server admin user, and create a
;; database, e.g. "tzz" and save the URL,
;; e.g. http://lesync.info:5984/tzz

;; 2. run `M-: (gnus-sync-lesync-setup "http://lesync.info:5984/tzz" "tzzadmin" "mypassword" "mysalt" t t)'

;;    (If you run it more than once, you have to remove the entry from
;;    _users yourself.  This is intentional.  This sets up a database
;;    admin for the "tzz" database, distinct from the server admin
;;    user in (1) above.)

;; That's it, you can start using http://lesync.info:5984/tzz in your
;; gnus-sync-backend as a LeSync backend.  Fan fiction about the
;; vampire LeSync is welcome.

;; You may not want to expose a CouchDB install to the Big Bad
;; Internet, especially if your love of all things furry would be thus
;; revealed.  Make sure it's not accessible by unauthorized users and
;; guests, at least.

;; If you want to try it out, I will create a test DB for you under
;; http://lesync.info:5984/yourfavoritedbname

;; TODO:

;; - after gnus-sync-read, the message counts look wrong until you do
;;   `g'.  So it's not run automatically, you have to call it with M-x
;;   gnus-sync-read

;; - use gnus-after-set-mark-hook and gnus-before-update-mark-hook to
;;   catch the mark updates

;; - repositioning of groups within topic after a LeSync sync is a
;;   weird sort of bubble sort ("buttle" sort: the old entry ends up
;;   at the rear of the list); you will eventually end up with the
;;   right order after calling `gnus-sync-read' a bunch of times.

;; - installing topics and groups is inefficient and annoying, lots of
;;   prompts could be avoided

;;; Code:

(eval-when-compile (require 'cl))
(require 'json)
(require 'gnus)
(require 'gnus-start)
(require 'gnus-util)

(defvar gnus-topic-alist) ;; gnus-group.el
(eval-when-compile
  (autoload 'gnus-group-topic "gnus-topic")
  (autoload 'gnus-topic-create-topic "gnus-topic" nil t)
  (autoload 'gnus-topic-enter-dribble "gnus-topic"))

(defgroup gnus-sync nil
  "The Gnus synchronization facility."
  :version "24.1"
  :group 'gnus)

(defcustom gnus-sync-newsrc-groups '("nntp" "nnrss")
  "List of groups to be synchronized in the gnus-newsrc-alist.
The group names are matched, they don't have to be fully
qualified.  Typically you would choose all of these.  That's the
default because there is no active sync backend by default, so
this setting is harmless until the user chooses a sync backend."
  :group 'gnus-sync
  :type '(repeat regexp))

(defcustom gnus-sync-newsrc-offsets '(2 3)
  "List of per-group data to be synchronized."
  :group 'gnus-sync
  :type '(set (const :tag "Read ranges" 2)
              (const :tag "Marks" 3)))

(defcustom gnus-sync-global-vars nil
  "List of global variables to be synchronized.
You may want to sync `gnus-newsrc-last-checked-date' but pretty
much any symbol is fair game.  You could additionally sync
`gnus-newsrc-alist', `gnus-server-alist', `gnus-topic-topology',
and `gnus-topic-alist'.  Also see `gnus-variable-list'."
  :group 'gnus-sync
  :type '(repeat (choice (variable :tag "A known variable")
                         (symbol :tag "Any symbol"))))

(defcustom gnus-sync-backend nil
  "The synchronization backend."
  :group 'gnus-sync
  :type '(radio (const :format "None" nil)
                (list :tag "Sync server"
                      (const :format "LeSync Server API" lesync)
                      (string :tag "URL of a CouchDB database for API access"))
                (string :tag "Sync to a file")))

(defvar gnus-sync-newsrc-loader nil
  "Carrier for newsrc data")

(defcustom gnus-sync-lesync-name (system-name)
  "The LeSync name for this machine."
  :group 'gnus-sync
  :version "24.3"
  :type 'string)

(defcustom gnus-sync-lesync-install-topics 'ask
  "Should LeSync install the recorded topics?"
  :group 'gnus-sync
  :version "24.3"
  :type '(choice (const :tag "Never Install" nil)
                 (const :tag "Always Install" t)
                 (const :tag "Ask Me Once" ask)))

(defvar gnus-sync-lesync-props-hash (make-hash-table :test 'equal)
  "LeSync props, keyed by group name")

(defvar gnus-sync-lesync-design-prefix "/_design/lesync"
  "The LeSync design prefix for CouchDB")

(defvar gnus-sync-lesync-security-object "/_security"
  "The LeSync security object for CouchDB")

(defun gnus-sync-lesync-parse ()
  "Parse the result of a LeSync request."
  (goto-char (point-min))
  (condition-case nil
      (when (search-forward-regexp "^$" nil t)
        (json-read))
    (error
     (gnus-message
      1
      "gnus-sync-lesync-parse: Could not read the LeSync response!")
     nil)))

(defun gnus-sync-lesync-call (url method headers &optional kvdata)
  "Make an access request to URL using KVDATA and METHOD.
KVDATA must be an alist."
  (flet ((json-alist-p (list) (gnus-sync-json-alist-p list))) ; temp patch
    (let ((url-request-method method)
          (url-request-extra-headers headers)
          (url-request-data (if kvdata (json-encode kvdata) nil)))
      (with-current-buffer (url-retrieve-synchronously url)
        (let ((data (gnus-sync-lesync-parse)))
          (gnus-message 12 "gnus-sync-lesync-call: %s URL %s sent %S got %S"
                        method url `((headers . ,headers) (data ,kvdata)) data)
          (kill-buffer (current-buffer))
          data)))))

(defun gnus-sync-lesync-PUT (url headers &optional data)
  (gnus-sync-lesync-call url "PUT" headers data))

(defun gnus-sync-lesync-POST (url headers &optional data)
  (gnus-sync-lesync-call url "POST" headers data))

(defun gnus-sync-lesync-GET (url headers &optional data)
  (gnus-sync-lesync-call url "GET" headers data))

(defun gnus-sync-lesync-DELETE (url headers &optional data)
  (gnus-sync-lesync-call url "DELETE" headers data))

;; this is not necessary with newer versions of json.el but 1.2 or older
;; (which are in Emacs 24.1 and earlier) need it
(defun gnus-sync-json-alist-p (list)
  "Non-null if and only if LIST is an alist."
  (while (consp list)
    (setq list (if (consp (car list))
                   (cdr list)
                 'not-alist)))
  (null list))

;; this is not necessary with newer versions of json.el but 1.2 or older
;; (which are in Emacs 24.1 and earlier) need it
(defun gnus-sync-json-plist-p (list)
  "Non-null if and only if LIST is a plist."
  (while (consp list)
    (setq list (if (and (keywordp (car list))
                        (consp (cdr list)))
                   (cddr list)
                 'not-plist)))
  (null list))

; (gnus-sync-lesync-setup "http://lesync.info:5984/tzz" "tzzadmin" "mypassword" "mysalt" t t)
; (gnus-sync-lesync-setup "http://lesync.info:5984/tzz")

(defun gnus-sync-lesync-setup (url &optional user password salt reader admin)
  (interactive "sEnter URL to set up: ")
  "Set up the LeSync database at URL.
Install USER as a READER and/or an ADMIN in the security object
under \"_security\", and in the CouchDB \"_users\" table using
PASSWORD and SALT.  Only one USER is thus supported for now.
When SALT is nil, a random one will be generated using `random'."
  (let* ((design-url (concat url gnus-sync-lesync-design-prefix))
         (security-object (concat url "/_security"))
         (user-record `((names . [,user]) (roles . [])))
         (couch-user-name (format "org.couchdb.user:%s" user))
         (salt (or salt (sha1 (format "%s" (random)))))
         (couch-user-record
          `((_id . ,couch-user-name)
            (type . user)
            (name . ,(format "%s" user))
            (roles . [])
            (salt . ,salt)
            (password_sha . ,(when password
                               (sha1
                                (format "%s%s" password salt))))))
         (rev (progn
                (gnus-sync-lesync-find-prop 'rev design-url design-url)
                (gnus-sync-lesync-get-prop 'rev design-url)))
         (latest-func "function(head,req)
{
  var tosend = [];
  var row;
  var ftime = (req.query['ftime'] || 0);
  while (row = getRow())
  {
    if (row.value['float-time'] > ftime)
    {
      var s = row.value['_id'];
      if (s) tosend.push('\"'+s.replace('\"', '\\\"')+'\"');
    }
  }
  send('['+tosend.join(',') + ']');
}")
;; <key>read</key>
;; <dict>
;;   <key>de.alt.fan.ipod</key>
;;   <array>
;;       <integer>1</integer>
;;       <integer>2</integer>
;;       <dict>
;;           <key>start</key>
;;           <integer>100</integer>
;;           <key>length</key>
;;           <integer>100</integer>
;;       </dict>
;;   </array>
;; </dict>
         (xmlplistread-func "function(head, req) {
  var row;
  start({ 'headers': { 'Content-Type': 'text/xml' } });

  send('<dict>');
  send('<key>read</key>');
  send('<dict>');
  while(row = getRow())
  {
    var read = row.value.read;
    if (read && read[0] && read[0] == 'invlist')
    {
      send('<key>'+row.key+'</key>');
      //send('<invlist>'+read+'</invlist>');
      send('<array>');

      var from = 0;
      var flip = false;

      for (var i = 1; i < read.length && read[i]; i++)
      {
        var cur = read[i];
        if (flip)
        {
          if (from == cur-1)
          {
            send('<integer>'+read[i]+'</integer>');
          }
          else
          {
            send('<dict>');
            send('<key>start</key>');
            send('<integer>'+from+'</integer>');
            send('<key>end</key>');
            send('<integer>'+(cur-1)+'</integer>');
            send('</dict>');
          }

        }
        flip = ! flip;
        from = cur;
      }
      send('</array>');
    }
  }

  send('</dict>');
  send('</dict>');
}
")
         (subs-func "function(doc){emit([doc._id, doc.source], doc._rev);}")
         (revs-func "function(doc){emit(doc._id, doc._rev);}")
         (bytimesubs-func "function(doc)
{emit([(doc['float-time']||0), doc._id], doc._rev);}")
         (bytime-func "function(doc)
{emit([(doc['float-time']||0), doc._id], doc);}")
         (groups-func "function(doc){emit(doc._id, doc);}"))
    (and (if user
             (and (assq 'ok (gnus-sync-lesync-PUT
                             security-object
                             nil
                             (append (and reader
                                          (list `(readers . ,user-record)))
                                     (and admin
                                          (list `(admins . ,user-record))))))
                  (assq 'ok (gnus-sync-lesync-PUT
                             (concat (file-name-directory url)
                                     "_users/"
                                     couch-user-name)
                             nil
                             couch-user-record)))
           t)
         (assq 'ok (gnus-sync-lesync-PUT
                    design-url
                    nil
                    `(,@(when rev (list (cons '_rev rev)))
                      (lists . ((latest . ,latest-func)
                                (xmlplistread . ,xmlplistread-func)))
                      (views . ((subs . ((map . ,subs-func)))
                                (revs . ((map . ,revs-func)))
                                (bytimesubs . ((map . ,bytimesubs-func)))
                                (bytime . ((map . ,bytime-func)))
                                (groups . ((map . ,groups-func)))))))))))

(defun gnus-sync-lesync-find-prop (prop url key)
  "Retrieve a PROPerty of a document KEY at URL.
Calls `gnus-sync-lesync-set-prop'.
For the 'rev PROP, uses '_rev against the document."
  (gnus-sync-lesync-set-prop
   prop key (cdr (assq (if (eq prop 'rev) '_rev prop)
                       (gnus-sync-lesync-GET url nil)))))

(defun gnus-sync-lesync-set-prop (prop key val)
  "Update the PROPerty of document KEY at URL to VAL.
Updates `gnus-sync-lesync-props-hash'."
    (puthash (format "%s.%s" key prop) val gnus-sync-lesync-props-hash))

(defun gnus-sync-lesync-get-prop (prop key)
  "Get the PROPerty of KEY from `gnus-sync-lesync-props-hash'."
    (gethash (format "%s.%s" key prop) gnus-sync-lesync-props-hash))

(defun gnus-sync-deep-print (data)
  (let* ((print-quoted t)
         (print-readably t)
         (print-escape-multibyte nil)
         (print-escape-nonascii t)
         (print-length nil)
         (print-level nil)
         (print-circle nil)
         (print-escape-newlines t))
    (format "%S" data)))

(defun gnus-sync-newsrc-loader-builder (&optional only-modified)
  (let* ((entries (cdr gnus-newsrc-alist))
         entry name ret)
    (while entries
      (setq entry (pop entries)
            name (car entry))
      (when (gnus-grep-in-list name gnus-sync-newsrc-groups)
        (if only-modified
            (when (not (equal (gnus-sync-deep-print entry)
                              (gnus-sync-lesync-get-prop 'checksum name)))
              (gnus-message 9 "%s: add %s, it's modified"
                            "gnus-sync-newsrc-loader-builder" name)
              (push entry ret))
          (push entry ret))))
    ret))

; (json-encode (gnus-sync-range2invlist '((1 . 47137) (47139 . 47714) 48129 48211 49231 49281 49342 49473 49475 49502)))
(defun gnus-sync-range2invlist (ranges)
  (append '(invlist)
          (let ((ranges (delq nil ranges))
                ret range from to)
            (while ranges
              (setq range (pop ranges))
              (if (atom range)
                  (setq from range
                        to range)
                (setq from (car range)
                      to (cdr range)))
              (push from ret)
              (push (1+ to) ret))
            (reverse ret))))

; (let* ((d '((1 . 47137) (47139 . 47714) 48129 48211 49231 49281 49342 49473 49475 49502)) (j (format "%S" (gnus-sync-invlist2range (gnus-sync-range2invlist d))))) (or (equal (format "%S" d) j) j))
(defun gnus-sync-invlist2range (inv)
  (setq inv (append inv nil))
  (if (equal (format "%s" (car inv)) "invlist")
      (let ((i (cdr inv))
            (start 0)
            ret cur top flip)
        (while i
          (setq cur (pop i))
          (when flip
            (setq top (1- cur))
            (if (= start top)
                (push start ret)
              (push (cons start top) ret)))
          (setq flip (not flip))
          (setq start cur))
        (reverse ret))
    inv))

(defun gnus-sync-position (search list &optional test)
  "Find the position of SEARCH in LIST using TEST, defaulting to `eq'."
  (let ((pos 0)
        (test (or test 'eq)))
    (while (and list (not (funcall test (car list) search)))
      (pop list)
      (incf pos))
    (if (funcall test (car list) search) pos nil)))

(defun gnus-sync-topic-group-position (group topic-name)
  (gnus-sync-position
   group (cdr (assoc topic-name gnus-topic-alist)) 'equal))

(defun gnus-sync-fix-topic-group-position (group topic-name position)
  (unless (equal position (gnus-sync-topic-group-position group topic-name))
    (let* ((loc "gnus-sync-fix-topic-group-position")
           (groups (delete group (cdr (assoc topic-name gnus-topic-alist))))
           (position (min position (1- (length groups))))
           (old (nth position groups)))
      (when (and old (not (equal old group)))
        (setf (nth position groups) group)
        (setcdr (assoc topic-name gnus-topic-alist)
                (append groups (list old)))
        (gnus-message 9 "%s: %s moved to %d, swap with %s"
                      loc group position old)))))

(defun gnus-sync-lesync-pre-save-group-entry (url nentry &rest passed-props)
  (let* ((loc "gnus-sync-lesync-save-group-entry")
         (k (car nentry))
         (revision (gnus-sync-lesync-get-prop 'rev k))
         (sname gnus-sync-lesync-name)
         (topic (gnus-group-topic k))
         (topic-offset (gnus-sync-topic-group-position k topic))
         (sources (gnus-sync-lesync-get-prop 'source k)))
    ;; set the revision so we don't have a conflict
    `(,@(when revision
          (list (cons '_rev revision)))
      (_id . ,k)
      ;; the time we saved
      ,@passed-props
      ;; add our name to the sources list for this key
      (source ,@(if (member gnus-sync-lesync-name sources)
                    sources
                  (cons gnus-sync-lesync-name sources)))
      ,(cons 'level (nth 1 nentry))
      ,@(if topic (list (cons 'topic topic)) nil)
      ,@(if topic-offset (list (cons 'topic-offset topic-offset)) nil)
      ;; the read marks
      ,(cons 'read (gnus-sync-range2invlist (nth 2 nentry)))
      ;; the other marks
      ,@(delq nil (mapcar (lambda (mark-entry)
                            (gnus-message 12 "%s: prep param %s in %s"
                                          loc
                                          (car mark-entry)
                                          (nth 3 nentry))
                            (if (listp (cdr mark-entry))
                                (cons (car mark-entry)
                                      (gnus-sync-range2invlist
                                       (cdr mark-entry)))
                              (progn    ; else this is not a list
                                (gnus-message 9 "%s: non-list param %s in %s"
                                              loc
                                              (car mark-entry)
                                              (nth 3 nentry))
                                nil)))
                          (nth 3 nentry))))))

(defun gnus-sync-lesync-post-save-group-entry (url entry)
  (let* ((loc "gnus-sync-lesync-post-save-group-entry")
         (k (cdr (assq 'id entry))))
    (cond
     ;; success!
     ((and (assq 'rev entry) (assq 'id entry))
      (progn
        (gnus-sync-lesync-set-prop 'rev k (cdr (assq 'rev entry)))
        (gnus-sync-lesync-set-prop 'checksum
                                   k
                                   (gnus-sync-deep-print
                                    (assoc k gnus-newsrc-alist)))
        (gnus-message 9 "%s: successfully synced %s to %s"
                      loc k url)))
     ;; specifically check for document conflicts
     ((equal "conflict" (format "%s" (cdr-safe (assq 'error entry))))
      (gnus-error
       1
       "%s: use `%s' to resolve the conflict synchronizing %s to %s: %s"
       loc "gnus-sync-read" k url (cdr (assq 'reason entry))))
     ;; generic errors
     ((assq 'error entry)
      (gnus-error 1 "%s: got error while synchronizing %s to %s: %s"
                  loc k url (cdr (assq 'reason entry))))

     (t
      (gnus-message 2 "%s: unknown sync status after %s to %s: %S"
                    loc k url entry)))
    (assoc 'error entry)))

(defun gnus-sync-lesync-groups-builder (url)
  (let ((u (concat url gnus-sync-lesync-design-prefix "/_view/groups")))
    (cdr (assq 'rows (gnus-sync-lesync-GET u nil)))))

(defun gnus-sync-subscribe-group (name)
  "Subscribe to group NAME.  Returns NAME on success, nil otherwise."
  (gnus-subscribe-newsgroup name))

(defun gnus-sync-lesync-read-group-entry (url name entry &rest passed-props)
  "Read ENTRY information for NAME.  Returns NAME if successful.
Skips entries whose sources don't contain
`gnus-sync-lesync-name'.  When the alist PASSED-PROPS has a
`subscribe-all' element that evaluates to true, we attempt to
subscribe to unknown groups.  The user is also allowed to delete
unwanted groups via the LeSync URL."
  (let* ((loc "gnus-sync-lesync-read-group-entry")
         (entry (gnus-sync-lesync-normalize-group-entry entry passed-props))
         (subscribe-all (cdr (assq 'subscribe-all passed-props)))
         (sources (cdr (assq 'source entry)))
         (rev (cdr (assq 'rev entry)))
         (in-sources (member gnus-sync-lesync-name sources))
         (known (assoc name gnus-newsrc-alist))
         cell)
    (unless known
      (if (and subscribe-all
               (y-or-n-p (format "Subscribe to group %s?" name)))
          (setq known (gnus-sync-subscribe-group name)
                in-sources t)
        ;; else...
        (when (y-or-n-p (format "Delete group %s from server?" name))
          (if (equal name (gnus-sync-lesync-delete-group url name))
              (gnus-message 1 "%s: removed group %s from server %s"
                            loc name url)
            (gnus-error 1 "%s: could not remove group %s from server %s"
                        loc name url)))))
    (when known
      (unless in-sources
        (setq in-sources
              (y-or-n-p
               (format "Read group %s even though %s is not in sources %S?"
                       name gnus-sync-lesync-name (or sources ""))))))
    (when rev
      (gnus-sync-lesync-set-prop 'rev name rev))

    ;; if the source matches AND we have this group
    (if (and known in-sources)
        (progn
          (gnus-message 10 "%s: reading LeSync entry %s, sources %S"
                        loc name sources)
          (while entry
            (setq cell (pop entry))
            (let ((k (car cell))
                  (val (cdr cell)))
              (gnus-sync-lesync-set-prop k name val)))
          name)
      ;; else...
      (unless known
        (gnus-message 5 "%s: ignoring entry %s, it wasn't subscribed.  %s"
                        loc name "Call `gnus-sync-read' with C-u to force it."))
      (unless in-sources
        (gnus-message 5 "%s: ignoring entry %s, %s not in sources %S"
                      loc name gnus-sync-lesync-name (or sources "")))
      nil)))

(defun gnus-sync-lesync-install-group-entry (name)
  (let* ((master (assoc name gnus-newsrc-alist))
         (old-topic-name (gnus-group-topic name))
         (old-topic (assoc old-topic-name gnus-topic-alist))
         (target-topic-name (gnus-sync-lesync-get-prop 'topic name))
         (target-topic-offset (gnus-sync-lesync-get-prop 'topic-offset name))
         (target-topic (assoc target-topic-name gnus-topic-alist))
         (loc "gnus-sync-lesync-install-group-entry"))
    (if master
        (progn
          (when (eq 'ask gnus-sync-lesync-install-topics)
            (setq gnus-sync-lesync-install-topics
                  (y-or-n-p "Install topics from LeSync?")))
          (when (and (eq t gnus-sync-lesync-install-topics)
                     target-topic-name)
            (if (equal old-topic-name target-topic-name)
                (gnus-message 12 "%s: %s is already in topic %s"
                              loc name target-topic-name)
              ;; see `gnus-topic-move-group'
              (when (and old-topic target-topic)
                (setcdr old-topic (gnus-delete-first name (cdr old-topic)))
                (gnus-message 5 "%s: removing %s from topic %s"
                              loc name old-topic-name))
              (unless target-topic
                (when (y-or-n-p (format "Create missing topic %s?"
                                        target-topic-name))
                  (gnus-topic-create-topic target-topic-name nil)
                  (setq target-topic (assoc target-topic-name
                                            gnus-topic-alist))))
              (if target-topic
                  (prog1
                      (nconc target-topic (list name))
                    (gnus-message 5 "%s: adding %s to topic %s"
                                  loc name (car target-topic))
                    (gnus-topic-enter-dribble))
                (gnus-error 2 "%s: LeSync group %s can't go in missing topic %s"
                            loc name target-topic-name)))
            (when (and target-topic-offset target-topic)
              (gnus-sync-fix-topic-group-position
               name target-topic-name target-topic-offset)))
          ;; install the subscription level
          (when (gnus-sync-lesync-get-prop 'level name)
            (setf (nth 1 master) (gnus-sync-lesync-get-prop 'level name)))
          ;; install the read and other marks
          (setf (nth 2 master) (gnus-sync-lesync-get-prop 'read name))
          (setf (nth 3 master) (gnus-sync-lesync-get-prop 'marks name))
          (gnus-sync-lesync-set-prop 'checksum
                                     name
                                     (gnus-sync-deep-print master))
          nil)
      (gnus-error 1 "%s: invalid LeSync group %s" loc name)
      'invalid-name)))

; (gnus-sync-lesync-delete-group (cdr gnus-sync-backend) "nntp+Gmane:gwene.org.slashdot")

(defun gnus-sync-lesync-delete-group (url name)
  "Returns NAME if successful deleting it from URL, an error otherwise."
  (interactive "sEnter URL to set up: \rsEnter group name: ")
  (let* ((u (concat (cadr gnus-sync-backend) "/" (url-hexify-string name)))
         (del (gnus-sync-lesync-DELETE
               u
               `(,@(when (gnus-sync-lesync-get-prop 'rev name)
                     (list (cons "If-Match"
                                 (gnus-sync-lesync-get-prop 'rev name))))))))
    (or (cdr (assq 'id del)) del)))

;;; (gnus-sync-lesync-normalize-group-entry '((subscribe . ["invlist"]) (read . ["invlist"]) (topic-offset . 20) (topic . "news") (level . 6) (source . ["a" "b"]) (float-time . 1319671237.099285) (_rev . "10-edf5107f41e5e6f7f6629d1c0ee172f7") (_id . "nntp+news.net:alt.movies")) '((read-time 1319672156.486414) (subscribe-all nil)))

(defun gnus-sync-lesync-normalize-group-entry (entry &optional passed-props)
  (let (ret
        marks
        cell)
    (setq entry (append passed-props entry))
    (while (setq cell (pop entry))
      (let ((k (car cell))
            (val (cdr cell)))
        (cond
         ((eq k 'read)
          (push (cons k (gnus-sync-invlist2range val)) ret))
         ;; we ignore these parameters
         ((member k '(_id subscribe-all _deleted_conflicts))
          nil)
         ((eq k '_rev)
          (push (cons 'rev val) ret))
         ((eq k 'source)
          (push (cons 'source (append val nil)) ret))
         ((or (eq k 'float-time)
              (eq k 'level)
              (eq k 'topic)
              (eq k 'topic-offset)
              (eq k 'read-time))
          (push (cons k val) ret))
;;; "How often have I said to you that when you have eliminated the
;;; impossible, whatever remains, however improbable, must be the
;;; truth?" --Sherlock Holmes
          ;; everything remaining must be a mark
          (t (push (cons k (gnus-sync-invlist2range val)) marks)))))
    (cons (cons 'marks marks) ret)))

(defun gnus-sync-save (&optional force)
"Save the Gnus sync data to the backend.
With a prefix, FORCE is set and all groups will be saved."
  (interactive "P")
  (cond
   ((and (listp gnus-sync-backend)
         (eq (nth 0 gnus-sync-backend) 'lesync)
         (stringp (nth 1 gnus-sync-backend)))

    ;; refresh the revisions if we're forcing the save
    (when force
      (mapc (lambda (entry)
              (when (and (assq 'key entry)
                         (assq 'value entry))
                (gnus-sync-lesync-set-prop
                 'rev
                 (cdr (assq 'key entry))
                 (cdr (assq 'value entry)))))
            ;; the revs view is key = name, value = rev
            (cdr (assq 'rows (gnus-sync-lesync-GET
                              (concat (nth 1 gnus-sync-backend)
                                      gnus-sync-lesync-design-prefix
                                      "/_view/revs")
                              nil)))))

    (let* ((ftime (float-time))
           (url (nth 1 gnus-sync-backend))
           (entries
            (mapcar (lambda (entry)
                      (gnus-sync-lesync-pre-save-group-entry
                       (cadr gnus-sync-backend)
                       entry
                       (cons 'float-time ftime)))
                    (gnus-sync-newsrc-loader-builder (not force))))
           ;; when there are no entries, there's nothing to save
           (sync (if entries
                     (gnus-sync-lesync-POST
                      (concat url "/_bulk_docs")
                      '(("Content-Type" . "application/json"))
                      `((docs . ,(vconcat entries nil))))
                   (gnus-message
                    2 "gnus-sync-save: nothing to save to the LeSync backend")
                   nil)))
      (mapcar (lambda (e) (gnus-sync-lesync-post-save-group-entry url e))
              sync)))
   ((stringp gnus-sync-backend)
    (gnus-message 7 "gnus-sync-save: saving to backend %s" gnus-sync-backend)
    ;; populate gnus-sync-newsrc-loader from all but the first dummy
    ;; entry in gnus-newsrc-alist whose group matches any of the
    ;; gnus-sync-newsrc-groups
    ;; TODO: keep the old contents for groups we don't have!
    (let ((gnus-sync-newsrc-loader
	   (loop for entry in (cdr gnus-newsrc-alist)
		 when (gnus-grep-in-list
		       (car entry)     ;the group name
		       gnus-sync-newsrc-groups)
		 collect (cons (car entry)
			       (mapcar (lambda (offset)
					 (cons offset (nth offset entry)))
				       gnus-sync-newsrc-offsets)))))
      (with-temp-file gnus-sync-backend
        (progn
          (let ((coding-system-for-write gnus-ding-file-coding-system)
                (standard-output (current-buffer)))
            (princ (format ";; -*- mode:emacs-lisp; coding: %s; -*-\n"
                           gnus-ding-file-coding-system))
            (princ ";; Gnus sync data v. 0.0.1\n")
            ;; TODO: replace with `gnus-sync-deep-print'
            (let* ((print-quoted t)
                   (print-readably t)
                   (print-escape-multibyte nil)
                   (print-escape-nonascii t)
                   (print-length nil)
                   (print-level nil)
                   (print-circle nil)
                   (print-escape-newlines t)
                   (variables (cons 'gnus-sync-newsrc-loader
                                    gnus-sync-global-vars))
                   variable)
              (while variables
                (if (and (boundp (setq variable (pop variables)))
                           (symbol-value variable))
                    (progn
                      (princ "\n(setq ")
                      (princ (symbol-name variable))
                      (princ " '")
                      (prin1 (symbol-value variable))
                      (princ ")\n"))
                  (princ "\n;;; skipping empty variable ")
                  (princ (symbol-name variable)))))
            (gnus-message
             7
             "gnus-sync-save: stored variables %s and %d groups in %s"
             gnus-sync-global-vars
             (length gnus-sync-newsrc-loader)
             gnus-sync-backend)

            ;; Idea from Dan Christensen <jdc@chow.mat.jhu.edu>
            ;; Save the .eld file with extra line breaks.
            (gnus-message 8 "gnus-sync-save: adding whitespace to %s"
                          gnus-sync-backend)
            (save-excursion
              (goto-char (point-min))
              (while (re-search-forward "^(\\|(\\\"" nil t)
                (replace-match "\n\\&" t))
              (goto-char (point-min))
              (while (re-search-forward " $" nil t)
                (replace-match "" t t))))))))
    ;; the pass-through case: gnus-sync-backend is not a known choice
    (nil)))

(defun gnus-sync-read (&optional subscribe-all)
  "Load the Gnus sync data from the backend.
With a prefix, SUBSCRIBE-ALL is set and unknown groups will be subscribed."
  (interactive "P")
  (when gnus-sync-backend
    (gnus-message 7 "gnus-sync-read: loading from backend %s" gnus-sync-backend)
    (cond
     ((and (listp gnus-sync-backend)
           (eq (nth 0 gnus-sync-backend) 'lesync)
           (stringp (nth 1 gnus-sync-backend)))
      (let ((errored nil)
            name ftime)
        (mapc (lambda (entry)
		(setq name (cdr (assq 'id entry)))
		;; set ftime the FIRST time through this loop, that
		;; way it reflects the time we FINISHED reading
		(unless ftime (setq ftime (float-time)))

		(unless errored
		  (setq errored
			(when (equal name
				     (gnus-sync-lesync-read-group-entry
				      (nth 1 gnus-sync-backend)
				      name
				      (cdr (assq 'value entry))
				      `(read-time ,ftime)
				      `(subscribe-all ,subscribe-all)))
			  (gnus-sync-lesync-install-group-entry
			   (cdr (assq 'id entry)))))))
	      (gnus-sync-lesync-groups-builder (nth 1 gnus-sync-backend)))))

     ((stringp gnus-sync-backend)
      ;; read data here...
      (if (or debug-on-error debug-on-quit)
          (load gnus-sync-backend nil t)
        (condition-case var
            (load gnus-sync-backend nil t)
          (error
           (error "Error in %s: %s" gnus-sync-backend (cadr var)))))
      (let ((valid-count 0)
            invalid-groups)
        (dolist (node gnus-sync-newsrc-loader)
          (if (gnus-gethash (car node) gnus-newsrc-hashtb)
              (progn
                (incf valid-count)
                (loop for store in (cdr node)
                      do (setf (nth (car store)
                                    (assoc (car node) gnus-newsrc-alist))
                               (cdr store))))
            (push (car node) invalid-groups)))
        (gnus-message
         7
         "gnus-sync-read: loaded %d groups (out of %d) from %s"
         valid-count (length gnus-sync-newsrc-loader)
         gnus-sync-backend)
        (when invalid-groups
          (gnus-message
           7
           "gnus-sync-read: skipped %d groups (out of %d) from %s"
           (length invalid-groups)
           (length gnus-sync-newsrc-loader)
           gnus-sync-backend)
          (gnus-message 9 "gnus-sync-read: skipped groups: %s"
                        (mapconcat 'identity invalid-groups ", ")))))
     (nil))

    (gnus-message 9 "gnus-sync-read: remaking the newsrc hashtable")
    (gnus-make-hashtable-from-newsrc-alist)))

;;;###autoload
(defun gnus-sync-initialize ()
"Initialize the Gnus sync facility."
  (interactive)
  (gnus-message 5 "Initializing the sync facility")
  (gnus-sync-install-hooks))

;;;###autoload
(defun gnus-sync-install-hooks ()
  "Install the sync hooks."
  (interactive)
  ;; (add-hook 'gnus-get-new-news-hook 'gnus-sync-read)
  ;; (add-hook 'gnus-read-newsrc-el-hook 'gnus-sync-read)
  (add-hook 'gnus-save-newsrc-hook 'gnus-sync-save))

(defun gnus-sync-unload-hook ()
  "Uninstall the sync hooks."
  (interactive)
  (remove-hook 'gnus-save-newsrc-hook 'gnus-sync-save))

(add-hook 'gnus-sync-unload-hook 'gnus-sync-unload-hook)

(when gnus-sync-backend (gnus-sync-initialize))

(provide 'gnus-sync)

;;; gnus-sync.el ends here
