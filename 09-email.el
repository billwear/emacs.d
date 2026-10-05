;; make the load-path addition conditional so it doesn't error
;; on machines where mu4e isn't installed (Mac, iPhone)
(when (file-directory-p "/usr/share/emacs/site-lisp/elpa-src/mu4e-1.10.8")
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/elpa-src/mu4e-1.10.8")
  (require 'mu4e)

  (setq mu4e-maildir           "~/mail"
        mu4e-get-mail-command  "mbsync -a"
        mu4e-update-interval   300
        mu4e-inbox-folder      "/gmail/Inbox"
        mu4e-sent-folder       "/gmail/[Gmail]/Sent Mail"
        mu4e-drafts-folder     "/gmail/[Gmail]/Drafts"
        mu4e-trash-folder      "/gmail/[Gmail]/Trash"
        ;; let gmail handle sent/trash filing
        mu4e-sent-messages-behavior 'delete
        ;; compose in a new frame
        mu4e-compose-in-new-frame t
        ;; don't keep message buffers around
        message-kill-buffer-on-exit t
        ;; show full addresses, not just names
        mu4e-view-show-addresses t
        ;; don't ask to quit
        mu4e-confirm-quit nil
        ;; show images inline
        mu4e-view-show-images t
        ;; prefer plaintext over html when both exist
        mu4e-view-prefer-html nil))
