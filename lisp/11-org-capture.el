;;; 11-org-capture.el --- capture templates -*- lexical-binding: t -*-

(setq org-default-notes-file
      (expand-file-name "capture.org" org-directory))

;; ensure capture.org exists with inbox headline
(with-temp-buffer
  (when (or (not (file-exists-p org-default-notes-file))
            (= (nth 7 (file-attributes org-default-notes-file)) 0))
    (insert "* inbox\n")
    (write-file org-default-notes-file)))

;; dedicated files for specific capture types
(defvar my/outreach-file  (expand-file-name "outreach.org"  org-directory))
(defvar my/writing-file   (expand-file-name "writing.org"   org-directory))
(defvar my/someday-file   (expand-file-name "someday.org"   org-directory))

(setq org-capture-templates
      `(;; ── quick capture ──────────────────────────
        ("t" "TODO"
         entry (file+headline ,org-default-notes-file "inbox")
         "** TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
         :empty-lines 1)

        ("n" "Note"
         entry (file+headline ,org-default-notes-file "inbox")
         "** %? :note:\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
         :empty-lines 1)

        ("l" "Link"
         entry (file+headline ,org-default-notes-file "inbox")
         "** %? :link:\n:PROPERTIES:\n:CREATED: %U\n:URL: %x\n:END:\n"
         :empty-lines 1)

        ;; ── meetings & appointments ────────────────
        ("m" "Meeting"
         entry (file+headline ,org-default-notes-file "inbox")
         "** APPT %? :meeting:\nSCHEDULED: %T\n:PROPERTIES:\n:CREATED: %U\n:END:\n*** Agenda\n\n*** Notes\n\n*** Action items\n"
         :empty-lines 1)

        ("p" "Phone call"
         entry (file+headline ,org-default-notes-file "inbox")
         "** APPT Phone: %? :call:\n:PROPERTIES:\n:CREATED: %U\n:CONTACT: \n:END:\n*** Notes\n\n*** Follow-up\n"
         :empty-lines 1
         :clock-in t :clock-resume t)

        ;; ── outreach & consulting ──────────────────
        ("o" "Outreach")  ; prefix key — submenu

        ("oc" "New contact"
         entry (file+headline ,my/outreach-file "prospects")
         "** %^{Company}\n:PROPERTIES:\n:CREATED: %U\n:CONTACT: %^{Name}\n:TITLE: %^{Title}\n:LINKEDIN: %^{LinkedIn URL}\n:EMAIL: %^{Email (if known)}\n:STATUS: prospect\n:END:\n*** Notes\n%?\n*** Pitch angle\n\n*** Follow-up\n- [ ] \n"
         :empty-lines 1)

        ("ol" "Log outreach"
         item (file+olp ,my/outreach-file "log")
         "- %U %^{Company}: %^{Action|connection request|message sent|email sent|follow-up|response received} %?"
         :prepend t)

        ("ow" "Weekly outreach tally"
         entry (file+headline ,my/outreach-file "weekly tallies")
         "** Week of %t\n- Connections sent: %^{Connections}\n- Messages sent: %^{Messages}\n- Responses: %^{Responses}\n- Notes: %?\n"
         :empty-lines 1)

        ;; ── writing & publishing ───────────────────
        ("w" "Writing")  ; prefix key — submenu

        ("wi" "Writing idea"
         entry (file+headline ,my/writing-file "ideas")
         "** %? :idea:\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
         :empty-lines 1)

        ("wd" "Draft"
         entry (file+headline ,my/writing-file "drafts")
         "** PROJ %^{Title} :draft:%^{Type|blog|essay|tutorial|chapter}:\n:PROPERTIES:\n:CREATED: %U\n:TARGET: %^{Target|billwear.github.io|stormrider.io|the-way-of-emacs.com|substack|linkedin|lesswrong}\n:DEADLINE: \n:END:\n*** Outline\n%?\n*** Notes\n\n"
         :empty-lines 1)

        ("wp" "Published"
         item (file+olp ,my/writing-file "published")
         "- %U [[%^{URL}][%^{Title}]] (%^{Platform|billwear.github.io|substack|linkedin|lesswrong})"
         :prepend t)

        ;; ── someday / maybe ────────────────────────
        ("s" "Someday / maybe"
         entry (file+headline ,my/someday-file "someday")
         "** %? :someday:\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
         :empty-lines 1)

        ;; ── capture from clipboard / region ────────
        ("c" "Clip from region"
         entry (file+headline ,org-default-notes-file "inbox")
         "** %? :clip:\n:PROPERTIES:\n:CREATED: %U\n:SOURCE: %a\n:END:\n#+begin_quote\n%i\n#+end_quote\n"
         :empty-lines 1)

        ;; ── emacs config note ──────────────────────
        ("e" "Emacs config idea"
         entry (file+headline ,org-default-notes-file "emacs")
         "** %? :emacs:\n:PROPERTIES:\n:CREATED: %U\n:FILE: %^{Which config file}\n:END:\n"
         :empty-lines 1)))

;; after capture, go back to what I was doing — don't linger
(setq org-capture-bookmark nil)
