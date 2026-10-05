;;; 18-journal.el --- org-journal + emologent + rich daily header -*- lexical-binding: t -*-

;; ── helper: sunrise/sunset from emacs solar.el ──
(require 'solar)

(defun my/sunrise-sunset-string ()
  "Return 'sunrise at HH:MM; sunset at HH:MM' for today."
  (let* ((calendar-latitude  30.63)
         (calendar-longitude -89.65)
         (data (solar-sunrise-sunset (calendar-current-date)))
         (rise (car data))
         (set  (cadr data)))
    (if (and rise set)
        (format "sunrise at %s; sunset at %s"
                (solar-time-string (car rise) nil)
                (solar-time-string (car set) nil))
      "sunrise/sunset unavailable")))

;; ── helper: weather from wttr.in ────────────────
(defun my/weather-string ()
  "Fetch one-line weather for Necaise, MS from wttr.in.
Returns a fallback string if the network is unavailable."
  (condition-case nil
      (let ((result (string-trim
                     (shell-command-to-string
                      "curl -s -m 5 'wttr.in/Necaise,MS?format=%C+%t+%h+%w' 2>/dev/null"))))
        (if (and result (not (string-empty-p result))
                 (not (string-match-p "Unknown" result)))
            result
          "weather unavailable"))
    (error "weather unavailable")))

;; ── helper: date metadata line ──────────────────
(defun my/date-metadata-string ()
  "Return date; epoch; day N of 365; week M."
  (let* ((now    (current-time))
         (date   (format-time-string "%A, %B %d, %Y" now))
         (epoch  (format-time-string "%s" now))
         (doy    (string-to-number (format-time-string "%j" now)))
         (diy    (if (date-leap-year-p
                      (string-to-number (format-time-string "%Y" now)))
                     366 365))
         (week   (format-time-string "%V" now)))
    (format "%s; epoch %s; day %d of %d; week %s"
            date epoch doy diy week)))

;; ── helper: agenda summary ──────────────────────
(defun my/agenda-summary-string ()
  "Return today's agenda items as a plain text list."
  (condition-case nil
      (let* ((date (calendar-current-date))
             (files (org-agenda-files))
             (entries (org-agenda-get-day-entries files date))
             (lines '()))
        (if entries
            (progn
              (dolist (entry entries)
                (let ((text (org-no-properties
                             (get-text-property 0 'txt entry))))
                  (when (and text (not (string-empty-p text)))
                    (push (format "- %s" (string-trim text)) lines))))
              (if lines
                  (string-join (nreverse lines) "\n")
                "no agenda items today"))
          "no agenda items today"))
    (error "agenda unavailable")))

;; ── emologent fields ────────────────────────────
(defvar my/emologent-fields
  '("mood" "energy" "mental wx" "actual wx" "loop" "lingering"
    "unfinished" "gravity" "anchor" "resisting" "mokusatsu" "pivot"
    "signal boost" "idea pressure" "creative current"
    "gains" "friction" "rare value")
  "Fields for the daily emotional log.")

(defun my/insert-emologent ()
  "Insert emologent template at point."
  (insert "\n** emologent\n")
  (dolist (f my/emologent-fields)
    (insert (format "- %s: \n" f)))
  (insert "\n"))

;; ── the big header hook ─────────────────────────
(defun my/journal-header-hook ()
  "Build the full daily header after org-journal creates a new file.
Inserts metadata, fortune, ddate, sunrise/sunset, weather,
emologent, and today's agenda."
  (save-excursion
    (goto-char (point-min))
    (end-of-line)
    ;; date metadata line
    (insert "\n" (my/date-metadata-string))
    ;; fortune
    (insert "\n" (string-trim
                  (shell-command-to-string "fortune -s fortunes")))
    ;; ddate
    (insert "\n" (string-trim
                  (shell-command-to-string "ddate")))
    ;; sunrise / sunset
    (insert "\n" (my/sunrise-sunset-string))
    ;; weather (async-ish — 5 second timeout so it won't hang)
    (insert "\nweather for necaise, ms: " (my/weather-string))
    ;; emologent
    (my/insert-emologent)
    ;; agenda
    (insert "** agenda\n"
            (my/agenda-summary-string)
            "\n\n")))

;; ── org-journal configuration ───────────────────
(use-package org-journal
  :custom
  ;; one file per day, stored OUTSIDE ~/org
  (org-journal-dir (expand-file-name "~/journal"))
  (org-journal-file-type 'daily)
  (org-journal-file-format "%Y%m%d.org")

  ;; date heading
  (org-journal-date-format "personal journal of bill wear")
  (org-journal-date-prefix "* ")

  ;; time-stamped sub-entries
  (org-journal-time-format "%H:%M")
  (org-journal-time-prefix "** ")

  ;; don't carry over unfinished TODOs from yesterday
  (org-journal-carryover-items nil)

  ;; open in current window
  (org-journal-find-file 'find-file)

  :config
  ;; ensure directory exists
  (unless (file-directory-p org-journal-dir)
    (make-directory org-journal-dir t))

  ;; fire the rich header only on brand-new daily files
  (add-hook 'org-journal-after-header-create-hook
            #'my/journal-header-hook))

;; ── convenience ─────────────────────────────────

(defun my/journal-search ()
  "Search all journal entries."
  (interactive)
  (org-journal-search-forever ""))

(defun my/journal-today ()
  "Open today's journal without creating a new time entry."
  (interactive)
  (org-journal-new-entry t))

(defun my/emologent-standalone ()
  "Insert an emologent template at point in any buffer."
  (interactive)
  (my/insert-emologent))

(defun my/journal-refresh-agenda ()
  "Update the agenda section of today's journal."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^\\*\\* agenda$" nil t)
      (forward-line 1)
      (let ((start (point)))
        ;; delete old agenda content up to next heading or end
        (if (re-search-forward "^\\*\\* " nil t)
            (progn (beginning-of-line) (delete-region start (point)))
          (delete-region start (point-max)))
        (insert (my/agenda-summary-string) "\n\n"))))
  (message "Agenda section refreshed"))
