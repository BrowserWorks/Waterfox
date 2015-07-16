;;; tsdh-dark-theme.el --- Tassilo's dark custom theme

;; Copyright (C) 2011-2014 Free Software Foundation, Inc.

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

;;; Code:

(deftheme tsdh-dark
  "Minor tweaks to the Emacs dark-background defaults.
Used and created by Tassilo Horn.")

(custom-theme-set-faces
 'tsdh-dark
 '(default ((t (:background "gray20" :foreground "white smoke"))))
 '(diff-added ((t (:inherit diff-changed :background "dark green"))) t)
 '(diff-changed ((t (:background "midnight blue"))) t)
 '(diff-indicator-added ((t (:inherit diff-indicator-changed))) t)
 '(diff-indicator-changed ((t (:weight bold))) t)
 '(diff-indicator-removed ((t (:inherit diff-indicator-changed))) t)
 '(diff-removed ((t (:inherit diff-changed :background "dark red"))) t)
 '(dired-directory ((t (:foreground "DodgerBlue" :weight bold))))
 '(error ((t (:foreground "deep pink" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "chartreuse2"))))
 '(font-lock-comment-face ((t (:foreground "peru"))))
 '(font-lock-constant-face ((t (:foreground "dodger blue"))))
 '(font-lock-doc-face ((t (:foreground "indian red"))))
 '(font-lock-function-name-face ((t (:foreground "spring green"))))
 '(font-lock-keyword-face ((t (:foreground "light sea green" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "cornflower blue"))))
 '(font-lock-string-face ((t (:foreground "light salmon"))))
 '(font-lock-type-face ((t (:foreground "medium purple"))))
 '(font-lock-variable-name-face ((t (:foreground "yellow green"))))
 '(font-lock-warning-face ((t (:foreground "hot pink"))))
 '(gnus-button ((t (:inherit button))))
 '(gnus-cite-1 ((t (:foreground "dark turquoise"))) t)
 '(gnus-group-mail-1 ((t (:inherit gnus-group-mail-1-empty :weight bold))))
 '(gnus-group-mail-1-empty ((t (:foreground "#00CC00"))))
 '(gnus-group-mail-3 ((t (:inherit gnus-group-mail-3-empty :weight bold))))
 '(gnus-group-mail-3-empty ((t (:foreground "#009999"))))
 '(gnus-group-news-3 ((t (:inherit gnus-group-news-3-empty :weight bold))))
 '(gnus-group-news-3-empty ((t (:foreground "light green"))))
 '(gnus-header-content ((t (:foreground "#A64B00"))))
 '(gnus-header-name ((t (:weight bold))))
 '(gnus-header-subject ((t (:foreground "#A64B00" :weight bold))))
 '(gnus-summary-high-ancient ((t (:foreground "#A64B00" :weight bold))))
 '(gnus-summary-low-ancient ((t (:foreground "medium turquoise" :slant italic))))
 '(gnus-summary-low-read ((t (:foreground "dark sea green" :slant italic))))
 '(header-line ((t (:inverse-video t :box (:line-width -1 :color "red" :style released-button)))))
 '(helm-header ((t (:background "DeepSkyBlue4" :weight bold))))
 '(highlight ((t (:background "sea green"))))
 '(hl-line ((t (:background "grey25"))))
 '(hl-paren-face ((t (:weight bold))) t)
 '(icomplete-first-match ((t (:foreground "deep sky blue" :weight bold))))
 '(ido-first-match ((t (:foreground "turquoise" :weight bold))))
 '(ido-only-match ((t (:foreground "medium spring green" :weight bold))))
 '(ido-subdir ((t (:inherit dired-directory :weight normal))))
 '(lusty-file-face ((t (:foreground "SpringGreen1"))) t)
 '(magit-header ((t (:box 1 :weight bold))))
 '(magit-section-title ((t (:inherit magit-header :background "dark slate blue"))))
 '(menu ((t (:background "gray30" :foreground "gray70"))))
 '(minibuffer-prompt ((t (:background "yellow" :foreground "medium blue" :box (:line-width -1 :color "red" :style released-button) :weight bold))))
 '(mode-line ((t (:background "gray30" :box (:line-width 1 :color "red") :family "DejaVu Sans"))))
 '(mode-line-inactive ((t (:inherit mode-line :foreground "dark gray"))))
 '(org-agenda-date ((t (:inherit org-agenda-structure))) t)
 '(org-agenda-date-today ((t (:inherit org-agenda-date :underline t))) t)
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date :foreground "green"))) t)
 '(org-agenda-done ((t (:foreground "#269926"))))
 '(org-agenda-restriction-lock ((t (:background "#FFB273"))))
 '(org-agenda-structure ((t (:foreground "#4671D5" :weight bold))))
 '(org-date ((t (:foreground "medium sea green" :underline t))))
 '(org-done ((t (:foreground "#008500" :weight bold))))
 '(org-drawer ((t (:foreground "#2A4480"))))
 '(org-ellipsis ((t (:foreground "#FF7400" :underline t))))
 '(org-footnote ((t (:foreground "#1240AB" :underline t))))
 '(org-hide ((t (:foreground "gray20"))))
 '(org-level-1 ((t (:inherit outline-1 :box nil))))
 '(org-level-2 ((t (:inherit outline-2 :box nil))))
 '(org-level-3 ((t (:inherit outline-3 :box nil))))
 '(org-level-4 ((t (:inherit outline-4 :box nil))))
 '(org-level-5 ((t (:inherit outline-5 :box nil))))
 '(org-level-6 ((t (:inherit outline-6 :box nil))))
 '(org-level-7 ((t (:inherit outline-7 :box nil))))
 '(org-level-8 ((t (:inherit outline-8 :box nil))))
 '(org-scheduled-previously ((t (:foreground "#FF7400"))))
 '(org-tag ((t (:weight bold))))
 '(org-todo ((t (:foreground "#FF6961" :weight bold))))
 '(outline-1 ((t (:foreground "cyan1" :weight bold))))
 '(outline-2 ((t (:foreground "SeaGreen1" :weight bold))))
 '(outline-3 ((t (:foreground "cyan3" :weight bold))))
 '(outline-4 ((t (:foreground "SeaGreen3" :weight bold))))
 '(outline-5 ((t (:foreground "LightGoldenrod1" :weight bold))))
 '(outline-6 ((t (:foreground "light salmon" :weight bold))))
 '(outline-7 ((t (:foreground "pale goldenrod" :weight bold))))
 '(outline-8 ((t (:foreground "OliveDrab1" :weight bold))))
 '(rcirc-my-nick ((t (:foreground "SpringGreen1" :weight bold))) t)
 '(rcirc-other-nick ((t (:foreground "dodger blue"))) t)
 '(rcirc-track-keyword ((t (:foreground "DodgerBlue" :weight bold))) t)
 '(rcirc-track-nick ((t (:background "yellow" :foreground "DodgerBlue" :weight bold))) t)
 '(region ((t (:background "SeaGreen4"))))
 '(scroll-bar ((t (:background "gray20" :foreground "dark turquoise"))))
 '(secondary-selection ((t (:background "#333366" :foreground "#f6f3e8"))))
 '(show-paren-match ((t (:background "DeepSkyBlue4"))))
 '(show-paren-mismatch ((t (:background "dark magenta"))))
 '(th-sentence-hl-face ((t (:weight bold))))
 '(widget-field ((t (:box (:line-width 2 :color "grey75" :style pressed-button)))))
 '(window-number-face ((t (:foreground "red" :weight bold)))))

(provide-theme 'tsdh-dark)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; tsdh-dark-theme.el ends here
