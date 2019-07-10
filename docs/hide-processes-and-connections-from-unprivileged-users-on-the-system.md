# Hide processes and connections from unprivileged users on the system

In `/etc/security/policy.conf` add `PRIV_DEFAULT=basic,!priv_proc_info`

Solution provided by **hugo** on `#smartos` on Freenode IRC.
