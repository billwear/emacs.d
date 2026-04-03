;;; 14-org-super-agenda.el --- agenda views -*- lexical-binding: t -*-

(use-package org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1)

  ;; kill the time grid — those 8:00, 10:00, 12:00 lines are noise
  ;; actual timed items still show at their scheduled time
  (setq org-agenda-use-time-grid nil)

  ;; don't show items already done
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t)

  ;; default super-agenda groups — used by the "n" daily view
  (setq org-super-agenda-groups
        '((:name "⚠ Overdue"
           :deadline past
           :order 0)
          (:name "⏰ Appointments"
           :todo "APPT"
           :order 1)
          (:name "🔥 Today"
           :scheduled today
           :order 2)
          (:name "⏳ Waiting"
           :todo "WAIT"
           :order 3)
          (:name "📦 Projects"
           :todo "PROJ"
           :order 4)
          (:name "📅 Upcoming"
           :deadline future
           :scheduled future
           :order 5)
          (:name "🔁 Habits"
           :habit t
           :order 6)
          (:name "📥 Inbox"
           :tag "inbox"
           :order 9)
          (:discard (:anything t))))

  ;; ── custom agenda views ─────────────────────────
  ;; access via C-c m a then the dispatch key
  (setq org-agenda-custom-commands
        `(;; ── d: daily driver ──────────────────────
          ;; the one you open every morning
          ("d" "Daily driver"
           ((agenda ""
                    ((org-agenda-span 1)
                     (org-agenda-start-on-weekday nil)
                     (org-super-agenda-groups
                      '((:name "⚠ Overdue"
                         :deadline past :order 0)
                        (:name "⏰ Today"
                         :scheduled today
                         :deadline today
                         :time-grid t :order 1)
                        (:name "🔁 Habits"
                         :habit t :order 5)
                        (:discard (:anything t))))))
            (alltodo ""
                     ((org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "⏳ Waiting for"
                          :todo "WAIT" :order 0)
                         (:name "📥 Inbox — needs processing"
                          :tag "inbox" :order 1)
                         (:discard (:anything t))))))))

          ;; ── w: weekly overview ───────────────────
          ;; the one you open Sunday night or Monday morning
          ("w" "Weekly overview"
           ((agenda ""
                    ((org-agenda-span 7)
                     (org-agenda-start-on-weekday 1) ; start Monday
                     (org-super-agenda-groups
                      '((:name "⚠ Overdue"
                         :deadline past :order 0)
                        (:name "⏰ Appointments"
                         :todo "APPT" :order 1)
                        (:name "📅 This week"
                         :scheduled t
                         :deadline t :order 2)
                        (:name "🔁 Habits"
                         :habit t :order 5)
                        (:discard (:anything t))))))
            (alltodo ""
                     ((org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "🚧 Stuck projects"
                          :todo "PROJ" :order 0)
                         (:name "⏳ Waiting for"
                          :todo "WAIT" :order 1)
                         (:discard (:anything t))))))))

          ;; ── o: outreach pipeline ─────────────────
          ;; your 15-contacts-per-week tracker
          ("o" "Outreach pipeline"
           ((alltodo ""
                     ((org-agenda-overriding-header "📡 Outreach Pipeline")
                      (org-agenda-files
                       '(,(expand-file-name "outreach.org" org-directory)))
                      (org-super-agenda-groups
                       '((:name "🔥 Follow up today"
                          :scheduled today
                          :deadline today :order 0)
                         (:name "⏳ Waiting for response"
                          :todo "WAIT" :order 1)
                         (:name "📋 Prospects to contact"
                          :todo "TODO" :order 2)
                         (:name "✅ Done this week"
                          :todo "DONE" :order 8)
                         (:discard (:anything t))))))))

          ;; ── W: writing pipeline ──────────────────
          ;; blog posts, essays, tutorials, chapters
          ("W" "Writing pipeline"
           ((alltodo ""
                     ((org-agenda-overriding-header "✍ Writing Pipeline")
                      (org-agenda-files
                       '(,(expand-file-name "writing.org" org-directory)))
                      (org-super-agenda-groups
                       '((:name "📝 Active drafts"
                          :todo "PROJ" :order 0)
                         (:name "💡 Ideas"
                          :tag "idea" :order 1)
                         (:name "⏳ Waiting (editor/review)"
                          :todo "WAIT" :order 2)
                         (:discard (:anything t))))))))

          ;; ── p: projects overview ─────────────────
          ;; everything tagged PROJ across all files
          ("p" "All projects"
           ((alltodo ""
                     ((org-agenda-overriding-header "📦 All Projects")
                      (org-super-agenda-groups
                       '((:name "🚧 Stuck (no next action)"
                          :and (:todo "PROJ"
                                :children nil) :order 0)
                         (:name "🔄 Active"
                          :todo "PROJ" :order 1)
                         (:discard (:anything t))))))))

          ;; ── i: inbox review ──────────────────────
          ;; everything that needs processing
          ("i" "Inbox review"
           ((alltodo ""
                     ((org-agenda-overriding-header "📥 Inbox — process these")
                      (org-super-agenda-groups
                       '((:name "Unprocessed"
                          :tag "inbox" :order 0)
                         (:discard (:anything t))))))))

          ;; ── n: default 3-day view ────────────────
          ;; keep the standard n view working
          ("n" "Three-day agenda + todos"
           ((agenda ""
                    ((org-agenda-span 3)
                     (org-agenda-start-on-weekday nil)))))
          )))
